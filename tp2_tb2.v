module tb_loteria;

  reg clock;
  reg [3:0] numero;
  reg reset;
  reg fim;
  reg fim_jogo;
  reg insere;

  wire [1:0] premio;
  wire [4:0] p1;
  wire [4:0] p2;

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

  // Teste básico
  initial begin
    clock = 0;
    reset = 1;
    fim = 0;
    fim_jogo = 0;
    insere = 0;

    // Aguarde alguns ciclos para o reset
    #10 reset = 0;

    // Simule alguns ciclos
    #10 insere = 1; numero = 4'b0101; // Insere número
    #20 insere = 1; numero = 4'b0011; // Insere número
    #20 insere = 1; numero = 4'b1000; // Insere número
    #20 insere = 1; numero = 4'b0010; // Insere número
    #20 insere = 1; numero = 4'b0000; // Insere número

    #10 insere = 0; // Finaliza a inserção

    // Aguarde alguns ciclos para observar os resultados
    #100;

    // Exiba os resultados
    $display("Resultado final:");
    $display("Premio: %b", premio);
    $display("P1: %b", p1);
    $display("P2: %b", p2);

    $finish; // Encerre a simulação
  end

  // Gerador de clock
  always #5 clock = ~clock;

endmodule
