library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- ================================================================
-- CLA10 (Carry Lookahead Adder de 10 bits)
--
-- Objetivo:
--   Somar A + B + Cin, gerando S (soma) e Cout (carry de saída).
--
-- Ideia do Carry Lookahead:
--   Calcula os carries de forma antecipada usando lógica combinacional.
--   Reduz o caminho crítico em comparação com ripple carry.
-- ================================================================

entity CLA10 is
    Port (
          Cin   : in  STD_LOGIC;
          A     : in  STD_LOGIC_VECTOR(9 downto 0);
          B     : in  STD_LOGIC_VECTOR(9 downto 0);
          S     : out STD_LOGIC_VECTOR(9 downto 0);
          Cout  : out STD_LOGIC
    );
end CLA10;

architecture Behavioral of CLA10 is
     signal G, P: STD_LOGIC_VECTOR(9 downto 0);
     signal C: STD_LOGIC_VECTOR(9 downto 1);
	 
begin
    gen_GP: for i in 0 to 9 generate
          G(i) <= A(i) and B(i);
          P(i) <= A(i) xor B(i);
    end generate;
    
    C(1) <= G(0) or (P(0) and Cin);
    
    C(2) <= G(1) or (P(1) and G(0)) or (P(1) and P(0) and Cin);
         
    C(3) <= G(2) or (P(2) and G(1)) or (P(2) and P(1) and G(0)) or (P(2) and P(1) and P(0) and Cin);
    
    C(4) <= G(3) or (P(3) and G(2)) or (P(3) and P(2) and G(1)) or (P(3) and P(2) and P(1) and G(0)) or (P(3) and P(2) and P(1) and P(0) and Cin);
         
    C(5) <= G(4) or (P(4) and G(3)) or (P(4) and P(3) and G(2)) or (P(4) and P(3) and P(2) and G(1)) or (P(4) and P(3) and P(2) and P(1) and G(0)) or (P(4) and P(3) and P(2) and P(1) and P(0) and Cin);
         
    C(6) <= G(5) or (P(5) and G(4)) or (P(5) and P(4) and G(3)) or (P(5) and P(4) and P(3) and G(2)) or (P(5) and P(4) and P(3) and P(2) and G(1)) or (P(5) and P(4) and P(3) and P(2) and P(1) and G(0)) or (P(5) and P(4) and P(3) and P(2) and P(1) and P(0) and Cin);
    
    C(7) <= G(6) or (P(6) and G(5)) or (P(6) and P(5) and G(4)) or (P(6) and P(5) and P(4) and G(3)) or (P(6) and P(5) and P(4) and P(3) and G(2)) or (P(6) and P(5) and P(4) and P(3) and P(2) and G(1)) or (P(6) and P(5) and P(4) and P(3) and P(2) and P(1) and G(0)) or (P(6) and P(5) and P(4) and P(3) and P(2) and P(1) and P(0) and Cin);
    
    C(8) <= G(7) or (P(7) and G(6)) or (P(7) and P(6) and G(5)) or (P(7) and P(6) and P(5) and G(4)) or (P(7) and P(6) and P(5) and P(4) and G(3)) or (P(7) and P(6) and P(5) and P(4) and P(3) and G(2)) or (P(7) and P(6) and P(5) and P(4) and P(3) and P(2) and G(1)) or (P(7) and P(6) and P(5) and P(4) and P(3) and P(2) and P(1) and G(0)) or (P(7) and P(6) and P(5) and P(4) and P(3) and P(2) and P(1) and P(0) and Cin);
    
    C(9) <= G(8) or (P(8) and G(7)) or (P(8) and P(7) and G(6)) or (P(8) and P(7) and P(6) and G(5)) or (P(8) and P(7) and P(6) and P(5) and G(4)) or (P(8) and P(7) and P(6) and P(5) and P(4) and G(3)) or (P(8) and P(7) and P(6) and P(5) and P(4) and P(3) and G(2)) or (P(8) and P(7) and P(6) and P(5) and P(4) and P(3) and P(2) and G(1)) or (P(8) and P(7) and P(6) and P(5) and P(4) and P(3) and P(2) and P(1) and G(0)) or (P(8) and P(7) and P(6) and P(5) and P(4) and P(3) and P(2) and P(1) and P(0) and Cin);
         
    Cout <= G(9) or (P(9) and G(8)) or (P(9) and P(8) and G(7)) or (P(9) and P(8) and P(7) and G(6)) or (P(9) and P(8) and P(7) and P(6) and G(5)) or (P(9) and P(8) and P(7) and P(6) and P(5) and G(4)) or (P(9) and P(8) and P(7) and P(6) and P(5) and P(4) and G(3)) or (P(9) and P(8) and P(7) and P(6) and P(5) and P(4) and P(3) and G(2)) or (P(9) and P(8) and P(7) and P(6) and P(5) and P(4) and P(3) and P(2) and G(1)) or (P(9) and P(8) and P(7) and P(6) and P(5) and P(4) and P(3) and P(2) and P(1) and G(0)) or (P(9) and P(8) and P(7) and P(6) and P(5) and P(4) and P(3) and P(2) and P(1) and P(0) and Cin);
         
    S(0) <= P(0) xor Cin;
    gen_sum: for i in 1 to 9 generate
        S(i) <= P(i) xor C(i);
    end generate;

end Behavioral;
