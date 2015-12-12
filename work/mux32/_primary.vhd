library verilog;
use verilog.vl_types.all;
entity mux32 is
    port(
        S               : in     vl_logic;
        A               : in     vl_logic_vector(31 downto 0);
        B               : in     vl_logic_vector(31 downto 0);
        Y               : out    vl_logic_vector(31 downto 0)
    );
end mux32;
