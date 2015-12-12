library verilog;
use verilog.vl_types.all;
entity adder32 is
    port(
        A               : in     vl_logic_vector(31 downto 0);
        B               : in     vl_logic_vector(31 downto 0);
        Cin             : in     vl_logic;
        Cout            : out    vl_logic;
        \out\           : out    vl_logic_vector(31 downto 0)
    );
end adder32;
