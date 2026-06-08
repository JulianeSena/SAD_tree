library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity csa_8bit is
    Port ( X         : in  STD_LOGIC_VECTOR (7 downto 0);
           Y         : in  STD_LOGIC_VECTOR (7 downto 0);
           Z         : in  STD_LOGIC_VECTOR (7 downto 0);
           Sum_Out   : out STD_LOGIC_VECTOR (7 downto 0);
           Carry_Out : out STD_LOGIC_VECTOR (7 downto 0));
end csa_8bit;

architecture Structural of csa_8bit is

    -- Vetor interno para armazenar os carries de cada bloco antes do deslocamento
    signal C_internal : STD_LOGIC_VECTOR(7 downto 0);

begin

    -- Laço que gera os 8 Full Adders em paralelo
    GEN_CSA: for i in 0 to 7 generate
        
        -- Aqui ocorre a importação direta do arquivo full_adder.vhd
        FA_inst : entity work.full_adder
            port map (
                A    => X(i),
                B    => Y(i),
                Cin  => Z(i),
                S    => Sum_Out(i),
                Cout => C_internal(i)
            );
            
    end generate GEN_CSA;

    -- Alinhamento correto dos Carries para a saída:
    -- O carry gerado no bit 0 vai para a posição 1 da saída, e assim por diante.
    Carry_Out(0) <= '0';
    Carry_Out(7 downto 1) <= C_internal(6 downto 0);

end Structural;