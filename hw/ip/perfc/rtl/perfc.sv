module perfc #(
    parameter type reg_req_t = logic,
    parameter type reg_rsp_t = logic
) (
    input  logic     clk_i,
    input  logic     rst_ni,
    input  reg_req_t reg_req_i,
    output reg_rsp_t reg_rsp_o,

    // cpu -- YA CONECTADAS
    input logic cpu_clock_gate_i,
    input logic cpu_power_gate_i,

    // plic
    input logic plic_clock_gate_i,
    input logic plic_power_gate_i,

    // gpio
    input logic gpio_clock_gate_i,
    input logic gpio_power_gate_i,

    // i2c
    input logic i2c_clock_gate_i,
    input logic i2c_power_gate_i,

    // timer
    input logic timer_clock_gate_i,
    input logic timer_power_gate_i,
    
    // spi
    input logic spi_clock_gate_i,
    input logic spi_power_gate_i,

    // ram bank 0
    input logic ram_bank_0_clock_gate_i,
    input logic ram_bank_0_power_gate_i,
    input logic ram_bank_0_retentive_i,

    // ram bank 1
    input logic ram_bank_1_clock_gate_i,
    input logic ram_bank_1_power_gate_i,
    input logic ram_bank_1_retentive_i,

    // ram bank 2
    input logic ram_bank_2_clock_gate_i,
    input logic ram_bank_2_power_gate_i,
    input logic ram_bank_2_retentive_i,

    // ram bank 3
    input logic ram_bank_3_clock_gate_i,
    input logic ram_bank_3_power_gate_i,
    input logic ram_bank_3_retentive_i
);

  import perfc_reg_pkg::*;

  // Estructuras para manejar los registros
  perfc_reg2hw_t reg2hw;
  perfc_hw2reg_t hw2reg;

  /////////////////////////////////////////
  // Performance interface
  /////////////////////////////////////////
  
  logic [31:0] reg0 = 32'd0;  // Total cycles

  // cpu
  logic [31:0] reg1 = 32'd0;  // CPU - Active cycles
  logic [31:0] reg2 = 32'd0;  // CPU - Clock-gate cycles
  logic [31:0] reg3 = 32'd0;  // CPU - Power-gate cycles


  // bus ao - UNCONNECTED
  logic [31:0] reg4 = 32'd0;  // BUS AO - Active cycles
  logic [31:0] reg5 = 32'd0;  // BUS AO - Clock-gate cycles

  // debug ao - UNCONNECTED
  logic [31:0] reg6 = 32'd0;  // DEBUG AO - Active cycles
  logic [31:0] reg7 = 32'd0;  // DEBUG AO - Clock-gate cycles

  // soc ctrl ao - UNCONNECTED
  logic [31:0] reg8 = 32'd0;  // SOC CTRL AO - Active cycles
  logic [31:0] reg9 = 32'd0;  // SOC CTRL AO - Clock-gate cycles

  // boot rom ao - UNCONNECTED
  logic [31:0] reg10 = 32'd0; // BOOT ROM AO - Active cycles
  logic [31:0] reg11 = 32'd0; // BOOT ROM AO - Clock-gate cycles

  // spi flash ao - UNCONNECTED
  logic [31:0] reg12 = 32'd0; // SPI FLASH AO - Active cycles
  logic [31:0] reg13 = 32'd0; // SPI FLASH AO - Clock-gate cycles

  // spi ao - UNCONNECTED
  logic [31:0] reg14 = 32'd0; // SPI AO - Active cycles
  logic [31:0] reg15 = 32'd0; // SPI AO - Clock-gate cycles

  // power manager ao - UNCONNECTED
  logic [31:0] reg16 = 32'd0; // POWER MANAGER AO - Active cycles
  logic [31:0] reg17 = 32'd0; // POWER MANAGER AO - Clock-gate cycles

  // timer ao - UNCONNECTED
  logic [31:0] reg18 = 32'd0; // TIMER AO - Active cycles
  logic [31:0] reg19 = 32'd0; // TIMER AO - Clock-gate cycles

  // dma ao - UNCONNECTED
  logic [31:0] reg20 = 32'd0; // DMA AO - Active cycles
  logic [31:0] reg21 = 32'd0; // DMA AO - Clock-gate cycles

  // fast int ctrl ao - UNCONNECTED
  logic [31:0] reg22 = 32'd0; // FAST INT CTRL AO - Active cycles
  logic [31:0] reg23 = 32'd0; // FAST INT CTRL AO - Clock-gate cycles

  // gpio ao - UNCONNECTED
  logic [31:0] reg24 = 32'd0; // GPIO AO - Active cycles
  logic [31:0] reg25 = 32'd0; // GPIO AO - Clock-gate cycles

  // uart ao - UNCONNECTED
  logic [31:0] reg26 = 32'd0; // UART AO - Active cycles
  logic [31:0] reg27 = 32'd0; // UART AO - Clock-gate cycles

  // plic
  logic [31:0] reg28 = 32'd0; // PLIC - Active cycles
  logic [31:0] reg29 = 32'd0; // PLIC - Clock-gate cycles
  logic [31:0] reg30 = 32'd0; // PLIC - Power-gate cycles

  // gpio
  logic [31:0] reg31 = 32'd0; // GPIO - Active cycles
  logic [31:0] reg32 = 32'd0; // GPIO - Clock-gate cycles
  logic [31:0] reg33 = 32'd0; // GPIO - Power-gate cycles

  // i2c
  logic [31:0] reg34 = 32'd0; // I2C - Active cycles
  logic [31:0] reg35 = 32'd0; // I2C - Clock-gate cycles
  logic [31:0] reg36 = 32'd0; // I2C - Power-gate cycles

  // timer
  logic [31:0] reg37 = 32'd0; // TIMER - Active cycles
  logic [31:0] reg38 = 32'd0; // TIMER - Clock-gate cycles
  logic [31:0] reg39 = 32'd0; // TIMER - Power-gate cycles

  // spi
  logic [31:0] reg40 = 32'd0; // SPI - Active cycles
  logic [31:0] reg41 = 32'd0; // SPI - Clock-gate cycles
  logic [31:0] reg42 = 32'd0; // SPI - Power-gate cycles

  // ram bank 0
  logic [31:0] reg43 = 32'd0; // RAM BANK 0 - Active cycles
  logic [31:0] reg44 = 32'd0; // RAM BANK 0 - Clock-gate cycles
  logic [31:0] reg45 = 32'd0; // RAM BANK 0 - Power-gate cycles
  logic [31:0] reg46 = 32'd0; // RAM BANK 0 - Retentive cycles

  // ram bank 1
  logic [31:0] reg47 = 32'd0; // RAM BANK 1 - Active cycles
  logic [31:0] reg48 = 32'd0; // RAM BANK 1 - Clock-gate cycles
  logic [31:0] reg49 = 32'd0; // RAM BANK 1 - Power-gate cycles
  logic [31:0] reg50 = 32'd0; // RAM BANK 1 - Retentive cycles

  // ram bank 2
  logic [31:0] reg51 = 32'd0; // RAM BANK 2 - Active cycles
  logic [31:0] reg52 = 32'd0; // RAM BANK 2 - Clock-gate cycles
  logic [31:0] reg53 = 32'd0; // RAM BANK 2 - Power-gate cycles
  logic [31:0] reg54 = 32'd0; // RAM BANK 2 - Retentive cycles

  // ram bank 3
  logic [31:0] reg55 = 32'd0; // RAM BANK 3 - Active cycles
  logic [31:0] reg56 = 32'd0; // RAM BANK 3 - Clock-gate cycles
  logic [31:0] reg57 = 32'd0; // RAM BANK 3 - Power-gate cycles
  logic [31:0] reg58 = 32'd0; // RAM BANK 3 - Retentive cycles


  /////////////////////////////////////////
  // Performance counters
  /////////////////////////////////////////

  // Total cycles
  always @(posedge clk_i) begin
    if (reg2hw.control.q[0]) begin
      reg0 <= 32'd0;
    end else if (reg2hw.control.q[1]) begin
      reg0 <= reg0 + 32'd1;
    end else begin
      // Se mantiene el valor de reg0
    end
  end

  // CPU - Active cycles
  always @(posedge clk_i) begin
    if (reg2hw.control.q[0]) begin
      reg1 <= 32'd0;
    end else if (reg2hw.control.q[1] && cpu_clock_gate_i == 1'b0 && cpu_power_gate_i == 1'b0) begin
      reg1 <= reg1 + 32'd1;
    end else begin
      // Se mantiene el valor de reg1
    end
  end

  // CPU - Clock-gate cycles
  always @(posedge clk_i) begin
    if (reg2hw.control.q[0]) begin
      reg2 <= 32'd0;
    end else if (reg2hw.control.q[1] && cpu_clock_gate_i == 1'b1 && cpu_power_gate_i == 1'b0) begin
      reg2 <= reg2 + 32'd1;
    end else begin
      // Se mantiene el valor de reg2
    end
  end

  // CPU - Power-gate cycles
  always @(posedge clk_i) begin
    if (reg2hw.control.q[0]) begin
      reg3 <= 32'd0;
    end else if (reg2hw.control.q[1] && cpu_clock_gate_i == 1'b1 && cpu_power_gate_i == 1'b1) begin
      reg3 <= reg3 + 32'd1;
    end else begin
      // Se mantiene el valor de reg3
    end
  end

  // Se asigna el valor de cada registro a la salida

  assign hw2reg.total_cycles.de = 1'b1;
  assign hw2reg.cpu_active_cycles.de = 1'b1;
  assign hw2reg.cpu_clock_gate_cycles.de = 1'b1;
  assign hw2reg.cpu_power_gate_cycles.de = 1'b1;

  assign hw2reg.total_cycles.d = reg0;
  assign hw2reg.cpu_active_cycles.d = reg1;
  assign hw2reg.cpu_clock_gate_cycles.d = reg2;
  assign hw2reg.cpu_power_gate_cycles.d = reg3;


  // Instancia del generador de registros (generado con regtool)
  perfc_reg_top #(
      .reg_req_t(reg_req_t),
      .reg_rsp_t(reg_rsp_t)
  ) perfc_reg_top_i (
      .clk_i,
      .rst_ni,
      .reg_req_i,
      .reg_rsp_o,
      .reg2hw,
      .hw2reg,
      .devmode_i(1'b1)
  );

endmodule
