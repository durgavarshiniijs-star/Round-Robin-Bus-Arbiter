# Round Robin Bus Arbiter

## Project Overview

This project implements a 4-request Round Robin Bus Arbiter using Verilog HDL. The arbiter manages multiple request signals and grants access to one requester at a time using a rotating priority mechanism.

Unlike fixed-priority arbitration, Round Robin arbitration provides fair access by changing the priority after each successful grant.

## Design Specifications

- Number of requesters: 4
- Request signals: `req[3:0]`
- Grant signals: `grant[3:0]`
- Clock: Positive-edge triggered
- Reset: Asynchronous active-high
- Arbitration: Round Robin priority-based selection
- Priority pointer: 2-bit register

## Working Principle

The arbiter maintains a priority pointer that determines which requester receives the highest priority.

After a successful grant, the priority pointer advances to the next requester. This ensures that no requester continuously dominates the arbitration process when multiple requests remain active.

## Verification and Testing

The testbench includes:

1. Clock generation and reset initialization.
2. Directed request testing.
3. Multiple simultaneous request testing.
4. Randomized request testing.
5. Mutual exclusion checking.
6. Invalid grant checking.
7. Fairness verification.

## Tools and Technologies

- Verilog HDL / SystemVerilog
- EDA Playground
- Icarus Verilog
- EPWave
- GTKWave (optional, for viewing VCD files)
- GitHub

## Simulation

The design and testbench were simulated using EDA Playground.

**EDA Playground Project:**  
https://edaplayground.com/x/ejdH

The testbench generates `wave.vcd` for waveform inspection.

## Key Concepts Demonstrated

- Combinational logic
- Sequential logic
- Priority arbitration
- Round Robin scheduling
- Verilog testbench development
- Functional verification
- Waveform analysis

## Author

Durgavarshini J S