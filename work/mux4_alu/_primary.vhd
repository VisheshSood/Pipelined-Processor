library verilog;
use verilog.vl_types.all;
entity mux4_alu is
    port(
        \out\           : out    vl_logic;
        A               : in     vl_logic;
        B               : in     vl_logic;
        C               : in     vl_logic;
        D               : in     vl_logic;
        sel             : in     vl_logic_vector(0 to 1)
    );
end mux4_alu;
