library verilog;
use verilog.vl_types.all;
entity proCoun is
    port(
        \out\           : out    vl_logic_vector(29 downto 0);
        \in\            : in     vl_logic_vector(29 downto 0);
        reset           : in     vl_logic;
        clk             : in     vl_logic
    );
end proCoun;
