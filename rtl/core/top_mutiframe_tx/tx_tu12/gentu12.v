// Filename     : gentu12.v
// Description  : .
////////////////////////////////////////////////////////////////////////////////

module gentu12
    (
     clk,
     rst,
     
     valid,
     addr,
     din,

     rei_bip2,
     rei_vld,
     
     en,
     dout,
     re
     
     );
parameter          ADDR = 0;
parameter          WIDTH = 8;
parameter          OFFSET = 10'd105;
parameter          NDF = 4'b0110;
parameter          SS = 2'b10;      // VT12
parameter          RDI = 1'b1;
parameter          SIGL = 3'b010;  // asyn mapping
parameter          O = 1'b0;
parameter          R = 1'b0;
parameter          S1 = 1'b0;
parameter          S2 = 1'b0;
////////////////////////////////////////////////////////////////////////////////
// Port declarations
input clk,
      rst;

input rei_vld;
input rei_bip2;
input en;

input [4:0] addr;
input       valid;
input [WIDTH-1:0] din;

output [WIDTH-1:0] dout;
output             re;
        
////////////////////////////////////////////////////////////////////////////////
// Output declarations
                                
reg [7:0]          row;
reg [7:0]          numfr;
reg [1:0]          bip2_reg;
reg [1:0]          v5_bip;

reg                rei;
reg                fault;

reg                di_vld;
reg [WIDTH-1:0]    data_reg;
////////////////////////////////////////////////////////////////////////////////
// Parameter declarations



// Local logic and instantiation
wire [WIDTH-1:0]   v1,      //pointer
                   v2,
                   v3,  
                   v4;  

wire [WIDTH-1:0]   v5,         // poh
                   j2,
                   n2,
                   k4;    
                 
assign             {v1[1:0],v2}= OFFSET;
assign             v1[7:2] = {NDF,SS};
assign             v3 = 8'b0;
assign             v4 = 8'b0;

assign             v5 = {v5_bip,rei,1'b0,SIGL,RDI};
assign             j2 = 8'b0;
assign             n2 = 8'b0;
assign             k4 = 8'b0;

reg                re;
wire [1:0]         C1C2;
reg                c1,
                   c2;
wire [5:0]         length;
assign             C1C2 = {c1,c2};

always @(posedge clk)
    begin
    if(rst)  re <= 0;
    else if(length == 15) re <= 1;
    else re <= re;
    end

always @(posedge clk)
    begin
    if(rst)
        begin
        c1 <= 1;  // S1 stuff
        c2 <= 0;    // S2 data
        end

    else if( re == 1)
        begin
        if((fradapt < 4'd8) & (fradapt >= 4'd1))
            begin
            c1 <= c1;
            c2 <= c2;
            end
        else if( fradapt == 4'd8)
            begin
            c1 <= 1;
            c2 <= 0;
            end
        else
            begin
            c1 <= (length > 16) ? 0:1; // length >16 S1 data
            c2 <= (length < 15) ? 1:0;
            end
        end
    end
reg [3:0] fradapt;  // adapt 8 frame;
/*
always @(posedge clk)
    begin
    if(rst) fradapt <= 4'b0000; 
    else if((!c1|c2) & (row == 1) & (numfr == 3))
        begin       
        fradapt <= fradapt+4'b1;
        if(fradapt == 8)
            fradapt <= 4'b0;
        end
    
    end
 */
wire    wr,
        rd;
wire [5:0] wrcnt,
           rdcnt;

  
fifo_anylen #(36,5,8) multiframe
    (
     .clk(clk),
     .rst_(!rst),

     // FIFO control
     .fifowr(di_vld),
     .fiford(en),
     .fifofsh(1'b0),

     .notempty(),
     .full(),
     .fifolen(length),
     .di(data_reg),
     .do(dout)
    );
////////////////////////////////////////////////////////////////////////////////
wire       s1_data ;
assign     s1_data = (({c1,c2} == 2'b00 ) & (row == 2) & (numfr == 3)|
                      (fradapt == 4'b1));
wire       sht_lt;  // shift left
assign     sht_lt = (({c1,c2} == 2'b0) & (row > 2) & (numfr == 3)|
                     (fradapt != 4'b0));
wire       s2_stf;
assign     s2_stf = (({c1,c2} == 2'b11) & (row == 3) & (numfr == 3)|
                     (fradapt >  4'b0)&(fradapt <= 8));
wire       sht_rt;
assign     sht_rt = (({c1,c2} == 2'b11) & (row >3 ) & (numfr == 3)|
                     (fradapt != 4'b0));
reg done_shlt,   // end shift data
    done_shrt;

reg [WIDTH-1:0] data_c1,
                data_c2;
wire            enc1;
assign          enc1 = (((row == 2 )& (numfr == 3) )& ({c1,c2} == 2'b00))|
                           (fradapt>1);

// multi_frame

always @(posedge clk)
    begin
    if(rst)
        begin
        bip2_reg <= 2'b0;
        v5_bip <= 2'b0;     
        row <= 0;
        numfr <= 0;
        di_vld <= 0;
        data_reg <= 0;
        fradapt <= 4'b0;       
        end 
    
    else if (row == 0 & numfr == 0 )  //pointer v1
        begin
        data_reg <= v1;
        di_vld <= 1;
        row <= row+1;
        end
    
    else if (row == 1 & numfr == 0) // poh v5
        begin
        data_reg <= v5;
        di_vld <= 1;
        row <= row+1;
        end
    
    else if (row == 2 & numfr == 0 ) 
        begin
        data_reg <= {WIDTH{R}};
        di_vld <= 1;
        row <= row+1;         
        end
    
    else if (row == 35 & numfr ==0)
        begin
        data_reg <= {WIDTH{R}};
        di_vld <= 1;
        numfr <= numfr +1;
        row <= 0;
        end
    
    else if (row == 0 & numfr == 1 )
        begin
        data_reg <= v2;
        di_vld <= 1;
        row <= row+1;
        end
    
    else if (row == 1 & numfr == 1 )
        begin
        data_reg <= j2;
        di_vld <= 1;
        row <= row+1;
        end
    
    else if (row == 2 & numfr == 1 )
        begin
        data_reg <= {C1C2,{4{O}},{2{R}}};
        bip2_reg[0] <= bip2_reg[0]^c2;
        bip2_reg[1] <= bip2_reg[1]^c1;
        di_vld <= 1;
        row <= row+1;
        end
    
    else if (row == 35 & numfr == 1)
        begin
        data_reg <= {WIDTH{R}};
        di_vld <= 1;
        row <= 0;
        numfr <= numfr +1;
        end
    
    else if (row == 0 & numfr == 2 )
        begin
        data_reg <= v3;
        di_vld <= 1;
        row <= row+1;
        end
    
    else if (row == 1 & numfr == 2 )
        begin
        data_reg <= n2;
        di_vld <= 1;
        row <= row +1;
        end
    
    else if (row == 2 & numfr == 2 )
        begin
        data_reg <= {C1C2,{4{O}},{2{R}}};
        bip2_reg[0] <= bip2_reg[0]^c2;
        bip2_reg[1] <= bip2_reg[1]^c1;
        di_vld <= 1;
        row <= row+1;
        end
    
    else if (row == 35 & numfr == 2)
        begin
        data_reg <= {WIDTH{R}};
        di_vld <= 1;
        row <= 0;
        numfr <= numfr +1;
        end
    
    else if (row == 0 & numfr == 3 )
        begin
        data_reg <= v4;
        di_vld <= 1;
        row <= row+1;
        end
    
    else if (row == 1 & numfr == 3 )   // byte poh k4
        begin
        data_reg <= k4;
        di_vld <= 1;
        row <= row +1;
        if(!c1|c2)   //  change length  , adpat 8 multi frame
            fradapt <= (fradapt == 8)?4'd0 : fradapt + 4'd1;
        end
    
    else if ((row == 2 & numfr == 3) & ({c1,c2} == 2'b10)) // normal length
        begin
        data_reg <= {C1C2,{5{R}},S1};
        bip2_reg[0] <= bip2_reg[0]^c2;
        bip2_reg[1] <= bip2_reg[1]^c1;
        di_vld <= 1;
        row <= row+1;
        end
    else if(enc1)       // S1 = data
        begin          // when fradapt > 1
        case(fradapt)
            4'd2:
                begin
                data_reg <= {C1C2,{5{R}},data_c1[6]}; // S1 = din[7]
                di_vld <= 1'b1;
                row <= row +1'b1;                                                          
                end
            4'd3:
                begin
                data_reg <= {C1C2,{5{R}},data_c1[5]}; // S1 = din[7]
                di_vld <= 1'b1;
                row <= row +1'b1;
            
                end
            4'd4:
                begin
                data_reg <= {C1C2,{5{R}},data_c1[4]}; // S1 = din[7]
                di_vld <= 1'b1;
                row <= row +1'b1;
                
                end
            4'd5:
                begin
                data_reg <= {C1C2,{5{R}},data_c1[3]}; // S1 = din[7]
                di_vld <= 1'b1;
                row <= row +1'b1;
            
                end
            4'd6:
                begin
                data_reg <= {C1C2,{5{R}},data_c1[2]}; // S1 = din[7]
                di_vld <= 1'b1;
                row <= row +1'b1;
              
                end
            4'd7:
                begin
                data_reg <= {C1C2,{5{R}},data_c1[1]}; // S1 = din[7]
                di_vld <= 1'b1;
                row <= row +1'b1;
                fradapt <= fradapt + 4'd1;
                end
            4'd8:
                begin
                data_reg <= {C1C2,{5{R}},data_c1[0]}; // S1 = din[7]
                di_vld <= 1'b1;
                row <= row +1'b1;
                done_shlt <= 1'b1;
            default:
                begin
                data_reg <= {C1C2,{5{R}},S1};            // S1 = din[7]
                di_vld <= 1'b1;
                row <= row +1'b1;
                end
                end
        endcase
        end
    else if (row == 35 & numfr == 3)  // stuff
        begin
        data_reg <= {WIDTH{R}};
        di_vld <= 1;
        numfr <= numfr +1'b1;
        row <= 0;      
        v5_bip <= bip2_reg^{1'b0,rei&fault}; 
        bip2_reg <= bip2_reg;
        end
    
    else if(valid&(addr == ADDR))
        begin
        if(s1_data)         // shift data to S1 , first frame           
            begin
            data_reg <= {C1C2,{5{R}},din[7]}; // S1 = din[7], store din in data_c1
            data_c1 <= din;
            di_vld <= 1'b1;
            row <= row +1'b1;                    
            end             
        else if (sht_lf) // shift left data
            begin
            case(fradapt)
                4'd1:
                    begin
                    data_c1 <= din;
                    data_reg <= {data_c1[6:0],din[7]};  // shift left data 1 bit
                    di_vld <= 1'b1;
                    row <= row +1'b1;
                    end
                4'd2:
                    begin
                    data_reg <= {data_c1[5:0],din[7:6]}; // S1 = din[7]
                    data_c1 <= din;
                    di_vld <= 1'b1;
                    row <= row +1'b1;
                    end                
                4'd3:
                    begin
                    data_reg <= {data_c1[4:0],din[7:5]}; // S1 = din[7]
                    data_c1 <= din;
                    di_vld <= 1'b1;
                    row <= row +1'b1;           
                    end
                4'd4:
                    begin
                    data_reg <= {data_c1[3:0],din[7:4]}; // S1 = din[7]
                    data_c1 <= din;
                    di_vld <= 1'b1;
                    row <= row +1'b1;            
                    end
                4'd5:
                    begin
                    data_reg <= {data_c1[2:0],din[7:3]}; // S1 = din[7]
                    data_c1 <= din;
                    di_vld <= 1'b1;
                    row <= row +1'b1;
            
                    end
                4'd6:
                    begin
                    data_reg <= {data_c1[1:0],din[7:2]}; // S1 = din[7]
                    data_c1 <= din;
                    di_vld <= 1'b1;
                    row <= row +1'b1;           
                    end
                4'd7:
                    begin
                    data_reg <= {data_c1[0],din[7:1]}; // S1 = din[7]
                    data_c1 <= din;
                    di_vld <= 1'b1;
                    row <= row +1'b1;        
                    end
                4'd8:
                    begin 
                    data_reg <= {C1C2,{5{R}},S1};  // return normal length
                    data_c1 <= din;
                    done_shlt <= 1'b1;
                    row <= row +1'b1;
                    end
                default: 
                    begin
                    di_vld <= 1'b0;
                    data_reg <= {WIDTH{1'b0}};
                    
                    end
            endcase 
        
        else if(s2_stf)  // shift right data, S2= stuff
            begin
            case(fradapt)
                4'd1:       
                    begin
                    data_reg <= {S2,din[6:0]};   // S2 = stuff
                    data_c2 <= din;
                    row <= row +1'b1;
                    di_vld <= 1'b1;
                    end 
                4'd2:
                    begin
                    data_reg <= {S2,din[5:0],data_c2[7]}; //S2 = stuff
                    data_c2 <= din;
                    row <= row +1;
                    di_vld <= 1'b1;
                    end
                4'd3:
                    begin
                    data_reg <= {S2,din[4:0],data_c2[7:6]};   // S2 = stuff
                    data_c2 <= din;
                    row <= row +1;
                    di_vld <= 1'b1;
                    end
                4'd4:
                    begin
                    data_reg <= {S2,din[3:0],data_c2[7:5]};   // S2 = stuff
                    data_c2 <= din;
                    row <= row +1;
                    di_vld <= 1'b1;
                    end
                4'd5:
                    begin
                    data_reg <= {S2,din[2:0],data_c2[7:4]};   // S2 = stuff
                    data_c2 <= din;
                    row <= row +1;
                    di_vld <= 1'b1;
                    end
                4'd6:
                    begin
                    data_reg <= {S2,din[1:0],data_c2[7:3]};   // S2 = stuff
                    data_c2 <= din;
                    row <= row +1;
                    di_vld <= 1'b1;
                    end
                4'd7:
                    begin
                    data_reg <= {S2,din[0],data_c2[7:2]};   // S2 = stuff
                    data_c2 <= din;
                    row <= row +1;
                    di_vld <= 1'b1;
                    end
                4'd8:
                    begin
                    data_reg <= {S2,data_c2[7:1]};   // S2 = stuff
                    data_c2 <= din;    // return normal length
                    row <= row +1;
                    di_vld <= 1'b1;
                    done_shrt <= 1;                 
                    end
                default: 
                    begin
                    di_vld <= 1'b0;
                    data_reg <= {WIDTH{1'b0}};                     
                    end
            endcase
            end
        
        else if(sht_rt)
            begin
            case(fradapt)
                4'd1:
                    begin
                    data_c2 <= din;
                    data_reg <= {din[6:0],data_c2[7]}; // shift right data 1 bit
                    row <= row +1;
                    di_vld <= 1'b1;
                    end
                4'd2:
                    begin
                    data_c2 <= din;
                    data_reg <= {din[5:0],data_c2[7:6]}; // shift right data 1 bit
                    row <= row +1;
                    di_vld <= 1'b1;
                    end
                4'd3:
                    begin
                    data_c2 <= din;
                    data_reg <= {din[4:0],data_c2[7:5]}; // shift right data 1 bit
                    row <= row +1;
                    di_vld <= 1'b1;
                    end
                4'd4:
                    begin
                    data_c2 <= din;
                    data_reg <= {din[3:0],data_c2[7:4]}; // shift right data 1 bit
                    row <= row +1;
                    di_vld <= 1'b1;
                    end
                4'd5:
                    begin
                    data_c2 <= din;
                    data_reg <= {din[2:0],data_c2[7:3]}; // shift right data 1 bit
                    row <= row +1;
                    di_vld <= 1'b1;
                    end
                4'd6:
                    begin
                    data_c2 <= din;
                    data_reg <= {din[1:0],data_c2[7:2]}; // shift right data 1 bit
                    row <= row +1;
                    di_vld <= 1'b1;
                    end
                4'd7:
                    begin
                    data_c2 <= din;
                    data_reg <= {din[0],data_c2[7:1]}; // shift right data 1 bit
                    row <= row +1;
                    di_vld <= 1'b1;
                    end
                default: 
                    begin
                    di_vld <= 1'b0;
                    data_reg <= {WIDTH{1'b0}};                     
                    end
            endcase
            end
        else
            begin
            data_reg <= din;
            bip2_reg[0] <= bip2_reg[0]^(^(din&{4{2'b10}}));
            bip2_reg[1] <= bip2_reg[1]^(^(din&{4{2'b01}}));
            di_vld <= 1;
            row <=  row +1;
            end
        end
    else if(done_shlt)
        begin
        data_reg <= data_c1;
        di_vld <= 1'b1;
        end
    else if(done_shrt)
        begin
        data_reg <= data_c2;
        di_vld <= 1'b1;
        end
        end
    else
        di_vld <= 0;
    end
////////////////////////////////////////////////////////////////////////////////
// rei bip2
always @(posedge clk)
    begin
    if(rst)
        rei <= 0;
    else if(rei_vld)
        begin
        rei <= rei_bip2;
        if(row>1|numfr>0)
            fault <= 1;
        end
    else 
        rei <= rei;
    end
////////////////////////////////////////////////////////////////////////////////

endmodule 
