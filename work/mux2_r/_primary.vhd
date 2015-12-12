library verilog;
use verilog.vl_types.all;
entity mux2_r is
    port(
        d0              : in     vl_logic;
        d1              : in     vl_logic;
        A               : in     vl_logic;
        Y               : out    vl_logic
    );
end mux2_r;
