library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- ================================================================
-- CLA8 (Carry Lookahead Adder de 8 bits)
--
-- Objetivo:
--   Somar A + B + Cin, gerando S (soma) e Cout (carry de saída).
--
-- Ideia do Carry Lookahead:
--   Em vez de esperar o carry "caminhar" bit a bit (ripple carry),
--   o CLA calcula os carries com lógica combinacional direta.
--   Isso reduz o caminho crítico e acelera a soma.
--
-- Neste arquivo, primeiro calculamos G e P em paralelo,
-- depois expandimos as equações dos carries C(1) até C(7) e Cout.
-- ================================================================

entity CLA8 is
    Port (
          Cin   : in  STD_LOGIC;                    -- Carry de entrada (vai-um inicial)
          A     : in  STD_LOGIC_VECTOR(7 downto 0); -- Operando de 8 bits
          B     : in  STD_LOGIC_VECTOR(7 downto 0); -- Operando de 8 bits
          S     : out STD_LOGIC_VECTOR(7 downto 0); -- Resultado da soma
          Cout  : out STD_LOGIC                     -- Carry final (vai-um do bit mais significativo)
    );
end CLA8;

architecture Behavioral of CLA8 is
	-- G(i): sinal de geração de carry, P(i): sinal de propagação de carry
     signal G, P: STD_LOGIC_VECTOR(7 downto 0);

	-- C(i) é o carry que entra no bit i (para i=1..7).
	-- Exemplo: C(1) é o carry de entrada do bit 1 (vindo do bit 0).
     signal C: STD_LOGIC_VECTOR(7 downto 1);
	 
begin
     -- Calcula G e P de todos os bits em paralelo.
    gen_GP: for i in 0 to 7 generate
          G(i) <= A(i) and B(i); -- Generate (gera carry local)
          P(i) <= A(i) xor B(i); -- Propagate (propaga carry recebido)
    end generate;
    
     -- Equações lookahead dos carries com carry de entrada Cin.
    C(1) <= G(0)
         or (P(0) and Cin);
    
    C(2) <= G(1)
         or (P(1) and G(0))
         or (P(1) and P(0) and Cin);
         
    C(3) <= G(2)
         or (P(2) and G(1))
         or (P(2) and P(1) and G(0))
         or (P(2) and P(1) and P(0) and Cin);
    
    C(4) <= G(3)
         or (P(3) and G(2))
         or (P(3) and P(2) and G(1))
         or (P(3) and P(2) and P(1) and G(0))
         or (P(3) and P(2) and P(1) and P(0) and Cin);
         
    C(5) <= G(4)
         or (P(4) and G(3))
         or (P(4) and P(3) and G(2))
         or (P(4) and P(3) and P(2) and G(1))
         or (P(4) and P(3) and P(2) and P(1) and G(0))
         or (P(4) and P(3) and P(2) and P(1) and P(0) and Cin);
         
    C(6) <= G(5)
         or (P(5) and G(4))
         or (P(5) and P(4) and G(3))
         or (P(5) and P(4) and P(3) and G(2))
         or (P(5) and P(4) and P(3) and P(2) and G(1))
         or (P(5) and P(4) and P(3) and P(2) and P(1) and G(0))
         or (P(5) and P(4) and P(3) and P(2) and P(1) and P(0) and Cin);
    
    C(7) <= G(6)
         or (P(6) and G(5))
         or (P(6) and P(5) and G(4))
         or (P(6) and P(5) and P(4) and G(3))
         or (P(6) and P(5) and P(4) and P(3) and G(2))
         or (P(6) and P(5) and P(4) and P(3) and P(2) and G(1))
         or (P(6) and P(5) and P(4) and P(3) and P(2) and P(1) and G(0))
         or (P(6) and P(5) and P(4) and P(3) and P(2) and P(1) and P(0) and Cin);
         
    Cout <= G(7)
         or (P(7) and G(6))
         or (P(7) and P(6) and G(5))
         or (P(7) and P(6) and P(5) and G(4))
         or (P(7) and P(6) and P(5) and P(4) and G(3))
         or (P(7) and P(6) and P(5) and P(4) and P(3) and G(2))
         or (P(7) and P(6) and P(5) and P(4) and P(3) and P(2) and G(1))
         or (P(7) and P(6) and P(5) and P(4) and P(3) and P(2) and P(1) and G(0))
         or (P(7) and P(6) and P(5) and P(4) and P(3) and P(2) and P(1) and P(0) and Cin);
         
     -- Soma do bit menos significativo:
     -- S(0) = A(0) xor B(0) xor Cin.
     S(0) <= P(0) xor Cin;

     -- Soma dos demais bits em paralelo:
     -- S(i) = P(i) xor C(i), para i = 1..7.
    gen_S: for i in 1 to 7 generate
        S(i) <= P(i) xor C(i);
    end generate;     
end Behavioral;
