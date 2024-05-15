------------------------------------------------------------
--File Name: MENSAH_TB_LC3
--Kennedy Mensah
--Advanced Digital Design
--Fall 2023
-----------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;

entity MENSAH_TB_LC3 is
end MENSAH_TB_LC3;


architecture TB1 of MENSAH_TB_LC3 is

    constant ADD_WIDTH: integer :=9;
    constant WIDTH: integer := 16;
    constant REG_ADD: integer :=3;
    constant E: natural:= 8;

    component MENSAH_LC3 is
        generic(
            ADD_WIDTH: integer := 9;
            WIDTH: integer := 16;
            REG_ADD: integer :=3;
            E: natural:= 8
        );
        port (
            CLK: in std_logic;
            RST: in std_logic
        );
    end component MENSAH_LC3;

    signal CLKtb : std_logic;
    signal RSTtb : std_logic;

begin

    CLK_GEN: process
    begin
        while now <= 6000 us loop
            CLKtb <='1'; wait for 5 ns; CLKtb <='0'; wait for 5 ns;
        end loop;
        wait;
    end process;

    Reset: process
    begin
        RSTtb  <='1','0' after 10 ns;
        wait;
    end process;


--------------------------------------do not change-----------------------------------------------
    datap: MENSAH_LC3 port map ( CLK=>CLKtb, RST=>RSTtb);

end TB1;

configuration CFG_MESNAH_TB_LC3 of MENSAH_TB_LC3 is
    for TB1
    end for;
end CFG_MESNAH_TB_LC3;
