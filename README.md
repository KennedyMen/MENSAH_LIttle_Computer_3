
# MENSAH Little Computer 3

## Overview
This project implements a simplified version of the Little Computer 3 (LC-3) architecture using VHDL (VHSIC Hardware Description Language). The LC-3 is a minimalistic educational computer architecture designed for teaching the fundamentals of computer organization and architecture. This VHDL implementation provides a hands-on approach to understanding digital logic design, sequential circuits, and computer architecture concepts.

## Features

### LC-3 Instruction Set
- Supports a subset of the LC-3 instruction set, including arithmetic, logic, control flow, and data movement instructions.

### Memory System
- Implements memory components such as instruction memory and data memory, providing storage for both program instructions and data.

### ALU (Arithmetic Logic Unit)
- Executes arithmetic and logic operations on data according to the instruction set.

### Control Unit
- Orchestrates the execution of instructions by controlling the flow of data between various components of the LC-3.

### I/O Interfaces
- Interfaces for input and output operations, allowing interaction with external devices such as displays, keyboards, or other peripherals.

### Simulation
- Simulate the behavior of the LC-3 design using VHDL simulation tools such as ModelSim or GHDL.

## File Structure

- `MENSAH_COMPONENTS.vhd`: Contains component definitions.
- `MENSAH_DATA_PATH.vhd`: Implements the data path.
- `MENSAH_LC3.vhd`: Top-level VHDL file for the LC-3.
- `MENSAH_TB_LC3.vhd`: Testbench for simulating the LC-3.
- `clock.vhd`: Clock generation module.
- `txt_util.vhd` and `util_pkg.vhd`: Utility packages.

## Getting Started

1. **Clone the repository**:
    ```sh
    git clone https://github.com/KennedyMen03032731/MENSAH_Little_Computer_3.git
    cd MENSAH_Little_Computer_3
    ```
2. **Open in your VHDL simulation tool**: Use tools like ModelSim or GHDL to open the project files.
3. **Run simulations**: Use the provided testbench `MENSAH_TB_LC3.vhd` to simulate and verify the design.

## Acknowledgements

- Inspired by the Little Computer 3 (LC-3) architecture designed by Yale Patt and Sanjay Patel.


## Screenshots

### Basic Setup
![Basic Schematic Setup](https://i.ibb.co/QvWS4Xs/Screenshot-2024-05-15-at-6-24-08-AM.png)

### DVT VHDL Schematic
![Schematic Diagram](https://i.ibb.co/fM4XPm0/schematic-of-path.png)
