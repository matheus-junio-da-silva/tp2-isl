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
            ACERTOU_QUATRO_CONSECUTIVOS = 3'b110,
            ACERTOU_DOIS_CONSECUTIVOS = 3'b111;

  // Definindo parâmetros
  parameter MAX_JOGOS = 5;

  // Definindo variáveis da máquina de estados
  reg [2:0] current_state;
  // sorteio = 53820
  reg [4:0] sorteio0 = 4'b0101, sorteio1 = 4'b0011, sorteio2 = 4'b1000, sorteio3 = 4'b0010, sorteio4 = 4'b0000; // número de matrícula em binário de 4 bits
  reg [1:0] premio_count;
  reg [4:0] p1_count;
  reg [4:0] p2_count;
  //reg [3:0] last_sorted_number;
  reg [1:0] consecutivos_count;
  reg [1:0] rodadas_count;

  // Inicialização
  always @(posedge clock or posedge reset) begin
    if (reset) begin
      current_state <= IDLE;
      premio_count <= 2'b00;
      p1_count <= 5'b00000;
      p2_count <= 5'b00000;
      consecutivos_count <= 2'b00;
      rodadas_count <= 2'b00;
      //last_sorted_number <= 4'b0000;
    end else begin
      // Lógica da máquina de estados
      case (current_state) // current_state = 3'b000
        IDLE:
          if (insere) begin // insere == 1
            if (rodadas_count == 2'b11) begin
              case (consecutivos_count) // pode ser que seja necessario subtrair 1 de consecutivos_count
                2'b01:
                  current_state <= ACERTOU_DOIS_CONSECUTIVOS;
                2'b10:
                  current_state <= ACERTOU_TRES_CONSECUTIVOS;
                2'b11:
                  current_state <= ACERTOU_QUATRO_CONSECUTIVOS;
                default:
                  current_state <= IDLE;
              endcase
            end else if (numero == sorteio0) begin
              current_state <= ACERTOU_UM;
            end else begin
              current_state <= IDLE;
            end

            if (rodadas_count != 2'b11) begin
              rodadas_count <= rodadas_count + 2'b01;
            end   

          end
        ACERTOU_UM:
          if (insere) begin
            if (numero == sorteio1) begin
              current_state <= ACERTOU_DOIS;
              consecutivos_count <= 2'b01;
            end else begin
              current_state <= IDLE;
            end
            rodadas_count <= rodadas_count + 2'b01;
          end
        ACERTOU_DOIS:
          if (insere) begin
            if (numero == sorteio2) begin
              current_state <= ACERTOU_TRES;
              consecutivos_count <= 2'b10;
            end else begin
              current_state <= IDLE;
            end
            rodadas_count <= rodadas_count + 2'b01;
          end
        ACERTOU_TRES:
          if (insere) begin
            if (numero == sorteio3) begin
              consecutivos_count <= 2'b11;
              current_state <= IDLE;
            end else begin
              current_state <= IDLE;
            end 
            rodadas_count <= rodadas_count + 2'b01;
          end
        
        ACERTOU_DOIS_CONSECUTIVOS:
          if (insere) begin
            if (numero == sorteio4) begin
              // logica da vitoria do premio 2
              p2_count <= p2_count + 5'b00001;
              premio_count <= 2'b10;
            end
          end
        ACERTOU_TRES_CONSECUTIVOS:
          if (insere) begin
            if (numero == sorteio4) begin
              // logica da vitoria do premio 1
              p1_count <= p1_count + 5'b00001;
              premio_count <= 2'b01;
            end else begin
              // acertou tres consecutivos mas nao acertou o ultimo
              p2_count <= p2_count + 5'b00001;
              premio_count <= 2'b10;
            end
          end
        ACERTOU_QUATRO_CONSECUTIVOS:
          if (insere) begin
            // logica da vitoria do premio 1
            p1_count <= p1_count + 5'b00001;
            premio_count <= 2'b01;
            //current_state <= IDLE;
          end
          
      endcase
    end
  end

  // Lógica de contagem de prêmios
  always @(posedge clock or posedge fim_jogo) begin
    if (fim_jogo) begin
      /*
      case (current_state)
        ACERTOU_QUATRO_CONSECUTIVOS:
          p1_count <= p1_count + 1;
        ACERTOU_DOIS_CONSECUTIVOS, ACERTOU_TRES_CONSECUTIVOS:
          p2_count <= p2_count + 1;
      endcase
      premio_count <= (current_state == ACERTOU_QUATRO_CONSECUTIVOS) ? 2'b01 : 2'b10;
      */
    end
  end

  // Saídas
  assign premio = premio_count;
  assign p1 = p1_count;
  assign p2 = p2_count;

endmodule
