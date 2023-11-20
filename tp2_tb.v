`timescale 1ns/1ps

module Loteria_tb;

  // Parâmetros
  parameter CLK_PERIOD = 10; // Período do clock em unidades de tempo
  
  // Sinais de Entrada
  reg clock;
  reg [3:0] numero;
  reg reset;
  reg fim;
  reg fim_jogo;
  reg insere;
  reg novo_jogo;
  // Sinais de Saída
  wire [1:0] premio;
  wire [4:0] p1;
  wire [4:0] p2;

  // Instanciando o módulo Loteria
  Loteria uut (
    .clock(clock),
    .numero(numero),
    .reset(reset),
    .fim(fim),
    .fim_jogo(fim_jogo),
    .insere(insere),
    .premio(premio),
    .p1(p1),
    .p2(p2),
    .novo_jogo(novo_jogo)
  );

  // Inicialização do clock
  initial begin
    clock = 0;
    forever #((CLK_PERIOD)/2) clock = ~clock;
  end

  // Geração de Estímulos
  initial begin
    // Inicializando as entradas
    reset = 1;
    numero = 4'b0000;
    fim = 0;
    fim_jogo = 0;
    insere = 0;
    novo_jogo = 1'b0;
    // Aguardando alguns ciclos
    #10 reset = 0;

    // Teste 1: Insere número e verifica prêmio
    insere = 1;
    numero = 4'b0000; // Número sorteado para ACERTOU_UM
    #10 numero = 4'b0011; // Número sorteado para ACERTOU_DOIS
    #10 numero = 4'b1000; // Número sorteado para ACERTOU_TRES
    #10 numero = 4'b0010; // Número sorteado para ACERTOU_QUATRO
    #10 numero = 4'b0000; // Número sorteado para ACERTOU_TRES_CONSECUTIVOS
    #20 insere = 0;
    //#10 $display("Resultado: premio=%b, p1=%b, p2=%b", premio, p1, p2);
    // Teste 2: Fim de Jogo, mas apenas de 1 jogo
    #100 fim_jogo = 1;
    #100 $display("Resultado: premio=%b, p1=%b, p2=%b", premio, p1, p2);

    #110 fim = 1;
    #110 $display("Resultado: premio=%b, p1=%b, p2=%b", premio, p1, p2);
    // Aguardando o final da simulação
    #200 $finish;
    //#100000; // Aguardar um número suficiente de ciclos para exibir mensagens
    //$stop; // Parar a simulação
  end

  

endmodule
