import shared_pkg::*;
module RAM_sva(din,clk,rst_n,rx_valid,dout,tx_valid);
    input      [9:0] din;
    input            clk, rst_n, rx_valid;

    input  [7:0] dout;
    input       tx_valid;

    op_e op;

    always_comb begin
        case (din[9:8])
            2'b00 : op = WRITE_ADDR;
            2'b01 : op = WRITE_DATA;
            2'b10 : op = READ_ADDR;
            2'b11 : op = READ_DATA;
        endcase
    end

//RAM_1 // RAM_2, RAM_3 //RAM_4, RAM_5 //RAM_6, RAM_7, RAM_8, RAM_9

//Assertions
    a_reset_txValid: assert property (@(posedge clk) !rst_n |->##1  tx_valid == 1'b0);
    a_reset_dout: assert property (@(posedge clk) !rst_n |-> ##1 dout == 7'b0);

    a_wr_addr: assert property (@(posedge clk) disable iff (!rst_n) op == WRITE_ADDR && rx_valid |-> ##1 ~tx_valid );
    a_wr_data: assert property (@(posedge clk) disable iff (!rst_n) op == WRITE_DATA && rx_valid |-> ##1 ~tx_valid );
    a_rd_addr: assert property (@(posedge clk) disable iff (!rst_n) op == READ_ADDR && rx_valid |-> ##1 ~tx_valid );
    
    a_rd_data: assert property (@(posedge clk) disable iff (!rst_n) (op == READ_DATA && rx_valid && !is_readOnly) |->##1 $rose(tx_valid) ##[1:$] $fell(tx_valid));

    a_wr_addr_to_wr_data: assert property (@(posedge clk) disable iff (!rst_n) (op == WRITE_ADDR && rx_valid) |-> (##[1:$] op == WRITE_DATA && rx_valid));
    a_rd_addr_to_rd_data: assert property (@(posedge clk) disable iff (!rst_n) (op == READ_ADDR && rx_valid) |-> (##[1:$] op == READ_DATA && rx_valid));
   
//Coverage
    a_reset_txValid_cvr: cover property (@(posedge clk) !rst_n |->##1  tx_valid == 1'b0);
    a_reset_dout_cvr: cover property (@(posedge clk) !rst_n |-> ##1 dout == 7'b0);

    a_wr_addr_cvr: cover property (@(posedge clk) disable iff (!rst_n) op == WRITE_ADDR |-> ##1 ~tx_valid );
    a_wr_data_cvr: cover property (@(posedge clk) disable iff (!rst_n) op == WRITE_DATA |-> ##1 ~tx_valid );
    a_rd_addr_cvr: cover property (@(posedge clk) disable iff (!rst_n) op == READ_ADDR |-> ##1 ~tx_valid );
    
    a_rd_data_cvr: cover property (@(posedge clk) disable iff (!rst_n) (op == READ_DATA && rx_valid && !is_readOnly) |-> ##1 $rose(tx_valid) ##[1:$]  $fell(tx_valid));

    a_wr_addr_to_wr_data_cvr: cover property (@(posedge clk) disable iff (!rst_n) (op == WRITE_ADDR && rx_valid) |-> (##[1:$] op == WRITE_DATA && rx_valid));
    a_rd_addr_to_rd_data_cvr: cover property (@(posedge clk) disable iff (!rst_n) (op == READ_ADDR && rx_valid) |-> (##[1:$] op == READ_DATA && rx_valid));



endmodule