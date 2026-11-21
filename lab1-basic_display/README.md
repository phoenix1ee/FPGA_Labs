# Lab 1: Basic 7-Segment Display (Combinational / Dataflow)

## Overview
This laboratory introduces basic FPGA I/O interfacing and combinational logic design in VHDL using concurrent dataflow assignments. The design maps user switch inputs to an 8-digit multiplexed seven-segment display and status LEDs on the Digilent Nexys 4 DDR board.

## Objectives
- Understand basic FPGA hardware primitives: slide switches, pushbuttons, LEDs, and active-low seven-segment displays.
- Implement combinational hexadecimal decoding using concurrent VHDL (`with ... select`).
- Manage active-low anode and cathode signals for seven-segment display multiplexing.
- Understand the role of physical constraint files (`.xdc`) in pin assignment and I/O standard configuration (`LVCMOS33`).

---

## Hardware Platform
- **Board:** Digilent Nexys 4 DDR (or Nexys A7-100T)
- **FPGA:** AMD / Xilinx Artix-7 `XC7A100T-1CSG324C`
- **Clock:** Not required for this lab (purely combinational design)

---

## File Structure
| File | Description |
| :--- | :--- |
| [`lab1_top.vhd`](./lab1_top.vhd) | Top-level entity defining concurrent signal assignments for cathode and anode control |
| [`seg7_hex.vhd`](./seg7_hex.vhd) | 4-bit binary to 7-segment active-low hexadecimal decoder component (`0`–`F`) |
| [`lab1_constraint.xdc`](./lab1_constraint.xdc) | Xilinx Design Constraints file mapping top-level ports to FPGA package pins |
| [`schematic.pdf`](./schematic.pdf) | Vivado synthesized RTL schematic diagram |

---

## Architecture & Functional Behavior

```
               +------------------------------------------------+
SW(3 downto 0) |                                                |
-------------->| [seg7_hex Decoder]                             |
               | (Digit 0-F to Cathodes CA..CG, DP)             |
               +-----------------------+------------------------+
                                       |
                                       v
                                SEG7_CATH(7 downto 0) (Cathodes)
                                
BTNU, BTNC, BTND, SW(11 downto 4)
-------------------------------------> [Anode Control Logic]
                                       |
                                       v
                                AN(7 downto 0) (Anodes)

SW(15 downto 0) ---------------------> LED(15 downto 0)
```

### 1. Hexadecimal Seven-Segment Decoder (`seg7_hex.vhd`)
Translates a 4-bit input (`0x0` through `0xF`) into the active-low 8-bit cathode control vector `SEG7_CATH(7 downto 0)` (representing `{DP, CG, CF, CE, CD, CC, CB, CA}`):
- `0x0` -> `"11000000"`
- `0x1` -> `"11111001"`
- ...
- `0xF` -> `"10001110"`

### 2. Top-Level Control (`lab1_top.vhd`)
The top-level logic uses concurrent conditional assignments (`when ... else`):
- **Cathode Data Selection (`disp1_data`):**
  - If `BTNC = '1'`: displays `0x0` (`"0000"`).
  - Else: displays the hex value set by switches `SW(3 downto 0)`.
- **Anode Selection (`AN` - Active Low):**
  - If `BTNC = '1'`: `AN = "00000000"` (all 8 digits enabled simultaneously, showing identical digit).
  - Else if `BTNU = '1'`: `AN = "00001111"` (enables the upper 4 digits `AN[7..4]`).
  - Else if `BTND = '1'`: `AN = "11110000"` (enables the lower 4 digits `AN[3..0]`).
  - Else: `AN = not SW(11 downto 4)` (individual digits enabled directly by switches `SW[11..4]`).
- **LED Indicators:**
  - `LED(15 downto 0) <= SW(15 downto 0)` (direct real-time loopback of switch states).

---

## I/O Port Mapping
| Signal Name | Direction | Pins / Source | Description |
| :--- | :--- | :--- | :--- |
| `SW[3:0]` | Input | `J15, L16, M13, R15` | Hexadecimal value to display (`0x0`–`0xF`) |
| `SW[11:4]` | Input | `R17, T18, U18, R13, T8, U8, R16, T13` | Direct digit anode control when buttons are unpressed |
| `SW[15:12]` | Input | `H6, U12, U11, V10` | General inputs (mirrored to LEDs) |
| `BTNU` | Input | `M18` | Button Up: Enables upper 4 display digits (`AN[7..4]`) |
| `BTND` | Input | `P18` | Button Down: Enables lower 4 display digits (`AN[3..0]`) |
| `BTNC` | Input | `N17` | Button Center: Overrides display to show `0` on all 8 digits |
| `SEG7_CATH[7:0]` | Output | `H15, L18, T11, P15, K13, K16, R10, T10` | 7-segment cathodes (`DP`, `CG` down to `CA`) |
| `AN[7:0]` | Output | `U13, K2, T14, P14, J14, T9, J18, J17` | 7-segment digit enable anodes (`AN7` down to `AN0`) |
| `LED[15:0]` | Output | `V11` down to `H17` | Onboard green LEDs mirroring `SW[15:0]` |

---

## Build and Programming Instructions
1. Open **Vivado** and create a new project targeting `xc7a100tcsg324-1`.
2. Add source files: `lab1_top.vhd` and `seg7_hex.vhd`.
3. Add constraints: `lab1_constraint.xdc`.
4. Run **Synthesis** and **Implementation**.
5. Generate Bitstream and open the **Hardware Manager**.
6. Program the FPGA and test switch inputs and button presses.
