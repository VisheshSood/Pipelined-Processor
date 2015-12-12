library verilog;
use verilog.vl_types.all;
entity mux2_alu is
    port(
        \out\           : out    vl_logic;
        A               : in     vl_logic;
        B               : in     vl_logic;
        sel             : in     vl_logic
    );
end mux2_alu;
