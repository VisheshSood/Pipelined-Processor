library verilog;
use verilog.vl_types.all;
entity dec2_4 is
    port(
        \out\           : out    vl_logic_vector(3 downto 0);
        \in\            : in     vl_logic_vector(1 downto 0);
        En              : in     vl_logic
    );
end dec2_4;
