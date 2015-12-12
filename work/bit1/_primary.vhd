library verilog;
use verilog.vl_types.all;
entity bit1 is
    port(
        A               : in     vl_logic;
        B               : in     vl_logic;
        Cin             : in     vl_logic;
        S0              : in     vl_logic;
        S1              : in     vl_logic;
        Cout            : out    vl_logic;
        S               : out    vl_logic
    );
end bit1;
