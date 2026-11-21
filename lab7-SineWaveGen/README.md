# Lab 7: Direct Digital Synthesis (DDS) Sine Wave Audio Generator

## Overview
Lab 7 implements an embedded digital audio synthesizer using **Direct Digital Synthesis (DDS)** and **Pulse-Width Modulation (PWM)** on the Artix-7 FPGA.

The design utilizes the AMD / Xilinx DDS Compiler IP core to generate a 16-bit sinusoidal waveform. Users dynamically select output frequencies ($0\text{ Hz}$ to $3.5\text{ kHz}$) and volume levels ($0\%$ to $100\%$) via onboard slide switches. The modulated audio signal is driven out to the Nexys 4 DDR mono audio jack via a 10-bit PWM generator, while a Double Dabble binary-to-BCD converter formats real-time frequency and volume telemetry on the 8-digit 7-segment display.

---

## Objectives
- Understand Direct Digital Synthesis (DDS) principles: Phase Accumulators, Sine Look-Up Tables (LUTs), and phase-to-amplitude generation.
- Integrate Xilinx IP cores (`sine_lut_dds` / DDS Compiler v6.0) with standard VHDL RTL logic.
- Design a high-frequency **10-bit Pulse-Width Modulation (PWM)** DAC running at ~97.6 kHz from the 100 MHz clock to drive an analog audio output filter.
- Implement volume scaling using arithmetic bit-shifting (`srl`).
- Convert binary data into decimal digits for display using the **Double Dabble (shift-and-add-3)** algorithm (`Hex2Decdigit.vhd`).
- Drive the onboard audio amplifier (`AUD_PWM`, `AUD_SD`).

---

## Hardware Platform
- **Board:** Digilent Nexys 4 DDR (or Nexys A7-100T)
- **FPGA:** AMD / Xilinx Artix-7 `XC7A100T-1CSG324C`
- **Audio Output:** Onboard Mono Audio Amplifier (Analog Devices SSM2211) connected to 3.5mm jack
- **Audio Modulation:** 10-bit PWM output (Pin `A11`), Shutdown Enable (Pin `D12`)
- **System Clock:** 100 MHz

---

## Directory Structure
```
lab7-SineWaveGen/
├── lab7_top.vhd                    # System top-level integration
├── frequency_control.vhd           # Frequency selector & sample pulse generator
├── phase_accu.vhd                  # 8-bit phase accumulator
├── vol_level_control.vhd           # Volume scaling (bit-shift) and percentage lookup
├── PWM_generator.vhd               # Parameterized 10-bit PWM audio driver
├── Hex2Decdigit.vhd                # Binary-to-BCD converter (Double Dabble)
├── pulse_gen.vhd                   # Clock pulse generator primitive
├── lab7_constraint.xdc             # Pin constraints for Nexys 4 DDR
├── schematic.pdf                   # Synthesized RTL schematic diagram
├── lab7_synthesis_report.txt       # Vivado synthesis report
├── lab7_top_utilization_synth.txt  # Resource utilization breakdown
├── seg7/                           # 7-Segment Display Subsystem
│   ├── seg7_controller.vhd         # 8-digit multiplexer
│   ├── seg7_hex.vhd                # Hexadecimal/decimal cathode decoder
│   └── seg7_3bti_rotator.vhd       # Digit scanner counter
└── sine_lut_dds/                   # Xilinx DDS Compiler IP Core
    ├── sine_lut_dds.xci            # Vivado IP configuration file
    ├── doc/                        # DDS compiler documentation
    └── synth/ & sim/               # IP synthesis and simulation wrappers
```

---

## System Architecture

```
                 +----------------------------------------------------+
                 |                   Artix-7 FPGA                     |
                 |                                                    |
SW[2:0] -------->| [frequency_control]                                |
                 | Generates sample pulse rate                        |
                 +-------------------+--------------------------------+
                                     | Sample Pulse (F_sample = 256 * F_out)
                                     v
                             +---------------+
                             |  phase_accu   | 8-bit Phase (0..255)
                             +-------+-------+
                                     |
                                     v
                           +-------------------+
                           |   sine_lut_dds    | Xilinx DDS Compiler
                           | (Sine Look-Up)    |
                           +---------+---------+
                                     | 16-bit 2's Complement Sine
                                     v
                           +-------------------+ Invert MSB to convert
                           | Offset Converter  | to unsigned amplitude
                           +---------+---------+
                                     |
SW[5:3] (Volume) ------------------->|
                                     v
                           +-------------------+
                           | vol_level_control | Scaled Sine
                           +---------+---------+
                                     | 10-bit Duty Cycle
                                     v
                           +-------------------+
                           |   PWM_generator   |------------> AUD_PWM (Pin A11)
                           | (10-bit @ 97.6kHz)|              (To 3.5mm Jack)
                           +-------------------+
SW[15] (Audio SD) ------------------------------------------> AUD_SD  (Pin D12)
                                                              (Amp Enable)

Frequency & Volume Data ---> [Hex2Decdigit] ---> [seg7_controller] ---> 7-Segment Display
                             (Double Dabble)     (8 Digits)             (Vol% : Freq Hz)
```

---

## Detailed Block Operation

### 1. Frequency Control (`frequency_control.vhd`)
Calculates the required sample strobe pulse according to $F_{\text{sample}} = 256 \times F_{\text{out}}$ (with an 8-bit phase accumulator holding $2^8 = 256$ samples per complete sine wave period):

| `SW[2:0]` | Desired Tone | Frequency Divider Count | Displayed Decimal |
| :---: | :---: | :---: | :---: |
| `000` | Mute ($0\text{ Hz}$) | `0` | `0000` Hz |
| `001` | $500\text{ Hz}$ | $100\text{ MHz} / (256 \times 500) \approx 781$ | `0500` Hz |
| `010` | $1000\text{ Hz}$ ($1.0\text{ kHz}$) | $100\text{ MHz} / (256 \times 1000) \approx 390$ | `1000` Hz |
| `011` | $1500\text{ Hz}$ ($1.5\text{ kHz}$) | $100\text{ MHz} / (256 \times 1500) \approx 260$ | `1500` Hz |
| `100` | $2000\text{ Hz}$ ($2.0\text{ kHz}$) | $100\text{ MHz} / (256 \times 2000) \approx 195$ | `2000` Hz |
| `101` | $2500\text{ Hz}$ ($2.5\text{ kHz}$) | $100\text{ MHz} / (256 \times 2500) \approx 156$ | `2500` Hz |
| `110` | $3000\text{ Hz}$ ($3.0\text{ kHz}$) | $100\text{ MHz} / (256 \times 3000) \approx 130$ | `3000` Hz |
| `111` | $3500\text{ Hz}$ ($3.5\text{ kHz}$) | $100\text{ MHz} / (256 \times 3500) \approx 111$ | `3500` Hz |

### 2. Phase Accumulator & Sine Core (`phase_accu.vhd` & `sine_lut_dds`)
- An 8-bit counter increments on every sample pulse, providing phase angles $0$ to $255$.
- Feeds into the Xilinx DDS IP block, which looks up the corresponding 16-bit signed sine sample.
- The signed two's complement waveform is offset to an unsigned positive value by inverting the MSB:
  ```vhdl
  inverted_sine_raw <= not sine_raw(15) & sine_raw(14 downto 0);
  ```

### 3. Volume Level Shifter (`vol_level_control.vhd`)
- Scales the amplitude dynamically using a right bit-shift:
  ```vhdl
  sine_out <= std_logic_vector(unsigned(sine_in) srl to_integer(unsigned(not vol_in)));
  ```
- Maps `SW[5:3]` to displayable volume percentages: `0%`, `14%`, `29%`, `43%`, `57%`, `71%`, `86%`, and `100%`.

### 4. 10-bit PWM Audio Generator (`PWM_generator.vhd`)
- Counts continuously from $0$ to $1023$ at the full 100 MHz clock rate.
- Frequency of the PWM carrier is $100\text{ MHz} / 1024 \approx 97.65\text{ kHz}$, far above human hearing (>20 kHz), allowing the RC low-pass filter on the Nexys board to reconstruct a smooth analog sine wave.
- Compares counter value against the top 10 bits of `sine_shifted` to set duty cycle:
  ```vhdl
  pwm_out <= '0' when count >= unsigned(duty_cycle) or count = max_count else '1';
  ```

### 5. Binary-to-BCD Converter (`Hex2Decdigit.vhd`)
- Implements the classic **Double Dabble** algorithm in RTL.
- Converts 16-bit binary volume and frequency values into four 4-bit BCD decimal digits.
- Enables the 7-segment display to read out natural decimal numbers (`0100` for 100% volume, `1500` for 1500 Hz).

---

## User Control & Display Mapping
- **`SW[2:0]`**: Audio frequency selection ($0$ to $3500\text{ Hz}$).
- **`SW[5:3]`**: Volume level scaling ($0\%$ to $100\%$).
- **`SW[15]`**: Audio Amplifier Enable (`AUD_SD`). Must be set to `'1'` to enable sound output.
- **`BTNC`**: System reset.
- **7-Segment Display:**
  - Digits 7–4 (`AN[7:4]`): Decimal Volume Percentage ($0$ to $100\%$).
  - Digits 3–0 (`AN[3:0]`): Decimal Frequency in Hz ($0$ to $3500\text{ Hz}$).

---

## Audio Pinout
| Signal | Pin | Standard | Description |
| :--- | :--- | :--- | :--- |
| `clock100mhz` | `E3` | LVCMOS33 | 100 MHz Oscillator |
| `BTNC` | `N17` | LVCMOS33 | Active-high Reset |
| `AUD_PWM` | `A11` | LVCMOS33 | PWM Audio output to low-pass filter |
| `AUD_SD` | `D12` | LVCMOS33 | Audio amplifier active-low shutdown (SW[15]=1 enables) |
| `SW[2:0]` | `J15, L16, M13` | LVCMOS33 | Frequency control switches |
| `SW[5:3]` | `R15, R17, T18` | LVCMOS33 | Volume control switches |
| `SW[15]` | `V10` | LVCMOS33 | Amplifier enable switch |
