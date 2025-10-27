import SPI_slave_test_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

module SPI_slave_top ();
bit clk;
initial begin
    clk=0;
    forever begin
        #1 clk=~clk;
    end
end

SPI_slave_if slave_if(clk);

SLAVE DUT(
    .clk(clk), .rst_n(slave_if.rst_n), .SS_n(slave_if.SS_n),
    .tx_valid(slave_if.tx_valid),.tx_data(slave_if.tx_data), .MOSI(slave_if.MOSI), 
    .rx_data(slave_if.rx_data), .rx_valid(slave_if.rx_valid), .MISO(slave_if.MISO)
);

SLAVE_golden_model GOLDEN(
    .clk(clk), .rst_n(slave_if.rst_n), .SS_n(slave_if.SS_n),
    .tx_valid(slave_if.tx_valid),.tx_data(slave_if.tx_data), .MOSI(slave_if.MOSI), 
    .rx_data(slave_if.rx_data_ref), .rx_valid(slave_if.rx_valid_ref), .MISO(slave_if.MISO_ref)
);

initial begin
    uvm_config_db#(virtual SPI_slave_if)::set(null,"uvm_test_top","SLAVE_IF",slave_if);
    run_test("SPI_slave_test");
end

endmodule