library verilog;
use verilog.vl_types.all;
entity dec5_32 is
    port(
        \out\           : out    vl_logic_vector(31 downto 0);
        \in\            : in     vl_logic_vector(4 downto 0);
        En              : in     vl_logic
    );
end dec5_32;
