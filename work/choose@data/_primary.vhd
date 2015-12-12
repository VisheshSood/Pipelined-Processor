library verilog;
use verilog.vl_types.all;
entity chooseData is
    port(
        R               : in     vl_logic_vector(4 downto 0);
        d1              : in     vl_logic_vector(4 downto 0);
        d2              : in     vl_logic_vector(4 downto 0);
        sel1            : out    vl_logic;
        sel2            : out    vl_logic
    );
end chooseData;
