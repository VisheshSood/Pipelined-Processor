library verilog;
use verilog.vl_types.all;
entity ALU is
    port(
        A               : in     vl_logic_vector(31 downto 0);
        B               : in     vl_logic_vector(31 downto 0);
        sel             : in     vl_logic_vector(1 downto 0);
        Cout            : out    vl_logic;
        \out\           : out    vl_logic_vector(31 downto 0);
        overflow        : out    vl_logic;
        Z               : out    vl_logic;
        neg             : out    vl_logic
    );
end ALU;
