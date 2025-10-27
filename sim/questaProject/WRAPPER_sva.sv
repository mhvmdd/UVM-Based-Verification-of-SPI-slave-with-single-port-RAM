module WRAPPER_sva(MOSI,MISO,SS_n,clk,rst_n,rx_data_din,rx_valid,tx_valid,operation);
    input  MOSI, SS_n, clk, rst_n;
    input MISO;
    input [9:0] rx_data_din;
    input       rx_valid;
    input       tx_valid;
    input [0:2] operation;

    property rst_wrapper_p;
        @(posedge clk) (!rst_n) |=> (!MISO && (rx_data_din == 10'b00_0000_0000) && !rx_valid);
    endproperty

    property MISO_wrapper_p;
		@(posedge clk) disable iff(!rst_n) (operation != 3'b100) |=> (MISO == $past(MISO));
	endproperty	

    assert property (rst_wrapper_p);
    assert property (MISO_wrapper_p);

    cover property (rst_wrapper_p);
    cover property (MISO_wrapper_p);
endmodule