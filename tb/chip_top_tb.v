// SPDX-FileCopyrightText: © 2025 Leo Moser <leo.moser@pm.me>
// SPDX-License-Identifier: Apache-2.0

`timescale 1 ns / 1 ps
`default_nettype none

reg [1023:0] firmware_file;
module chip_top_tb;

    // Signal pads
    parameter NUM_FPGA_PADS = 36;

    /*initial begin
        `ifdef DUMP_WAVEFORMS
            $dumpfile("chip_top_tb.fst");
            $dumpvars(0, chip_top_tb);
        `endif
    end*/

    `ifdef USE_POWER_PINS
    wire vddio;
    wire vssio;
    wire vccd;
    wire vssd;
    wire vdda;
    wire vssa;
    wire vdda1;
    wire vssa1;
    wire vccd1;
    wire vssd1;
    wire vdda2;
    wire vssa2;
    wire vccd2;
    wire vssd2;
    `endif

    wire [58:0] gpio_in;
    wire [58:0] gpio_in_h;
    wire [58:0] gpio_out;
    wire [58:0] gpio_oeb;
    wire [58:0] gpio_inp_dis;
    wire [58:0] gpio_ib_mode_sel;
    wire [58:0] gpio_vtrip_sel;
    wire [58:0] gpio_slow_sel;
    wire [58:0] gpio_holdover;
    wire [58:0] gpio_analog_en;
    wire [58:0] gpio_analog_sel;
    wire [58:0] gpio_analog_pol;
    wire [58:0] gpio_dm0;
    wire [58:0] gpio_dm1;
    wire [58:0] gpio_dm2;
    wire [58:0] analog_io;
    wire [58:0] analog_noesd_io;
    
    wire fpga_cs_n_PAD;
    wire fpga_sclk_PAD;
    wire fpga_mosi_PAD;
    wire fpga_miso_PAD;
    
    `ifdef BITSTREAM_FLASH
    
    // SPI Flash - Bitstream
    spiflash_powered i_spiflash_powered (
	    .csb (fpga_cs_n_PAD),
	    .clk (fpga_sclk_PAD),
	    .io0 (fpga_mosi_PAD), // MOSI
	    .io1 (fpga_miso_PAD), // MISO
	    .io2 (  ),
	    .io3 (  )
    );
    
    // Pull down z to 0
    //assign (pull1, pull0) io_fpga_miso_PAD = 1'b0;
    
    `else

    assign fpga_cs_n_PAD = 1'b1;
    assign fpga_sclk_PAD = 1'b0;
    assign fpga_mosi_PAD = 1'b0;

    `endif
    
    wire fpga_clk_PAD;
    wire fpga_rst_n_PAD;

    wire fpga_mode_PAD;
    wire fpga_config_busy_PAD;
    wire fpga_config_configured_PAD;

    wire [18*2-1:0] fabric_io_PAD;

    // -------------------------

    assign gpio_in[0] = fpga_clk_PAD;
    assign gpio_in[1] = fpga_rst_n_PAD;

    assign gpio_in[2] = fpga_sclk_PAD;
    assign gpio_in[3] = fpga_cs_n_PAD;
    assign gpio_in[4] = fpga_mosi_PAD;
    assign gpio_in[5] = fpga_miso_PAD;

    assign gpio_in[6] = fpga_mode_PAD;
    
    genvar i;
    generate
      for (i = 0; i < 36; i = i + 1) begin : gen_io
        assign fabric_io_PAD[i] = ~gpio_oeb[i + 9] ? gpio_out[i + 9] : 1'bz;
      end
    endgenerate
    
    assign gpio_in[44:9] = fabric_io_PAD;
    
    // ---------------------------
    
    assign fpga_sclk_PAD = ~gpio_oeb[2] ? gpio_out[2] : 1'bz;
    assign fpga_cs_n_PAD = ~gpio_oeb[3] ? gpio_out[3] : 1'bz;
    assign fpga_mosi_PAD = ~gpio_oeb[4] ? gpio_out[4] : 1'bz;
    assign fpga_miso_PAD = ~gpio_oeb[5] ? gpio_out[5] : 1'bz;
    
    assign fpga_config_busy_PAD = gpio_out[7];
    assign fpga_config_configured_PAD = gpio_out[8];
    
    // ---------------------------
    
    wire fabric_io_PAD_0, fabric_io_PAD_1, fabric_io_PAD_2, fabric_io_PAD_3, fabric_io_PAD_4, fabric_io_PAD_5, fabric_io_PAD_6, fabric_io_PAD_7, fabric_io_PAD_8, fabric_io_PAD_9, fabric_io_PAD_10, fabric_io_PAD_11, fabric_io_PAD_12, fabric_io_PAD_13, fabric_io_PAD_14, fabric_io_PAD_15, fabric_io_PAD_16, fabric_io_PAD_17, fabric_io_PAD_18, fabric_io_PAD_19, fabric_io_PAD_20, fabric_io_PAD_21, fabric_io_PAD_22, fabric_io_PAD_23, fabric_io_PAD_24, fabric_io_PAD_25, fabric_io_PAD_26, fabric_io_PAD_27, fabric_io_PAD_28, fabric_io_PAD_29, fabric_io_PAD_30, fabric_io_PAD_31, fabric_io_PAD_32, fabric_io_PAD_33, fabric_io_PAD_34, fabric_io_PAD_35;
    
    assign fabric_io_PAD_0 = fabric_io_PAD[0];
    assign fabric_io_PAD_1 = fabric_io_PAD[1];
    assign fabric_io_PAD_2 = fabric_io_PAD[2];
    assign fabric_io_PAD_3 = fabric_io_PAD[3];
    assign fabric_io_PAD_4 = fabric_io_PAD[4];
    assign fabric_io_PAD_5 = fabric_io_PAD[5];
    assign fabric_io_PAD_6 = fabric_io_PAD[6];
    assign fabric_io_PAD_7 = fabric_io_PAD[7];
    assign fabric_io_PAD_8 = fabric_io_PAD[8];
    assign fabric_io_PAD_9 = fabric_io_PAD[9];
    assign fabric_io_PAD_10 = fabric_io_PAD[10];
    assign fabric_io_PAD_11 = fabric_io_PAD[11];
    assign fabric_io_PAD_12 = fabric_io_PAD[12];
    assign fabric_io_PAD_13 = fabric_io_PAD[13];
    assign fabric_io_PAD_14 = fabric_io_PAD[14];
    assign fabric_io_PAD_15 = fabric_io_PAD[15];
    assign fabric_io_PAD_16 = fabric_io_PAD[16];
    assign fabric_io_PAD_17 = fabric_io_PAD[17];
    assign fabric_io_PAD_18 = fabric_io_PAD[18];
    assign fabric_io_PAD_19 = fabric_io_PAD[19];
    assign fabric_io_PAD_20 = fabric_io_PAD[20];
    assign fabric_io_PAD_21 = fabric_io_PAD[21];
    assign fabric_io_PAD_22 = fabric_io_PAD[22];
    assign fabric_io_PAD_23 = fabric_io_PAD[23];
    assign fabric_io_PAD_24 = fabric_io_PAD[24];
    assign fabric_io_PAD_25 = fabric_io_PAD[25];
    assign fabric_io_PAD_26 = fabric_io_PAD[26];
    assign fabric_io_PAD_27 = fabric_io_PAD[27];
    assign fabric_io_PAD_28 = fabric_io_PAD[28];
    assign fabric_io_PAD_29 = fabric_io_PAD[29];
    assign fabric_io_PAD_30 = fabric_io_PAD[30];
    assign fabric_io_PAD_31 = fabric_io_PAD[31];
    assign fabric_io_PAD_32 = fabric_io_PAD[32];
    assign fabric_io_PAD_33 = fabric_io_PAD[33];
    assign fabric_io_PAD_34 = fabric_io_PAD[34];
    assign fabric_io_PAD_35 = fabric_io_PAD[35];

    // greyhound instance
    double_wide_openframe_project_wrapper double_wide_openframe_project_wrapper (
        `ifdef USE_POWER_PINS
        .vddio,
        .vssio,
        .vccd,
        .vssd,
        .vdda,
        .vssa,
        .vdda1,
        .vssa1,
        .vccd1,
        .vssd1,
        .vdda2,
        .vssa2,
        .vccd2,
        .vssd2,
        `endif

        .gpio_in,
        .gpio_in_h,
        .gpio_out,
        .gpio_oeb,
        .gpio_inp_dis,
        .gpio_ib_mode_sel,
        .gpio_vtrip_sel,
        .gpio_slow_sel,
        .gpio_holdover,
        .gpio_analog_en,
        .gpio_analog_sel,
        .gpio_analog_pol,
        .gpio_dm0,
        .gpio_dm1,
        .gpio_dm2,
        .analog_io,
        .analog_noesd_io
    );

endmodule

`default_nettype wire
