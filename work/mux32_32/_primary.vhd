library verilog;
use verilog.vl_types.all;
entity mux32_32 is
    port(
        \out\           : out    vl_logic_vector(31 downto 0);
        \in\            : in     vl_logic_vector(31 downto 0);
        sel             : in     vl_logic_vector(4 downto 0)
    );
end mux32_32;
