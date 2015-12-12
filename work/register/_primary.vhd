library verilog;
use verilog.vl_types.all;
entity \register\ is
    port(
        \out\           : out    vl_logic;
        \in\            : in     vl_logic;
        En              : in     vl_logic;
        clk             : in     vl_logic;
        reset           : in     vl_logic
    );
end \register\;
