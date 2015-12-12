library verilog;
use verilog.vl_types.all;
entity register_module is
    port(
        \out\           : out    vl_logic_vector(31 downto 0);
        \in\            : in     vl_logic_vector(31 downto 0);
        En              : in     vl_logic_vector(31 downto 0);
        clk             : in     vl_logic
    );
end register_module;
