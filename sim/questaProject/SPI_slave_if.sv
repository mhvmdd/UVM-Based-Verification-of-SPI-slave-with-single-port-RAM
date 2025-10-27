interface SPI_slave_if(clk);
    input clk;
    logic MOSI, rst_n, SS_n, tx_valid;
    logic [7:0] tx_data;
    logic [9:0] rx_data, rx_data_ref;
    logic rx_valid, rx_valid_ref, MISO, MISO_ref;  
endinterface