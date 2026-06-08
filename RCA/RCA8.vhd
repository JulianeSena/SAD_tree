library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- ================================================================
-- RCA8 (Ripple Carry Adder de 8 bits)
--
-- Objetivo:
--   Somar A + B + Cin, gerando S (soma) e Cout (carry de saída).
--
-- Ideia do Ripple Carry:
--   Cada bit calcula sua soma e seu carry de saída.
--   O carry de saída de um bit "escorre" para o próximo bit,
--   formando uma cadeia sequencial de carries (ripple).
--
-- Neste arquivo, todos os bits usam a mesma lógica via for-generate.
-- ================================================================

entity RCA8 is
    Port (
        Cin  : in  STD_LOGIC;                    -- Carry de entrada (vai-um inicial)
        A    : in  STD_LOGIC_VECTOR(7 downto 0); -- Operando de 8 bits
        B    : in  STD_LOGIC_VECTOR(7 downto 0); -- Operando de 8 bits
        S    : out STD_LOGIC_VECTOR(7 downto 0); -- Resultado da soma
        Cout : out STD_LOGIC                     -- Carry final (vai-um do bit mais significativo)
    );
end RCA8;

architecture Behavioral of RCA8 is
    -- Vetor de carries reais encadeados entre os bits.
    -- C(0) é carry de saída do bit 0, ..., C(7) do bit 7.
    signal C : STD_LOGIC_VECTOR(7 downto 0);
    
begin
    -- Bit 0 usa Cin diretamente.
    S(0) <= A(0) xor B(0) xor Cin;
    C(0) <= (A(0) and B(0)) or (Cin and (A(0) xor B(0)));

    -- Gera os estágios restantes (bits 1 a 7).
    gen_rca: for i in 1 to 7 generate
        -- Soma completa do bit i
        S(i) <= A(i) xor B(i) xor C(i - 1);

        -- Carry de saída do bit i
        C(i) <= (A(i) and B(i)) or (C(i - 1) and (A(i) xor B(i)));
    end generate;

    -- Carry final do somador de 8 bits.
    Cout <= C(7);
end Behavioral;
