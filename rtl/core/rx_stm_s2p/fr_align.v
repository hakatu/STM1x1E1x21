// Filename     : fr_align.v
// Description  : STM-1 Rx frame alignment
////////////////////////////////////////////////////////////////////////////////

module fr_align
    (
     clk155,
     rst,
     
     sdi,     
     sdo, // to scrambler
     sce
     );

////////////////////////////////////////////////////////////////////////////////
// Port declarations

input clk155;
input rst;

input sdi;

output sdo;
output sce;

////////////////////////////////////////////////////////////////////////////////
// Output declarations

reg    sce;

////////////////////////////////////////////////////////////////////////////////
// Parameter declarations

parameter FAS = 32'hF6F6F628;

parameter OOF = 2'b00;
parameter IF  = 2'b01;
parameter LOF = 2'b10;


parameter INIT = 0;
parameter MAXROW = 9;
parameter MAXCOL = 90;
parameter MAXSTS = 3;

            
////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation

// row, col, sts, bit counter

reg [3:0] row;
reg [6:0] col;
reg [1:0] sts;
reg [2:0] bcnt;

always @(posedge clk155)
    begin
    if (rst)
        begin
        row <= INIT;
        col <= INIT;
        sts <= INIT;
        bcnt <= INIT;
        end
    else
        begin
        bcnt <= bcnt + 1;
        sts <= (bcnt == 3'b111)?
               (sts >= MAXSTS-1)? INIT : sts + 1 : sts;
        
        col <= (bcnt == 3'b111)?
               (sts >= MAXSTS-1)? 
               (col >= MAXCOL-1)? INIT : col + 1 : col : col;
        
        row <= (bcnt == 3'b111)?
               (sts >= MAXSTS-1)?
               (col >= MAXCOL-1)?
               (row >= MAXROW-1)? INIT : row + 1 : row : row : row;
        end
    end

// frame alignment

reg [4:0]   ccnt;   // count consecutive events
reg         flag;
reg         detfas; // last frame's FAS deteced
           
reg [31:0]  shfreg;
reg [1:0]   state;

reg [15:0]  pos;    // FAS positions
reg [15:0]  treg;   // timing register

always @(posedge clk155)
    begin
    if (rst)
        begin
        ccnt    <= INIT;
        flag    <= INIT;
        detfas  <= INIT;
        pos     <= INIT;
        treg    <= INIT;
        shfreg  <= INIT;
        state   <= INIT;
        end
    else
        begin
        shfreg  <= {shfreg[30:0], sdi};
        case(state)
            IF:
                begin
                if (shfreg == FAS)
                    begin
                    if (!(treg == {row,col,sts,bcnt}))
                        begin
                        pos     <= {row, col, sts, bcnt};
                        // verify FAS
                        if (pos == {row,col,sts,bcnt}) 
                            begin
                            ccnt    <= INIT;
                            treg    <= {row,col,sts,bcnt};
                            end
                        else
                            begin
                            ccnt    <= ccnt;
                            treg    <= treg;
                            end
                        end
                    else
                        begin
                        ccnt    <= INIT;
                        treg    <= treg;
                        end
                    end
                // 5 consecutive unframes
                else if (treg == {row,col,sts,bcnt})
                    begin
                    if (ccnt == 4)
                        begin
                        state   <= OOF;
                        ccnt    <= 5'd1;
                        flag    <= INIT;
                        pos     <= INIT;
                        end
                    else
                        begin
                        state   <= state;
                        ccnt    <= ccnt + 1;
                        end
                    end
                end
            LOF:
                begin
                // detect FAS
                if (shfreg == FAS)
                    begin
                    pos     <= {row,col,sts,bcnt};
                    // verify FAS
                    if (pos == {row,col,sts,bcnt})  
                        begin       
                        if (ccnt == 5'd22)
                            begin
                            ccnt    <= INIT;
                            state   <= IF;
                            treg    <= {row,col,sts,bcnt};
                            flag    <= INIT;
                            end
                        else
                            begin
                            ccnt    <= ccnt + 1;
                            state   <= state;
                            end
                        end
                    // fail verification
                    else
                        begin
                        ccnt    <= INIT;
                        end
                    end
                // lost FAS
                else if (pos == {row,col,sts,bcnt})
                    begin
                    ccnt    <= INIT;
                    state   <= state;
                    pos     <= INIT;
                    end
                end
            // OOF
            default:
                begin
                // detect FAS
                if (shfreg == FAS)
                    begin
                    pos     <= {row, col, sts, bcnt};
                    detfas  <= 1'b1;
                    // verify FAS
                    if ((pos == {row,col,sts,bcnt}) && flag)  
                        begin                       
                        state   <= IF;  
                        flag    <= INIT;
                        treg    <= {row,col,sts,bcnt};
                        ccnt    <= INIT;
                        end
                    else
                        begin
                        state   <= state;
                        flag    <= 1'b1;
                        treg    <= treg;
                        // in case FAS at treg positions
                        if (treg == {row,col,sts,bcnt})
                            begin
                            ccnt    <= ccnt + 1;
                            end
                        else
                            begin
                            ccnt    <= ccnt;
                            end
                        end
                    end
                // 24 consecutive out-frames
                else if (treg == {row,col,sts,bcnt})
                    begin
                    if (ccnt >= 24)
                        begin
                        state   <= LOF;
                        ccnt    <= INIT;
                        pos     <= INIT;
                        flag    <= INIT;
                        end
                    else
                        begin
                        ccnt    <= ccnt + 1;
                        state   <= state;
                        // last frame has no FAS
                        if (!detfas)
                            begin
                            detfas  <= INIT;
                            flag    <= INIT;
                            end
                        // last frame has FAS
                        else
                            begin
                            detfas  <= INIT;
                            flag    <= flag;
                            end
                        end
                    end
                end
        endcase
        end
    end

// scramber enbale

fflopx #(1) dout(clk155, rst, shfreg[31], sdo);

reg [6:0] scecnt;
always @(posedge clk155)
    begin
    if (rst)
        begin
        scecnt  <= INIT;
        sce     <= 1'b1;
        end
    // FAS was detected
    else if (shfreg == FAS)
        begin
        sce     <= 1'b0;
        scecnt  <= INIT;
        end
    else if (sce == 1'b0)
        begin
        if (scecnt == 7'd71)
            begin
            sce     <= 1'b1;
            scecnt  <= INIT;
            end
        else
            begin
            scecnt  <= scecnt + 1;
            end
        end
    end

endmodule 
