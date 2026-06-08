library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- ================================================================
-- CSLA8 (Carry Select Adder de 8 bits)
--
-- Objetivo:
--   Somar A + B + Cin, gerando S (soma) e Cout (carry de saída).
--
-- Ideia do Carry Select:
--   Para cada bit i, este circuito pré-calcula duas possibilidades:
--     1) Resultado assumindo carry de entrada = '0'
--     2) Resultado assumindo carry de entrada = '1'
--   Depois, quando o carry real chega, um multiplexador seleciona
--   qual resultado é o correto para aquele bit.
--
-- Neste arquivo, isso é feito bit a bit dentro de um for-generate.
-- ================================================================

entity CSLA8 is
    Port (
        Cin   : in  STD_LOGIC;                    -- Carry de entrada do somador (equivalente ao "vai-um" inicial)
        A     : in  STD_LOGIC_VECTOR(7 downto 0); -- Operando de 8 bits
        B     : in  STD_LOGIC_VECTOR(7 downto 0); -- Operando de 8 bits
        S     : out STD_LOGIC_VECTOR(7 downto 0); -- Resultado da soma
        Cout  : out STD_LOGIC                     -- Carry final (vai-um do bit mais significativo)
    );
end CSLA8;

architecture Behavioral of CSLA8 is
    -- S0(i): soma do bit i assumindo carry_in = 0
    -- S1(i): soma do bit i assumindo carry_in = 1
    signal S0, S1: STD_LOGIC_VECTOR(7 downto 0);

    -- Vetor de carries reais encadeados entre os bits.
    -- Atenção ao índice -1:
    --   C(-1) representa o carry "antes" do bit 0 (recebe Cin).
    --   C(0) é carry de saída do bit 0, ..., C(7) do bit 7.
    signal C: STD_LOGIC_VECTOR(7 downto -1);

    -- C0(i): carry de saída do bit i assumindo carry_in = 0
    -- C1(i): carry de saída do bit i assumindo carry_in = 1
    signal C0, C1: STD_LOGIC_VECTOR(7 downto 0);
    
begin
    -- Define o carry inicial da cadeia.
    C(-1) <= Cin;

    -- Gera 8 estágios idênticos (um para cada bit, de 0 a 7).
    gen_csa: for i in 0 to 7 generate
        
        S0(i) <= A(i) xor B(i); -- Se carry_in=0, soma = A xor B
        S1(i) <= not(S0(i));    -- Se carry_in=1, soma = not(A xor B)
        
        C0(i) <= A(i) and B(i); -- Carry assumindo carry_in=0: somente quando A e B são 1
        C1(i) <= A(i) or  B(i); -- Carry assumindo carry_in=1: ocorre se A ou B for 1
        
        -- Seleciona a soma correta do bit i usando o carry real do bit anterior.
        -- C(i-1) funciona como seletor do multiplexador.
        with C(i-1) select
            S(i) <= S0(i) when '0',
                    S1(i) when others;

        -- Seleciona também o carry de saída correto do bit i.
        with C(i-1) select
            C(i) <= C0(i) when '0',
                    C1(i) when others;
    end generate;
    
    -- Carry final do somador de 8 bits.
    Cout <= C(7);
end Behavioral;
