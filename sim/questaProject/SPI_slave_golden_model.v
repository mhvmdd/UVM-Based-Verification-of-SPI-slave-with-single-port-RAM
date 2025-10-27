module SLAVE_golden_model (
    input clk, rst_n, SS_n, MOSI, tx_valid, 
    input[7:0] tx_data,
    output reg MISO, rx_valid,
    output reg[9:0] rx_data
);
parameter IDLE = 3'b000;
parameter CHK_CMD = 3'b001;
parameter WRITE = 3'b010;
parameter READ_ADD = 3'b011;
parameter READ_DATA = 3'b100;

// (* fsm_encoding = "gray" *) 
reg[2:0] cs, ns; 
reg rx_type;
reg[4:0] cnt;

always @(posedge clk) begin
    if(~rst_n) cs <= IDLE;
    else cs <= ns;
end

always @(*) begin
    case(cs) 
    IDLE: begin
        if(~SS_n) ns = CHK_CMD;
        else ns = IDLE;
    end
    CHK_CMD: begin
        if(SS_n) ns = IDLE;
        else begin
            if(~MOSI) ns = WRITE;
            else begin
                if(rx_type) ns = READ_DATA;
                else ns = READ_ADD;
            end
        end
    end
    WRITE: begin
        if(SS_n) ns = IDLE;
        else ns = WRITE;
    end
    READ_ADD: begin
        if(SS_n) ns = IDLE;
        else ns = READ_ADD;
    end
    READ_DATA: begin
        if(SS_n) ns = IDLE;
        else ns = READ_DATA;
    end
    default: ns = IDLE;
    endcase
end

always @(posedge clk) begin
    if(~rst_n) begin
        MISO <= 0;
        rx_type <= 0;
        rx_valid <= 0;
        rx_data <= 0;
        cnt <= 0;
    end
    else begin
        case(cs)
        IDLE: rx_valid <= 0;
        CHK_CMD: cnt <= 0;
        WRITE: begin
            cnt <= cnt + 1;
                if (cnt < 10) rx_data[9-cnt] <= MOSI;
            if (cnt == 10) rx_valid <= 1;
        end
        READ_ADD: begin
            cnt <= cnt + 1;
                if (cnt < 10) rx_data[9-cnt] <= MOSI;
            if (cnt == 10) begin
                rx_valid <= 1;
                rx_type <= 1;
            end
        end
        READ_DATA: begin
            if(!tx_valid) begin
                cnt <= cnt + 1;
                if (cnt < 10) rx_data[9-cnt] <= MOSI;
                else begin
                    rx_type <= 0;
                end
                if (cnt == 10) cnt <= 1;
                rx_valid <= (cnt == 10);
            end
            else begin
                rx_valid <= 0;
                cnt <= cnt + 1;
                if (cnt >= 2 && cnt <= 9) MISO <= tx_data[9 - cnt];
                else begin
                    rx_type <= 0;
                end
            end
        end
        endcase
    end
end

endmodule
