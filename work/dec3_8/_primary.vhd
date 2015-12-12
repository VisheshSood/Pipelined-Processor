library verilog;
use verilog.vl_types.all;
entity dec3_8 is
    port(
        \out\           : out    vl_logic_vector(7 downto 0);
        \in\            : in     vl_logic_vector(2 downto 0);
        En              : in     vl_logic
    );
end dec3_8;
