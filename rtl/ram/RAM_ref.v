module RAM_ref #(
    parameter ADDR_SIZE = 8,
    parameter MEM_DEPTH = 256
) (
    input clk, rst_n, rx_valid,
    input[9:0] rx_data,
    output reg tx_valid,
    output reg[7:0] tx_data
);

reg[ADDR_SIZE-1:0] mem [MEM_DEPTH-1:0];
reg[ADDR_SIZE-1:0] wr_address, rd_address;

always @(posedge clk) begin
    if(~rst_n) begin
        tx_valid <= 0;
        tx_data <= 0;
        rd_address <= 0;
        wr_address <= 0;
    end
    else begin
        if(rx_valid) begin
            if(rx_data[9:8] == 2'b00) begin
                wr_address <= rx_data[7:0];
                tx_valid <= 0;
            end
            else if(rx_data[9:8] == 2'b01) begin 
                mem[wr_address] <= rx_data[7:0];
                tx_valid <= 0;
            end
            else if(rx_data[9:8] == 2'b10) begin 
                rd_address <= rx_data[7:0];
                tx_valid <= 0;
            end
            else begin 
                tx_data <= mem[rd_address];
                tx_valid <= 1;
            end
        end
    end
end
    
endmodule