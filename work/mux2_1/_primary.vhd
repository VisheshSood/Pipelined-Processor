library verilog;
use verilog.vl_types.all;
entity mux2_1 is
    port(
        \out\           : out    vl_logic;
        \in\            : in     vl_logic_vector(1 downto 0);
        sel             : in     vl_logic
    );
end mux2_1;
