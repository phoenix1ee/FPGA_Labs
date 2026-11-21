# Lab 4: VGA Controller with Interactive Grid Navigation

## Overview
Lab 4 implements a complete standard 640x480 @ 60 Hz **VGA video display controller** in VHDL. The system generates active display timing, blanking, and horizontal/vertical sync pulses, rendering an interactive $20 \times 15$ checkerboard grid. Users can navigate a red cursor across the grid using debounced directional pushbuttons, with real-time cursor $(X, Y)$ coordinates displayed on the 7-segment display.

A companion Python simulation script is provided in [`signal_gen/`](./signal_gen/) to verify standard VGA synchronization timing.

---

## Objectives
- Understand standard video timing specifications: active video, front porch, sync pulse, and back porch.
- Derive a 25 MHz pixel clock enable from a 100 MHz oscillator.
- Generate standard active-low `HSYNC` and `VSYNC` pulses and handle display blanking to prevent video distortion.
- Implement synchronous input button debouncing (`debouncer.vhd`) with configurable latency.
- Render procedural 2D graphics (checkerboard grid + highlighted movable cursor).
- Coordinate multi-peripheral integration: Video DACs, debounced buttons, and multiplexed 7-segment display.

---

## Hardware Platform
- **Board:** Digilent Nexys 4 DDR (or Nexys A7-100T)
- **FPGA:** AMD / Xilinx Artix-7 `XC7A100T-1CSG324C`
- **Video Output:** 12-bit VGA connector (4-bit Red, 4-bit Green, 4-bit Blue, HSYNC, VSYNC)
- **Pixel Clock:** 25 MHz (4 cycles of 100 MHz system clock)

---

## File Structure
| File | Description |
| :--- | :--- |
| [`lab4_top.vhd`](./lab4_top.vhd) | Top-level entity interconnecting VGA controller, color generator, debouncer, navigation, and display |
| [`vga_controller.vhd`](./vga_controller.vhd) | Main VGA engine coordinating horizontal/vertical counters, sync signals, and video blanking |
| [`horizontal_sync.vhd`](./horizontal_sync.vhd) | Horizontal line scanner (counts 0 to 799; generates `HSYNC` and blanking intervals) |
| [`V_sync.vhd`](./V_sync.vhd) | Vertical frame scanner (counts 0 to 524 lines; generates `VSYNC` and frame blanking) |
| [`disp_enable_control.vhd`](./disp_enable_control.vhd) | Display enable logic asserting RGB outputs only during the active 640x480 display zone |
| [`color_control.vhd`](./color_control.vhd) | Pattern generator creating 32x32 checkerboard and painting the red cursor at grid coordinate `(x, y)` |
| [`navigate.vhd`](./navigate.vhd) | Grid position accumulator tracking cursor coordinates `X` (0..19) and `Y` (0..14) with boundary clamping |
| [`debouncer.vhd`](./debouncer.vhd) | Pushbutton debouncer filter preventing mechanical switch bounce false triggers (0.1s latency) |
| [`pulse_gen.vhd`](./pulse_gen.vhd) | Pulse generator generating 25 MHz pixel enable pulse from 100 MHz clock |
| [`counter.vhd`](./counter.vhd) | Synchronous counter primitive |
| [`seg7_controller.vhd`](./seg7_controller.vhd) | 8-digit multiplexed 7-segment display controller (from Lab 3) |
| [`seg7_hex.vhd`](./seg7_hex.vhd) | Hexadecimal cathode decoder |
| [`lab4_constraint.xdc`](./lab4_constraint.xdc) | Constraints file mapping clock, VGA pins, reset, pushbuttons, and 7-segment display |
| [`signal_gen/reference_output_vga.py`](./signal_gen/reference_output_vga.py) | Python reference model generating gold-standard timing verification CSV |
| [`signal_gen/vga_expected_timing.csv`](./signal_gen/vga_expected_timing.csv) | Reference CSV of expected cycle-by-cycle HSYNC, VSYNC, and RGB values |

---

## VGA Timing Specification (640x480 @ 60 Hz)

With a 25.0 MHz pixel clock:

| Timing Parameter | Horizontal (Pixels) | Vertical (Lines) |
| :--- | :--- | :--- |
| **Active Video** | 640 pixels | 480 lines |
| **Front Porch** | 16 pixels | 10 lines |
| **Sync Pulse** | 96 pixels (low) | 2 lines (low) |
| **Back Porch** | 48 pixels | 33 lines |
| **Total Period** | **800 pixels** (32.0 $\mu\text{s}$) | **525 lines** (16.68 ms $\approx$ 60 Hz) |

```
Horizontal Scanline Timing (800 Pixel Clocks total):
+------------------------------------+-------+-----------+--------+
|       Active Video (640 px)        |  FP   | Sync (96) |   BP   |
|         (RGB valid)                | (16)  |  (HS=0)   |  (48)  |
+------------------------------------+-------+-----------+--------+
0                                   640     656         752      800
```

---

## Functional Description

### 1. Checkerboard and Cursor Generation (`color_control.vhd`)
- Screen is divided into squares of $32 \times 32$ pixels.
- Horizontal squares: $640 / 32 = 20$ (columns $0$ to $19$, 5-bit `x`).
- Vertical squares: $480 / 32 = 15$ (rows $0$ to $14$, 4-bit `y`).
- Background checkerboard is created using bit 5 of the counters:
  ```vhdl
  color <= h_count(5) xor v_count(5);
  ```
- If the current pixel falls inside `(x, y)`:
  - Cursor square is rendered in solid **Red** (`RGB = 0xF00`).
- Otherwise:
  - Alternating checkerboard squares are rendered in light/dark contrasting tiles.
- During blanking intervals (`disp_enable = '0'`), RGB outputs are forced to `0x000` to prevent visual streaking and invalid voltage levels.

### 2. Pushbutton Debouncing & Navigation (`debouncer.vhd` & `navigate.vhd`)
- Mechanical pushbuttons are sampled and filtered with a debounce counter of 10,000,000 cycles (0.1 s latency at 100 MHz).
- Debounced single-cycle pulses feed into `navigate.vhd`:
  - `BTNU` (`pulse_u`): decrements `y` (clamps at `0`).
  - `BTND` (`pulse_d`): increments `y` (clamps at `14`).
  - `BTNL` (`pulse_l`): decrements `x` (clamps at `0`).
  - `BTNR` (`pulse_r`): increments `x` (clamps at `19`).

### 3. Coordinate Readout on 7-Segment Display
The active cursor position is passed into the 8-digit 7-segment display controller:
- Digits 3–2: Cursor $X$ coordinate (00 to 19).
- Digits 1–0: Cursor $Y$ coordinate (00 to 14).

---

## I/O Pinout Mapping
| Port | Pin | Description |
| :--- | :--- | :--- |
| `clock100mhz` | `E3` | 100 MHz onboard oscillator |
| `reset` | `J15` (`SW[0]`) | System reset |
| `BTNU` | `M18` | Move cursor Up |
| `BTND` | `P18` | Move cursor Down |
| `BTNL` | `P17` | Move cursor Left |
| `BTNR` | `M17` | Move cursor Right |
| `VGA_HS` | `B11` | VGA Horizontal Sync |
| `VGA_VS` | `B12` | VGA Vertical Sync |
| `VGA_R[3:0]` | `A4, C5, B4, A3` | 4-bit VGA Red DAC |
| `VGA_G[3:0]` | `A6, B6, A5, C6` | 4-bit VGA Green DAC |
| `VGA_B[3:0]` | `D8, D7, C7, B7` | 4-bit VGA Blue DAC |
| `AN1[7:0]` | `U13` .. `J17` | 7-segment display digit anodes |
| `SEG7_CATH1[7:0]` | `H15` .. `T10` | 7-segment display cathodes |

---

## Verification via Python Model
In [`signal_gen/`](./signal_gen/):
- Run `python reference_output_vga.py` to regenerate `vga_expected_timing.csv`.
- This file models all $525 \times 800 = 420,000$ clock ticks of a full frame, providing expected states of `HSYNC`, `VSYNC`, and color blanking for testbench verification.
