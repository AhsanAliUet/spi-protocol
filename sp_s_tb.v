`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UET Lahore
// Engineer: Umer Shahid, Shehzeen Malik, Ahsan Ali

// Create Date: 30.01.2022 22:47:24
// Create Date: 27.01.2022 18:57:50
// Design Name: SPI Slave Testbench
// Module Name: sp_s_tb
// Project Name: SPI Implementation
// Target Devices: Nexys A7100T
// Tool Versions: Vivado 2019.2
// Description: 
// 
// Dependencies: SPI Slave 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sp_s_tb();
    reg [7:0] data_send;
    reg clk;
    reg ss;  
    reg mosi;
    reg sp_clk;
    reg [1:0] count=0;
    wire miso;
    wire busy_s;
    wire [7:0] s_rece;
    sp1_s uut(data_send,clk,sp_clk,mosi,ss,miso,busy_s, s_rece);
    
    // define clock
	initial begin
		clk = 0;
		sp_clk = 1;
		ss=0;
	end

	always #10 clk = ~clk;

	
	always@(negedge ss) begin
	       sp_clk = 0;
	end
	
	
	always@(posedge clk) begin
	if (ss==0)
	begin
	   count = count + 1;
	   if (count == 1) begin
	       sp_clk = ~sp_clk;
	       count = 0;
	   end
	   end
	end

	initial begin
		// Initialize Inputs
		data_send=8'hab;
		mosi=1;
		ss=1;
		#40;
		ss = 0;
		//data_send = 8'hab;
		mosi=1;
		#40;
		mosi=0;
		#40;
		mosi=1;
		#40;
		mosi=0;
		#40;
		mosi=1;
		#40;
		mosi=0;
		#40;
		data_send = 8'h61;
		mosi=1;
		#40;
		mosi =1;
		#40;
		mosi=1;
		#40;
		mosi=0;
		#40;
		mosi=0;
		#330;
		ss=1;
		#40;
		ss=0;
		data_send = 8'hab;
		mosi=1;
		#40;
		mosi=0;
		#40;
		mosi=0;
		#40;
		mosi=0;
		#40;
		mosi=1;
		#40;
		mosi=1;
		#40;
		mosi=1;
		#40;
		mosi=0;
		#40;
		mosi=0;
		#80;
		$finish;
		end
endmodule
