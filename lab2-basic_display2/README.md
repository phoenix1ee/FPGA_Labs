# Lab 2: Basic 7-Segment Display (Behavioral / Process-Based)

## Overview
Lab 2 extends and refactors the combinational design of Lab 1 by replacing concurrent dataflow assignments with **sequential behavioral processes** (`process` blocks) utilizing `case` and `if-elsif-else` control constructs. It also includes synthesis and utilization reports along with a pre-built bitstream to analyze FPGA resource usage.

## Objectives
- Compare **dataflow** (`when ... else`, `with ... select`) versus **behavioral** (`process`, `case`, `if ... then ... else`) VHDL modeling paradigms.
- Verify that both description styles synthesize into equivalent hardware primitives (LUTs and I/O buffers).
- Read and interpret Vivado synthesis reports and resource utilization metrics on an AMD Artix-7 device.

---

## Hardware Platform
- **Board:** Digilent Nexys 4 DDR (or Nexys A7-100T)
- **FPGA:** AMD / Xilinx Artix-7 `XC7A100T-1CSG324C`
- **Clock:** Not required (purely combinational behavioral processes)

---

## File Structure
| File | Description |
| :--- | :--- |
| [`lab2_top.vhd`](./lab2_top.vhd) | Top-level behavioral VHDL architecture using explicit `process` blocks |
| [`seg7_hex.vhd`](./seg7_hex.vhd) | 4-bit binary to 7-segment active-low hexadecimal decoder component |
| [`lab1_constraint.xdc`](./lab1_constraint.xdc) | Physical constraints file for Nexys 4 DDR board I/O mapping |
| [`lab2_top.bit`](./lab2_top.bit) | Pre-generated FPGA configuration bitstream ready for hardware programming |
| [`lab2-schematic.pdf`](./lab2-schematic.pdf) | Vivado synthesized RTL schematic view |
| [`lab2_top_synthesis_report.txt`](./lab2_top_synthesis_report.txt) | Detailed Vivado synthesis log |
| [`lab2_top_utilization_synth.txt`](./lab2_top_utilization_synth.txt) | Post-synthesis device utilization report |

---

## Behavioral Implementation Details

### 1. Cathode Process (`cathode`)
Instead of concurrent conditional assignments, a combinational process with a complete sensitivity list (`BTNC, SW`) evaluates `BTNC` inside a `case` statement:
```vhdl
cathode : process(BTNC, SW)
begin
    case BTNC is
        when '1' =>
            disp1_data <= "0000";
        when others =>
            disp1_data <= SW(3 downto 0);
    end case;   
end process cathode;
```

### 2. Anode Control Process (`anode`)
An explicit priority-encoded `if-elsif-else` process controls digit enablement:
```vhdl
anode : process(BTNU, BTND, SW)
begin
    if (BTNC = '1') then
        AN <= "00000000";
    elsif (BTNU = '1') then
        AN <= "00001111";
    elsif (BTND = '1') then
        AN <= "11110000";
    else
        AN <= not SW(11 downto 4);
    end if;
end process anode;
```

---

## Resource Utilization Summary

From [`lab2_top_utilization_synth.txt`](./lab2_top_utilization_synth.txt) for the Artix-7 `XC7A100T`:
- **Slice LUTs:** `8` of `63,400` (<0.01% utilization)
  - 7 LUTs for the hexadecimal 7-segment decoder
  - 1 LUT for conditional data selection
- **Bonded IOB:** `51` of `210` (24.29%)
  - 16 Switches (`SW[15:0]`)
  - 3 Buttons (`BTNU`, `BTNC`, `BTND`)
  - 16 LEDs (`LED[15:0]`)
  - 8 Cathodes (`SEG7_CATH[7:0]`)
  - 8 Anodes (`AN[7:0]`)
- **Registers (Flip-Flops):** `0` (Zero sequential storage elements inferred, confirming purely combinational logic)

---

## I/O Pinout
The pinout is identical to Lab 1, as defined in [`lab1_constraint.xdc`](./lab1_constraint.xdc):
- `SW[3:0]`: Digit value to display
- `SW[11:4]`: Individual digit enable when buttons are released
- `BTNC`: Center button to display `0` on all digits
- `BTNU`: Upper 4 digits display `SW[3:0]`
- `BTND`: Lower 4 digits display `SW[3:0]`
- `LED[15:0]`: Directly mirrors `SW[15:0]`

---

## Programming the Board
You can program the board directly using the included bitstream without re-synthesizing:
1. Connect the Nexys 4 DDR board to your computer via USB (PROG/UART port).
2. Open Vivado -> **Hardware Manager** -> **Open Target** -> **Auto Connect**.
3. Select `xc7a100t_0` and choose **Program Device**.
4. Point to [`lab2_top.bit`](./lab2_top.bit) and click **Program**.
