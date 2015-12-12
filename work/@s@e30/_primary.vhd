library verilog;
use verilog.vl_types.all;
entity SE30 is
    port(
        \out\           : out    vl_logic_vector(29 downto 0);
        \in\            : in     vl_logic_vector(15 downto 0)
    );
end SE30;
