# FPGA & VHDL Laboratory Projects

A progressive series of digital design laboratories in **VHDL** implemented on the **AMD / Xilinx Artix-7 FPGA** using the **Digilent Nexys 4 DDR** (Nexys A7-100T) development board. 

The projects advance incrementally from combinational and behavioral logic, synchronous sequential counters, and time-multiplexed displays to standard VGA video controllers, hardware SPI bus interfaces for MEMS motion sensors, soft-core RISC microcontrollers (Xilinx KCPSM6 PicoBlaze), and Direct Digital Synthesis (DDS) PWM audio synthesizers.

---

## Target Hardware Specifications

| Component | Specification |
| :--- | :--- |
| **FPGA Device** | AMD / Xilinx Artix-7 `XC7A100T-1CSG324C` |
| **Development Board** | Digilent Nexys 4 DDR (compatible with Nexys A7-100T) |
| **Primary Clock** | 100 MHz Single-Ended Oscillator (Pin `E3`) |
| **User I/O** | 16 Slide Switches, 5 Pushbuttons, 16 User LEDs |
| **Displays** | 8-Digit Common Anode Multiplexed Seven-Segment Display |
| **Video** | 12-bit Analog VGA Output (4-bit R, 4-bit G, 4-bit B, HSYNC, VSYNC) |
| **Sensors** | Analog Devices ADXL362 3-Axis SPI MEMS Accelerometer |
| **Audio** | Analog Devices SSM2211 Class-D Mono Audio Amp via 10-bit PWM (`AUD_PWM`, `AUD_SD`) |
| **Communication** | FTDI FT2232HQ USB-UART Bridge (115,200 baud) |
| **EDA Toolchain** | AMD / Xilinx Vivado Design Suite |

---

## Laboratory Overview

| Lab | Name & Folder | Key Concepts | Peripherals / Interfaces |
| :---: | :--- | :--- | :--- |
| **01** | [**lab1-basic_display**](./lab1-basic_display) | Combinational logic, concurrent dataflow VHDL (`with ... select`, `when ... else`), hex decoding | Switches (`SW[3:0]`, `SW[11:4]`), Pushbuttons (`BTNU`, `BTNC`, `BTND`), 7-Segment Display, LEDs |
| **02** | [**lab2-basic_display2**](./lab2-basic_display2) | Behavioral modeling, clocked/combinational `process` blocks (`case`, `if-elsif-else`), Vivado synthesis & utilization analysis | Switches, Pushbuttons, 7-Segment Display, LEDs |
| **03** | [**lab3-clocked_display**](./lab3-clocked_display) | Synchronous sequential design, pulse generators, 1 kHz display multiplexing (>100 Hz refresh), 32-bit shifting marquee register | 100 MHz Clock, Switches, Center Reset Button, 8-Digit 7-Segment Display |
| **04** | [**lab4-VGA_controller**](./lab4-VGA_controller) | Standard 640x480 @ 60 Hz VGA timing generator, 25 MHz pixel enable, debouncing filter, 2D checkerboard pattern & cursor navigation | 12-bit VGA DAC, Pushbuttons (`BTNU/D/L/R`), 7-Segment Display (X/Y coordinates)|
| **05** | [**lab5-SPIaccelerometer**](./lab5-SPIaccelerometer) | 4-wire SPI master interface (5 MHz), command FSM sequencing, ADXL362 3-axis accelerometer, tilt gesture thresholding, motion-controlled VGA cursor | ADXL362 MEMS Accelerometer (SPI), VGA Display, 7-Segment Display (Register IDs & Accel telemetry), Pushbuttons |
| **06** | [**lab6-SoftIPCore_PICOBLAZE_calculator**](./lab6-SoftIPCore_PICOBLAZE_calculator) | Xilinx KCPSM6 (PicoBlaze-6) 8-bit soft processor core, memory-mapped I/O, assembly firmware (`.psm`), 16-bit multi-precision arithmetic (+, -, <<, *), UART | Soft-Core RISC CPU, Switches, Pushbuttons, 4-Digit 7-Segment Display, 115.2 kbps UART, KCPSM6 Assembler |
| **07** | [**lab7-SineWaveGen**](./lab7-SineWaveGen) | Direct Digital Synthesis (DDS), Xilinx DDS Compiler IP block, phase accumulator, volume bit-shifting, 10-bit PWM audio driver (~97.6 kHz), Double Dabble binary-to-BCD conversion | Xilinx DDS IP Core, 3.5mm Mono Audio Jack (`AUD_PWM`, `AUD_SD`), 7-Segment Display (Dec Frequency & Vol%), Switches |

---

## Detailed Lab Summaries

### [Lab 1: Basic 7-Segment Display (Dataflow)](./lab1-basic_display)
- Implements a combinational 4-bit binary-to-hexadecimal decoder (`seg7_hex.vhd`).
- Uses concurrent dataflow signal assignments (`when ... else` and `with ... select`) to display hexadecimal digits on the active-low seven-segment displays.
- Selects individual digits or digit banks using pushbuttons and slide switches.
- Directly loops back slide switch positions to onboard LEDs.

### [Lab 2: Basic 7-Segment Display (Behavioral)](./lab2-basic_display2)
- Re-architects Lab 1's combinational functionality using sequential behavioral VHDL constructs within `process` blocks.
- Compares `case` statements and priority-encoded `if-elsif-else` blocks against concurrent assignments.
- Explores synthesis and implementation reports, showing identical low-level hardware utilization (8 LUTs and 0 Flip-Flops).
- Includes pre-compiled bitstream and synthesized schematic.

### [Lab 3: Clocked 7-Segment Display & Shifting Marquee](./lab3-clocked_display)
- Introduces synchronous sequential logic operating on the board's 100 MHz clock.
- Builds parameterized pulse generator modules to generate a 1 kHz display refresh pulse and a 1 Hz sampling pulse.
- Drives an 8-digit time-division multiplexer scanning digits at 125 Hz per digit to eliminate visual flicker.
- Implements a 32-bit synchronous left-shift register that samples 4-bit switch values every second, scrolling hexadecimal characters across the 8 digits.

### [Lab 4: VGA Controller with Interactive Grid Navigation](./lab4-VGA_controller)
- Implements a full standard 640x480 @ 60 Hz VGA video sync generator (800 total horizontal clocks, 525 vertical lines) using a 25 MHz pixel clock derived from 100 MHz.
- Generates precise active-low `HSYNC` and `VSYNC` signals and gates RGB color lines during blanking intervals.
- Procedurally renders a $20 \times 15$ checkerboard of $32 \times 32$ pixel squares.
- Features debounced directional pushbuttons (0.1 s latency) to move a red cursor square across the grid, clamping at screen borders.
- Displays real-time cursor coordinates $(X, Y)$ on the seven-segment display.
- Includes a standalone Python script (`signal_gen/reference_output_vga.py`) modeling frame-by-frame sync signals for verification.

### [Lab 5: SPI 3-Axis Accelerometer Interface & Motion-Controlled VGA](./lab5-SPIaccelerometer)
- Designs a complete 4-wire SPI bus master controller running at 5 MHz in VHDL.
- Implements a Finite State Machine (FSM) sequencer to initialize the onboard Analog Devices ADXL362 MEMS accelerometer into continuous measurement mode and continuously poll device IDs (`0xAD`, `0x1D`) and 3-axis acceleration registers ($X, Y, Z$).
- Telemetry readout mode: Displays hardware IDs or raw signed acceleration registers on the upper digits of the 7-segment display.
- Motion consolidation: Thresholds $X$ and $Y$ tilt values to detect board tilting, seamlessly integrating with pushbuttons to steer the VGA cursor.

### [Lab 6: PicoBlaze Soft-Core Processor 16-Bit Calculator](./lab6-SoftIPCore_PICOBLAZE_calculator)
- Instantiates the Xilinx KCPSM6 (PicoBlaze-6) 8-bit soft RISC microprocessor core clocked at 50 MHz.
- Constructs a memory-mapped I/O address decoding network bridging processor ports to slide switches, pushbuttons, LEDs, 7-segment displays, hardware millisecond timers, and a 115,200 baud UART.
- Firmware written in PicoBlaze assembly (`lab6_starter.psm`) implements a 16-bit interactive calculator supporting:
  - Software button debouncing
  - 16-bit Addition with carry propagation
  - 16-bit Subtraction with borrow propagation
  - Multi-bit Logical Shift Left
  - Shift-and-Add Multiplication algorithm
- Includes the KCPSM6 assembler toolchain and ROM generation flow.

### [Lab 7: DDS Sine Wave Audio Generator & PWM Audio Synthesizer](./lab7-SineWaveGen)
- Implements digital Direct Digital Synthesis (DDS) using the AMD/Xilinx DDS Compiler IP block (`sine_lut_dds`).
- Features a phase accumulator and frequency controller supporting 8 switch-selectable tones ($500\text{ Hz}$ to $3500\text{ Hz}$).
- Volume level shifter provides 8 dynamic attenuation levels ($0\%$ to $100\%$) via arithmetic bit-shifting.
- Drives the onboard audio amplifier with a 10-bit PWM DAC operating at a ~97.6 kHz carrier frequency.
- Implements the classic **Double Dabble** (shift-and-add-3) algorithm in RTL to convert binary telemetry into decimal BCD for display on the 8-digit 7-segment display (Volume % and Frequency in Hz).

---

## Repository Structure

```
FPGA_Labs/
├── README.md                                       # Master repository documentation (this file)
├── lab1-basic_display/                             # Lab 1: Combinational 7-segment display
│   ├── README.md
│   ├── lab1_top.vhd
│   ├── seg7_hex.vhd
│   ├── lab1_constraint.xdc
│   └── schematic.pdf
├── lab2-basic_display2/                            # Lab 2: Behavioral 7-segment display
│   ├── README.md
│   ├── lab2_top.vhd
│   ├── seg7_hex.vhd
│   ├── lab1_constraint.xdc
│   └── lab2-schematic.pdf
├── lab3-clocked_display/                           # Lab 3: Synchronous multiplexed display
│   ├── README.md
│   ├── lab3_top.vhd
│   ├── seg7_controller.vhd
│   ├── 1hz_pulse.vhd
│   ├── pulse_gen.vhd
│   ├── counter.vhd
│   ├── char_shift.vhd
│   ├── seg7_hex.vhd
│   └── lab3_constraint.xdc
├── lab4-VGA_controller/                            # Lab 4: 640x480 VGA controller & navigation
│   ├── README.md
│   ├── lab4_top.vhd
│   ├── vga_controller.vhd
│   ├── horizontal_sync.vhd
│   ├── V_sync.vhd
│   ├── disp_enable_control.vhd
│   ├── color_control.vhd
│   ├── navigate.vhd
│   ├── debouncer.vhd
│   ├── pulse_gen.vhd
│   ├── counter.vhd
│   ├── seg7_controller.vhd
│   ├── seg7_hex.vhd
│   └── lab4_constraint.xdc
├── lab5-SPIaccelerometer/                          # Lab 5: ADXL362 SPI & motion-controlled VGA
│   ├── README.md
│   ├── lab5_top.vhd
│   ├── motion_consolidate.vhd
│   ├── navigate.vhd
│   ├── debouncer.vhd
│   ├── accel_control_input.vhd
│   ├── reg_v_dsp_cntl.vhd
│   ├── pulse_gen.vhd
│   ├── lab5_constraint.xdc
│   ├── schematic.pdf
│   ├── schematic-accele.pdf
│   ├── accelerometer_SPI/
│   │   ├── accel_spi_rw.vhd
│   │   ├── command_control.vhd
│   │   └── SPI_control.vhd
│   ├── VGA_controller/
│   │   ├── vga_controller.vhd
│   │   ├── h_sync.vhd
│   │   ├── V_sync.vhd
│   │   └── disp_enable_control.vhd
│   ├── pixel_color_control/
│   │   └── color_control.vhd
│   └── seg7/
│       ├── seg7_controller.vhd
│       ├── seg7_hex.vhd
│       └── seg7_3bti_rotator.vhd
├── lab6-SoftIPCore_PICOBLAZE_calculator/           # Lab 6: PicoBlaze soft-core processor
│   ├── README.md
│   ├── Picoblaze_Base_Project_Files/
│   │   ├── top_level.vhd
│   │   ├── kcpsm6.vhd
│   │   ├── lab6_starter.vhd
│   │   ├── clkdivider.vhd
│   │   ├── seg7_driver.vhd
│   │   ├── uart_rx6.vhd
│   │   ├── uart_tx6.vhd
│   │   └── Nexys4DDR_Master.xdc
│   └── Picoblaze_Tools/
│       ├── kcpsm6.exe
│       ├── lab6_starter.psm
│       └── lab6_starter.vhd
└── lab7-SineWaveGen/                               # Lab 7: DDS sine generator & PWM audio
    ├── README.md
    ├── lab7_top.vhd
    ├── frequency_control.vhd
    ├── phase_accu.vhd
    ├── vol_level_control.vhd
    ├── PWM_generator.vhd
    ├── Hex2Decdigit.vhd
    ├── pulse_gen.vhd
    ├── lab7_constraint.xdc
    ├── schematic.pdf
    ├── seg7/
    │   ├── seg7_controller.vhd
    │   ├── seg7_hex.vhd
    │   └── seg7_3bti_rotator.vhd
    └── sine_lut_dds/
        └── sine_lut_dds.xci
```

---

## Tool Requirements & Setup

1. **Xilinx Vivado Design Suite**:
   - Version 2020.1 or newer recommended (tested up to 2025.2).
   - Ensure the **Artix-7** device family support is installed.
   - Part number: `xc7a100tcsg324-1`.
2. **PicoBlaze Assembler (Lab 6)**:
   - `kcpsm6.exe` (included in [`lab6-SoftIPCore_PICOBLAZE_calculator/Picoblaze_Tools/`](./lab6-SoftIPCore_PICOBLAZE_calculator/Picoblaze_Tools/)).
   - Runs natively on Windows; can run under Wine on Linux / macOS.

---

## General Vivado Project Build Instructions

To plug and play or build upon any of the labs in Vivado:
1. Launch **Vivado** and click **Create Project**.
2. Select **RTL Project** and check *Do not specify sources at this time*.
3. In the Default Part selector, choose:
   - Category: **General Purpose**
   - Family: **Artix-7**
   - Package: **csg324**
   - Speed: **-1**
   - Target Part: **`xc7a100tcsg324-1`** (or select board: **Digilent Nexys 4 DDR**).
4. Click **Add Sources** -> **Add or create design sources** and add all `.vhd` files from the specific lab folder (including subdirectories where applicable).
5. (For Lab 7): Click **Add Sources** -> **Add or create IP** and add `sine_lut_dds/sine_lut_dds.xci`.
6. Click **Add Sources** -> **Add or create constraints** and add the lab's `.xdc` constraint file.
7. Click **Run Synthesis** $\rightarrow$ **Run Implementation** $\rightarrow$ **Generate Bitstream**.
8. Open **Hardware Manager**, connect the board via USB, click **Auto Connect**, and program the generated `.bit` file.
