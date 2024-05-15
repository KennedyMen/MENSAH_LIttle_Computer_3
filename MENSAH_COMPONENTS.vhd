
--------------------------------------------------------------------------------
-- LCE_DATA_PATH compoenents
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Path: BUS-> MAR-> RAM-> MDR-> GATE_MDR-> BUS
--------------------------------------------------------------------------------

-- All entities are compoenents
-- MAR
-- RAM
-- MDR
-- TRISTATE(GATE_MDR)
--------------------------------------------------------------------------------
-- ENTITY toggles INPUTS/OUTPUTS
--------------------------------------------------------------------------------
-- GENERICS P(16),MW(9)
--------------------------------------------------------------------------------
-- PATH INPUTS
--------------------------------------------------------------------------------
--Clk: Global(MAR,RAM, MDR)
--RESET: (MAR, MDR)
---MAR_EN: 1bit
--MDR_EN: 1bit
--MEM_EN: 1bit(0->disabled,1 .-> MEM enabled)
--READ_WRITE_ENABLE: 1bit(0->read,1->write)
--GATE_MDR: 1bit(0->'Z',1 .-> MDR enabled)
--BUS_IN: 16bit
--MDR_IN: 16bit
--------------------------------------------------------------------------------
-- PATH OUTPUTS
--------------------------------------------------------------------------------
--GATE_MDR_OUT: 16bit(FROM_MDR)
--------------------------------------------------------------------------------
-- KENNEDY MENSAH_16_bit_REG
-- LC3
-- Advanced DIGITAL DESIGN
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- MAR_REG
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.all;
entity MENSAH_MAR_REG is
        port (  Clk:    std_logic;
                EN:     in std_logic;
                RSTn:   in std_logic;
                BUS_IN: in std_logic_vector(15 downto 0);
                MAR_OUT:out std_logic_vector(15 downto 0)
        );
end MENSAH_MAR_REG;
architecture MAR_arch OF MENSAH_MAR_REG is
        signal MAR_DATA_OUT : std_logic_vector(8 downto 0);
begin
        process(Clk)
        begin
                if rising_edge(clk) then
                        if RSTn='1'then
                                MAR_DATA_OUT<=(others=>'Z');
                        elsif EN='1' then
                                MAR_DATA_OUT<=BUS_IN(8 downto 0);
                        else
                                MAR_DATA_OUT<=(others=>'Z');
                        end if;
                end if;
        end process;
        MAR_OUT<=MAR_DATA_OUT;
end MAR_arch;

--------------------------------------------------------------------------------
-- RAM
--------------------------------------------------------------------------------



Library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity MENSAH_RAM is

        Generic (   MW   :    integer:= 9;
                P       :    integer:=16);
        Port(   Clk                 :IN std_logic;
                mem_wr_rd_add       :In std_logic_vector(MW -1 downto 0);
                OP_A                :IN std_logic_vector(P-1 downto 0);
                read_write_en       :IN std_logic;
                mem_en              :IN std_logic;
                OP_Q                :OUT std_logic_vector(P-1 downto 0));
END MENSAH_RAM;

Architecture RAM_512 of MENSAH_RAM is

        Type DATA_ARRAY is ARRAY(Integer Range<>) of std_logic_Vector(P-1 downto 0);
        signal Data : data_array(0 to (2**MW-1)):=(OTHERS =>(others => '0'));
        signal sOP_Q : std_logic_Vector(P-1 Downto 0);

begin

        Process(Clk)

        begin

                if rising_edge(Clk) then

                        if mem_en = '1'then
                                if read_write_en = '1' then
                                        data(to_integer(unsigned(mem_wr_rd_add)))<= OP_A;
                                        sOP_Q   <= (OTHERS =>'Z');
                                else
                                        sOP_Q   <= data(to_integer(unsigned(mem_wr_rd_add)));

                                end if;
                        else
                                sOP_Q<= (OTHERS => 'Z');
                        end if;
                else
                        sOP_Q       <= sOP_Q;
                        data        <= data;
                end if;

        end process;

        OP_Q <= sOP_Q;

END Ram_512;

--------------------------------------------------------------------------------
-- MDR
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity MENSAH_MDR_REG is
        port(   Clk:     in std_logic;
                En:      in std_logic;
                RST:    in std_logic;
                BUS_IN:  in std_logic_vector(15 downto 0);
                MEM_IN:  in std_logic_vector(15 downto 0);
                MDR_OUT: out std_logic_vector(15 downto 0)
        );
end MENSAH_MDR_REG;
ARCHITECTURE MDR_arch of MENSAH_MDR_REG is
        signal MDR_DATA: std_logic_vector(15 downto 0);
begin
        MDR_REG:process(Clk)
        begin
                if rising_edge(Clk) then
                        if RST = '1' then
                                MDR_DATA<=(OTHERS=>'Z');
                        elsif EN='1' then
                                MDR_DATA<= MEM_IN;
                        elsif EN='0' then
                                MDR_DATA <= BUS_IN;
                        else
                                MDR_DATA<=MDR_DATA;
                        end if;
                else
                        MDR_DATA<=MDR_DATA;
                end if;

        end process;
        MDR_OUT<= MDR_DATA;


end MDR_arch;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- GATE_MDR
--------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity MENSAH_GATE is
        port(   Clk:    in std_logic;
                En:     in std_logic;
                DATA_IN: in std_logic_vector(15 downto 0);
                GATE_OUT:out std_logic_vector(15 downto 0)
        );
end MENSAH_GATE;
architecture GATE_arch of MENSAH_GATE is
        signal GATE_DATA: std_logic_vector(15 downto 0);
begin
        GATE_MDR_REG:process(Clk)
        begin
                if rising_edge(Clk) then
                        if En='1' then
                                GATE_DATA <= DATA_IN;
                        else
                                GATE_DATA <= (others=>'Z');
                        end if;
                else
                        GATE_DATA <= GATE_DATA;
                end if;

        end process;
        GATE_OUT<= GATE_DATA;
end GATE_arch;

--------------------------------------------------------------------------------
-- LC3_REGISTER SET
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- REGISTER_ARRAY_ENTITY
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std.all;
entity MENSAH_REGISTER_ARRAY is
        generic(InOutwidth :    integer:=16;
                Placement:      integer:=3;
                ArrayAmount:    natural:=8
        );

        port(
                clk:            std_logic;
                LD_REG:         in std_logic;   -- enable bit
                rst:            in std_logic;
                DEST_ADD:       in std_logic_vector(PLacement-1 downto 0);  -- address selector
                SOURCE_ADD1:    in std_logic_vector(Placement-1 downto 0);
                SOURCE_ADD2:    in std_logic_vector(placement-1 downto 0);
                OP_A:           IN std_logic_vector(InOutwidth-1 downto 0);
                OP_Q1:          OUT std_logic_vector(InOutwidth-1 downto 0);
                OP_Q2:          OUT std_logic_vector(InOutwidth-1 downto 0));
End MENSAH_REGISTER_ARRAY;

architecture GENERAL_ARRAY of MENSAH_REGISTER_ARRAY is
------------Array Creation-------------------------------------------------------------------------------------
        type REGISTER_ARRAY is array (ArrayAmount-1 downto 0) of std_logic_vector(InOutwidth-1 downto 0);
        signal sEN : std_logic_vector(ArrayAmount-1 downto 0);
        signal sFF: REGISTER_ARRAY;
------------Component instatiation------------------------------------------------------------------------------
        component MENSAH_GENERAL_REG
                generic(InOutwidth:integer:=16);
                port (
                        Clk:    in std_logic;
                        en: in std_logic;
                        RST:    in std_logic;
                        OP_A:   in std_logic_vector(InOutwidth-1 downto 0);
                        OP_Q:   out std_logic_vector(InOutwidth-1 downto 0)
                );
        end component;
-----------------Process----------------------------------------------------------------------------------------
        signal S_D: std_logic_vector(Placement-1 downto 0):=(OTHERS =>'0');
        signal CH: std_logic:='0';

begin

-----------------ARRAY FOR ENABLED REGISTER PARTS----------------------------------------------------------------
        ENABLE_ARRAY:process (DEST_ADD,LD_REG)
        begin
                sEN<= (sEN'range =>'0');
                sEN(to_integer(unsigned(DEST_ADD)))<= LD_REG;
        end process;
-----------------GENERATE ARRAY OF OUR GENERAL REGISTER------------------------------------------------------------
        GENERATE_REGISTERS: for J in 0 to (ArrayAmount-1) generate
                InstREGISTER_H0 : MENSAH_GENERAL_REG
                        port map (
                                RST=> RST,
                                en=>sEN(J),
                                Clk=> Clk,
                                OP_A=> OP_A,
                                OP_Q=> sFF(J)
                        );
        end generate;

--------------GENERAL REGISTER CODE the code will run each clock cycle on the rising edge-------------------------------
--------------once it has run the values in the component will be updated then the value -------------------------------
--------------of the Registers generated by the GENERATE_REGISTERS process will become   -------------------------------
--------------the same values so sEN(j)<=EN and sFF(j)<=OP_Q the enable register will be -------------------------------
--------------1 bit and the sFF arrary will be 16 bits like the output.-------------------------------------------------

        OP_Q1 <= sFF(to_integer(unsigned(SOURCE_ADD1)));
        OP_Q2 <= sFF(to_integer(unsigned(SOURCE_ADD2)));
END GENERAL_ARRAY;

--------------------------------------------------------------------------------
-- GENERAL_REGISTER
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std.all;
use work.all;
Entity MENSAH_GENERAL_REG is
        generic(InOutwidth : integer
        );
        port(
                rst:            in std_logic;
                en:             in std_logic;
                Clk:            in std_logic;
                OP_A:           IN std_logic_vector(InOutwidth-1 downto 0);
                OP_Q:           OUT std_logic_vector(InOutwidth-1 downto 0));
End MENSAH_GENERAL_REG;

architecture MENSAH_GENERAL_arch of MENSAH_GENERAL_REG is

begin        process(clk)
        begin
                if rising_edge(clk) then
                        if rst='1' then
                                OP_Q <= (OTHERS=> '0');
                        elsif  en ='1' then
                                OP_Q <= OP_A;
                        end if;
                end if;
        end process;

END MENSAH_GENERAL_arch;


--------------------------------------------------------------------------------
-- ALU
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity MENSAH_ALU is
        port( OP_A: in STD_LOGIC_VECTOR(15 downto 0);
                OP_A2: in STD_LOGIC_VECTOR(15 downto 0);
                SEL_ALU: in STD_LOGIC_VECTOR(1 downto 0);
                OP_Q: out STD_LOGIC_VECTOR(15 downto 0));
end MENSAH_ALU;

architecture MENSAH_ALU_arch of MENSAH_ALU is

        SIGNAL SALU: STD_LOGIC_VECTOR(15 downto 0);

begin

        SALU <= (OP_A + OP_A2) when (SEl_ALU="00") else
        (OP_A and OP_A2) when (SEl_ALU="01") else
        (OP_A ) when (SEl_ALU="10") else
        not OP_A when (SEl_ALU="11");
        OP_Q <= SALU;
end MENSAH_ALU_arch;
--------------------------------------------------------------------------------
-- MUX's
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- 2 to 1 MUX
--------------------------------------------------------------------------------
Library ieee;
use ieee.std_logic_1164.all;
entity MENSAH_mux_2_1 is
        port(
                OP_A:   in          std_logic;
                a :     in          std_logic_vector(15 downto 0);
                b :     in          std_logic_vector(15 downto 0);
                OP_Q:   out         std_logic_vector(15 downto 0));
end MENSAH_Mux_2_1;
architecture Mux_2_1_arch of MENSAH_mux_2_1 is

begin
        OP_Q<= a when (OP_A='1') else

        b;
end Mux_2_1_arch;
--------------------------------------------------------------------------------
-- 3 to 1 MUX
--------------------------------------------------------------------------------
Library ieee;
use ieee.std_logic_1164.all;
entity MENSAH_mux_3_1 is
        port(
                OP_A:   in          std_logic_vector(1 downto 0);
                a :     in          std_logic_vector(15 downto 0);
                b :     in          std_logic_vector(15 downto 0);
                c :     in          std_logic_vector(15 downto 0);
                OP_Q:   out         std_logic_vector(15 downto 0));
end MENSAH_Mux_3_1;
architecture Mux_3_1_arch of MENSAH_Mux_3_1 is

begin
        OP_Q<= a when (OP_A="00") else
        b when (OP_A="01") else
        c
        ;
end Mux_3_1_arch;

--------------------------------------------------------------------------------
-- 4 to 1 MUX
--------------------------------------------------------------------------------
Library ieee;
use ieee.std_logic_1164.all;
entity MENSAH_mux_4_1 is
        port(
                OP_A:   in          std_logic_vector(1 downto 0);
                a :     in          std_logic_vector(15 downto 0);
                b :     in          std_logic_vector(15 downto 0);
                c :     in          std_logic_vector(15 downto 0);
                d :     in          std_logic_vector(15 downto 0);
                OP_Q:   out         std_logic_vector(15 downto 0));
end MENSAH_Mux_4_1;
architecture Mux_4_1_arch of MENSAH_Mux_4_1 is
begin
        OP_Q <= a when (OP_A="00") else
        b when (OP_A="01") else
        c when (OP_A="10") else
        d when (OP_A="11") ;
end Mux_4_1_arch;



--------------------------------------------------------------------------------
-- ADDER
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MENSAH_ADD is
        port(   OP_A:   in  STD_LOGIC_VECTOR(15 downto 0);
                OP_B:  in  STD_LOGIC_VECTOR(15 downto 0);
                OP_Q:   out STD_LOGIC_VECTOR(15 downto 0));
end MENSAH_ADD;

architecture MENSAH_ADD_arch of MENSAH_ADD is
        SIGNAL MOST: STD_LOGIC_VECTOR(15 downto 0):= (OTHERS => '1');


begin

        OP_Q <= (OTHERS => 'X') WHEN( (OP_A+OP_B)< MOST) ELSE

        OP_A + OP_B ;

end MENSAH_ADD_arch;

--------------------------------------------------------------------------------
-- NZP
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
entity MENSAH_NZP is
        port (  Clk:        in std_logic;
                rst:        in std_logic;
                en:         in std_logic;
                OP_A:       in std_logic_vector(15 downto 0):= (others => '0');
                OP_Q:       out std_logic_vector(3 downto 0):= (others => '0'));
end MENSAH_NZP;

architecture MENSAH_NZP_arch of MENSAH_NZP is
        signal S_D: std_logic_vector(3 downto 0):=(OTHERS=>'0');
begin
        Process(Clk)
        begin
                if rising_edge(Clk) then
                        if (rst='1') then
                                S_D <= "000";
                        elsif (en='1') then
                                if OP_A(15)='1'then
                                        S_D <= "100";

                                elsif OP_A(15)='0'then
                                        S_D <="001";

                                elsif OP_A(15 downto 0)= x"0000" then
                                        S_D <="010";
                                else
                                        S_D<="000";
                                end if;

                        end if;
                end if;
        end process;
        OP_Q <= S_D;
end MENSAH_NZP_arch;

--------------------------------------------------------------------------------
-- PC
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
entity MENSAH_PC_CNT is
        port(   RST:        in std_logic;
                en:      in std_logic;
                Clk:         in std_logic;
                OP_A:       in std_logic_vector(15 downto 0);
                OP_Q1:   OUT std_logic_vector(15 downto 0):= (OTHERS=>'0');
                OP_Q2:   OUT std_logic_vector(15 downto 0):= x"0001");
end MENSAH_PC_CNT;

architecture BEH  of MENSAH_PC_CNT is
        signal  PC_DATA : std_logic_vector(15 downto 0);
        signal  PC_DATA_PLUS: std_logic_vector(15 downto 0);

begin
        PROCESS(Clk)
        begin
                if (Clk'event and Clk='1') then
                        if (RST='1') then
                                PC_DATA         <= x"0000";
                                PC_DATA_PLUS    <= x"0001";
                        elsif (en='1') then
                                PC_DATA         <= OP_A;
                                PC_DATA_PLUS    <= OP_A+'1';
                        else
                                PC_DATA         <= PC_DATA;
                                PC_DATA         <= PC_DATA_PLUS;
                        end if;
                else
                        PC_DATA             <= PC_DATA;
                        PC_DATA             <= PC_DATA_PLUS;
                end if;
        END PROCESS;
        OP_Q1   <= PC_DATA;
        OP_Q2    <= PC_DATA_PLUS;

end BEH;

--------------------------------------------------------------------------------
-- SIGN EXTENDERS
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- 5 to 16
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity MENSAH_SIGN_5_1_EXTENDER is
        port(
                OP_A: in std_logic_vector(5 downto 0);
                OP_Q: out std_logic_vector(15 downto 0));
end MENSAH_SIGN_5_1_EXTENDER;

architecture SIGN_EXTENDER_5_16_arch of MENSAH_SIGN_5_1_EXTENDER is
        SIGNAL ONES: STD_LOGIC_VECTOR(9 DOWNTO 0) := (OTHERS => '1');
        SIGNAL ZEROS: STD_LOGIC_VECTOR(9 DOWNTO 0) := (OTHERS => '0');


begin
        OP_Q <= ONES(9 DOWNTO 0) & OP_A(5 downto 0) WHEN OP_A(5) = '1' ELSE
        ZEROS(9 DOWNTO 0) & OP_A(5 downto 0);

end SIGN_EXTENDER_5_16_arch;

--------------------------------------------------------------------------------
-- 4 to 16
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity MENSAH_SIGN_4_1_EXTENDER is
        port(
                OP_A: in std_logic_vector(4 downto 0);
                OP_Q: out std_logic_vector(15 downto 0));
end MENSAH_SIGN_4_1_EXTENDER;

architecture SIGN_EXTENDER_4_16_arch of MENSAH_SIGN_4_1_EXTENDER is
        SIGNAL ONES: STD_LOGIC_VECTOR(10 DOWNTO 0) := (OTHERS => '1');
        SIGNAL ZEROS: STD_LOGIC_VECTOR(10 DOWNTO 0) := (OTHERS => '0');


begin
        OP_Q <= ONES(10 DOWNTO 0) & OP_A(4 downto 0) WHEN OP_A(4) = '1' ELSE
        ZEROS(10 DOWNTO 0) & OP_A(4 downto 0);

end SIGN_EXTENDER_4_16_arch;

--------------------------------------------------------------------------------
-- 10 to 16
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity MENSAH_SIGN_10_1_EXTENDER is
        port(
                OP_A: in std_logic_vector(10 downto 0);
                OP_Q: out std_logic_vector(15 downto 0));
end MENSAH_SIGN_10_1_EXTENDER;

architecture SIGN_EXTENDER_10_16_arch of MENSAH_SIGN_10_1_EXTENDER is
        SIGNAL ONES: STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '1');
        SIGNAL ZEROS: STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');


begin
        OP_Q <= ONES(4 DOWNTO 0)& OP_A(10 downto 0) WHEN OP_A(10) = '1' ELSE
        ZEROS(4 DOWNTO 0)& OP_A(10 downto 0);

end SIGN_EXTENDER_10_16_arch;

--------------------------------------------------------------------------------
-- 7 to 16
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity MENSAH_ZERO_EXTENDER is
        port(
                OP_A: in std_logic_vector(7 downto 0);
                OP_Q: out std_logic_vector(15 downto 0));
end MENSAH_ZERO_EXTENDER;

architecture ZERO_EXTENDER_8_16_arch of MENSAH_ZERO_EXTENDER is
        SIGNAL ZEROS: STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');

begin
        OP_Q <= ZEROS(7 DOWNTO 0) & OP_A(7 downto 0);


end ZERO_EXTENDER_8_16_arch;


--------------------------------------------------------------------------------
-- 8 to 16
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity MENSAH_SIGN_8_1_EXTENDER is
        port(
                OP_A: in std_logic_vector(8 downto 0);
                OP_Q: out std_logic_vector(15 downto 0));
end MENSAH_SIGN_8_1_EXTENDER;

architecture SIGN_EXTENDER_8_1_arch of MENSAH_SIGN_8_1_EXTENDER is
        SIGNAL ONES: STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '1');
        SIGNAL ZEROS: STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');


begin
        OP_Q <= ONES(6 DOWNTO 0) & OP_A(8 downto 0) WHEN OP_A(8) = '1' ELSE
        ZEROS(6 DOWNTO 0) & OP_A(8 downto 0);

end SIGN_EXTENDER_8_1_arch;










































































































































































































































































