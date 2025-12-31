# Accelerated-Systolic-Array-for-Matrix-Multiplication

## Overview

This project demonstrates a high-performance, open-source systolic array accelerator designed for efficient matrix-based computation. The system implements a `35x35 processing element (PE) array`, optimized for deeply pipelined execution. The design targets the **Xilinx Zynq Ultrascale+ ZCU104 FPGA**, leveraging its programmable logic to enable high parallel computation.

## System Architecture

The accelerator is composed of a 35x35 two-dimensional, 1,225 Processing Elements (PE), systolic array. Each Processing Element (PE) performs a single MAC operation per cycle and communicated with its immediate neighbors in a waveform fashion.

### Systolic Array

Data and associated `valid control signals` enters from the top and left edges of the array and propagates diagonally. This mechanism ensures correct computation under continuous and bursty data input. Partial sums are accumulated locally within each PE. 

(The following image presents a 3x3 Systolic Array)

<img width="1800" height="900" alt="Blank diagram (1)" src="https://github.com/user-attachments/assets/5969dd04-8776-40ca-870f-042a709c34ab" />

### Processing Element (PE)

Each Processing Element (PE) performs the operation
`C = C + (A x B)`

The PE is fully pipelined and can accept new inputs every clock cycle. The computation is implemented using a dedicated DSP macro, which provides a `three-stage pipeline` for efficient multiply-accumulate operations.

<img width="1300" height="900" alt="Blank diagram (2)" src="https://github.com/user-attachments/assets/478881aa-85b9-4315-a3fc-32de391c2bc0" />

## Timing and Performance

The design was implemented with a target clock period of `5.000 ns`, corresponding to an operating frequency of approximately `200 MHz`.
  - `Worst Negative Slack (WNS):` +0.142 ns
  - `Worst Hold Slack (WHS):` +0.010 ns
    
The positive slack values indicate that both setup and hold timing constaints are satisfied.

Data must also travel across the array horizontally (35 cycles) and vertically (35 cycles), so the total delay before the first valid output is roughly `70 cycles (Latency)`.

Each PE performs 1 MAC per clock cycle once the pipeline is full. At a clock frequency of `200 MHz`, the accelerator can achieve `245 billion multiply-accumulate operations per second (245 GMAC/s)` assuming no stalls and continuous input.

## Power and Resources

The total on-chip power consumption is:
  - `Total Power`: 4.560 W
    - `Dynamic Power`: 3.946 W  (87%)
    - `Static Power`: 0.613 W (13%)
  

The design occupies a small fraction of the available FPGA resources, while DSP is high, potentially constraining future expansion.

| Resource        | Usage       | Estimated Percentages        |
|----------------|-------------------|----------------|
|     LUTs     |     17,540     |     7.6 %     |
| Flip-Flops (FFs)   |     143,695     |     31.2 %     |
| DSP   |     1,225     |     70.9 %     |
| BRAM  | 1 |  0.3 % |

## Design Considerations

This project is `actively under development and testing`. While functional validation and timing closure have been achieved, additional verification is still ongoing.

The current design is implemented entirely withing the `Programmable Logic (PL)` of the Zynq UltraScale+ device. All mechanisms are handled internally without direct interaction with the Processing System (PS).

If this design is to be integrated with the `Processing System (PS)`, special care must be taked due to clock domain differences between PS and PL. Since both of them typically operate on asychronous clocks, direct data exchange must be under decoupling memory or buffering mechanish such as:
  - Asychronous FIFO
  - Dual-port BRAM

## Setup

Below you can find a short guide on how to set up your system:
  
1. Open **Vivado 2025.1**
2. Create a new project and select **Xilinx Zynq Ultrascale+ ZCU104 FPGA**
3. Download the files from the project and place them into the appropriate projects folders
4. Run **Synthesis** and **Implementation**
5. Test the testbenches using **post-implementation functional timing simulation**

#### Note
If you find any bugs or issues, feel free to report them.

