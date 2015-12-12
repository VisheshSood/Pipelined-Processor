library verilog;
use verilog.vl_types.all;
entity fetchUnit is
    port(
        addr            : out    vl_logic_vector(31 downto 2);
        tInstr          : in     vl_logic_vector(25 downto 0);
        jumprAddr       : in     vl_logic_vector(29 downto 0);
        neg             : in     vl_logic;
        branch          : in     vl_logic;
        jump            : in     vl_logic;
        jumpR           : in     vl_logic;
        imm16           : in     vl_logic_vector(15 downto 0);
        reset           : in     vl_logic;
        clk             : in     vl_logic
    );
end fetchUnit;
