# STM1x1 To E1x21 Mapping for SONET Application

## Overview

A not very good Verilog implementation of STM1x1 To E1x21 mapping for SONET application

This project provides a comprehensive FPGA-based solution for mapping 21 E1 serial interfaces to a single STM-1 serial interface. The device integrates multiple functionalities, including E1 framing, SONET/SDH framing. It is designed to support business aggregation, customer premises data service aggregation, routers, switches, and more.

## Key Features

### E1 Framer
- Integrates 21 E1 framers.
- Implements bit asynchronous mapping of 21 E1 to VT2/TU12.
- Supports mapping of VT2/TU12 to SONET/SDH SPE.
- Asynchronous DS1/E1 to VT/TU Map.

## Device Interfaces
- SONET/SDH Serial Interface.
- E1 Serial Interfaces.

## Functional Description

### Data Path
- **HDB3/NRZ Line Coder**: Supports both HDB3 and NRZ line interfaces, allowing bypass to NRZ.
- **21xE1 Tx/Rx Framer**: Supports E1 2048 kbps basic frame standard, CRC-4 Monitoring, and LOS/AIS/LOF detection.
- **E1 Data Mux**: Muxes data from 21 E1 framers into a single data bus (8-bit wide).
- **Memory Bridge & Channel ID Control**: Manages data transmission and reception sequences.
- **Multi-frame TU12/TUG3**: Supports mapping 21xE1 into VC-4, and handling ingress and egress operations.
- **VC4, AU4**: Implements VC-4 POH and AU-4 Pointer Generation and Interpretation.
- **STM-1 Rx/Tx Framer**: Handles the framing for STM-1 signals, including RSOH and MSOH processing.

## References
The project refers to various ITU-T standards for digital interfaces, frame structures, and error detection criteria, including ITU-T G.703, G.704, G.707/Y.1322, G.706, G.705, and G.841.

## Contributing

Contributions are welcome. Please fork the repository and create a pull request with detailed information on your changes.

### To change

- STM frame interleave byte, so you don't need to use a 2D array to store the whole frame. 

## License

This project is released under the MIT License. See the LICENSE file for more details.
