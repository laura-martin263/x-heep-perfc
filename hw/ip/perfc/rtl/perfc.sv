module perfc #(
    parameter type reg_req_t = logic,
    parameter type reg_rsp_t = logic
) (
    input  logic     clk_i,
    input  logic     rst_ni,
    input  reg_req_t reg_req_i,
    output reg_rsp_t reg_rsp_o,

    input logic [31:0] prueba_desde_core
);

  import perfc_reg_pkg::*;

  // Estructuras para manejar los registros
  perfc_reg2hw_t reg2hw;
  perfc_hw2reg_t hw2reg;

  logic [31:0] registro = 32'd0;

  /////////////////////////////////////////
  // Performance counters
  /////////////////////////////////////////

  // Total cycles
  always @(posedge clk_i) begin
    if (reg2hw.control.q[0]) begin
      registro <= 32'd0;
    end else if (reg2hw.control.q[1]) begin
      registro <= registro + 32'd1;
    end else begin
      // Se mantiene el valor del registro
    end
  end

  assign hw2reg.prueba.d  = registro;
  assign hw2reg.prueba.de = 1'b1;

  assign hw2reg.prueba2.d = reg2hw.prueba2.q;
  assign hw2reg.prueba.de = 1'b1;

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
