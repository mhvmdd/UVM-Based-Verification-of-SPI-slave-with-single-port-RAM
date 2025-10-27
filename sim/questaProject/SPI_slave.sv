module SLAVE (MOSI,MISO,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);

localparam IDLE      = 3'b000;
localparam CHK_CMD   = 3'b001; // (001) Check Command operation
localparam WRITE     = 3'b010; // (010) Write operation
localparam READ_ADD  = 3'b011;
localparam READ_DATA = 3'b100;

input            MOSI, clk, rst_n, SS_n, tx_valid;
input      [7:0] tx_data;
output reg [9:0] rx_data;
output reg       rx_valid, MISO;

reg [3:0] counter;
reg       received_address;

reg [2:0] cs, ns;

always @(posedge clk) begin
    if (~rst_n) begin
        cs <= IDLE;
    end
    else begin
        cs <= ns;
    end
end

always @(*) begin
    case (cs)
        IDLE : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = CHK_CMD;
        end
        CHK_CMD : begin
            if (SS_n)
                ns = IDLE;
            else begin
                if (~MOSI)
                    ns = WRITE;
                else begin
                    if (!received_address)
                        ns = READ_ADD; 
                    else
                        ns = READ_DATA;
                end
            end
        end
        WRITE : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = WRITE;
        end
        READ_ADD : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = READ_ADD;
        end
        READ_DATA : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = READ_DATA;
        end
    endcase
end

always @(posedge clk) begin
    if (~rst_n) begin 
        rx_data <= 0;
        rx_valid <= 0;
        received_address <= 0;
        MISO <= 0;
        counter <= 0;
    end
    else begin
        case (cs)
            IDLE : begin
                rx_valid <= 0;
            end
            CHK_CMD : begin
                counter <= 10;      
            end
            WRITE : begin
                if (counter > 0) begin
                    rx_data[counter-1] <= MOSI;
                    counter <= counter - 1;
                end
                else begin
                    rx_valid <= 1;
                end
            end
            READ_ADD : begin
                if (counter > 0) begin
                    rx_data[counter-1] <= MOSI;
                    counter <= counter - 1;
                end
                else begin
                    rx_valid <= 1;
                    received_address <= 1;
                end
            end
            READ_DATA : begin
                if (tx_valid) begin
                    rx_valid <= 0;
                    if (counter > 0) begin
                        MISO <= tx_data[counter-1];
                        counter <= counter - 1;
                    end
                    else begin
                        received_address <= 0;
                    end
                end
                else begin
                    if (counter > 0) begin
                        rx_data[counter-1] <= MOSI;
                        counter <= counter - 1;
                        rx_valid <= 0;
                    end
                    else begin
                        rx_valid <= 1;
                        counter <= 9; 
                    end
                end
            end
        endcase
    end
end

`ifdef SIM

property rst_p;
    @(posedge clk) (!rst_n) |=> (!MISO && !rx_valid && (rx_data == 10'b00_0000_0000) && (cs == IDLE) && !received_address);
endproperty

property write_seq_p;
    @(posedge clk) disable iff (!rst_n) (SS_n == 1 ##2 MOSI == 0) |=> MOSI == 0;
endproperty

property read_seq_p;
    @(posedge clk) disable iff (!rst_n) (SS_n == 1 ##2 MOSI == 1) |=> MOSI == 1;
endproperty

sequence write1_seq_s;
    SS_n == 1 ##2 MOSI == 0 ##1 MOSI == 0 ##1 MOSI == 0;
endsequence

sequence read1_seq_s;
    SS_n == 1 ##2 MOSI == 1 ##1 MOSI == 1 ##1 MOSI == 0;
endsequence

sequence write2_seq_s;
    SS_n == 1 ##2 MOSI == 0 ##1 MOSI == 0 ##1 MOSI == 1;
endsequence

sequence read2_seq_s;
    SS_n == 1 ##2 MOSI == 1 ##1 MOSI == 1 ##1 MOSI == 1;
endsequence

sequence rx_ss_n_s;
    ##10 rx_valid ##[1:$] SS_n;
endsequence

property rx_valid_p;
    @(posedge clk) disable iff (!rst_n) 
    (write1_seq_s or read1_seq_s or write2_seq_s or read2_seq_s) |-> rx_ss_n_s;
endproperty

property cs_p1;
    @(posedge clk) disable iff (!rst_n) (SS_n) |=> (cs == IDLE);
endproperty

property cs_p2;
    @(posedge clk) disable iff (!rst_n) (cs == IDLE && !SS_n) |=> (cs == CHK_CMD);
endproperty

property cs_p3;
    @(posedge clk) disable iff (!rst_n) (cs == CHK_CMD && !SS_n && !MOSI) |=> (cs == WRITE);
endproperty

property cs_p4;
    @(posedge clk) disable iff (!rst_n) (cs == CHK_CMD && !SS_n && MOSI && received_address) |=> (cs == READ_DATA);
endproperty

property cs_p6;
    @(posedge clk) disable iff (!rst_n) (cs == CHK_CMD && !SS_n && MOSI && !received_address) |=> (cs == READ_ADD);
endproperty

property cs_p7;
    @(posedge clk) disable iff (!rst_n) (cs == WRITE && !SS_n) |=> (cs == WRITE);
endproperty

property cs_p8;
    @(posedge clk) disable iff (!rst_n) (cs == READ_ADD && !SS_n) |=> (cs == READ_ADD);
endproperty

property cs_p9;
    @(posedge clk) disable iff (!rst_n) (cs == READ_DATA && !SS_n) |=> (cs == READ_DATA);
endproperty

property counter_rst_p;
    @(posedge clk) disable iff (!rst_n) (cs == CHK_CMD) |=> (counter == 4'b1010);
endproperty

property counter_write_p;
    @(posedge clk) disable iff (!rst_n) 
    ((cs == WRITE || cs == READ_ADD || cs == READ_DATA) && counter > 0) |=> (counter == $past(counter) - 1'b1);
endproperty

property received_address_p1;
    @(posedge clk) disable iff (!rst_n) (cs == READ_ADD && counter == 0) |=> (received_address);
endproperty

property received_address_p2;
    @(posedge clk) disable iff (!rst_n) (cs == READ_DATA && tx_valid && counter == 0) |=> (!received_address);
endproperty

assert property (rst_p);
assert property (write_seq_p);
assert property (read_seq_p);
assert property (rx_valid_p);
assert property (cs_p1);
assert property (cs_p2);
assert property (cs_p3);
assert property (cs_p4);
assert property (cs_p6);
assert property (cs_p7);
assert property (cs_p8);
assert property (cs_p9);
assert property (counter_rst_p);
assert property (counter_write_p);
assert property (received_address_p1);
assert property (received_address_p2);

cover property (rst_p);
cover property (write_seq_p);
cover property (read_seq_p);
cover property (rx_valid_p);
cover property (cs_p1);
cover property (cs_p2);
cover property (cs_p3);
cover property (cs_p4);
cover property (cs_p6);
cover property (cs_p7);
cover property (cs_p8);
cover property (cs_p9);
cover property (counter_rst_p);
cover property (counter_write_p);
cover property (received_address_p1);
cover property (received_address_p2);

`endif

endmodule