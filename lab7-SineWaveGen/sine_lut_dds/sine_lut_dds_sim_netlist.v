// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.2.1 (win64) Build 6403652 Thu Mar 19 19:48:24 GMT 2026
// Date        : Wed Jul 29 14:12:47 2026
// Host        : pldktpa running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top sine_lut_dds -prefix
//               sine_lut_dds_ dds_compiler_0_sim_netlist.v
// Design      : dds_compiler_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "dds_compiler_0,dds_compiler_v6_0_28,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "dds_compiler_v6_0_28,Vivado 2025.2.1" *) 
(* NotValidForBitStream *)
module sine_lut_dds
   (aclk,
    s_axis_phase_tvalid,
    s_axis_phase_tdata,
    m_axis_data_tvalid,
    m_axis_data_tdata);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 aclk_intf CLK" *) (* x_interface_mode = "slave aclk_intf" *) (* x_interface_parameter = "XIL_INTERFACENAME aclk_intf, ASSOCIATED_BUSIF M_AXIS_PHASE:S_AXIS_CONFIG:M_AXIS_DATA:S_AXIS_PHASE, ASSOCIATED_RESET aresetn, ASSOCIATED_CLKEN aclken, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, INSERT_VIP 0" *) input aclk;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 S_AXIS_PHASE TVALID" *) (* x_interface_mode = "slave S_AXIS_PHASE" *) (* x_interface_parameter = "XIL_INTERFACENAME S_AXIS_PHASE, TDATA_NUM_BYTES 1, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 0, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 100000000, PHASE 0.0, LAYERED_METADATA undef, INSERT_VIP 0" *) input s_axis_phase_tvalid;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 S_AXIS_PHASE TDATA" *) input [7:0]s_axis_phase_tdata;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 M_AXIS_DATA TVALID" *) (* x_interface_mode = "master M_AXIS_DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME M_AXIS_DATA, TDATA_NUM_BYTES 2, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 0, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 100000000, PHASE 0.0, LAYERED_METADATA undef, INSERT_VIP 0" *) output m_axis_data_tvalid;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 M_AXIS_DATA TDATA" *) output [15:0]m_axis_data_tdata;

  wire aclk;
  wire [15:0]m_axis_data_tdata;
  wire m_axis_data_tvalid;
  wire [7:0]s_axis_phase_tdata;
  wire s_axis_phase_tvalid;
  wire NLW_U0_debug_axi_resync_in_UNCONNECTED;
  wire NLW_U0_debug_core_nd_UNCONNECTED;
  wire NLW_U0_debug_phase_nd_UNCONNECTED;
  wire NLW_U0_event_phase_in_invalid_UNCONNECTED;
  wire NLW_U0_event_pinc_invalid_UNCONNECTED;
  wire NLW_U0_event_poff_invalid_UNCONNECTED;
  wire NLW_U0_event_s_config_tlast_missing_UNCONNECTED;
  wire NLW_U0_event_s_config_tlast_unexpected_UNCONNECTED;
  wire NLW_U0_event_s_phase_chanid_incorrect_UNCONNECTED;
  wire NLW_U0_event_s_phase_tlast_missing_UNCONNECTED;
  wire NLW_U0_event_s_phase_tlast_unexpected_UNCONNECTED;
  wire NLW_U0_m_axis_data_tlast_UNCONNECTED;
  wire NLW_U0_m_axis_phase_tlast_UNCONNECTED;
  wire NLW_U0_m_axis_phase_tvalid_UNCONNECTED;
  wire NLW_U0_s_axis_config_tready_UNCONNECTED;
  wire NLW_U0_s_axis_phase_tready_UNCONNECTED;
  wire [0:0]NLW_U0_debug_axi_chan_in_UNCONNECTED;
  wire [7:0]NLW_U0_debug_axi_pinc_in_UNCONNECTED;
  wire [7:0]NLW_U0_debug_axi_poff_in_UNCONNECTED;
  wire [7:0]NLW_U0_debug_phase_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_data_tuser_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_phase_tdata_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_phase_tuser_UNCONNECTED;

  (* C_ACCUMULATOR_WIDTH = "8" *) 
  (* C_AMPLITUDE = "0" *) 
  (* C_CHANNELS = "1" *) 
  (* C_CHAN_WIDTH = "1" *) 
  (* C_DEBUG_INTERFACE = "0" *) 
  (* C_HAS_ACLKEN = "0" *) 
  (* C_HAS_ARESETN = "0" *) 
  (* C_HAS_M_DATA = "1" *) 
  (* C_HAS_M_PHASE = "0" *) 
  (* C_HAS_PHASEGEN = "0" *) 
  (* C_HAS_PHASE_OUT = "0" *) 
  (* C_HAS_SINCOS = "1" *) 
  (* C_HAS_S_CONFIG = "0" *) 
  (* C_HAS_S_PHASE = "1" *) 
  (* C_HAS_TLAST = "0" *) 
  (* C_HAS_TREADY = "0" *) 
  (* C_LATENCY = "2" *) 
  (* C_MEM_TYPE = "1" *) 
  (* C_MODE_OF_OPERATION = "0" *) 
  (* C_MODULUS = "9" *) 
  (* C_M_DATA_HAS_TUSER = "0" *) 
  (* C_M_DATA_TDATA_WIDTH = "16" *) 
  (* C_M_DATA_TUSER_WIDTH = "1" *) 
  (* C_M_PHASE_HAS_TUSER = "0" *) 
  (* C_M_PHASE_TDATA_WIDTH = "1" *) 
  (* C_M_PHASE_TUSER_WIDTH = "1" *) 
  (* C_NEGATIVE_COSINE = "0" *) 
  (* C_NEGATIVE_SINE = "0" *) 
  (* C_NOISE_SHAPING = "0" *) 
  (* C_OPTIMISE_GOAL = "0" *) 
  (* C_OUTPUTS_REQUIRED = "0" *) 
  (* C_OUTPUT_FORM = "0" *) 
  (* C_OUTPUT_TYPE = "0" *) 
  (* C_OUTPUT_WIDTH = "16" *) 
  (* C_PHASE_ANGLE_WIDTH = "8" *) 
  (* C_PHASE_INCREMENT = "2" *) 
  (* C_PHASE_INCREMENT_VALUE = "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0" *) 
  (* C_PHASE_OFFSET = "0" *) 
  (* C_PHASE_OFFSET_VALUE = "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0" *) 
  (* C_POR_MODE = "0" *) 
  (* C_RESYNC = "0" *) 
  (* C_S_CONFIG_SYNC_MODE = "0" *) 
  (* C_S_CONFIG_TDATA_WIDTH = "1" *) 
  (* C_S_PHASE_HAS_TUSER = "0" *) 
  (* C_S_PHASE_TDATA_WIDTH = "8" *) 
  (* C_S_PHASE_TUSER_WIDTH = "1" *) 
  (* C_USE_DSP48 = "0" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  sine_lut_dds_dds_compiler_v6_0_28 U0
       (.aclk(aclk),
        .aclken(1'b1),
        .aresetn(1'b1),
        .debug_axi_chan_in(NLW_U0_debug_axi_chan_in_UNCONNECTED[0]),
        .debug_axi_pinc_in(NLW_U0_debug_axi_pinc_in_UNCONNECTED[7:0]),
        .debug_axi_poff_in(NLW_U0_debug_axi_poff_in_UNCONNECTED[7:0]),
        .debug_axi_resync_in(NLW_U0_debug_axi_resync_in_UNCONNECTED),
        .debug_core_nd(NLW_U0_debug_core_nd_UNCONNECTED),
        .debug_phase(NLW_U0_debug_phase_UNCONNECTED[7:0]),
        .debug_phase_nd(NLW_U0_debug_phase_nd_UNCONNECTED),
        .event_phase_in_invalid(NLW_U0_event_phase_in_invalid_UNCONNECTED),
        .event_pinc_invalid(NLW_U0_event_pinc_invalid_UNCONNECTED),
        .event_poff_invalid(NLW_U0_event_poff_invalid_UNCONNECTED),
        .event_s_config_tlast_missing(NLW_U0_event_s_config_tlast_missing_UNCONNECTED),
        .event_s_config_tlast_unexpected(NLW_U0_event_s_config_tlast_unexpected_UNCONNECTED),
        .event_s_phase_chanid_incorrect(NLW_U0_event_s_phase_chanid_incorrect_UNCONNECTED),
        .event_s_phase_tlast_missing(NLW_U0_event_s_phase_tlast_missing_UNCONNECTED),
        .event_s_phase_tlast_unexpected(NLW_U0_event_s_phase_tlast_unexpected_UNCONNECTED),
        .m_axis_data_tdata(m_axis_data_tdata),
        .m_axis_data_tlast(NLW_U0_m_axis_data_tlast_UNCONNECTED),
        .m_axis_data_tready(1'b0),
        .m_axis_data_tuser(NLW_U0_m_axis_data_tuser_UNCONNECTED[0]),
        .m_axis_data_tvalid(m_axis_data_tvalid),
        .m_axis_phase_tdata(NLW_U0_m_axis_phase_tdata_UNCONNECTED[0]),
        .m_axis_phase_tlast(NLW_U0_m_axis_phase_tlast_UNCONNECTED),
        .m_axis_phase_tready(1'b0),
        .m_axis_phase_tuser(NLW_U0_m_axis_phase_tuser_UNCONNECTED[0]),
        .m_axis_phase_tvalid(NLW_U0_m_axis_phase_tvalid_UNCONNECTED),
        .s_axis_config_tdata(1'b0),
        .s_axis_config_tlast(1'b0),
        .s_axis_config_tready(NLW_U0_s_axis_config_tready_UNCONNECTED),
        .s_axis_config_tvalid(1'b0),
        .s_axis_phase_tdata(s_axis_phase_tdata),
        .s_axis_phase_tlast(1'b0),
        .s_axis_phase_tready(NLW_U0_s_axis_phase_tready_UNCONNECTED),
        .s_axis_phase_tuser(1'b0),
        .s_axis_phase_tvalid(s_axis_phase_tvalid));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2025.2.1"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
EOICL2ZHxrCTz//2fxHcpPURRmG/WYuJBkNFgd2WcwiC/ARyUlzwdqC8fAHAQ38v8h2qaJxKIWOx
BNLXQQgO/S3h3EH5+wLN21rxc5cMtSKJKssOfIJspcrkd/FxmXNLXTtys37DdcSBjQUGmIVpEI7z
Skph87ELcmBq0k9gltM=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
wJA5cgv2pLKtmTKqOy9FlAXjSujhPgf8+q12/ubsT7DGd4aGklDdaU9lDN7b13WohG/BK9MFnkgw
s99lUGN4Sba27t90VI+3ZXJOHHtSwdKd0oFW+Ebk6JMkH+FNay5SDH4Z1i8jai6TtT4leiT0ZHlD
awGqW3J0M3+d4xj+FfqkTIU9vLLvi79mrfTQd2q3qjiMjO5a45PK2spnJWEM8MIcjJIXLCd51gCx
MWvQVsFOcySSwiudZA+ua3KFAl3uJ9/19O/sZ3Krkb+QYh+S8WnwI8jLx5digqxDSWuqiCX4ONHp
XNBN/TAHFlZfqVyar4ET/kE317ygpxAQWUC0Tg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
nhuQlXfWxp3vDcMGvXR5HHc+HUB7ShuHDjStAf2VwJ/8RLVBxvUak53s5JTDnrSRNYhzlW2XXLIf
FJLz18BFeAhdrIC8uSOUuciqtKqtKG0pZeGolOjtg4Wevmbk6LWB6a7Aql8KILIH7xGkH+YacZEd
vc2OxcZrqdaPu8oL6gA=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
LiUj/4xNJxpg7aB9paqb7sa2ZiaqCU+GvZOpxTIU2rcFcTqF2AyrBioFmodC0SxG9zvDMp1BIGop
RLW7injvdDOHFnTIMNOvnphyW/HFANemprUt0W37c/P5Q5yAgS6DLv8FjahyANZs8KJ0+5hNYXnd
tzawfvV+P0vC4/tojHvIcXnchKjHx0peJHXYla+mY2qIklVz8C0gdzKsGA0PowPbikVgBtn3xSjA
uX9yDleOCeETa4whI+4bDkIAS8ZO8P5ZmlRviez3xO2M/HyX1XmQ8Elw7nMVhevWGzhg736NKpWE
Td0mbxl8nzZLMEB2ToqkDMtXqIqsMqb5OCYv2g==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
ahmgcj8Lc0X9xMXaG+fenNBdhZaOsT7+MaAKyGOuauikSptLk9toOOrVl/RwalzQv8Kx2ikKJEQI
LGAot1OtQgx50/0kNKsVmxm1/JyOXeYi8bJXJlqv0nIrKXpf5dPnuAyiuvLovuXpmZjnjL9I+Xl0
rjNvbWfWMBn2Uculf4MDk0qSKwYScF0uZEchqNA3BrMPJQNTYMdwgGc6g0QBexxg5oUBP2NPHJUg
6Zu1w8CIaCajCBv4jfpFqA3CZGiAis1w8JXoIJEzAcmfK9unnX5+nmqWfRPcQoc94hnXB/mn4dKj
Us3qctLyaf7xQA9oy1iTFxRy725zI/fFugbEew==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2025.1-2029.x", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
YtNbR390DWinAns87C4gO1WTrZhNYARTsG8E6q0FIzT/62xORk5B3vaFYXEJQuuNkcT6R9Dewet8
19PVTWnly8kpE3mPYs6UY33vKTWmYe/9cWn8J9UbHqq/fzipqSiIyzE5dGnmEPJWS1h42zdGPLTy
n37t1se5z4HJkL2TvQYFBY7R34EPrKyr4ko3gEoWwMsRydZfIGePuiPE4osMdrwA13K/cD0NEiYa
9yvE/TOnlQV41aNzX6ZnVxIMOe4ymHFXxF18AFXn6tEC/XePkzVnr4O1PiXe/FdUkTROC+FaYS8r
WmTVpW0B0o6vRZ6lf0DrWuS0NlWtLBlHpQuxxQ==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
LNvSeMR/tev+2mf856Mt8iAJmeZVxy4eYgFDLDQkp06Hp0mJARpIQLTKXQ3uPF+rNKz8DySsuFwL
0v8AGj4G1Q3y69pq5Kujv+qjZO2CJ0Zu6fyORxB609Hp3gVR0JV3OH6AZkd8UYXpeBkGIhn458tu
Km+MkYUmof296+hGKJyoFcPzobMF8KdRTce6b+a0C0Z8TPTaFwfEwHcPEN+a+fr3lK7PbQwN48+C
3GdBijELTs8v25gwZvyyzNh3sC++piBS2Td0mXIp5npLleUaJ+MuS+B/SzJ8S6MxZbnDk7XxepkP
wDGBZWn6CZT//zwv1sm8K0wPZNvech7rExBulg==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
ibHsnjXVo/w/ZfiWNNtuV+0a+ptKErZr5UljYauRf+FmiH9s7zOOUKuzeGH1sYvrFQ0ypStNXkro
1fl7caML+y8CrIhFbM6aC0XkL2lbRCaAVPPAtdkwqMkpGx+ctDioyqKkkLXwvcBFGJx8vrB2VpK0
WRSgofemtWMhYy7/OwPtDrJbHiADAHhtij72lZ353nZj6GXwL5wAyq3ivxGRWMiI5x84ItwrkHwk
QhTI1wwfew6+YYwM3s+RnCOHjU9GZtQlEYFPfnDmu+XaToAXQfc788m+L8Bj3M7M9SZwFfjvfUsp
NS0hTvtakrp9PsfExi6cVMk+eXK7WAj7CK52JOjS/NbVGYlHVh+zvvQp7E5WZugtqCmxRYdZhQ7K
3TXr9imyNvEuFrZTG5+UNQgOHJOLPX/M2IagxH2vSWVFg3cKenhEnJLqhuKGRF3JLbNv+9ek/+9X
PSNlkAwA7/gwIdBIrF+R7iYbS7Kdvr1yCO0erzx1M7WiaHN+V8vUUAx9

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
bQtyBwE4eqteaRL42nguj3ynJm2o4s2VDSXtuNYxYuKeR8Rdrq0qfR29HxzQRvw9gpt89eHc65MF
OCAffO7p/MKjKij0JouxYZCgoFwYrVCCwBSiG9vifYyEC8M+lFVPmgWRNR3pbSTFVH2vnXACJQ1E
bfwrcCEqFp+9QEZ0YN0zTGreNEIzJEPPiUyMpoA15FK1MnHV2PsVIsscNIMkCdxbfVBuj6awVeA+
7pyHIy3dQa707r+yzED7wxTnLqBSVg9g0WTUK3ooU/s+CAFSJgTxwiSBJLHnwiDnZO2sdjH2N+M0
BOHYEDFGYWtyi+9UieQU18FlC7W1K3MQH5DQ4A==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 11136)
`pragma protect data_block
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
mrsj4sTWu7JVApeNhh6PsmoF8HhR
`pragma protect end_protected
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2025.2.1"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
EOICL2ZHxrCTz//2fxHcpPURRmG/WYuJBkNFgd2WcwiC/ARyUlzwdqC8fAHAQ38v8h2qaJxKIWOx
BNLXQQgO/S3h3EH5+wLN21rxc5cMtSKJKssOfIJspcrkd/FxmXNLXTtys37DdcSBjQUGmIVpEI7z
Skph87ELcmBq0k9gltM=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
wJA5cgv2pLKtmTKqOy9FlAXjSujhPgf8+q12/ubsT7DGd4aGklDdaU9lDN7b13WohG/BK9MFnkgw
s99lUGN4Sba27t90VI+3ZXJOHHtSwdKd0oFW+Ebk6JMkH+FNay5SDH4Z1i8jai6TtT4leiT0ZHlD
awGqW3J0M3+d4xj+FfqkTIU9vLLvi79mrfTQd2q3qjiMjO5a45PK2spnJWEM8MIcjJIXLCd51gCx
MWvQVsFOcySSwiudZA+ua3KFAl3uJ9/19O/sZ3Krkb+QYh+S8WnwI8jLx5digqxDSWuqiCX4ONHp
XNBN/TAHFlZfqVyar4ET/kE317ygpxAQWUC0Tg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
nhuQlXfWxp3vDcMGvXR5HHc+HUB7ShuHDjStAf2VwJ/8RLVBxvUak53s5JTDnrSRNYhzlW2XXLIf
FJLz18BFeAhdrIC8uSOUuciqtKqtKG0pZeGolOjtg4Wevmbk6LWB6a7Aql8KILIH7xGkH+YacZEd
vc2OxcZrqdaPu8oL6gA=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
LiUj/4xNJxpg7aB9paqb7sa2ZiaqCU+GvZOpxTIU2rcFcTqF2AyrBioFmodC0SxG9zvDMp1BIGop
RLW7injvdDOHFnTIMNOvnphyW/HFANemprUt0W37c/P5Q5yAgS6DLv8FjahyANZs8KJ0+5hNYXnd
tzawfvV+P0vC4/tojHvIcXnchKjHx0peJHXYla+mY2qIklVz8C0gdzKsGA0PowPbikVgBtn3xSjA
uX9yDleOCeETa4whI+4bDkIAS8ZO8P5ZmlRviez3xO2M/HyX1XmQ8Elw7nMVhevWGzhg736NKpWE
Td0mbxl8nzZLMEB2ToqkDMtXqIqsMqb5OCYv2g==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
ahmgcj8Lc0X9xMXaG+fenNBdhZaOsT7+MaAKyGOuauikSptLk9toOOrVl/RwalzQv8Kx2ikKJEQI
LGAot1OtQgx50/0kNKsVmxm1/JyOXeYi8bJXJlqv0nIrKXpf5dPnuAyiuvLovuXpmZjnjL9I+Xl0
rjNvbWfWMBn2Uculf4MDk0qSKwYScF0uZEchqNA3BrMPJQNTYMdwgGc6g0QBexxg5oUBP2NPHJUg
6Zu1w8CIaCajCBv4jfpFqA3CZGiAis1w8JXoIJEzAcmfK9unnX5+nmqWfRPcQoc94hnXB/mn4dKj
Us3qctLyaf7xQA9oy1iTFxRy725zI/fFugbEew==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2025.1-2029.x", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
YtNbR390DWinAns87C4gO1WTrZhNYARTsG8E6q0FIzT/62xORk5B3vaFYXEJQuuNkcT6R9Dewet8
19PVTWnly8kpE3mPYs6UY33vKTWmYe/9cWn8J9UbHqq/fzipqSiIyzE5dGnmEPJWS1h42zdGPLTy
n37t1se5z4HJkL2TvQYFBY7R34EPrKyr4ko3gEoWwMsRydZfIGePuiPE4osMdrwA13K/cD0NEiYa
9yvE/TOnlQV41aNzX6ZnVxIMOe4ymHFXxF18AFXn6tEC/XePkzVnr4O1PiXe/FdUkTROC+FaYS8r
WmTVpW0B0o6vRZ6lf0DrWuS0NlWtLBlHpQuxxQ==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
LNvSeMR/tev+2mf856Mt8iAJmeZVxy4eYgFDLDQkp06Hp0mJARpIQLTKXQ3uPF+rNKz8DySsuFwL
0v8AGj4G1Q3y69pq5Kujv+qjZO2CJ0Zu6fyORxB609Hp3gVR0JV3OH6AZkd8UYXpeBkGIhn458tu
Km+MkYUmof296+hGKJyoFcPzobMF8KdRTce6b+a0C0Z8TPTaFwfEwHcPEN+a+fr3lK7PbQwN48+C
3GdBijELTs8v25gwZvyyzNh3sC++piBS2Td0mXIp5npLleUaJ+MuS+B/SzJ8S6MxZbnDk7XxepkP
wDGBZWn6CZT//zwv1sm8K0wPZNvech7rExBulg==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
ibHsnjXVo/w/ZfiWNNtuV+0a+ptKErZr5UljYauRf+FmiH9s7zOOUKuzeGH1sYvrFQ0ypStNXkro
1fl7caML+y8CrIhFbM6aC0XkL2lbRCaAVPPAtdkwqMkpGx+ctDioyqKkkLXwvcBFGJx8vrB2VpK0
WRSgofemtWMhYy7/OwPtDrJbHiADAHhtij72lZ353nZj6GXwL5wAyq3ivxGRWMiI5x84ItwrkHwk
QhTI1wwfew6+YYwM3s+RnCOHjU9GZtQlEYFPfnDmu+XaToAXQfc788m+L8Bj3M7M9SZwFfjvfUsp
NS0hTvtakrp9PsfExi6cVMk+eXK7WAj7CK52JOjS/NbVGYlHVh+zvvQp7E5WZugtqCmxRYdZhQ7K
3TXr9imyNvEuFrZTG5+UNQgOHJOLPX/M2IagxH2vSWVFg3cKenhEnJLqhuKGRF3JLbNv+9ek/+9X
PSNlkAwA7/gwIdBIrF+R7iYbS7Kdvr1yCO0erzx1M7WiaHN+V8vUUAx9

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
bQtyBwE4eqteaRL42nguj3ynJm2o4s2VDSXtuNYxYuKeR8Rdrq0qfR29HxzQRvw9gpt89eHc65MF
OCAffO7p/MKjKij0JouxYZCgoFwYrVCCwBSiG9vifYyEC8M+lFVPmgWRNR3pbSTFVH2vnXACJQ1E
bfwrcCEqFp+9QEZ0YN0zTGreNEIzJEPPiUyMpoA15FK1MnHV2PsVIsscNIMkCdxbfVBuj6awVeA+
7pyHIy3dQa707r+yzED7wxTnLqBSVg9g0WTUK3ooU/s+CAFSJgTxwiSBJLHnwiDnZO2sdjH2N+M0
BOHYEDFGYWtyi+9UieQU18FlC7W1K3MQH5DQ4A==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
lKHcTmqY1voPj4WsM5pACMFeAS64lDiyLPQDAkTDWlXbEiCxPRiREBxbBg4YwyaQzNuH59DcaAgP
rKSlaFZ8y3G7RdIgNEyQqz5HiPYU6PNUL1+F5AL2p3lO3sU1cRbN0LZ9MXi34T2qf5cbW67za2pe
UmfCj3cUS/UXMwI0LLLMH4kH3IYW2kXcxjAKma23wwSAaa8bQ+EiodEuCV506v4upEqgxBGTebdd
iAiMLIa6dzVsak3VQXzczQ5gl4agZw2wTtmDcsb+G1uVvZhJ4n7hNPOmZfPBoB1zYaHmVrFYgSlc
kOZJ/Z2tkmUNT2VSqPG3IjRdROi4eSOd4Rb/zg==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
WsrjiLbytYC82MQGMNNAgYzXkeNucQQd2jfR8dz/cSVdv6udhxl2wHLDstVR6SKQ8LwTRoEF1tUB
33UNUtauHsYDm/f5usUbqO/vh2fOmWpaedrKVykJmEEayi7Q9hbZ7Hgw1LZju5lB7rUlIWPu8rOl
HalN8MnBdL25KkwUI0XWhDtK1G3BshRPlcAeaydNvOAS6OpLz59X3yGjefj4StVsH+EDcbC5CA7x
JzLiXvNle9qIY07QhXgaM/FtOYCUBDNpUg9zEZG2gG/Ej79PbFS44GAl082Lu1nONa1EsmNcTPIY
7k4jhZT9PNTGfd8zHF3HxPlm82ZnCoIdD98+Wg==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 21888)
`pragma protect data_block
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
`pragma protect end_protected
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2025.2.1"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
thpKo9nWbuauRiC1ok+ncvcl1h5fyhTvZQt4V30wMMys0fKM+zNw7UGaesGp449c3xdvBQVNgmbo
ccK+HSkgujJd3KYgrgER34FmhPPh6mdljmM+5+mBg0jCY75zu7fJk+dk9kzHB4FY/f7+aitrnX9B
a24DrhrMWEcfsAPFS7s=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
NfgaxsYrOFJxyCeF6qLBvaNTgvK0z3PeYuLy8awzfl84Q/NqO06AJJ04NsBsyIXyhrP8xX94CfpY
GlwmFyTkDOgtoxqG+wqmUea1YeuT/m7bOZL0fpOBe3JQLc7bHORmyXM/hu4mklW2LrOdAT69W+f/
nXeyCfpM93oMb4XWcGQIDmp2Wfl/aOMC49Z1T/tssdNUCtAkgfUdpknXgi8FlhD41ig1ZthRJhDy
OWYr+6K7zse7aU7QnLytISQyxr1yHe2TLRM0oTTkI7tvV5USiEvgSPj0oXeL3gcpw/rKVJKUczBL
UEP6jG8+cGt0JQCAJHlHkiVFs3UglA4XGxGaKA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
V1jgNHeUukrZmQWpPL586gRSdcCfEoo1nmHq2ZvOQQP8JHx7WWDUB9osaEkoiTEq5iI8LDqgyB/L
xo6tK+L66UJLCHbsda70vR2hGTkKuboC8dhKYaKa3C07RDRzrsIgveeHhNEvnAfjVUsPlRJKRh6q
hL6tRG7I2JBQ6QumYXg=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
jqdS4NdilPiwIgWKA6plhUUcPjazsGHYwBBbLyFbIWn62xHvgWGbAhLNrCRZkWzFO5fRh+r2rdda
FdOA+zQlFMV0pfu4p0RuyRAll2hS/XkTGs+aOJmzr5yRgwpJ4eeie71VLJARBikrq6SW9y8wbrkA
d2JFLuZ6nGsA9GY++1bUmOyAEOpwGnb+JIwN41mJByoTPpz8DJAWn7cbR/t1i7F59kh/PkoBhtMd
B+XT90t0W+6GqAcYdJW0D3Dtobid3yDX+dm9g89RFOE0jvqbj2QpcOz3ofrtSch2a2vLW3r2hhZ5
/Y2MTHc06VxkVpLGJ1Ql8rBXh5tQMXybrFm+OQ==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
KH0sNQ3xsPqh2rdXNEc6hicq5af6r9oA0trGbpAgF9nd6c5AjiaUnT5Zllze+6k1cYbt/D9cIUN/
tkzzwURD7U3wrQg/JuENdFpswz+7ntFzcJbrZrQ87K1pqjgLlVbpgBBu6vbOXqx/uB5+Vi8BjQ4V
mUSyJA43TJLthrdGX9JVyPQyFDodftbGiLqnFj9HcDnmbIynNKETdtcYQP2wPuq3nvVC6MCA7jWM
jwAxKHmXBIvmZBV2c0WIiH7WsXPaJEdbWTe6FWdAIXLvInJad2ltDCR7ICW6Xgl3zigFRPf6+3/X
FKX5cyMkW1IHPLZRc5i8IkRcdZkMdAsIgkAgrg==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2025.1-2029.x", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
jWIlwRSz6jU0HycQViQao96MqzMhafUds69e6cfUz3Ad1OyrlV2dRrRW9vkVOMcDHoo9ooNkKUuC
UDhp6WWpJlmSbNU+OvSDft79YAWyP6DIOnO5CiH4J6KVDI8cNyD3TSyXTFRjJFvDgjvmFl8iRJAy
CRB/4gJ5qSAonpbjwYPAuX0Jb5QPgypMa5VRoF6siMehQssojiAGTe2HuUrpkeC+7HAsPX3TTtw8
/SSyvlgH+cDnsHhb22Ko4GrKwLoM56BEkRWWK+pupgVAQ+LGZQ4yUJARUpuXPmYnh5O2fOV2oEsk
zp7JInYMGD4PVQjwyCc8apnpeC22VyLWBTazGQ==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
OjpCxI4h9FAdVlbU19IG0+ALnDbuT170cVvU9x4KlAe9+GmKFLSr1sIwTH6CRVu/M5SPX2zlxsYE
T9bQpD8WFQszy+tLzRosK/6oCHYJjtnyvgppQYLfY8BGcbDtoPUl0V5z/u57dUonfhsu4E6Ymbwt
LIrAv7Ofe5QckkkBtoq+0zMhGhjeWUwUte/mqbamGApNJwlYLADpqN0BqsQteOEz5HOI2SYegI3b
v8UyDs0Xosev4aBfqi+ILZpbskY1RAmheJiwZioUxPcMcHyzZtHbZJtLjuezYOd3EKl4d1+GIdPk
puWMiQ1Tu9/Bg6VTg7XZFwmHCX50YtXhHxT25A==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
GwOb37vBeQP6byfafPPfCGVdj30n3yhF7svzOUj2W6OQ8QxmeQ5jEYAV7aEaEtkfLIHQGtRYyy1M
LwuJEuRzc1fvZsDrt+CkhL76LIb0Gz/78u3n1JPi94D2/RZPf+Mp72F4o1xjvTynPi4itsRoOm3Y
GAcGqB1MBEplR3fU/fGM0BwsPwnvJDqRm9YUCRAnssQC2i1+9Zd13ZiI2MvqXegibb34ryVimniv
/BHwxXJBWwRbKmX/nDnpEJKJlDl+ZRlTL6df1oSrdBBGylXb01+1czNyQRdWumPkgv4JaLw+z6T9
j96qDIwk8QKEYet8pUaEzCOThWm8XTBU501nA+XCcrBgm0hk2BhI8Q7w3rcCgu7AJeFa22/aBGZg
iLQGWSjbVbPVOUFy14KCSFsi15TA6a3/8EJXFbnaJ48wjZHVOETV6QGuE/hIF7izbUoUAcSEHvuT
aSBKtab3IDX9vDNo7pRNuslwVX7P2cXKad4AVpc94Y50xX0z6b5uSPxw

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
WxAngXD/mc7SS4aUIyrwN8nNreaXGqVZ0/tJ2IT4LdGboICwpDvGcRlEY5QoyGEV5Pw3pjKauHdf
SfgtdQUkqDIIeyvl5QIXvip418JOb5EOUmtGysx5q6GZjeNKkSPjpAromMcJ0FBGYwFxUnGtZkpT
6VH8CnrdkRjKn2nIaXraF/u+f0uNL3dwtRYqMJxtmCaB1NEusB78IFR2Wx4XlEEjzJ86j8xoUln1
tcmTL0RZTR0gQpJT2pUVB8x1TfVT394KdleYF3YT6nk4GSFv81MXq0ZUWfr9mJ43AIpXjG8OKClD
vtNxwiL4/a2G/q/VukgLIFgQs4FzpTx1578hew==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
wciZxfJLWADywteFxAYUlsF+IuIzKq14kaEGMXZ14BOkuF6bxmegkRhm8joN/NfVVsPTj2b2RlYL
JoklnqlsD2dqj1J1KkUaZlI4K6AxvR/aBJuU9EdpmgQVyppq7+D60IU0glUzj6OJQiptav8lHE1O
LCckSXtyYZrPm3ZQzOk3fGlNIuTQ1450wblIJtuMZIe0Kk56b+NEBngelK8zd1BqhWtCmJ1nwnLt
2wCI/x3Unco8N1Tb0U0NrFYF3ptJLSsxpzzhlHcd9I5ifATl6O3tXykFEKRXnBl30OatdSiYd9A7
+BrW8eKTUZz1uh9QnUeiGzJy+vPFqeNw2Tdcpw==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
bEb+XOhgd5khm3WeUt7z2Rb1GOTZGU1CMNsmxoYzhigDYEHg/AX8kMInYpkn2SL3AK7rhasDanOw
sfTLaXfP8tQxFOiqXQdFc5+t+04kNuXWEZBAQFuBgjtru31M/YHqQeROMemYAMNxsJYtgPMaDyLc
J45u4F6rZCt+SMI95iID4c+7a2DzcEEo8bbv5Z86V4buRyydnonxgFAedybU+sLyKDMEqTsI4hPW
OPZC4R1XzHqsXynp+JNNixPatEJtTcb7avkZffUk2SZBvP/hb348J9Ph1744xl50jD1n7NHNJPXC
xGkb87j6vDU3v7TPMk+PQ+UhJL8tqT/x+qEdWA==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 2528)
`pragma protect data_block
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
C7M4/VdFejvyFkSutHz6JEOpnYQ=
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
