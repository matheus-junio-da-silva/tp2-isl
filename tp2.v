module Loteria (
  input wire clock,
  input wire [3:0] numero,
  input wire reset,
  input wire fim,
  input wire fim_jogo,
  input wire insere,
  output wire [1:0] premio,
  output wire [4:0] p1,
  output wire [4:0] p2
);

  // Definindo os estados da máquina de estados finita
  parameter IDLE = 3'b000,
            ACERTOU_UM = 3'b001,
            ACERTOU_DOIS = 3'b010,
            ACERTOU_TRES = 3'b011,
            ACERTOU_QUATRO = 3'b100,
            ACERTOU_TRES_CONSECUTIVOS = 3'b101,
            ACERTOU_QUATRO_CONSECUTIVOS = 3'b110;

  // Definindo parâmetros
  parameter MAX_JOGOS = 5;

  // Definindo variáveis da máquina de estados
  reg [2:0] current_state;
  reg [3:0] sorteio;
  reg [3:0] segundo_numero;
  reg [1:0] premio_count;
  reg [4:0] p1_count;
  reg [4:0] p2_count;

  // Inicialização
  always @(posedge clock or posedge reset) begin
    if (reset) begin
      current_state <= IDLE;
      sorteio <= 4'b0000;
      segundo_numero <= 4'b0000;
      premio_count <= 2'b00;
      p1_count <= 5'b00000;
      p2_count <= 5'b00000;
    end else begin
      // Lógica da máquina de estados
      case (current_state)
        IDLE:
          if (insere) begin
            sorteio <= {sorteio[2:0], numero};
            if (segundo_numero == 4'b0000) begin
              segundo_numero <= sorteio;
            end
            current_state <= ACERTOU_UM;
          end
        ACERTOU_UM:
          if (insere) begin
            if (numero == sorteio[3:0]) begin
              current_state <= ACERTOU_DOIS;
            end else begin
              current_state <= IDLE;
            end
          end
        // Adicione os outros estados de acordo com as regras do jogo...
      endcase
    end
  end

  // Lógica de contagem de prêmios
  always @(posedge clock or posedge fim_jogo) begin
    if (fim_jogo) begin
      case (current_state)
        ACERTOU_QUATRO_CONSECUTIVOS:
          p1_count <= p1_count + 1;
        ACERTOU_DOIS, ACERTOU_TRES_CONSECUTIVOS:
          p2_count <= p2_count + 1;
      endcase
      premio_count <= (current_state == ACERTOU_QUATRO_CONSECUTIVOS) ? 2'b01 : 2'b10;
    end
  end

  // Saídas
  assign premio = premio_count;
  assign p1 = p1_count;
  assign p2 = p2_count;

endmodule
