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

  // Ejemplo simple: asignamos de vuelta el valor de prueba
  assign hw2reg.prueba.d  = prueba_desde_core;
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
