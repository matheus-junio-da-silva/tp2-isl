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
    reset = 1;
    numero = 0;
    fim = 0;
    fim_jogo = 0;
    insere = 0;
    #2 reset = 0;

    // Jogo 1
    insere = 1;
    numero = 1;
    #2 numero = 2;
    #2 numero = 3;
    #2 numero = 4;
    #2 numero = 5;
    insere = 0;
    fim_jogo = 1;
    #2 fim_jogo = 0;

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
    reset = 1;
    numero = 0;
    fim = 0;
    fim_jogo = 0;
    insere = 0;
    #2 reset = 0;

    // Jogo 2
    insere = 1;
    numero = 3;
    #2 numero = 8;
    #2 numero = 6;
    #2 numero = 9;
    #2 numero = 1;
    insere = 0;
    fim_jogo = 1;
    #2 fim_jogo = 0;

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
    reset = 1;
    numero = 0;
    fim = 0;
    fim_jogo = 0;
    insere = 0;
    #2 reset = 0;

    // Jogo 3
    insere = 1;
    numero = 3;
    #2 numero = 8;
    #2 numero = 6;
    #2 numero = 2;
    #2 numero = 1;
    insere = 0;
    fim_jogo = 1;
    #2 fim_jogo = 0;

    // Verificação
    #10 $display("Teste 3 - Ganhou o prêmio 2");
    #10 $display("Prêmio: %b", premio);
    #10 $display("P1: %b", p1);
    #10 $display("P2: %b", p2);
    #10 $finish;
  end

endmodule