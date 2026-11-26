// Example user design filling the double-wide openframe user area.
//
// Keeps the EXACT same module name and port list as the empty template so it
// can be hardened against the same footprint and cell-swapped into the padframe.
//
// Behaviour: a 32-bit counter clocked from gpio 0, reset (active-low) from
// gpio 1, driving its low bits out on gpios 2..33; all other gpios are inputs.

`default_nettype none

module double_wide_openframe_project_wrapper #(
    parameter NUM_IOS = 59 // 63
)(
`ifdef USE_POWER_PINS
    inout wire vddio,
    inout wire vssio,
    inout wire vccd,
    inout wire vssd,
    inout wire vdda,
    inout wire vssa,
    inout wire vdda1,
    inout wire vssa1,
    inout wire vccd1,
    inout wire vssd1,
    inout wire vdda2,
    inout wire vssa2,
    inout wire vccd2,
    inout wire vssd2,
`endif

    // Frame power-on / master reset
    // input  porb_h,      // power-on reset, sense inverted, 3.3V domain
    // input  por_l,       // power-on reset, noninverted, 1.8V domain
    // input  porb_l,      // power-on reset, sense inverted, 1.8V domain
    // input  resetb_h,    // master reset, sense inverted, 3.3V domain
    // input  resetb_l,    // master reset, sense inverted, 1.8V domain

    // User project ID, programmed in the frame's user_id_programming block
    // input  [31:0] mask_rev,

    // GPIO data (gpio_in_h is 3.3V domain; everything else is 1.8V)
    input  [NUM_IOS-1:0] gpio_in,
    input  [NUM_IOS-1:0] gpio_in_h,
    // input  [NUM_IOS-1:0] gpio_loopback_one,
    // input  [NUM_IOS-1:0] gpio_loopback_zero,
    output [NUM_IOS-1:0] gpio_out,
    output [NUM_IOS-1:0] gpio_oeb,
    output [NUM_IOS-1:0] gpio_inp_dis,
    
    // GPIO pad configuration (see sky130_fd_io__gpiov2)
    output [NUM_IOS-1:0] gpio_ib_mode_sel,
    output [NUM_IOS-1:0] gpio_vtrip_sel,
    output [NUM_IOS-1:0] gpio_slow_sel,
    output [NUM_IOS-1:0] gpio_holdover,
    output [NUM_IOS-1:0] gpio_analog_en,
    output [NUM_IOS-1:0] gpio_analog_sel,
    output [NUM_IOS-1:0] gpio_analog_pol,
    output [NUM_IOS-1:0] gpio_dm0,
    output [NUM_IOS-1:0] gpio_dm1,
    output [NUM_IOS-1:0] gpio_dm2,

    inout  wire [NUM_IOS-1:0] analog_io,
    inout  wire [NUM_IOS-1:0] analog_noesd_io
);

    wire fpga_clk_i;
    wire fpga_rst_ni;

    wire fpga_sclk_i;
    wire fpga_sclk_o;
    wire fpga_sclk_en_o;
          
    wire fpga_cs_n_i;
    wire fpga_cs_n_o;
    wire fpga_cs_n_en_o;
          
    wire fpga_mosi_i;
    wire fpga_mosi_o;
    wire fpga_mosi_en_o;
          
    wire fpga_miso_i;
    wire fpga_miso_o;
    wire fpga_miso_en_o;

    wire fpga_mode_i;
    wire fpga_config_busy_o;
    wire fpga_config_configured_o;

    wire [18*2-1:0] fabric_io_in_i;
    wire [18*2-1:0] fabric_io_out_o;
    wire [18*2-1:0] fabric_io_oe_o;

    // Analog
    wire analog_Iref;
    wire analog_Vcc_read;
    wire analog_Vcomp;
    wire analog_Bias_comp2;
    wire analog_Vcc_wl_read;
    wire analog_Vcc_wl_set;
    wire analog_Vbias;
    wire analog_Vcc_wl_reset;
    wire analog_Vcc_set;
    wire analog_dc_bias;

    // gpio_in
  
    assign fpga_clk_i  = gpio_in[0];
    assign fpga_rst_ni = gpio_in[1];

    assign fpga_sclk_i = gpio_in[2];
    assign fpga_cs_n_i = gpio_in[3];
    assign fpga_mosi_i = gpio_in[4];
    assign fpga_miso_i = gpio_in[5];

    assign fpga_mode_i = gpio_in[6];
    
    assign fabric_io_in_i = gpio_in[44:9];

    // gpio_out
    
    assign gpio_out[0] = '0;
    assign gpio_out[1] = '0;
    
    assign gpio_out[2] = fpga_sclk_o;
    assign gpio_out[3] = fpga_cs_n_o;
    assign gpio_out[4] = fpga_mosi_o;
    assign gpio_out[5] = fpga_miso_o;
    
    assign gpio_out[6] = '0;
    
    assign gpio_out[7] = fpga_config_busy_o;
    assign gpio_out[8] = fpga_config_configured_o;
    
    assign gpio_out[44:9]  = fabric_io_out_o;
    
    assign gpio_out[NUM_IOS-1:45] = '0; // unused

    // gpio_oeb

    assign gpio_oeb[0] = '1;
    assign gpio_oeb[1] = '1;
    
    assign gpio_oeb[2] = ~fpga_sclk_en_o;
    assign gpio_oeb[3] = ~fpga_cs_n_en_o;
    assign gpio_oeb[4] = ~fpga_mosi_en_o;
    assign gpio_oeb[5] = ~fpga_miso_en_o;
    
    assign gpio_oeb[6] = '1;
    
    assign gpio_oeb[7] = '0;
    assign gpio_oeb[8] = '0;
    
    assign gpio_oeb[44:9]  = ~fabric_io_oe_o;
    
    assign gpio_oeb[NUM_IOS-1:45] = '1; // unused

    // dm = 001 input, 110 output
    
    wire [2:0] gpio_dm [NUM_IOS];
    
    assign gpio_dm[0] = 3'b001;
    assign gpio_dm[1] = 3'b001;
    
    assign gpio_dm[2] = fpga_sclk_en_o ? 3'b110 : 3'b001;
    assign gpio_dm[3] = fpga_cs_n_en_o ? 3'b110 : 3'b001;
    assign gpio_dm[4] = fpga_mosi_en_o ? 3'b110 : 3'b001;
    assign gpio_dm[5] = fpga_miso_en_o ? 3'b110 : 3'b001;
    
    assign gpio_dm[6] = 3'b001;
    
    assign gpio_dm[7] = 3'b110;
    assign gpio_dm[8] = 3'b110;
    
    generate
    for (genvar i=9; i<45; i++) begin
        assign gpio_dm[i] = fabric_io_oe_o[i-9] ? 3'b110 : 3'b001;
    end
    // all others: unused/analog
    for (genvar i=45; i<NUM_IOS; i++) begin
        assign gpio_dm[i] = 3'b000;
    end
    endgenerate
    
    generate
    for (genvar i=0; i<NUM_IOS; i++) begin
        assign gpio_dm0[i] = gpio_dm[i][0];
        assign gpio_dm1[i] = gpio_dm[i][1];
        assign gpio_dm2[i] = gpio_dm[i][2];
    end
    endgenerate

    // disable inpput buffer for unused/analog
    assign gpio_inp_dis     = {{14{1'b1}}, {45{1'b0}}};

    assign gpio_ib_mode_sel = {NUM_IOS{1'b0}};
    assign gpio_vtrip_sel   = {NUM_IOS{1'b0}};
    assign gpio_slow_sel    = {NUM_IOS{1'b0}};
    assign gpio_holdover    = {NUM_IOS{1'b0}};
    assign gpio_analog_en   = {NUM_IOS{1'b0}};
    assign gpio_analog_sel  = {NUM_IOS{1'b0}};
    assign gpio_analog_pol  = {NUM_IOS{1'b0}};
    
    // Analog

    assign analog_Iref          = analog_io[45];
    assign analog_Vcc_read      = analog_io[46];
    assign analog_Vcomp         = analog_io[47];
    assign analog_Bias_comp2    = analog_io[48];
    assign analog_Vcc_wl_read   = analog_io[49];
    assign analog_Vcc_wl_set    = analog_io[50];
    assign analog_Vbias         = analog_io[51];
    assign analog_Vcc_wl_reset  = analog_io[52];
    assign analog_Vcc_set       = analog_io[53];
    assign analog_dc_bias       = analog_io[54];

    chip_core chip_core (
      // FPGA
      .fpga_clk_i     (fpga_clk_i),
      .fpga_rst_ni    (fpga_rst_ni),

      .fpga_sclk_i    (fpga_sclk_i),
      .fpga_sclk_o    (fpga_sclk_o),
      .fpga_sclk_en_o (fpga_sclk_en_o),
      
      .fpga_cs_n_i    (fpga_cs_n_i),
      .fpga_cs_n_o    (fpga_cs_n_o),
      .fpga_cs_n_en_o (fpga_cs_n_en_o),
      
      .fpga_mosi_i    (fpga_mosi_i),
      .fpga_mosi_o    (fpga_mosi_o),
      .fpga_mosi_en_o (fpga_mosi_en_o),
      
      .fpga_miso_i    (fpga_miso_i),
      .fpga_miso_o    (fpga_miso_o),
      .fpga_miso_en_o (fpga_miso_en_o),

      // FPGA config mode
      // if mode == 0: SPI controller
      // if mode == 1: SPI receiver
      .fpga_mode_i              (fpga_mode_i),
      .fpga_config_busy_o       (fpga_config_busy_o),
      .fpga_config_configured_o (fpga_config_configured_o),

      // I/Os FPGA
      .fabric_io_in_i     (fabric_io_in_i),
      .fabric_io_out_o    (fabric_io_out_o),
      .fabric_io_oe_o     (fabric_io_oe_o),
      
      // Analog
      .analog_Iref          (analog_Iref),
      .analog_Vcc_read      (analog_Vcc_read),
      .analog_Vcomp         (analog_Vcomp),
      .analog_Bias_comp2    (analog_Bias_comp2),
      .analog_Vcc_wl_read   (analog_Vcc_wl_read),
      .analog_Vcc_wl_set    (analog_Vcc_wl_set),
      .analog_Vbias         (analog_Vbias),
      .analog_Vcc_wl_reset  (analog_Vcc_wl_reset),
      .analog_Vcc_set       (analog_Vcc_set),
      .analog_dc_bias       (analog_dc_bias)
  );
    

endmodule

`default_nettype wire
