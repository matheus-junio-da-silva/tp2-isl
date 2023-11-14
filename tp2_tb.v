`timescale 1ns / 1ps

module Testbench;

  reg clock;
  reg [3:0] numero;
  reg reset;
  reg fim;
  reg fim_jogo;
  reg insere;
  wire [1:0] premio;
  wire [4:0] p1;
  wire [4:0] p2;

  // Instanciando o módulo Loteria
  Loteria loteria (
    .clock(clock),
    .numero(numero),
    .reset(reset),
    .fim(fim),
    .fim_jogo(fim_jogo),
    .insere(insere),
    .premio(premio),
    .p1(p1),
    .p2(p2)
  );

  // Gerando um sinal de clock
  always begin
    #5 clock = ~clock;
  end

  // Testando o módulo Loteria
  initial begin
    // Inicializando as entradas
    reset = 1;
    fim = 0;
    fim_jogo = 0;
    insere = 0;
    numero = 4'b0000;

    // Aplicando a sequência de teste
    #10 reset = 0;
    #10 insere = 1; numero = 4'b0001;
    #10 $display("premio: %d, p1: %d, p2: %d", premio, p1, p2);
    #10 insere = 1; numero = 4'b0010;
    #10 $display("premio: %d, p1: %d, p2: %d", premio, p1, p2);
    #10 insere = 1; numero = 4'b0011;
    #10 $display("premio: %d, p1: %d, p2: %d", premio, p1, p2);
    #10 insere = 1; numero = 4'b0100;
    #10 $display("premio: %d, p1: %d, p2: %d", premio, p1, p2);
    #10 insere = 0; numero = 4'b0000;
    #10 fim_jogo = 1;
    #10 $display("premio: %d, p1: %d, p2: %d", premio, p1, p2);
    #10 fim_jogo = 0;
    #10 insere = 1; numero = 4'b0101;
    #10 $display("premio: %d, p1: %d, p2: %d", premio, p1, p2);
    #10 insere = 1; numero = 4'b0110;
    #10 $display("premio: %d, p1: %d, p2: %d", premio, p1, p2);
    #10 insere = 1; numero = 4'b0111;
    #10 $display("premio: %d, p1: %d, p2: %d", premio, p1, p2);
    #10 insere = 1; numero = 4'b1000;
    #10 $display("premio: %d, p1: %d, p2: %d", premio, p1, p2);
    #10 insere = 0; numero = 4'b0000;
    #10 fim_jogo = 1;
    #10 $display("premio: %d, p1: %d, p2: %d", premio, p1, p2);

    // Terminando a simulação
    #10 $finish;
  end

endmodule
