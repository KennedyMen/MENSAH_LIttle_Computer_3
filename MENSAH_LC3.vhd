library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_1164.all;

use Ieee.std_logic_unsigned.all;
use ieee.NUMERIC_STD.all;


entity LC3_FSM is
    port(
        CLK                 : IN STD_LOGIC;
        RSTn                : in std_logic;
        OUT_FROM_IR         : in std_logic_vector(15 downto 0) ;
        FROM_NZP            : in std_logic_vector(2 downto 0) ;
        LD_IR               : out std_logic;
        LD_MARMUX           : out std_logic;
        LD_REG1             : out std_logic;
        LD_PC               : out std_logic;
        LD_MAR              : out std_logic;
        LD_MDR              : out std_logic;
        LD_CC               : out std_logic;
        MEM_EN              : out std_logic;
        READ_WRITE_ENABLE   : out std_logic;   --- READ OR WRITE MEMOREY read=0 write=1
        GATE_PC1            : out std_logic;
        GATE_MARMUX            : out std_logic;
        GATE_ALU1           : out std_logic;
        GATE_MDR1           : out std_logic;


        ADDR2_MUX_SEL       : out std_logic_vector(1 downto 0);
        ADDR1_MUX_SEL       : out std_logic;
        SR1_SEL             :out std_logic_vector(2 downto 0);
        SR2_SEL             :out std_logic_vector(2 downto 0);
        DR_SEL              :out std_logic_vector(2 downto 0);
        SR2MUX_SEL          :out std_logic;
        PCMUX_SEL           : out std_logic_vector(1 downto 0);
        ALU_SEL             :out std_logic_vector(1 downto 0)

    );
end  LC3_FSM;

architecture BEH of LC3_FSM is

    --declarative part
    type LC3_STATE_TYPE is (S0,S1,S2,S2A,S2B,S2C,S2D,S2E,S2G,S2F,S3,S3A,S4,
        S5,S5A,S5B,S5C,S5D,S5E,S5F,S6,S7,S7A,S7B,S7C,S7D,S7E,S8);
    signal cpu_state: LC3_STATE_TYPE;
    signal next_state: LC3_STATE_TYPE;

    constant ADD    : std_logic_vector(3 downto  0) := "0001";   --add instruction
    constant ANDL   : std_logic_vector(3 downto  0) := "0101"; --add instruction
    constant BR     : std_logic_vector(3 downto  0) := "0000";   ---branch instruction
    constant JMP    : std_logic_vector(3 downto  0) := "1101";  --jump, if baser ='111' this is return
    constant JSR    : std_logic_vector(3 downto  0) := "0100";   --jump2subroutine,if IR(11)=0,this is jsrr
    constant LD     : std_logic_vector(3 downto  0) := "0010"; -- load instruction
    constant LDI    : std_logic_vector(3 downto  0) := "1010"; --load indirect
    constant LDR    : std_logic_vector(3 downto  0) := "0110"; --load relative
    constant LEA    : std_logic_vector(3 downto  0) := "1110";  --load effective address
    constant NOTL   : std_logic_vector(3 downto  0) := "1001"; --not instruction
    constant RTI    : std_logic_vector(3 downto  0) := "1000"; --return from inturrupt
    constant ST     : std_logic_vector(3 downto  0) := "0011";    -- store in memory
    constant STI    : std_logic_vector(3 downto  0) := "1011";   -- store indirect
    constant STR    : std_logic_vector(3 downto  0) := "0111";  -- store relative
    constant TRAP   : std_logic_vector(3 downto  0) := "1111";  --trap
begin
    --statement part
    FSM: process(OUT_FROM_IR,FROM_NZP,cpu_state,next_state)
        variable TRAPVECTOR     :   std_logic_vector(7 downto 0);
        variable OPCODE         :   std_logic_vector(3 downto 0);
        variable PC_OFFSET_10   :   std_logic_vector(10 downto 0);
        variable PC_OFFSET_8    :   std_logic_vector(8 downto 0);
        variable PC_OFFSET_5    :   std_logic_vector(5 downto 0);
        variable SR1IN          :   std_logic_vector(2 downto 0);
        variable SR2IN          :   std_logic_vector(2 downto 0);
        variable DRIN           :   std_logic_vector(2 downto 0);
        variable IR_5           :   std_logic;
        variable IMMEDIATE      :   std_logic_vector(4 downto 0);
        variable BASEREG        :   std_logic_vector(2 downto 0);
    begin
--initialize
        case cpu_state is
            when S0 =>
                -- TODO: Handle S0 state
                LD_IR <= '0';
                LD_MARMUX <= '0';
                LD_REG1 <=  '0';
                LD_MAR <= '0';
                LD_MDR <= '0';
                LD_CC <= '0';
                MEM_EN <= '0';
                GATE_PC1 <= '0';
                GATE_MARMUX <= '0';
                GATE_ALU1 <= '0';
                GATE_MDR1 <= '0';
                ADDR2_MUX_SEL <= (others => '0');
                ADDR1_MUX_SEL <= '0';
                SR1_SEL <= (others => '0');
                SR2_SEL <= (others => '0');
                DR_SEL <= (others => '0');
                SR2MUX_SEL <= '0';
                PCMUX_SEL <= (others => '0');
                ALU_SEL <= (others => '0');
                READ_WRITE_ENABLE <= '0';
                next_state <= S1;
--get instruction (fetch)
            when S1 =>
                -- TODO: Handle S1 state
                GATE_MARMUX        <= '0';
                GATE_ALU1       <= '0';
                GATE_MARMUX        <= '0';
                LD_CC           <= '0';
                LD_PC           <= '1';
                LD_MAR          <= '1';
                GATE_PC1        <= '1';
                PCMUX_SEL       <= "00";
                READ_WRITE_ENABLE    <= '0';
                LD_MDR          <= '0';
                next_state      <= S2;
            when S2 =>
                -- TODO: Handle S2 state
                next_state <= S2A;
            when S2A =>
                -- TODO: Handle S2A state
                next_state <= S2B;
            when S2B =>
                -- TODO: Handle S2B state
                MEM_EN <= '1';
                LD_MAR <= '0';
                next_state <= S2C;
            when S2C =>
                next_state <= S2D;



            when S2D =>
                LD_MDR <= '1';
                MEM_EN <= '0';
                GATE_MDR1    <= '1';
                next_state <= S2E;
            when S2E =>
                next_state <= S2F;
            when S2F =>
                LD_IR <= '1';

            when S2G =>
                -- TODO: Handle S2G state
                GATE_MDR1 <= '0';
                LD_IR <= '0';
                next_state <= S3;
            -- TODO: Handle S2E state
            when S3 =>
                -- decode instruction
                OPCODE := OUT_FROM_IR(15 downto  12);
                IR_5    := OUT_FROM_IR(5);
                DRIN    := OUT_FROM_IR(11 downto     9);
                SR1IN   := OUT_FROM_IR(8 downto  6);
                SR2IN   := OUT_FROM_IR(2 downto  0);
                IMMEDIATE := OUT_FROM_IR(4 downto    0);
                BASEREG   := OUT_FROM_IR(8 downto    6);
                PC_OFFSET_8 := OUT_FROM_IR(8 downto   0);
                PC_OFFSET_10 := OUT_FROM_IR(10 downto 0);
                PC_OFFSET_5 := OUT_FROM_IR(5 downto 0);
----- "00" 10_0  "01" 8_0  "10" 5_0 "11" 0 --------------------------
-----ADDR1_MUX_SEL("1" PC "0" SR1_OUT)-------------------------------
-----MARMUX("1" 7_1 IR "0" ADDER_OUT)--------------------------------
                case OPCODE is
                    when ADD =>
                        if (IR_5 <= '0')then
                            LD_IR       <= '0';
                            LD_REG1     <= '1';
                            LD_CC       <= '1';
                            GATE_MDR1   <= '0';
                            GATE_ALU1   <= '1';

                            SR1_SEL     <= SR1IN;
                            SR2_SEL     <= SR2IN;
                            DR_SEL      <= DRIN;
                            SR2MUX_SEL  <= '0';
                            ALU_SEL     <= "00";

                            next_state  <= S3A;
                        else
                            LD_IR       <= '0';
                            LD_REG1     <= '1';
                            LD_CC       <= '1';
                            GATE_MDR1   <= '0';
                            GATE_ALU1   <= '1';

                            SR1_SEL     <= SR1IN;
                            DR_SEL      <= DRIN;
                            SR2MUX_SEL  <= '1';
                            ALU_SEL     <= "00";

                            next_state  <= S3A;
                        end if;

                    when ANDL =>
                        if (IR_5 <= '0')then
                            LD_IR       <= '0';
                            LD_REG1     <= '1';
                            LD_CC       <= '1';
                            GATE_MDR1   <= '0';
                            GATE_ALU1   <= '1';

                            SR1_SEL     <= SR1IN;
                            SR2_SEL     <= SR2IN;
                            DR_SEL      <= DRIN;
                            SR2MUX_SEL  <= '0';
                            ALU_SEL     <= "01";

                            next_state  <= S3A;
                        else
                            LD_IR       <= '0';
                            LD_REG1     <= '1';
                            LD_CC       <= '1';
                            GATE_MDR1   <= '0';
                            GATE_ALU1   <= '1';

                            SR1_SEL     <= SR1IN;
                            DR_SEL      <= DRIN;
                            SR2MUX_SEL  <= '1';
                            ALU_SEL     <= "01";

                            next_state  <= S3A;
                        end if;
                    when LD =>
                        LD_IR <= '0';       -- go to next state S5, TO COMPLETE
                        LD_CC <= '0';
                        LD_PC <= '0';
                        GATE_MDR1 <= '0';
                        GATE_ALU1 <= '0';
                        GATE_PC1 <= '0';

                        ADDR1_MUX_SEL <= '1';
                        ADDR2_MUX_SEL <= "01";
                        LD_MARMUX <= '0';
                        GATE_MARMUX <= '1';

                        LD_MAR <= '1';
                        MEM_EN <= '0';
                        READ_WRITE_ENABLE <= '0';
                        LD_MDR <= '0';

                        next_state <= S5;
                    when LDI =>
                        LD_IR <= '0';       -- go to next state S5, TO COMPLETE
                        LD_CC <= '0';
                        LD_PC <= '0';
                        GATE_MDR1 <= '0';
                        GATE_ALU1 <= '0';
                        GATE_PC1 <= '0';

                        ADDR1_MUX_SEL <= '1';
                        ADDR2_MUX_SEL <= "01";
                        LD_MARMUX <= '1';
                        GATE_MARMUX <= '1';
                        GATE_MARMUX <= '1';

                        LD_MAR <= '1';
                        MEM_EN <= '0';
                        READ_WRITE_ENABLE <= '0';
                        LD_MDR <= '0';

                        next_state <= S5;

                        next_state <= S5;
                    when STI =>
                        LD_IR <= '0';       -- go to next state S5, TO COMPLETE
                        LD_CC <= '0';
                        LD_PC <= '0';
                        GATE_MDR1 <= '0';
                        GATE_ALU1 <= '0';
                        GATE_PC1 <= '0';

                        ADDR1_MUX_SEL <= '1';
                        ADDR2_MUX_SEL <= "01";
                        LD_MARMUX <= '0';
                        GATE_MARMUX <= '1';

                        LD_MAR <= '1';
                        MEM_EN <= '0';
                        READ_WRITE_ENABLE <= '0';
                        LD_MDR <= '0';

                        next_state <= S5;
                    when LEA =>
                        LD_IR <= '0';       -- go to next state S5, TO COMPLETE
                        LD_CC <= '0';
                        LD_PC <= '0';
                        LD_MARMUX <= '0';
                        LD_REG1 <= '1';
                        DR_SEL <= DRIN;

                        GATE_MARMUX <= '1';
                        ADDR2_MUX_SEL <= "01";
                        ADDR1_MUX_SEL <= '1';
                        GATE_MDR1 <= '0';
                        GATE_ALU1 <= '0';
                        GATE_PC1 <= '0';

                        ADDR1_MUX_SEL <= '0';
                        ADDR2_MUX_SEL <= "0";
                        next_state <= S1;
                    when NOTL=>
                        if OUT_FROM_IR(5 downto 0 ) = "111111" then
                            LD_IR <= '0';       -- go to next state S5, TO COMPLETE
                            LD_CC <= '0';
                            LD_PC <= '0';
                            GATE_MDR1 <= '0';
                            GATE_ALU1 <= '1';
                            GATE_PC1 <= '0';
                            SR1_SEL <= SR1IN;
                            ADDR1_MUX_SEL <= '0';
                            ADDR2_MUX_SEL <= "10";
                            LD_MARMUX <= '0';
                            GATE_MARMUX <= '0';
                            ALU_SEL <= "11";
                            LD_MAR <= '0';
                            MEM_EN <= '0';
                            READ_WRITE_ENABLE <= '0';
                            LD_MDR <= '0';
                            next_state <= S5;
                        else
                            next_state <= S1;

                        end if;
                    when LDR=>
                        LD_IR <= '0';       -- go to next state S5, TO COMPLETE
                        LD_CC <= '0';
                        LD_PC <= '0';
                        GATE_MDR1 <= '0';
                        GATE_ALU1 <= '0';
                        GATE_PC1 <= '0';
                        DR_SEL <= DRIN;
                        ADDR1_MUX_SEL <= '0';
                        ADDR2_MUX_SEL <= "10";
                        LD_MARMUX <= '0';
                        GATE_MARMUX <= '1';

                        LD_MAR <= '1';
                        MEM_EN <= '0';
                        READ_WRITE_ENABLE <= '0';
                        LD_MDR <= '0';

                        next_state <= S5;
                    when STR=>
                        LD_IR <= '0';       -- go to next state S5, TO COMPLETE
                        LD_CC <= '0';
                        LD_PC <= '0';
                        GATE_MDR1 <= '0';
                        GATE_ALU1 <= '0';
                        GATE_PC1 <= '0';

                        ADDR1_MUX_SEL <= '0';
                        ADDR2_MUX_SEL <= "10";
                        LD_MARMUX <= '0';
                        GATE_MARMUX <= '1';
                        SR1_SEL <= SR1IN;

                        LD_MAR <= '1';
                        MEM_EN <= '0';
                        READ_WRITE_ENABLE <= '0';
                        LD_MDR <= '0';
                        next_state <= S5;


                    when JSR=>
                        LD_IR <= '0';       -- go to next state S5, TO COMPLETE
                        LD_CC <= '0';
                        LD_PC <= '0';
                        GATE_MDR1 <= '0';
                        GATE_ALU1 <= '0';
                        GATE_PC1 <= '0';

                        ADDR1_MUX_SEL <= '0';
                        ADDR2_MUX_SEL <= "11";
                        PCMUX_SEL <= "01";
                        LD_MARMUX <= '0';
                        GATE_MARMUX <= '1';

                        LD_MAR <= '0';
                        MEM_EN <= '0';
                        READ_WRITE_ENABLE <= '0';
                        LD_MDR <= '0';
                        DR_SEL <= DRIN;
                        LD_REG1 <= '1';
                        next_state <= S1;
                    when others =>
                        next_state <= S0;





                end case;

            when S3A =>
                -- TODO: Handle S3A state
                LD_IR <= '0';
                LD_CC <= '0';
                LD_PC <= '0';
                GATE_ALU1 <= '1';

                LD_REG1 <= '1';
                DR_SEL <= DRIN;
                next_state <= S1;
            when S4 =>
            -- TODO: Handle S4 state

            when S5 =>
                -- TODO: Handle S5 state
                case OPCODE is
                    when STR =>
                        -- sequence of statements
                        LD_IR <= '0';
                        LD_CC <= '0';
                        LD_PC <= '0';
                        GATE_ALU1 <= '1';
                        ALU_SEL <= "10";
                        GATE_PC1 <= '0';
                        GATE_MARMUX <= '0';
                        LD_MAR <= '1';
                        READ_WRITE_ENABLE <= '1';
                        MEM_EN <= '1';
                        LD_MDR <= '0';
                        GATE_MARMUX <= '0';
                        GATE_MDR1 <= '0';
                        next_state <= S1;


                    when others=>
                        LD_IR <= '0';
                        LD_CC <= '0';
                        LD_PC <= '0';
                        GATE_ALU1 <= '0';
                        GATE_PC1 <= '0';
                        GATE_MARMUX <= '0';
                        LD_MAR <= '1';
                        READ_WRITE_ENABLE <= '0';
                        MEM_EN <= '1';
                        LD_MDR <= '0';
                        GATE_MARMUX <= '0';
                        next_state <= S5A;
                end case;

            when S5A =>
                -- TODO: Handle S5A state
                next_state <= S5B;
            when S5B =>
                -- TODO: Handle S5B state
                LD_MAR <= '1';
                MEM_EN <= '1';
                next_state <= S5C;
            when S5C =>
                -- TODO: Handle S5C state
                GATE_MDR1 <= '1';

                next_state <= S1;

            when S5D =>
                -- TODO: Handle S5D state
                case OPCODE is
                    when LDR =>
                        DR_SEL <= DRIN;
                        LD_REG1 <= '1';
                        next_state <= S1;

                    when LDI =>
                        LD_MAR <= '1';
                        next_state <= S5E;
                    when STI =>
                        LD_MAR <= '1';
                        next_state <= S5E;
                    when others =>
                        next_state <= S1;


                end case;

            when S5E =>
                -- TODO: Handle S5E state
                case OPCODE is
                    when LDI =>
                        LD_MAR <= '1';
                        MEM_EN <= '1';
                        LD_MDR <= '1';
                        next_state <= S5F;-- sequence of statements
                    when STI =>
                        LD_MAR <= '1';
                        SR1_SEL <= SR1IN;
                        ALU_SEL<= "10";
                        READ_WRITE_ENABLE <= '1';
                        LD_MDR <= '0';
                        next_state <= S1;
                    when others =>
                        next_state <= S1;

                end case;

            when S5F =>
                -- TODO: Handle S5F state
                case OPCODE is
                    when LDI =>
                        GATE_MDR1 <= '1';
                        LD_REG1 <= '1';
                        DR_SEL <= DRIN;    -- sequence of statements

                end case;

                next_state <= S1;
            when S6 =>
            -- TODO: Handle S6 state

            when S7 =>
            -- TODO: Handle S7 state

            when S7A =>
            -- TODO: Handle S7A state

            when S7B =>
            -- TODO: Handle S7B state

            when S7C =>
            -- TODO: Handle S7C state

            when S7D =>
            -- TODO: Handle S7D state

            when S7E =>
            -- TODO: Handle S7E state

            when S8 =>
            -- TODO: Handle S8 state


            -- TODO: Handle S2F state


            -- TODO: Handle S3 state
            -- TODO: Handle others state

            when others =>
                next_state <= S0;


        end case;
    end process;

end architecture BEH;








