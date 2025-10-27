package shared_pkg;
    typedef enum bit [1:0] {WRITE_ADDR=2'b00, WRITE_DATA=2'b01, READ_ADDR=2'b10, READ_DATA=2'b11} op_e;   
    bit is_readOnly = 0; 
    bit start_read;
endpackage