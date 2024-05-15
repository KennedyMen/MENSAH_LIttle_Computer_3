library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MENSAH_LC3_COMPLETE is
    generic(
        P   : integer := 16;
        MW  : integer := 9
    );
    port(
        OP_A : IN STD_LOGIC_VECTOR(15 downto 0);
        OP_Q : OUT STD_LOGIC_VECTOR(15 downto 0)
    );
end entity MENSAH_LC3_COMPLETE;

architecture rtl of MENSAH_LC3_COMPLETE is

    --declarative part
    signal    sLD_IR               :  std_logic;
    signal    sLD_MARMUX           :  std_logic;
    signal    sLD_REG1             :  std_logic;
    signal    sLD_PC               :  std_logic;
    signal    sLD_MAR              :  std_logic;
    signal    sLD_MDR              :  std_logic;
    signal    sLD_CC               :  std_logic;
    signal    sMEM_EN              :  std_logic;
    signal    sREAD_WRITE_ENABLE   :  std_logic;   --- READ OR WRITE MEMOREY read=0 write=1
    signal    sGATE_PC1            :  std_logic;
    signal    sGATE_MARMUX         :  std_logic;
    signal    sGATE_ALU1           :  std_logic;
    signal    sGATE_MDR1           :  std_logic;
    signal    sADDR2_MUX_SEL       : std_logic_vector(1 downto 0);
    signal    sADDR1_MUX_SEL       : std_logic;
    signal    sSR1_SEL             : std_logic_vector(2 downto 0);
    signal    sSR2_SEL             : std_logic_vector(2 downto 0);
    signal    sDR_SEL              : std_logic_vector(2 downto 0);
    signal    sSR2MUX_SEL          : std_logic;
    signal    sPCMUX_SEL           : std_logic_vector(1 downto 0);
    signal    sALU_SEL             : std_logic_vector(1 downto 0);
    component PATH is
        generic(
            P   : integer := 16;
            MW  : integer := 9
        );
        port(
            --------------------------------------------------------------------------------
            -- TO FSM
            --------------------------------------------------------------------------------
            IR_TO_FSM: out std_logic_vector(P-1 downto 0);
            NZP_TO_FSM: out std_logic_vector(2 downto 0);
            --------------------------------------------------------------------------------
            -- CLK
            --------------------------------------------------------------------------------
            CLK                     : in std_logic;
            RESET                   : in std_logic;
            --------------------------------------------------------------------------------
            -- ENABLE SIGNALS && LOADS
            --------------------------------------------------------------------------------
            MAR_EN                      : in std_logic;
            MDR_EN                      : in std_logic;
            MEM_EN                      : in std_logic;
            LD_PC                       : in std_logic;
            LD_MARMUX                   : in std_logic;
            LD_REG                      : in std_logic;
            LD_CC                       : in std_logic;
            READ_WRITE_ENABLE           : in std_logic;-- 0 = read, 1 = write
            LD_DR                       : in std_logic_vector(2 downto 0);
            LD_SR2                      : in std_logic_vector(2 downto 0);
            LD_SR1                      : in std_logic_vector(2 downto 0);
            LD_ALU                      : in std_logic_vector(1 downto 0);
            LD_SR2MUX                   : in std_logic;
            LD_PCMUX                    : in std_logic_vector(1 downto 0);
            LD_ADDR2MUX                 : in std_logic_vector(1 downto 0);
            LD_ADDR1MUX                 : in std_logic;
            LD_IR                       : in std_logic;
            --------------------------------------------------------------------------------
            -- GATES
            --------------------------------------------------------------------------------
            GATE_PC                 : in std_logic;
            GATE_ALU                : in std_logic;
            GATE_MARMUX             : in std_logic;
            GATE_MDR                : in std_logic;
            --------------------------------------------------------------------------------
            -- BUS
            --------------------------------------------------------------------------------
            BUS_IN                  : in std_logic_vector(P-1 downto  0);
            MDR_IN                  : in std_logic_vector(P-1 downto  0);
            GATE_MDR_OUT            : out std_logic_vector(P-1 downto 0);
            GATE_ALU_OUT            : out std_logic_vector(P-1 downto 0);
            GATE_PC_OUT             : out std_logic_vector(P-1 downto 0);
            GATE_MARMUX_OUT         : out std_logic_vector(P-1 downto 0)
        );
    end component PATH;
    component LC3_FSM is
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
            GATE_MARMUX         : out std_logic;
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
    end component LC3_FSM;
begin



    --statement part
    inst_PATH : entity work.PATH
        generic map (
            P  => 16,
            MW => 9
        )

        port map (
            --TO FSM
            IR_TO_FSM         => IR_TO_FSM,
            NZP_TO_FSM        => NZP_TO_FSM,
            --CLK
            CLK               => CLK,
            RESET             => RESET,
            --ENABLE SIGNALS && LOADS
            MAR_EN            => MAR_EN,
            MDR_EN            => MDR_EN,
            MEM_EN            => MEM_EN,
            LD_PC             => LD_PC,
            LD_MARMUX         => LD_MARMUX,
            LD_REG            => LD_REG,
            LD_CC             => LD_CC,
            READ_WRITE_ENABLE => READ_WRITE_ENABLE, --0 = read, 1 = write
            LD_DR             => LD_DR,
            LD_SR2            => LD_SR2,
            LD_SR1            => LD_SR1,
            LD_ALU            => LD_ALU,
            LD_SR2MUX         => LD_SR2MUX,
            LD_PCMUX          => LD_PCMUX,
            LD_ADDR2MUX       => LD_ADDR2MUX,
            LD_ADDR1MUX       => LD_ADDR1MUX,
            LD_IR             => LD_IR,
            --GATES
            GATE_PC           => GATE_PC,
            GATE_ALU          => GATE_ALU,
            GATE_MARMUX       => GATE_MARMUX,
            GATE_MDR          => GATE_MDR,
            --BUS
            BUS_IN            => BUS_IN,
            MDR_IN            => MDR_IN,
            GATE_MDR_OUT      => GATE_MDR_OUT,
            GATE_ALU_OUT      => GATE_ALU_OUT,
            GATE_PC_OUT       => GATE_PC_OUT,
            GATE_MARMUX_OUT   => GATE_MARMUX_OUT
        );
    inst_LC3_FSM : ENTITY work.LC3_FSM
        GENERIC MAP (
            P  => 16,
            MW => 9
        )

        PORT MAP (
            CLK               => CLK,
            RSTn              => RSTn,
            OUT_FROM_IR       => OUT_FROM_IR,
            FROM_NZP          => FROM_NZP,
            LD_IR             => sLD_IR,
            LD_MARMUX         => sLD_MARMUX,
            LD_REG1           => sLD_REG1,
            LD_PC             => sLD_PC,
            LD_MAR            => sLD_MAR,
            LD_MDR            => sLD_MDR,
            LD_CC             => sLD_CC,
            MEM_EN            => sMEM_EN,
            READ_WRITE_ENABLE => sREAD_WRITE_ENABLE, --READ OR WRITE MEMOREY read=0 write=1
            GATE_PC1          => sGATE_PC1,
            GATE_MARMUX       => sGATE_MARMUX,
            GATE_ALU1         => sGATE_ALU1,
            GATE_MDR1         => sGATE_MDR1,
            ADDR2_MUX_SEL     => sADDR2_MUX_SEL,
            ADDR1_MUX_SEL     => sADDR1_MUX_SEL,
            SR1_SEL           => sSR1_SEL,
            SR2_SEL           => sSR2_SEL,
            DR_SEL            => sDR_SEL,
            SR2MUX_SEL        => sSR2MUX_SEL,
            PCMUX_SEL         => sPCMUX_SEL,
            ALU_SEL           => sALU_SEL
        );
end architecture rtl;
