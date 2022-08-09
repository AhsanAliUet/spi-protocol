`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UET Lahore
// Engineer: Umer Shahid, Shehzeen Malik, Ahsan Ali
// 
// Create Date: 30.01.2022 22:36:13
// Design Name: 
// Module Name: sp1_s
// Project Name: 
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


module sp1_s(
    input [7:0] data_send,
	input clk,
    input sp_clk,
    input mosi,
    input ss,
    output reg miso,
    output reg busy_s,
    output reg [7:0] s_rece
    );
    
    reg [7:0] s_data;
    reg [7:0] mosi_buf;
    reg [7:0] miso_buf;
    reg [3:0] i;
    
    initial begin
    s_rece = 0;
    miso=0;
    busy_s = 0;
    s_data = 0;
    mosi_buf = 0;
    miso_buf = 0;
    i = 0;
    end

    always @ (posedge clk)
    begin
		if (ss == 0)
		begin
			if (i <= 7)
				busy_s = 1;
			else 
				busy_s = 0;

			if (busy_s == 1)
				s_data = s_data;		
			else
				s_data = data_send;
		end
		else
			s_data = 0;
    end

		always @ (posedge sp_clk)
		begin
			miso_buf = s_data>>i;
			miso <= miso_buf[0];
			//i <= i+1;
		end
		always @ (negedge sp_clk)
		begin
			mosi_buf[7-i] <= mosi;
			if (i>=7)
			begin
			    s_rece <= mosi_buf;
				i<=0;
				mosi_buf <= 0;
			end
			else
			   i=i+1; 
		end
endmodule
