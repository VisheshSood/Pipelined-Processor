library verilog;
use verilog.vl_types.all;
entity forwardingcntrl is
    port(
        Da              : in     vl_logic_vector(31 downto 0);
        Db              : in     vl_logic_vector(31 downto 0);
        ALUoutTo3       : in     vl_logic_vector(31 downto 0);
        dataTo4         : in     vl_logic_vector(31 downto 0);
        Rs              : in     vl_logic_vector(4 downto 0);
        Rt              : in     vl_logic_vector(4 downto 0);
        RegDstFrom2     : in     vl_logic_vector(4 downto 0);
        RegDstFrom3     : in     vl_logic_vector(4 downto 0);
        readRs          : in     vl_logic;
        readRt          : in     vl_logic;
        fwdedDa         : out    vl_logic_vector(31 downto 0);
        fwdedDb         : out    vl_logic_vector(31 downto 0)
    );
end forwardingcntrl;
