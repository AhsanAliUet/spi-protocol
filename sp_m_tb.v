`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UET Lahore
// Engineer: Umer Shahid, Shehzeen Malik, Ahsan Ali
// 
// Create Date: 27.01.2022 18:57:50
// Design Name: 
// Module Name: sp_m_tb
// Project Name: SPI Implementation
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sp_m_tb();
    reg [7:0] m_data_send;
    reg clk;
    reg ss;  
    wire mosi;
    wire sp_clk;
    reg miso;
    wire busy_m;
    wire [7:0] m_rece;
    //wire [7:0] received_data;
//    wire [3:0] i;
//     wire [7:0] miso_buf;
//     wire [7:0] mosi_buf;
//     wire [7:0] m_data;
    sp1_m uut(m_data_send,clk,miso,ss, mosi,sp_clk,busy_m, m_rece);//received_data,
    
    // define clock
	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end

	initial begin
		// Initialize Inputs
		m_data_send=0;
		miso=0;
        ss = 1;
		#45;
		ss = 0;
		m_data_send = 8'hab;
		miso=1;
		#45;
		miso=0;
		#45;
		miso=1;
		#45;
		miso=0;
		#45;
		miso=1;
		#45;
		miso=0;
		#45;
		m_data_send = 8'h61;
		miso=1;
		#45;
		miso =1;
		#45;
		ss=1;
		miso = 0;
		#45;
		miso =0;
		#45;
		miso=1;
		ss=0;
		#45;
		miso=1;
		#45;
		miso=0;
		#45;
		miso=0;
		m_data_send = 8'h45;
		miso=1;
		#45;
		miso=0;
		#45;
		miso=0;
		#45;
		miso=0;
		#45;
		miso=1;
		#45;
		miso=1;
		#45;
		miso=1;
		#45;
		miso=0;
		#45;
		miso=0;
		#80;
		$finish;
		end
endmodule
