# Lab 3: Clocked 7-Segment Display Controller & Shifting Marquee

## Overview
Lab 3 transitions from pure combinational logic into **synchronous sequential digital design**. It implements a time-multiplexed 8-digit seven-segment display controller driven by a 1 kHz scan rate, along with a 1 Hz clock pulse generator that samples user switch inputs into a 32-bit shifting marquee register.

## Objectives
- Implement synchronous clock pulse generators and frequency dividers from a 100 MHz system clock.
- Design an 8-digit **time-division multiplexed display controller** operating above the human flicker threshold (>100 Hz per digit).
- Build a multi-bit synchronous shift register (`char_shift`) that samples hexadecimal nibbles and scrolls them across the display.
- Work with synchronous resets and modular hierarchical VHDL architectures.

---

## Hardware Platform
- **Board:** Digilent Nexys 4 DDR (or Nexys A7-100T)
- **FPGA:** AMD / Xilinx Artix-7 `XC7A100T-1CSG324C`
- **System Clock:** 100 MHz onboard oscillator (Pin `E3`)

---

## File Structure
| File | Description |
| :--- | :--- |
| [`lab3_top.vhd`](./lab3_top.vhd) | Top-level entity integrating pulse generators, shift register, and display multiplexer |
| [`seg7_controller.vhd`](./seg7_controller.vhd) | 8-digit time-division multiplexer with internal 1 kHz pulse generator and 3-bit digit counter |
| [`pulse_gen.vhd`](./pulse_gen.vhd) | Generic parameterized synchronous pulse generator (generates 1-clock-cycle pulses) |
| [`1hz_pulse.vhd`](./1hz_pulse.vhd) | Fixed 1 Hz pulse generator configured for a 100 MHz system clock (`max_count = 10^8 - 1`) |
| [`char_shift.vhd`](./char_shift.vhd) | 32-bit synchronous left-shift register shifting 4-bit switch nibbles into display memory |
| [`counter.vhd`](./counter.vhd) | Synchronous 3-bit up-counter with synchronous enable pulse and reset |
| [`seg7_hex.vhd`](./seg7_hex.vhd) | 4-bit binary to 7-segment active-low hexadecimal cathode decoder |
| [`lab3_constraint.xdc`](./lab3_constraint.xdc) | Physical constraints mapping clock, switches, buttons, LEDs, cathodes, and anodes |

---

## System Architecture

```
                    100 MHz Clock (Pin E3)
                             |
             +---------------+---------------+
             |                               |
             v                               v
    +-----------------+             +------------------+
    |   pulse_1hz     |             |  seg7_controller |
    | (Count to 10^8) |             |                  |
    +--------+--------+             |  +------------+  |
             | 1 Hz Pulse           |  | pulse_gen  |  |
             v                      |  | (1 kHz)    |  |
    +-----------------+             |  +-----+------+  |
    |   char_shift    |             |        | 1 kHz   |
    | (32-bit shift)  |             |  +-----v------+  |
SW  | char <= char<<4 | 32-bit      |  | 3-bit cnt  |  |
--->|      & SW(3..0) +------------>|  +-----+------+  |
    +-----------------+ char(31..0) |        | 0..7    |
                                    |  +-----v------+  |
                                    |  | Mux & Dec  |  |
                                    |  +-----+------+  |
                                    +--------|---------+
                                             |
                               +-------------+-------------+
                               |                           |
                               v                           v
                        SEG7_CATH1(7..0)                AN1(7..0)
                          (Cathodes)                 (Active Anode)
```

---

## Detailed Component Operation

### 1. Pulse Generation (`pulse_gen.vhd` & `1hz_pulse.vhd`)
- Nexys 4 DDR provides an onboard 100 MHz oscillator.
- `pulse_gen` uses a 27-bit counter that increments on every rising clock edge.
- When `count = max_count`, it asserts `pulseOut` for a single 10 ns clock cycle and rolls over to 0.
- `pulse_1hz` sets `max_count = 99,999,999` (`100,000,000 - 1`), delivering an exact 1 Hz pulse.

### 2. Shifting Marquee Register (`char_shift.vhd`)
- Maintains an internal 32-bit register `char1(31 downto 0)` representing eight 4-bit hexadecimal digits.
- On each rising edge of `clock100mhz` where `pulse1 = '1'` (once per second):
  ```vhdl
  char1 <= char1(27 downto 0) & SWvalue(3 downto 0);
  ```
- This scrolls existing digits 1 position to the left and inserts the current state of `SW(3 downto 0)` as the new rightmost digit.
- Pressing `BTNC` resets all 32 bits to `0x00000000`.

### 3. Time-Multiplexed Display Controller (`seg7_controller.vhd`)
- The 8 digits share cathode lines, so only one digit can be turned on at any given instant.
- `seg7_controller` uses `pulse_gen` with `max_count = 99,999` to generate a **1 kHz** switching pulse.
- A 3-bit counter cycles from `0` to `7` on each 1 kHz pulse:
  - **Digit 0 (`AN[0]` active low):** Displays `char(3 downto 0)`
  - **Digit 1 (`AN[1]` active low):** Displays `char(7 downto 4)`
  - ...
  - **Digit 7 (`AN[7]` active low):** Displays `char(31 downto 28)`
- Each individual digit is refreshed at $1000\text{ Hz} / 8 = 125\text{ Hz}$, well above the human visual flicker threshold (~60 Hz), creating the illusion of a continuous, steady 8-digit display.

---

## I/O Port Mapping
| Signal Name | Direction | Pin | Description |
| :--- | :--- | :--- | :--- |
| `clock100mhz` | Input | `E3` | 100 MHz system clock oscillator |
| `BTNC` | Input | `N17` | Center push button: Active-high synchronous system reset |
| `SW[3:0]` | Input | `J15, L16, M13, R15` | Hexadecimal value shifted into display every 1 second |
| `SW[15:4]` | Input | Various | General inputs (mirrored to LEDs) |
| `LED[15:0]` | Output | Various | Status LEDs mirroring `SW[15:0]` |
| `SEG7_CATH1[7:0]` | Output | `H15` .. `T10` | Multiplexed 7-segment cathode signals |
| `AN1[7:0]` | Output | `U13` .. `J17` | Active-low digit enable anode signals |

---

## How to Test
1. Synthesize, implement, and program the design onto the Nexys 4 DDR board.
2. Observe all 8 digits initially initialized to `0`.
3. Set `SW[3:0]` to `0xA` (`1010` in binary). After 1 second, `A` will appear on the rightmost digit (`AN0`).
4. Set `SW[3:0]` to `0xB` (`1011` in binary). After 1 second, `A` shifts left to `AN1`, and `B` appears on `AN0`.
5. Continue changing `SW[3:0]` to watch arbitrary 8-digit hexadecimal patterns scroll smoothly across the display.
6. Press `BTNC` at any time to clear the display back to `00000000`.
