library verilog;
use verilog.vl_types.all;
entity control is
    port(
        RegDst          : out    vl_logic;
        ALUSrc          : out    vl_logic;
        MemToReg        : out    vl_logic;
        RegWr           : out    vl_logic;
        MemWr           : out    vl_logic;
        Jump            : out    vl_logic;
        JumpR           : out    vl_logic;
        ALUcntrl        : out    vl_logic_vector(1 downto 0);
        op              : in     vl_logic_vector(5 downto 0);
        func            : in     vl_logic_vector(5 downto 0);
        readRs          : out    vl_logic;
        readRt          : out    vl_logic
    );
end control;
