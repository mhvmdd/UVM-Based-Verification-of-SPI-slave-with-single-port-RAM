import uvm_pkg::*;
`include"uvm_macros.svh"
import RAM_test_pkg::*;
module RAM_top;
    logic clk = 0;
    initial begin
        $readmemb("mem.dat", DUT.MEM);
        $readmemb("mem.dat", GM.mem);
        forever #1 clk = ~clk;
    end
    RAM_IF ram_if (clk);

    RAM DUT (
        .clk(ram_if.clk),
        .rst_n(ram_if.rst_n),
        .rx_valid(ram_if.rx_valid),
        .din(ram_if.din),
        .tx_valid(ram_if.tx_valid),
        .dout(ram_if.dout)
    );

    RAM_ref GM (
        .clk(ram_if.clk),
        .rst_n(ram_if.rst_n),
        .rx_valid(ram_if.rx_valid),
        .rx_data(ram_if.din),
        .tx_valid(ram_if.tx_valid_ref),
        .tx_data(ram_if.dout_ref)
    );

    bind DUT RAM_sva SVA (
        .clk(ram_if.clk),
        .rst_n(ram_if.rst_n),
        .rx_valid(ram_if.rx_valid),
        .din(ram_if.din),
        .tx_valid(ram_if.tx_valid),
        .dout(ram_if.dout)
    );

    initial begin
        uvm_config_db #(virtual RAM_IF)::set(null, "uvm_test_top", "RAM_IF", ram_if);
        run_test("RAM_test");
    end

endmodule