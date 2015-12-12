library verilog;
use verilog.vl_types.all;
entity dataMem is
    port(
        data            : out    vl_logic_vector(31 downto 0);
        address         : in     vl_logic_vector(31 downto 0);
        writedata       : in     vl_logic_vector(31 downto 0);
        writeenable     : in     vl_logic;
        clk             : in     vl_logic
    );
end dataMem;
