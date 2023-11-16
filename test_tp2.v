`timescale 1ns / 1ps

module Loteria_tb;

  // Parâmetros
  parameter CLOCK_PERIOD = 10;

  // Sinais
  reg clock;
  reg [3:0] numero;
  reg reset;
  reg fim;
  reg fim_jogo;
  reg insere;
  wire [1:0] premio;
  wire [4:0] p1;
  wire [4:0] p2;

  // Instância do módulo
  Loteria dut (
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

  // Clock
  always #CLOCK_PERIOD clock = ~clock;

  // Teste 1 - Não ganhou nenhum prêmio
  initial begin
    $dumpfile("tp2_tb.vcd");
    $dumpvars(0, Loteria_tb);

    clock = 0;
    reset = 1'b1;
    numero = 4'b0000;
    fim = 1'b0;
    fim_jogo = 1'b0;
    insere = 1'b0;
    #2 reset = 1'b0;

    // Jogo 1
    insere = 1'b1;
    numero = 4'b0101;
    #2 numero = 4'b0011;
    #2 numero = 4'b1000;
    #2 numero = 4'b0010;
    #2 numero = 4'b0000;
    insere = 1'b0;
    fim_jogo = 1'b1;
    #2 fim_jogo = 1'b0;

    // Verificação
    #10 $display("Teste 1 - Não ganhou nenhum prêmio");
    #10 $display("Prêmio: %b", premio);
    #10 $display("P1: %b", p1);
    #10 $display("P2: %b", p2);
    #10 $finish;
  end

  // Teste 2 - Ganhou o prêmio 1
  initial begin
    $dumpfile("tp2_tb.vcd");
    $dumpvars(0, Loteria_tb);

    clock = 0;
    reset = 1'b1;
    numero = 4'b0000;
    fim = 1'b0;
    fim_jogo = 1'b0;
    insere = 1'b0;
    #2 reset = 1'b0;

    // Jogo 2
    insere = 1'b1;
    numero = 4'b0011;
    #2 numero = 4'b1000;
    #2 numero = 4'b0110;
    #2 numero = 4'b1001;
    #2 numero = 4'b0001;
    insere = 1'b0;
    fim_jogo = 1'b1;
    #2 fim_jogo = 1'b0;

    // Verificação
    #10 $display("Teste 2 - Ganhou o prêmio 1");
    #10 $display("Prêmio: %b", premio);
    #10 $display("P1: %b", p1);
    #10 $display("P2: %b", p2);
    #10 $finish;
  end

  // Teste 3 - Ganhou o prêmio 2
  initial begin
    $dumpfile("tp2_tb.vcd");
    $dumpvars(0, Loteria_tb);

    clock = 0;
    reset = 1'b1;
    numero = 4'b0000;
    fim = 1'b0;
    fim_jogo = 1'b0;
    insere = 1'b0;
    #2 reset = 1'b0;

    // Jogo 3
    insere = 1'b1;
    numero = 4'b0011;
    #2 numero = 4'b1000;
    #2 numero = 4'b0110;
    #2 numero = 4'b0010;
    #2 numero = 4'b0000;
    insere = 1'b0;
    fim_jogo = 1'b1;
    #2 fim_jogo = 1'b0;

    // Verificação
    #10 $display("Teste 3 - Ganhou o prêmio 2");
    #10 $display("Prêmio: %b", premio);
    #10 $display("P1: %b", p1);
    #10 $display("P2: %b", p2);
    #10 $finish;
  end

endmodule