# Lab 6: PicoBlaze Soft-Core Processor 16-Bit Calculator

## Overview
Lab 6 implements an embedded soft-core computing system on the Artix-7 FPGA by instantiating the Xilinx **KCPSM6 (PicoBlaze-6)** 8-bit RISC microcontroller. The processor executes firmware written in PicoBlaze assembly (`lab6_starter.psm`) that implements a multi-function 16-bit arithmetic calculator with interactive hardware I/O, software debouncing, 7-segment display readout, and serial UART support.

---

## Objectives
- Integrate a soft-core processor IP core (`kcpsm6.vhd`) into an FPGA hardware design.
- Define a memory-mapped I/O port address space interfacing hardware peripherals (buttons, switches, LEDs, UART, timers) to processor assembly software.
- Write, assemble, and link embedded assembly firmware using `kcpsm6.exe`.
- Implement 16-bit multi-precision arithmetic subroutines in an 8-bit architecture:
  - 16-bit Addition with carry propagation (`ADDCY`).
  - 16-bit Subtraction with borrow propagation (`SUBCY`).
  - Multi-bit Logical Shift Left (`SL0` / `SLA`).
  - Multi-bit Shift-and-Add Multiplication algorithm.
- Implement software button debouncing and state machine polling.

---

## Hardware Platform
- **Board:** Digilent Nexys 4 DDR (or Nexys A7-100T)
- **FPGA:** AMD / Xilinx Artix-7 `XC7A100T-1CSG324C`
- **Core Clock:** 50 MHz (derived by dividing 100 MHz oscillator by 2)
- **Soft Core:** Xilinx KCPSM6 (PicoBlaze-6) 8-bit RISC soft processor
- **UART Communication:** 115,200 baud, 8-N-1

---

## Directory Structure
```
lab6-SoftIPCore_PICOBLAZE_calculator/
├── lab6_utilization_synth.txt       # Post-synthesis resource utilization report
├── synthesis_report.txt             # Vivado synthesis execution log
├── Picoblaze_Base_Project_Files/    # Hardware (VHDL) Implementation
│   ├── top_level.vhd                # Top-level entity with PicoBlaze bus decoding
│   ├── kcpsm6.vhd                   # KCPSM6 PicoBlaze soft-core processor macro
│   ├── lab6_starter.vhd             # Assembled firmware instruction ROM (2K words)
│   ├── clkdivider.vhd               # Clock divider for baud rate and ms timer
│   ├── seg7_driver.vhd              # 4-digit 7-segment display driver
│   ├── uart_rx6.vhd                 # KCPSM6 companion UART receiver (16x oversampling)
│   ├── uart_tx6.vhd                 # KCPSM6 companion UART transmitter
│   └── Nexys4DDR_Master.xdc         # Physical constraints for Nexys 4 DDR board
└── Picoblaze_Tools/                 # Software Development & Assembly Tools
    ├── kcpsm6.exe                   # Official KCPSM6 assembler executable (DOS/Windows)
    ├── lab6_starter.psm             # Calculator assembly source code
    ├── lab6_starter.fmt             # Formatted assembly listing
    ├── lab6_starter.hex             # Generated hex program image
    ├── lab6_starter.log             # Assembler compilation log
    ├── lab6_starter.vhd             # Generated VHDL BRAM ROM module
    ├── ROM_form.vhd                 # VHDL template used by assembler
    └── README.txt                   # Assembler instructions
```

---

## System Architecture

```
                    100 MHz Oscillator (Pin E3)
                                 |
                          [/2 Prescaler]
                                 |
                             50 MHz clk
                                 |
         +-----------------------+-----------------------+
         |                                               |
         v                                               v
+------------------+   Instruction   +-----------------------+
| lab6_starter.vhd |<----------------|     kcpsm6 Core       |
| Instruction ROM  |---------------->|   (PicoBlaze-6)       |
+------------------+  (18-bit word)  +-----+-----------+-----+
                                           |           ^
                             PORT_ID(7..0) |           | IN_PORT(7..0)
                            OUT_PORT(7..0) |           |
                             WRITE_STROBE  |           |
                                           v           |
                                    +---------------------+
                                    | I/O Port Controller |
                                    +----------+----------+
                                               |
       +-------------------+-------------------+-------------------+
       |                   |                   |                   |
       v                   v                   v                   v
+--------------+    +--------------+    +--------------+    +--------------+
| Switches     |    | Push Buttons |    | 7-Segment    |    | UART Tx/Rx   |
| SW[7:0]      |    | Debounced    |    | 4-Digit Hex  |    | 115.2 kbps   |
| (Port 02)    |    | (Port 03)    |    | (Port 04,05) |    | (Port 00,01) |
+--------------+    +--------------+    +--------------+    +--------------+
```

---

## PicoBlaze Memory-Mapped I/O Specification

### Input Ports (`INPUT sX, Port_ID`)
| Port ID | Signal / Peripheral | Description |
| :---: | :--- | :--- |
| `0x00` | UART Status Register | Bit 0: `rx_data_present`, Bit 1: `tx_half`, Bit 2: `tx_full`, Bit 3: `rx_half`, Bit 4: `rx_full` |
| `0x01` | UART Data In | Received byte from UART RX buffer |
| `0x02` | Slider Switches | `SW[7:0]` (Operand value and operation selectors) |
| `0x03` | Pushbuttons | `[3:0] = {BTND, BTNU, BTNL, BTNR}` |
| `0x04` | 7-Segment Lower Byte | Readback of `Val_L` register |
| `0x05` | 7-Segment Upper Byte | Readback of `Val_U` register |
| `0x06` | LED Register | Readback of active LED state |
| `0x07` | Millisecond Timer LSB | 1 kHz real-time counter lower byte |
| `0x08` | Millisecond Timer MSB | 1 kHz real-time counter upper byte |

### Output Ports (`OUTPUT sX, Port_ID`)
| Port ID | Signal / Peripheral | Description |
| :---: | :--- | :--- |
| `0x01` | UART Data Out | Transmit byte to UART TX buffer |
| `0x04` | 7-Segment Digits 1–0 | Lower byte of 16-bit display (`Val_L`) |
| `0x05` | 7-Segment Digits 3–2 | Upper byte of 16-bit display (`Val_U`) |
| `0x06` | LED Output | 8-bit board LED drivers (`LED[7:0]`) |

---

## Calculator Firmware Operation (`lab6_starter.psm`)

The calculator maintains a persistent 16-bit accumulator stored in register pair `[Val_U : Val_L]`, shown on the four lower 7-segment digits.

### Control & Switch Functionality:
- **`SW[3:0]`**: 4-bit unsigned input operand ($0$ to $15$).
- **`SW[7:4]`**: Operation Selector:
  - `SW[4] = 1`: **Addition** $\rightarrow$ `Accumulator <= Accumulator + SW[3:0]`
  - `SW[5] = 1`: **Subtraction** $\rightarrow$ `Accumulator <= Accumulator - SW[3:0]`
  - `SW[6] = 1`: **Shift Left** $\rightarrow$ `Accumulator <= Accumulator << SW[3:0]`
  - `SW[7] = 1`: **Multiplication** $\rightarrow$ `Accumulator <= Accumulator * SW[3:0]`
- **`BTNR` (Button Right)**: Execute Operation trigger (reads switches and applies selected operation).
- **`BTND` (Button Down)**: Master Clear / Reset (clears accumulator to `0x0000`).
- **`CPU_RESETN`**: Hardware asynchronous system reset pin.

### Multi-Precision Algorithms in Assembly:
- **Multiplication via Shift-and-Add (`opmul`):** Iterates across a bit mask (`temp_C`), testing each bit of the 4-bit operand. When set, shifts the multiplicand left by the bit index (`CALL opshift`) and accumulates the partial sum with full 16-bit carry addition.
- **Software Debouncing (`del10ms`):** Samples pushbuttons twice separated by a 10 ms delay loop; performs a bitwise `AND` on both samples to reject mechanical switch bounce.

---

## Assembly & Build Workflow
If you modify `lab6_starter.psm`:
1. Open a terminal in the `Picoblaze_Tools/` directory.
2. Run the KCPSM6 assembler:
   ```cmd
   kcpsm6.exe lab6_starter.psm
   ```
3. The assembler will generate an updated [`lab6_starter.vhd`](./Picoblaze_Base_Project_Files/lab6_starter.vhd) ROM file.
4. Copy `lab6_starter.vhd` into `Picoblaze_Base_Project_Files/` (or update the file directly).
5. In Vivado, run **Synthesis**, **Implementation**, and **Generate Bitstream**.
