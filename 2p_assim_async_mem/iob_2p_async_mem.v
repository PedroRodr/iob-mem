`timescale 1ns/1ps

`define max(a,b) {(a) > (b) ? (a) : (b)}
`define min(a,b) {(a) < (b) ? (a) : (b)}

/*WARNING: This memory assumes that the write port data width is bigger than the
read port data width and that they are multiples of eachother
*/
module iob_2p_async_mem
	#( 
		parameter DATA_W = 16,
		parameter ADDR_W = 6,
		parameter USE_RAM = 1
	) 
	(
		//Inputs
	 input 			   wclk, //write clock
         input 			   w_en, //write enable
         input [DATA_W-1:0] 	   data_in, //Input data to write port
         input [ADDR_W-1:0] 	   w_addr, //address for write port
	 input 			   rclk, //read clock
         input [ADDR_W-1:0] 	   r_addr, //address for read port
         input 			   r_en,
        //Outputs
         output reg [DATA_W-1:0] data_out //output port
    );	
	//memory declaration
	reg [DATA_W-1:0] ram [2**ADDR_W-1:0];
		
	//reading from the RAM
	generate
           if(USE_RAM)
              always@(posedge wclk)  begin
                 if(r_en)
                    data_out <= ram[r_addr];
              end
           else //use reg file
              always@* data_out = ram[r_addr];
        endgenerate
	
	//writing to the RAM
	always@(posedge rclk) begin
	   if(w_en)    //check if write enable is ON
	     ram[w_addr] <= data_in;
	end

endmodule   
