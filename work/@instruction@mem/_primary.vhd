library verilog;
use verilog.vl_types.all;
entity InstructionMem is
    port(
        instruction     : out    vl_logic_vector(31 downto 0);
        address         : in     vl_logic_vector(31 downto 0)
    );
end InstructionMem;
