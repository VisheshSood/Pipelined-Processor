library verilog;
use verilog.vl_types.all;
entity zero is
    port(
        S               : in     vl_logic_vector(0 to 31);
        \out\           : out    vl_logic
    );
end zero;
