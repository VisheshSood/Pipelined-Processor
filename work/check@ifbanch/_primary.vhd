library verilog;
use verilog.vl_types.all;
entity checkIfbanch is
    port(
        \in\            : in     vl_logic_vector(5 downto 0);
        branchFlag      : out    vl_logic
    );
end checkIfbanch;
