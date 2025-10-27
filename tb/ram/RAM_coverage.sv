package RAM_coverage_pkg;
    import uvm_pkg::*;
    `include"uvm_macros.svh"

    import RAM_seq_item_pkg::*;
    import shared_pkg::*;
    class RAM_coverage extends uvm_component;
        `uvm_component_utils(RAM_coverage)
        
        uvm_analysis_export #(RAM_seq_item) cvg_axp;
        uvm_tlm_analysis_fifo #(RAM_seq_item) cvg_fifo;

        RAM_seq_item cvg_seq_item;
//RAM_1 // RAM_2, RAM_3 //RAM_4, RAM_5 //RAM_6, RAM_7, RAM_8, RAM_9
        covergroup RAM_CVG;
            rx_valid_cp: coverpoint cvg_seq_item.rx_valid{
                bins Bin_rxValid_High = {1'b1};
                bins Bin_rxValid_Low = {1'b0};
            }
            tx_valid_cp: coverpoint cvg_seq_item.tx_valid{
                bins Bin_txValid_High = {1'b1};
                bins Bin_txValid_Low = {1'b0};
            }
           operation_cp: coverpoint cvg_seq_item.din[9:8]{
                bins Bin_Write_Addr = {WRITE_ADDR};
                bins Bin_Write_Data = {WRITE_DATA};
                bins Bin_Read_Addr = {READ_ADDR};
                bins Bin_Read_Data = {READ_DATA};
                bins Bin_Write_AddrToData = (WRITE_ADDR=>WRITE_DATA);
                bins Bin_Read_AddrToData = (READ_ADDR=>READ_DATA);
                bins Bin_Trans = (0 => 1), (1 => 3), (1 => 0), (0 => 2),
                                 (2 => 3), (2 => 0), (3 => 1), (3 => 2);
           }

           OP_rxValid_cross: cross operation_cp, rx_valid_cp {
                option.cross_auto_bin_max = 0;
                bins Bin_Write_Addr_rxValidHigh  = binsof(operation_cp.Bin_Write_Addr) && binsof(rx_valid_cp.Bin_rxValid_High);
                bins Bin_Write_Data_rxValidHigh  = binsof(operation_cp.Bin_Write_Data) && binsof(rx_valid_cp.Bin_rxValid_High);
                bins Bin_Read_Addr_rxValidHigh   = binsof(operation_cp.Bin_Read_Addr) && binsof(rx_valid_cp.Bin_rxValid_High);
                bins Bin_Read_Data_rxValidHigh   = binsof(operation_cp.Bin_Read_Data) && binsof(rx_valid_cp.Bin_rxValid_High);
            }
           Read_OP_cross: cross operation_cp,  tx_valid_cp {
                option.cross_auto_bin_max = 0;
                bins Bin_out = binsof(operation_cp) intersect {READ_DATA} && binsof(tx_valid_cp) intersect {1};
           }
        endgroup
        function new (string name = "RAM_coverage", uvm_component parent = null);
            super.new(name, parent);
            RAM_CVG = new;
        endfunction

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);

            cvg_axp = new ("cvg_axp", this);
            cvg_fifo = new ("cvg_fifo", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cvg_axp.connect(cvg_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cvg_fifo.get(cvg_seq_item);
                RAM_CVG.sample();
            end
        endtask
    endclass
endpackage