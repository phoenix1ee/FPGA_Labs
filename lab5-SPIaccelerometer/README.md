# Lab 5: SPI 3-Axis Accelerometer Interface & Motion-Controlled VGA

## Overview
Lab 5 interfaces the Artix-7 FPGA with the onboard **Analog Devices ADXL362** 3-axis MEMS accelerometer via a custom **SPI (Serial Peripheral Interface)** bus controller implemented in VHDL.

The system reads 3-axis acceleration vectors and device identification registers, displays real-time register telemetry on the 7-segment display, and consolidates physical board tilting with pushbutton inputs to navigate the VGA grid cursor.

---

## Objectives
- Implement a 4-wire **SPI master controller** in VHDL (`SCLK`, `CSn`, `MOSI`, `MISO`) adhering to ADXL362 SPI protocol timing.
- Build a Finite State Machine (FSM) command sequencer (`command_control.vhd`) to configure the sensor (measurement mode) and poll acceleration registers periodically.
- Filter and threshold signed acceleration data ($X, Y, Z$) to detect board tilt gestures.
- Implement input consolidation (`motion_consolidate.vhd`) combining tilt gestures with debounced pushbuttons.
- Display diagnostic register telemetry (Device IDs and 8-bit acceleration values) on the 7-segment display.
- Drive the interactive 640x480 VGA display controller from physical motion.

---

## Hardware Platform
- **Board:** Digilent Nexys 4 DDR (or Nexys A7-100T)
- **FPGA:** AMD / Xilinx Artix-7 `XC7A100T-1CSG324C`
- **Sensor:** Analog Devices ADXL362 Ultra-low Power, 3-Axis MEMS Accelerometer
- **Display:** Standard 640x480 VGA (12-bit RGB DAC) and 8-digit 7-segment display

---

## Directory Structure
```
lab5-SPIaccelerometer/
├── lab5_top.vhd                    # System top-level integration
├── lab5_constraint.xdc             # Pin constraints for Nexys 4 DDR
├── lab5_top.bit                    # Pre-compiled bitstream
├── debouncer.vhd                   # Pushbutton debouncer filter
├── accel_control_input.vhd         # Tilt acceleration comparator & debouncer
├── motion_consolidate.vhd          # Combines tilt gestures and button presses
├── navigate.vhd                    # Grid position accumulator (X: 0..19, Y: 0..14)
├── pulse_gen.vhd                   # Clock pulse generator
├── reg_v_dsp_cntl.vhd              # Diagnostic register display selector
├── schematic.pdf                   # Top-level synthesized schematic
├── schematic-accele.pdf            # SPI & accelerometer subsystem schematic
├── accelerometer_SPI/              # SPI Bus Controller Subsystem
│   ├── accel_spi_rw.vhd            # SPI master wrapper (5 MHz SPI clock generator)
│   ├── command_control.vhd         # Command FSM sequencer (Init + 5-register polling)
│   └── SPI_control.vhd             # Byte-level SPI serializer/deserializer shift register
├── VGA_controller/                 # VGA Video Subsystem
│   ├── vga_controller.vhd          # Core VGA timing generator
│   ├── h_sync.vhd                  # Horizontal scan counter & sync
│   ├── V_sync.vhd                  # Vertical frame counter & sync
│   └── disp_enable_control.vhd     # Active video blanking gate
├── pixel_color_control/            # Procedural Video Pattern Generator
│   └── color_control.vhd           # 32x32 checkerboard and red cursor generator
└── seg7/                           # 7-Segment Multiplexed Display Subsystem
    ├── seg7_controller.vhd         # 8-digit time-division multiplexer
    ├── seg7_hex.vhd                # Hexadecimal decoder
    └── seg7_3bti_rotator.vhd       # Digit scanner counter
```

---

## System Architecture

```
                  +----------------------------------------------+
                  |               Artix-7 FPGA                   |
                  |                                              |
+----------+      |  +--------------------+     +-------------+  |
| ADXL362  |<=======>| accelerometer_SPI  |---->| reg_v_disp  |--+---> 7-Segment (Digits 7..4)
|  Sensor  | SPI  |  | (5 MHz SCLK Master)|     | Controller  |  |    (IDs or X/Y/Z Accel)
+----------+      |  +---------+----------+     +-------------+  |
                  |            | X, Y Accel                      |
                  |            v                                 |
+----------+      |  +--------------------+     +-------------+  |
| Buttons  |-------->| motion_consolidate |---->|  navigate   |--+---> 7-Segment (Digits 3..0)
| U,D,L,R  |      |  | (Tilt + Debounce)  |     |  (X, Y Pos) |  |    (Cursor Coordinates)
+----------+      |  +--------------------+     +------+------+  |
                  |                                    |         |
                  |                                    v         |
                  |                             +-------------+  |
                  |                             | VGA Subsys  |--+---> VGA Display
                  |                             | Checkerboard|  |    (640x480 @ 60 Hz)
                  |                             +-------------+  |
                  +----------------------------------------------+
```

---

## ADXL362 SPI Communication Protocol

The SPI master runs at **5 MHz** derived from the 100 MHz clock. Communication uses standard SPI Mode 0 ($CPOL = 0, CPHA = 0$):

1. **Initialization:**
   - Issues write command `0x0A` to register `0x2D` (`POWER_CTL`) with value `0x02` to place the accelerometer into continuous **Measurement Mode**.
2. **Polling Cycle:**
   The command FSM continuously issues 24-bit read transactions (`0x0B [Reg_Address] 0x00`):
   - `0x0B0000`: Read Register `0x00` $\rightarrow$ Device ID (`0xAD` for Analog Devices).
   - `0x0B0100`: Read Register `0x01` $\rightarrow$ MEMS ID (`0x1D`).
   - `0x0B0800`: Read Register `0x08` $\rightarrow$ `XDATA` (8-bit MSB of X-axis acceleration).
   - `0x0B0900`: Read Register `0x09` $\rightarrow$ `YDATA` (8-bit MSB of Y-axis acceleration).
   - `0x0B0A00`: Read Register `0x0A` $\rightarrow$ `ZDATA` (8-bit MSB of Z-axis acceleration).

---

## User Interface & Control Mapping

### 1. Accelerometer Telemetry Selection (`SW[4:3]`)
The upper 4 digits (`AN[7:4]`) of the seven-segment display show sensor register contents:

| `SW[4]` | `SW[3]` | Digits 7–6 | Digits 5–4 | Description |
| :---: | :---: | :---: | :---: | :--- |
| `0` | `0` | `1D` | `AD` | Hardware IDs (Confirming active SPI communication) |
| `0` | `1` | `00` | `XX` | X-axis acceleration register (`r0x08`) |
| `1` | `0` | `00` | `YY` | Y-axis acceleration register (`r0x09`) |
| `1` | `1` | `00` | `ZZ` | Z-axis acceleration register (`r0x0A`) |

### 2. Cursor Coordinates Display
The lower 4 digits (`AN[3:0]`) show the current red square cursor location on the VGA screen:
- Digits 3–2: Cursor **X** column (`00` to `19`)
- Digits 1–0: Cursor **Y** row (`00` to `14`)

### 3. Motion & Pushbutton Navigation
The cursor can be driven in two simultaneous modes:
- **Board Tilt:** Tilting the board front, back, left, or right past threshold `0x30` causes the cursor to navigate in the tilt direction.
- **Pushbuttons:** Pressing `BTNU`, `BTND`, `BTNL`, or `BTNR` provides manual incremental navigation.

---

## Hardware Pinout
| Function | Signal | Pin | Standard |
| :--- | :--- | :--- | :--- |
| **Clock** | `clock100mhz` | `E3` | LVCMOS33 |
| **Reset** | `SW[0]` | `J15` | LVCMOS33 |
| **SPI SCLK** | `ACL_SCLK` | `F15` | LVCMOS33 |
| **SPI CSn** | `ACL_CSN` | `D15` | LVCMOS33 |
| **SPI MOSI** | `ACL_MOSI` | `F14` | LVCMOS33 |
| **SPI MISO** | `ACL_MISO` | `E15` | LVCMOS33 |
| **VGA HSYNC**| `VGA_HS` | `B11` | LVCMOS33 |
| **VGA VSYNC**| `VGA_VS` | `B12` | LVCMOS33 |
| **VGA Red** | `VGA_R[3:0]` | `A4, C5, B4, A3` | LVCMOS33 |
| **VGA Green**| `VGA_G[3:0]` | `A6, B6, A5, C6` | LVCMOS33 |
| **VGA Blue** | `VGA_B[3:0]` | `D8, D7, C7, B7` | LVCMOS33 |
| **Buttons** | `BTNU, BTND, BTNL, BTNR` | `M18, P18, P17, M17` | LVCMOS33 |

---

## Quick Start
1. Program [`lab5_top.bit`](./lab5_top.bit) using Vivado Hardware Manager.
2. Confirm the 7-segment display shows `1D AD` on the left digits (verifies ADXL362 SPI communication).
3. Connect a VGA monitor to view the 640x480 checkerboard.
4. Tilt the Nexys 4 board or press directional buttons to move the red cursor.
