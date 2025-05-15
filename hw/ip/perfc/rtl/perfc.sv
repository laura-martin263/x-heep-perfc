module perfc #(
    parameter type reg_req_t = logic,
    parameter type reg_rsp_t = logic
) (
    input  logic     clk_i,
    input  logic     rst_ni,
    input  reg_req_t reg_req_i,
    output reg_rsp_t reg_rsp_o,

    input logic cpu_clock_gate_i,
    input logic cpu_power_gate_i
);

  import perfc_reg_pkg::*;

  // Estructuras para manejar los registros
  perfc_reg2hw_t reg2hw;
  perfc_hw2reg_t hw2reg;

  // Definición de los registros
  logic [31:0] reg0 = 32'd0;  // Total cycles
  logic [31:0] reg1 = 32'd0;  // CPU - Active cycles

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

  // Se asigna el valor de cada registro a la salida
  assign hw2reg.total_cycles.d = reg0;
  assign hw2reg.total_cycles.de = 1'b1;
  assign hw2reg.cpu_active_cycles.d = reg1;
  assign hw2reg.cpu_active_cycles.de = 1'b1;


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
