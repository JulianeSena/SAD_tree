library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package SAD4x4_pkg is
    subtype pixel_t is STD_LOGIC_VECTOR(7 downto 0);
    type pixel_block_t is array (0 to 15) of pixel_t;
end SAD4x4_pkg;

package body SAD4x4_pkg is
end SAD4x4_pkg;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.SAD4x4_pkg.ALL;

-- ================================================================
-- SAD4x4_tree com Carry Select Adder (CSLA)
--
-- Objetivo:
--   Calcular o SAD (Sum of Absolute Differences) entre dois blocos
--   4x4 em paralelo, utilizando Carry Select Adders para melhor
--   desempenho.
--
-- Interface dos blocos:
--   - Cada bloco é um array com 16 pixels.
--   - Cada pixel é um STD_LOGIC_VECTOR(7 downto 0).
--
-- Observação:
--   A árvore de soma está separada em estágios para facilitar a
--   substituição posterior por instâncias dos seus somadores.
-- ================================================================

entity SAD4x4_tree is
    Port (
        block_a : in  pixel_block_t;
        block_b : in  pixel_block_t;
        sad_out : out STD_LOGIC_VECTOR(11 downto 0)
    );
end SAD4x4_tree;

architecture Structural of SAD4x4_tree is

    type sum_array_9_t is array (0 to 7) of STD_LOGIC_VECTOR(8 downto 0);
    type sum_array_10_t is array (0 to 3) of STD_LOGIC_VECTOR(9 downto 0);
    type sum_array_11_t is array (0 to 1) of STD_LOGIC_VECTOR(10 downto 0);
    type acc1_s_array_t is array (0 to 7) of STD_LOGIC_VECTOR(7 downto 0);
    type acc2_s_array_t is array (0 to 3) of STD_LOGIC_VECTOR(8 downto 0);
    type acc3_s_array_t is array (0 to 1) of STD_LOGIC_VECTOR(9 downto 0);

    component CSLA8 is
        Port (
            Cin  : in  STD_LOGIC;
            A    : in  STD_LOGIC_VECTOR(7 downto 0);
            B    : in  STD_LOGIC_VECTOR(7 downto 0);
            S    : out STD_LOGIC_VECTOR(7 downto 0);
            Cout : out STD_LOGIC
        );
    end component;

    component CSLA9 is
        Port (
            Cin  : in  STD_LOGIC;
            A    : in  STD_LOGIC_VECTOR(8 downto 0);
            B    : in  STD_LOGIC_VECTOR(8 downto 0);
            S    : out STD_LOGIC_VECTOR(8 downto 0);
            Cout : out STD_LOGIC
        );
    end component;

    component CSLA10 is
        Port (
            Cin  : in  STD_LOGIC;
            A    : in  STD_LOGIC_VECTOR(9 downto 0);
            B    : in  STD_LOGIC_VECTOR(9 downto 0);
            S    : out STD_LOGIC_VECTOR(9 downto 0);
            Cout : out STD_LOGIC
        );
    end component;

    component CSLA11 is
        Port (
            Cin  : in  STD_LOGIC;
            A    : in  STD_LOGIC_VECTOR(10 downto 0);
            B    : in  STD_LOGIC_VECTOR(10 downto 0);
            S    : out STD_LOGIC_VECTOR(10 downto 0);
            Cout : out STD_LOGIC
        );
    end component;

    signal block_b_inv : pixel_block_t;
    signal sub_s       : pixel_block_t;
    signal sub_cout    : STD_LOGIC_VECTOR(0 to 15);
    signal sub_result  : pixel_block_t;

    signal acc1_s      : acc1_s_array_t;
    signal acc1_cout   : STD_LOGIC_VECTOR(0 to 7);
    signal acc1_result : sum_array_9_t;

    signal acc2_s      : acc2_s_array_t;
    signal acc2_cout   : STD_LOGIC_VECTOR(0 to 3);
    signal acc2_result : sum_array_10_t;

    signal acc3_s      : acc3_s_array_t;
    signal acc3_cout   : STD_LOGIC_VECTOR(0 to 1);
    signal acc3_result : sum_array_11_t;

    signal sad_s       : STD_LOGIC_VECTOR(10 downto 0);
    signal sad_cout    : STD_LOGIC;

begin

    -- Subtracao por complemento de 2: A - B = A + not(B) + 1.
    gen_b_inv: for i in 0 to 15 generate
    begin
        block_b_inv(i) <= not block_b(i);
    end generate;

    -- 16 subtratores em paralelo usando CSLA8.
    gen_sub_csla8: for i in 0 to 15 generate
    begin
        u_sub: CSLA8
            port map (
                Cin  => '1',
                A    => block_a(i),
                B    => block_b_inv(i),
                S    => sub_s(i),
                Cout => sub_cout(i)
            );

        -- Modulo da subtracao em 8 bits.
        -- Em A + not(B) + 1, Cout='1' indica ausencia de borrow (A>=B).
        -- Portanto, Cout nao eh bit de sinal neste caso.
        with sub_cout(i) select
            sub_result(i) <= sub_s(i)                                     when '1',
                             std_logic_vector(unsigned(not sub_s(i)) + 1) when others;
        
    end generate;

    -- 1o estagio de acumulacao: 8 somas de pares de sub_result.
    gen_acc1_csla8: for i in 0 to 7 generate
    begin
        u_acc1: CSLA8
            port map (
                Cin  => '0',
                A    => sub_result(2 * i),
                B    => sub_result((2 * i) + 1),
                S    => acc1_s(i),
                Cout => acc1_cout(i)
            );

        acc1_result(i) <= acc1_cout(i) & acc1_s(i);
    end generate;

    -- 2o estagio de acumulacao: 4 somas de pares de acc1_result.
    gen_acc2_csla9: for i in 0 to 3 generate
    begin
        u_acc2: CSLA9
            port map (
                Cin  => '0',
                A    => acc1_result(2 * i),
                B    => acc1_result((2 * i) + 1),
                S    => acc2_s(i),
                Cout => acc2_cout(i)
            );

        acc2_result(i) <= acc2_cout(i) & acc2_s(i);
    end generate;

    -- 3o estagio de acumulacao: 2 somas de pares de acc2_result.
    gen_acc3_csla10: for i in 0 to 1 generate
    begin
        u_acc3: CSLA10
            port map (
                Cin  => '0',
                A    => acc2_result(2 * i),
                B    => acc2_result((2 * i) + 1),
                S    => acc3_s(i),
                Cout => acc3_cout(i)
            );

        acc3_result(i) <= acc3_cout(i) & acc3_s(i);
    end generate;

    -- Estagio final: soma os 2 resultados de 11 bits e dirige sad_out (12 bits).
    u_final_csla11: CSLA11
        port map (
            Cin  => '0',
            A    => acc3_result(0),
            B    => acc3_result(1),
            S    => sad_s,
            Cout => sad_cout
        );

    sad_out <= sad_cout & sad_s;

end Structural;
