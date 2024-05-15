library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity PATH is
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
end PATH;

ARCHITECTURE STRUCTURAL of PATH is


    -- component declaration
    --------------------------------------------------------------------------------
    -- GENERAL REGISER
    --------------------------------------------------------------------------------
    component MENSAH_GENERAL_REG is
        port(
            Clk:        in std_logic;
            rst:        in std_logic;
            en:         in std_logic;
            OP_A:       in std_logic_vector(15 downto 0);
            OP_Q:       out std_logic_vector(15 downto 0));
    end component MENSAH_GENERAL_REG;
    --------------------------------------------------------------------------------
    -- MUX's
    --------------------------------------------------------------------------------
    --------------------------------------------------------------------------------
    -- MUX 2-1
    --------------------------------------------------------------------------------
    component MENSAH_mux_2_1 is
        generic (P : integer := 16);
        port(
            OP_A: in        std_logic;
            a: in           std_logic_vector(P-1 downto 0);
            b: in           std_logic_vector(P-1 downto 0);
            OP_Q: out       std_logic_vector(P-1 downto 0));

    end component MENSAH_mux_2_1;
    --------------------------------------------------------------------------------
    -- MUX 3-1
    --------------------------------------------------------------------------------
    component MENSAH_MUX_3_1 is
        port(
            OP_A:   in          std_logic_vector(1 downto 0);
            a :     in          std_logic_vector(15 downto 0);
            b :     in          std_logic_vector(15 downto 0);
            c :     in          std_logic_vector(15 downto 0);
            OP_Q:   out         std_logic_vector(15 downto 0));

    end component MENSAH_MUX_3_1;

    --------------------------------------------------------------------------------
    -- MUX 4-1
    --------------------------------------------------------------------------------
    component MENSAH_mux_4_1 is
        port(
            OP_A:   in          std_logic_vector(1 downto 0);
            a :     in          std_logic_vector(15 downto 0);
            b :     in          std_logic_vector(15 downto 0);
            c :     in          std_logic_vector(15 downto 0);
            d :     in          std_logic_vector(15 downto 0);
            OP_Q:   out         std_logic_vector(15 downto 0));
    end component MENSAH_mux_4_1;

    --------------------------------------------------------------------------------
    -- ADDER
    --------------------------------------------------------------------------------
    component MENSAH_ADD is
        port(   OP_A:   in  STD_LOGIC_VECTOR(15 downto 0);
            OP_B:   in  STD_LOGIC_VECTOR(15 downto 0);
            OP_Q:   out STD_LOGIC_VECTOR(15 downto 0));
    end component MENSAH_ADD;
    --------------------------------------------------------------------------------
    -- NZP
    --------------------------------------------------------------------------------
    component MENSAH_NZP is
        port (  Clk:        in std_logic;
            rst:        in std_logic;
            en:         in std_logic;
            OP_A:       in std_logic_vector(15 downto 0):= (others => '0');
            OP_Q:       out std_logic_vector(2 downto 0):= (others => '0'));
    end component MENSAH_NZP;
    --------------------------------------------------------------------------------
    -- PC
    --------------------------------------------------------------------------------
    component PC is
        port(   RST:        in std_logic;
            en:         in std_logic;
            Clk:        in std_logic;
            OP_A:       in std_logic_vector(15 downto 0);
            OP_Q1:      OUT std_logic_vector(15 downto 0):= (OTHERS=>'0');
            OP_Q2:      OUT std_logic_vector(15 downto 0):= x"0001");
    end component PC;
    --------------------------------------------------------------------------------
    -- SIGN EXTENDERS
    --------------------------------------------------------------------------------
    --------------------------------------------------------------------------------
    -- 5 to 16
    --------------------------------------------------------------------------------
    component MENSAH_SIGN_5_1_EXTENDER is
        port(
            OP_A: in std_logic_vector(5 downto 0);
            OP_Q: out std_logic_vector(15 downto 0));
    end component MENSAH_SIGN_5_1_EXTENDER;
    --------------------------------------------------------------------------------
    -- 4 to 16
    --------------------------------------------------------------------------------
    component MENSAH_SIGN_4_1_EXTENDER is
        port(
            OP_A: in std_logic_vector(4 downto 0);
            OP_Q: out std_logic_vector(15 downto 0));
    end component MENSAH_SIGN_4_1_EXTENDER;
    --------------------------------------------------------------------------------
    -- 10 to 16
    --------------------------------------------------------------------------------
    component MENSAH_SIGN_10_1_EXTENDER is
        port(
            OP_A: in std_logic_vector(10 downto 0);
            OP_Q: out std_logic_vector(15 downto 0));
    end component MENSAH_SIGN_10_1_EXTENDER;
    --------------------------------------------------------------------------------
    -- 7 to 16
    --------------------------------------------------------------------------------
    component MENSAH_ZERO_EXTENDER is
        port(
            OP_A: in std_logic_vector(7 downto 0);
            OP_Q: out std_logic_vector(15 downto 0));
    end component MENSAH_ZERO_EXTENDER ;
    --------------------------------------------------------------------------------
    -- 8 to 16
    --------------------------------------------------------------------------------
    component MENSAH_SIGN_8_16_EXTENDER is
        port(
            OP_A: in std_logic_vector(8 downto 0);
            OP_Q: out std_logic_vector(15 downto 0));
    end component MENSAH_SIGN_8_16_EXTENDER;

    --------------------------------------------------------------------------------
    -- REGISTER_ARRAY
    --------------------------------------------------------------------------------
    component MENSAH_REGISTER_ARRAY

        port(
            clk:            std_logic;
            LD_REG:         in std_logic;   -- enable bit
            rst:            in std_logic;
            DEST_ADD:       in std_logic_vector(2 downto 0);  -- address selector
            SOURCE_ADD1:    in std_logic_vector(2 downto 0);
            SOURCE_ADD2:    in std_logic_vector(2 downto 0);
            OP_A:           IN std_logic_vector(15 downto 0);
            OP_Q1:          OUT std_logic_vector(15 downto 0);
            OP_Q2:          OUT std_logic_vector(15 downto 0));
    end component MENSAH_REGISTER_ARRAY;

    --------------------------------------------------------------------------------
    -- MAR_REG
    --------------------------------------------------------------------------------
    component MENSAH_MAR_REG
        generic (
            P : integer := 16;
            MW: integer := 9
        );
        port (  Clk:    std_logic;
            EN:     in std_logic;
            RSTn:   in std_logic;
            BUS_IN: in std_logic_vector(15 downto 0);
            MAR_OUT:out std_logic_vector(8 downto 0)
        );
    end component MENSAH_MAR_REG ;

    --------------------------------------------------------------------------------
    -- MDR_REG
    --------------------------------------------------------------------------------
    component MENSAH_MDR_REG
        generic (
            P : integer := 16);
        port(   Clk:     in std_logic;
            En:      in std_logic;
            RST:     in std_logic;
            BUS_IN:  in std_logic_vector(15 downto 0);
            MEM_IN:  in std_logic_vector(15 downto 0);
            MDR_OUT: out std_logic_vector(15 downto 0)
        );


    end component MENSAH_MDR_REG;

    --------------------------------------------------------------------------------
    -- RAM
    --------------------------------------------------------------------------------
    component MENSAH_RAM
        generic (P :integer:=16;
            MW : integer := 9);
        port ( CLK : in std_logic;
            MEM_EN : in std_logic;
            READ_WRITE_EN : in std_logic;
            mem_wr_rd_add : in std_logic_vector(MW-1 downto  0);
            OP_A : in std_logic_vector(P-1 downto    0);
            OP_Q : out std_logic_vector(P-1 downto   0)
        );
    end component MENSAH_RAM;

    --------------------------------------------------------------------------------
    -- GATE_MDR
    --------------------------------------------------------------------------------
    component MENSAH_GATE_MDR
        generic (P : integer := 16);
        port(  CLK:         in std_logic;
            EN:             in std_logic;
            MDR_IN:         in std_logic_vector(P-1 downto 0);
            GATE_MDR_OUT:   out std_logic_vector(P-1 downto  0)
        );
    end component MENSAH_GATE_MDR;
    --------------------------------------------------------------------------------
    -- SIGNALS FOR INSTANTIATIONS OF COMPONENTS BASICALLY THE OUTPUTS OF THE COMPONENTS
    -- AS LONG AS THEY ARENT GOING BACK TO THE BUS
    -- THESE ARE THE SIGNALS THAT ARE DETERMINING THE PATH OF THE DATA
    --------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- WORKING SIGNALS
--------------------------------------------------------------------------------
    SIGNAL ZEROS            : STD_LOGIC_VECTOR(15 DOWNTO 0):=(others => '0');
--------------------------------------------------------------------------------
-- BOTTOM OF THE BUS
--------------------------------------------------------------------------------
    signal S_MAR_OUT    : std_logic_vector(MW-1 downto  0);
    signal S_MDR_BUS    : std_logic_vector(P-1 downto   0);
    signal S_MEM_OUT    : std_logic_vector(P-1 downto   0);
--------------------------------------------------------------------------------
-- RIGHT SIDE OF BUS
--------------------------------------------------------------------------------

    signal SR2_OUT      : std_logic_vector(P-1 downto 0);
    signal SR1_OUT      : std_logic_vector(P-1 downto 0);
    signal SR2_MUX_OUT  : std_logic_vector(P-1 downto 0);
    signal ALU_OUT      : std_logic_vector(P-1 downto 0);
--------------------------------------------------------------------------------
-- TOP OF BUS
--------------------------------------------------------------------------------
    signal PC_OUT       : std_logic_vector(P-1 downto 0);
    signal PC_NEXT      : std_logic_vector(P-1 downto 0);
    SIGNAL PC_MUX_OUT       : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ADD_OUT          : STD_LOGIC_VECTOR(15 DOWNTO 0);

--------------------------------------------------------------------------------
-- CENTER OF BUS
--------------------------------------------------------------------------------


    -- IR_OUT non extended
    signal IR_4_0_OUT   : std_logic_vector(4 downto 0);
    signal IR_5_0_OUT   : std_logic_vector(5 downto 0);
    signal IR_7_0_OUT   : std_logic_vector(7 downto 0);
    signal IR_8_0_OUT   : std_logic_vector(8 downto 0);
    signal IR_10_0_OUT  : std_logic_vector(10 downto 0);
    -- IR_OUT extended
    signal IR_EXT_4_0_OUT   : std_logic_vector(15 downto 0);
    signal IR_EXT_5_0_OUT   : std_logic_vector(15 downto 0);
    signal IR_ZEXT_7_0_OUT   : std_logic_vector(15 downto 0);
    signal IR_EXT_8_0_OUT   : std_logic_vector(15 downto 0);
    signal IR_EXT_10_0_OUT  : std_logic_vector(15 downto 0);

    SIGNAL IR_OUT           : std_logic_vector(P-1 downto 0);
    SIGNAL ADDR_1_MUX_OUT   : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL NZP_OUT          : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL MARMUX_OUT       : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ADDR_2_MUX_OUT   : STD_LOGIC_VECTOR(15 DOWNTO 0);




begin
    --------------------------------------------------------------------------------
    -- SIGNAL CALLING
    --------------------------------------------------------------------------------
    IR_TO_FSM <= IR_OUT;
    IR_4_0_OUT <= IR_OUT(4 downto 0);
    IR_5_0_OUT <= IR_OUT(5 downto 0);
    IR_7_0_OUT <= IR_OUT(7 downto 0);
    IR_8_0_OUT <= IR_OUT(8 downto 0);
    IR_10_0_OUT <= IR_OUT(10 downto 0);

    NZP_TO_FSM <= NZP_OUT(2 downto 0);

    -- statement part
    --------------------------------------------------------------------------------
    --------------------------------------------------------------------------------
    --------------------------------------------------------------------------------
    --------------------------------------------------------------------------------
    --------------------------------------------------------------------------------
    --COMPONENT INSTATIOATIONS
    --------------------------------------------------------------------------------
    --------------------------------------------------------------------------------
    --------------------------------------------------------------------------------
    --------------------------------------------------------------------------------
    --------------------------------------------------------------------------------

    --------------------------------------------------------------------------------
    -- SIGN_EXTENDERS
    --------------------------------------------------------------------------------
    inst_MENSAH_IR_EXT_4_0 : ENTITY  work.MENSAH_SIGN_4_1_EXTENDER
        PORT MAP (

            OP_A => IR_4_0_OUT,
            OP_Q => IR_EXT_4_0_OUT
        );
    inst_MENSAH_IR_EXT_5_0 : ENTITY  work.MENSAH_SIGN_5_1_EXTENDER
        PORT MAP (

            OP_A => IR_5_0_OUT,
            OP_Q => IR_EXT_5_0_OUT
        );
    inst_MENSAH_IR_ZEXT_7_0 : ENTITY  work.MENSAH_ZERO_EXTENDER
        PORT MAP (

            OP_A => IR_7_0_OUT,
            OP_Q => IR_ZEXT_7_0_OUT
        );
    inst_MENSAH_IR_EXT_8_0 : ENTITY  work.MENSAH_SIGN_8_1_EXTENDER
        PORT MAP (

            OP_A => IR_8_0_OUT,
            OP_Q => IR_EXT_8_0_OUT
        );
    inst_MENSAH_IR_EXT_10_0 : ENTITY  work.MENSAH_SIGN_10_1_EXTENDER
        PORT MAP (

            OP_A => IR_10_0_OUT,
            OP_Q => IR_EXT_10_0_OUT
        );

    --------------------------------------------------------------------------------
    -- CENTER OF THE BUS
    -------------------------------------------------------------------------------------
    inst_MENSAH_IR : ENTITY work.MENSAH_GENERAL_REG
        GENERIC MAP (
            InOutwidth => 16
        )

        PORT MAP (
            rst  => RESET,
            en   => LD_IR,
            Clk  => Clk,
            OP_A => BUS_IN,
            OP_Q => IR_OUT
        );
    inst_MENSAH_NZP : ENTITY work.MENSAH_NZP

        PORT MAP (
            Clk  => Clk,
            rst  => RESET,
            en   => LD_CC,
            OP_A => BUS_IN,
            OP_Q => NZP_OUT
        );

    inst_MENSAH_PC_MUX : ENTITY work.MENSAH_mux_3_1
        PORT MAP (
            OP_A => LD_PCMUX,
            a    => BUS_IN,
            b    => ADD_OUT,
            c    => PC_NEXT,
            OP_Q => PC_MUX_OUT
        );
    inst_MENSAH_PC : ENTITY work.MENSAH_PC_CNT
        PORT MAP (
            RST   => RESET,
            en    => LD_PC,
            Clk   => Clk,
            OP_A  => PC_MUX_OUT,
            OP_Q1 => PC_OUT,
            OP_Q2 => PC_NEXT
        );

    inst_MENSAH_GATE_PC : ENTITY work.MENSAH_GATE
        PORT MAP (
            Clk      => Clk,
            En       => GATE_PC,
            DATA_IN  => PC_OUT,
            GATE_OUT => GATE_PC_OUT
        );
    inst_MENSAH_ADDR1_MUX : ENTITY work.MENSAH_mux_2_1
        PORT MAP (
            OP_A => LD_ADDR1MUX,
            a    => PC_NEXT,
            b    => SR1_OUT,
            OP_Q => ADDR_1_MUX_OUT
        );
    inst_MENSAH_ADD : ENTITY work.MENSAH_ADD
        PORT MAP (
            OP_A => ADDR_1_MUX_OUT,
            OP_B => ADDR_2_MUX_OUT,
            OP_Q => ADD_OUT
        );
    inst_MENSAH_MAR_MUX : ENTITY work.MENSAH_mux_2_1
        PORT MAP (
            OP_A => LD_MARMUX,
            a    => IR_ZEXT_7_0_OUT,
            b    => ADD_OUT,
            OP_Q => MARMUX_OUT
        );
    inst_MENSAH_GATE_MAR_MUX : ENTITY work.MENSAH_GATE
        PORT MAP (
            Clk      => Clk,
            En       => GATE_MARMUX,
            DATA_IN  => MARMUX_OUT,
            GATE_OUT => GATE_MARMUX_OUT
        );
    Inst_MENSAH_ADDR2_MUX : ENTITY work.MENSAH_mux_4_1
        PORT MAP (
            OP_A => LD_ADDR2MUX,
            a    => IR_EXT_10_0_OUT,
            b    => IR_EXT_8_0_OUT,
            c    => IR_EXT_5_0_OUT,
            d    => ZEROS,
            OP_Q => ADDR_2_MUX_OUT
        );

    --------------------------------------------------------------------------------
    -- RIGHT SIDE OF THE BUS
    --------------------------------------------------------------------------------

    Inst_MENSAH_ALU : ENTITY work.MENSAH_ALU
        PORT MAP (
            OP_A    => SR1_OUT,
            OP_A2   => SR2_MUX_OUT,
            SEL_ALU => LD_ALU,
            OP_Q    => ALU_OUT
        );
    Inst_MENSAH_SR2_MUX : ENTITY work.MENSAH_mux_2_1
        PORT MAP (
            OP_A => LD_SR2MUX,
            a    => IR_EXT_4_0_OUT,
            b    => SR2_OUT,
            OP_Q => SR2_MUX_OUT
        );
    inst_MENSAH_REGISTER_ARRAY : ENTITY work.MENSAH_REGISTER_ARRAY
        GENERIC MAP (
            InOutwidth  => 16,
            Placement   => 3,
            ArrayAmount => 8
        )

        PORT MAP (
            clk         => clk,
            LD_REG      => LD_REG, --enable bit
            rst         => RESET,
            DEST_ADD    => LD_DR, --address selector
            SOURCE_ADD1 => LD_SR1,
            SOURCE_ADD2 => LD_SR2,
            OP_A        => BUS_IN,
            OP_Q1       => SR1_OUT,-- this will get you to the alu and the adr 2 mux
            OP_Q2       => SR2_OUT-- this will get you to the SR2
        );
    INST_MENSAH_GATE_ALU : ENTITY work.MENSAH_GATE
        PORT MAP (
            Clk      => Clk,
            En       => GATE_ALU,
            DATA_IN  => ALU_OUT,
            GATE_OUT => GATE_ALU_OUT
        );

    --------------------------------------------------------------------------------
    -- BOTTOM HALF OF THE DATAPATH
    --------------------------------------------------------------------------------
    inst_MAR_REG : MENSAH_MAR_REG
        generic map (P => P,
            MW => MW)
        port map (CLK => CLK,
            RSTn =>RESET,
            EN => MAR_EN,
            BUS_IN => BUS_IN,
            MAR_OUT => S_MAR_OUT);
    inst_RAM : MENSAH_RAM
        generic map (P => P,
            MW => MW)
        port map (CLK => CLK,
            MEM_EN => MEM_EN,
            READ_WRITE_EN => READ_WRITE_ENABLE,
            mem_wr_rd_add => S_MAR_OUT,
            OP_A => S_MDR_BUS,
            OP_Q => S_MEM_OUT);
    inst_MDR_REG : MENSAH_MDR_REG
        generic map (P => P)
        port map (CLK => CLK,
            RST => RESET,
            EN => MDR_EN,
            BUS_IN => MDR_IN,
            MEM_IN => S_MEM_OUT,
            MDR_OUT => S_MDR_BUS);
    inst_MENSAH_GATE_MDR : ENTITY work.MENSAH_GATE
        PORT MAP (
            Clk      => Clk,
            En       => GATE_MDR,
            DATA_IN  => S_MDR_BUS,
            GATE_OUT => GATE_MDR_OUT
        );

----path components
end architecture STRUCTURAL;--------------------------------------------------------------------------------


























































