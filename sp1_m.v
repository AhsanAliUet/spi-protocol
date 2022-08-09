`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UET Lahore
// Engineer: Umer Shahid, Shehzeen Malik, Ahsan Ali
// 
// Create Date: 02.02.2022 14:14:53
// Design Name: 
// Module Name: sp1_m
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


module sp1_m(input [7:0] data_send,
    input clk,
    input miso,
    input ss,
    output reg mosi,
    output reg sp_clk,
    output reg busy_m,
    output reg [7:0] m_rece
    );
    //reg temp_clk;
    reg [7:0] m_data;
    reg [7:0] mosi_buf;
    reg [7:0] miso_buf;
    reg [3:0] i_m;
    //wire sclk;
    reg [24:0] count = 0;
    initial begin
    mosi=0;
    //busy_m = 0;
    m_data = 0;
    mosi_buf = 0;
    miso_buf = 0;
    i_m = 0;


    sp_clk=0;
    end
    
    always @ (posedge clk)
    begin
        if (count == 24'hFFFFFF)
        begin
            sp_clk <= ~sp_clk;
            count <= 0;
        end
        else
            count <= count + 1;
           
    end
    
    
    
    always @ (posedge clk)
    begin
            if (ss == 0)
            begin
		if (i_m <= 7)   //if 8 bits are not transferred
            busy_m = 1;
		else
			busy_m = 0;
        if (busy_m == 1)
            m_data = m_data;
        else
            m_data = data_send;
            end
            else
                m_data = 0;
    end
    
    always @ (posedge sp_clk)
    begin
    mosi_buf = m_data<<i_m; 
    mosi <= mosi_buf[7];
    end
    always @ (negedge sp_clk)
    begin
    miso_buf[i_m] <= miso;

    if (i_m>=7)     //if 8 bits transferred successfully
    begin
    m_rece <= miso_buf;
    i_m<=0;
    miso_buf <= 0;
    //busy_m <= 0;
    end 
    else
        i_m = i_m+1;
    end
endmodule
