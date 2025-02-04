module Loteria (
  input wire clock,
  input wire [3:0] numero,
  input wire reset,
  input wire fim,
  input wire fim_jogo,
  input wire novo_jogo,
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
  reg [4:0] sorteio_atual;
  reg [1:0] premio_count;
  reg [4:0] p1_count;
  reg [4:0] p2_count;
  //reg [3:0] last_sorted_number;
  reg [1:0] consecutivos_count;
  reg [2:0] rodadas_count;
  reg sorteio_concluido;

  // Inicialização
  always @(posedge clock or posedge reset or posedge novo_jogo) begin
    if (reset || novo_jogo) begin
      current_state <= IDLE;
      premio_count <= 2'b00;
      p1_count <= 5'b00000;
      p2_count <= 5'b00000;
      consecutivos_count <= 2'b00;
      rodadas_count <= 3'b000;
      sorteio_atual <= 4'b0101;
      sorteio_concluido <= 1'b0;
    
      $display("Entrou aqui");
      //last_sorted_number <= 4'b0000;
    end else begin
      // Lógica da máquina de estados
      case (current_state) // current_state = 3'b000
        IDLE:
          if (insere) begin // insere == 1
            // Lógica para definir sorteio_atual
            if (rodadas_count == 3'b000) begin
              sorteio_atual = 4'b0101; // sorteio0;
              sorteio_concluido <= 1'b1;
            end else if (rodadas_count == 3'b001) begin
              sorteio_atual = 4'b0011; // sorteio1;
              sorteio_concluido <= 1'b1;
            end else if (rodadas_count == 3'b010) begin
              sorteio_atual = 4'b1000; // sorteio2;
              sorteio_concluido <= 1'b1;
            end else if (rodadas_count == 3'b011) begin
              sorteio_atual = 4'b0010; // sorteio3;
              sorteio_concluido <= 1'b1;
            end

            if(rodadas_count == 3'b101) begin // gambiarra para subtrair um rodada
              rodadas_count = 3'b100;
            end

            if (rodadas_count == 3'b100) begin // gambiarra para nao contar a ultima rodada
              $display("Entrou aqui oi");
              if (consecutivos_count == 2'b01) begin
                
                $display("Entrou aqui 4");
                
                current_state <= ACERTOU_DOIS_CONSECUTIVOS;
              end
              else if (consecutivos_count == 2'b10) begin
                current_state <= ACERTOU_TRES_CONSECUTIVOS;
                if (1) begin
                  $display("Entrou aqui 3");
                end
              end
              else if (consecutivos_count == 2'b11) begin
                current_state <= ACERTOU_QUATRO_CONSECUTIVOS;
                $display("Entrou aqui 2");
              end
              else begin
                //current_state <= IDLE;
              end
            end else if (numero == sorteio_atual) begin
              $display("Valor de sorteio_atual: %b", sorteio_atual);

              if (rodadas_count != 3'b100) begin
              rodadas_count <= rodadas_count + 2'b01;
              $display("Entrou aqui 1");
              end 
              current_state <= ACERTOU_UM;
              $display("Entrou aqui 5");
            end else begin
              $display("Entrou aqui ola");
              if (rodadas_count != 3'b100) begin
              rodadas_count <= rodadas_count + 2'b01;
              $display("Entrou aqui 01");
              $display("Valor de rodadas_count: %b", rodadas_count);
              end
              $display("Valor de sorteio_atual: %b", sorteio_atual);
              current_state <= IDLE;
              $display("Entrou aqui 6");
              $display("Valor de rodadas_count: %b", rodadas_count);
            end
            
          end
        ACERTOU_UM:
          if (insere) begin

            if (rodadas_count == 3'b000) begin
              sorteio_atual = 4'b0101; // sorteio0;
            end else if (rodadas_count == 3'b001) begin
              sorteio_atual = 4'b0011; // sorteio1;
            end else if (rodadas_count == 3'b010) begin
              sorteio_atual = 4'b1000; // sorteio2;
            end else if (rodadas_count == 3'b011) begin
              sorteio_atual = 4'b0010; // sorteio3;
            end

            if (numero == sorteio_atual) begin
              $display("Valor de sorteio_atual: %b", sorteio_atual);

              current_state <= ACERTOU_DOIS;
              consecutivos_count <= 2'b01;
              $display("Entrou aqui 7");
              rodadas_count <= rodadas_count + 2'b01;
              $display("Valor de consecutivos_count: %b", consecutivos_count);
              $display("Valor de rodadas_count: %b", rodadas_count);
            end else begin
              current_state <= IDLE;
              $display("Entrou aqui 15");
              rodadas_count <= rodadas_count + 2'b01;
            end
            
          end
        ACERTOU_DOIS:
          if (insere) begin
            
            if (rodadas_count == 3'b000) begin
              sorteio_atual = 4'b0101; // sorteio0;
            end else if (rodadas_count == 3'b001) begin
              sorteio_atual = 4'b0011; // sorteio1;
            end else if (rodadas_count == 3'b010) begin
              sorteio_atual = 4'b1000; // sorteio2;
            end else if (rodadas_count == 3'b011) begin
              sorteio_atual = 4'b0010; // sorteio3;
            end

            if (numero == sorteio_atual) begin
              $display("Valor de sorteio_atual: %b", sorteio_atual);

              current_state <= ACERTOU_TRES;
              consecutivos_count <= 2'b10;
              $display("Entrou aqui 8");
              rodadas_count <= rodadas_count + 2'b01;
              $display("Valor de consecutivos_count: %b", consecutivos_count);
              $display("Valor de rodadas_count: %b", rodadas_count);
            end else begin
              current_state <= IDLE;
              $display("Entrou aqui 13");
              $display("Valor de consecutivos_count: %b", consecutivos_count);
              if (rodadas_count != 3'b100) begin
              rodadas_count <= rodadas_count + 2'b01;
              $display("Entrou aqui 133");
              end
              $display("Valor de rodadas_count: %b", rodadas_count);
            end
            //rodadas_count <= rodadas_count + 2'b01;
          end
        ACERTOU_TRES:
          if (insere) begin

            if (rodadas_count == 3'b000) begin
              sorteio_atual = 4'b0101; // sorteio0;
            end else if (rodadas_count == 3'b001) begin
              sorteio_atual = 4'b0011; // sorteio1;
            end else if (rodadas_count == 3'b010) begin
              sorteio_atual = 4'b1000; // sorteio2;
            end else if (rodadas_count == 3'b011) begin
              sorteio_atual = 4'b0010; // sorteio3;
            end

            if (numero == sorteio_atual) begin
              $display("Valor de sorteio_atual: %b", sorteio_atual);

              consecutivos_count <= 2'b11;
              current_state <= IDLE;
              $display("Entrou aqui 9");
              rodadas_count <= rodadas_count + 2'b01;
              $display("Valor de rodadas_count: %b", rodadas_count);
              // o valor desse diplay nao esta atualizado com o valor atribuido aqui, demora um tempo para atualizar
              $display("Valor de consecutivos_count: %b", consecutivos_count);

            end else begin
              current_state <= IDLE;
              $display("Entrou aqui 14");
              rodadas_count <= rodadas_count + 2'b01;
            end 
            //rodadas_count <= rodadas_count + 2'b01;
          end

        
      endcase
    end
  end

  // Lógica de contagem de prêmios
  //always @(posedge clock or posedge fim_jogo) begin
  always @(posedge fim_jogo) begin
    if (fim_jogo) begin
      
      case (current_state)
        ACERTOU_DOIS_CONSECUTIVOS:
          begin
            $display("Entrou aqui 2conseq");
            if (numero == sorteio4) begin
              // logica da vitoria do premio 2
              p2_count <= p2_count + 5'b00001;
              premio_count <= 2'b10;
              $display("Entrou aqui 9");
            end
          end
        ACERTOU_TRES_CONSECUTIVOS:
          begin
            if (numero == sorteio4) begin
              // logica da vitoria do premio 1
              p1_count <= p1_count + 5'b00001;
              premio_count <= 2'b01;
              $display("Entrou aqui 10");
            end else begin
              // acertou tres consecutivos mas nao acertou o ultimo
              p2_count <= p2_count + 5'b00001;
              premio_count <= 2'b10;
            end
          end
        ACERTOU_QUATRO_CONSECUTIVOS:
          //if (insere) begin
          begin
            // logica da vitoria do premio 1
            p1_count <= p1_count + 5'b00001;
            premio_count <= 2'b01;
            //current_state <= IDLE;
            $display("Entrou aqui 11");
          end

        default:
          premio_count <= 2'b00;
      endcase
      
      $display("Entrou aqui 0012");
      $display("Valor de rodadas_count: %b", rodadas_count);
    end
  end

  // Saídas
  assign premio = premio_count;
  assign p1 = p1_count;
  assign p2 = p2_count;

  always @(posedge fim) begin
    if (fim) begin
      current_state <= IDLE;
      premio_count <= 2'b00;
      p1_count <= 5'b00000;
      p2_count <= 5'b00000;
      consecutivos_count <= 2'b00;
      rodadas_count <= 3'b000;
      sorteio_atual <= 4'b0101;
      sorteio_concluido <= 1'b0;
    
      $display("Entrou aqui");
      //last_sorted_number <= 4'b0000;
    end

  end

endmodule
