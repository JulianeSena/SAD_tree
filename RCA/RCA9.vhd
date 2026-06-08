library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- ================================================================
-- RCA9 (Ripple Carry Adder de 9 bits)
--
-- Objetivo:
--   Somar A + B + Cin, gerando S (soma) e Cout (carry de saida).
--
-- Ideia do Ripple Carry:
--   Cada bit calcula sua soma e seu carry de saida.
--   O carry de saida de um bit escorre para o proximo bit,
--   formando uma cadeia sequencial de carries (ripple).
-- ================================================================

entity RCA9 is
    Port (
        Cin  : in  STD_LOGIC;
        A    : in  STD_LOGIC_VECTOR(8 downto 0);
        B    : in  STD_LOGIC_VECTOR(8 downto 0);
        S    : out STD_LOGIC_VECTOR(8 downto 0);
        Cout : out STD_LOGIC
    );
end RCA9;

architecture Behavioral of RCA9 is
    -- C(0) eh carry de saida do bit 0, ..., C(8) do bit 8.
    signal C : STD_LOGIC_VECTOR(8 downto 0);

begin
    -- Bit 0 usa Cin diretamente.
    S(0) <= A(0) xor B(0) xor Cin;
    C(0) <= (A(0) and B(0)) or (Cin and (A(0) xor B(0)));

    gen_rca: for i in 1 to 8 generate
        S(i) <= A(i) xor B(i) xor C(i - 1);
        C(i) <= (A(i) and B(i)) or (C(i - 1) and (A(i) xor B(i)));
    end generate;

    Cout <= C(8);
end Behavioral;
