library verilog;
use verilog.vl_types.all;
entity checkDaDb is
    port(
        Da              : in     vl_logic_vector(31 downto 0);
        Db              : in     vl_logic_vector(31 downto 0);
        DataEqual       : out    vl_logic
    );
end checkDaDb;
