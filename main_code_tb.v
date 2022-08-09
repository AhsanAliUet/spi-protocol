`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UET Lahore
// Engineer: Umer Shahid, Shehzeen Malik, Ahsan Ali
// 
// Create Date: 02.02.2022 14:17:00
// Design Name: 
// Module Name: main_code_tb
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

//Anode_Activate, LED_out, indicator, clk_fpga, m_data, s_data, slave_sel, m_data_send, s_data_send, mosi_indi, miso_indi);

module main_code_tb();


    reg clk_fpga;
	reg ss;
	//reg [7:0] data;
    //reg [7:0] data_send;
    reg [7:0] m_data, s_data;

    wire [6:0] LED_out;
	wire [7:0] Anode_Activate;
	wire [3:0] indicator;
	
	//input = reg
	//out = wire
	
    wire miso;
    wire mosi;
    wire sp_clk;
    wire busy_m;
    wire busy_s;
    
    
    wire mosi_indi, miso_indi;
    //wire [7:0] m_data_send, s_data_send;
    wire [7:0] m_rece, s_rece;
    
    //.clk(clock)
    
    main_code uut(Anode_Activate, LED_out, indicator, clk_fpga, m_data, s_data, ss   , mosi_indi, miso_indi);
    //main_code uut(Anode_Activate, LED_out, indicator, clk_fpga, data, ss);
    sp1_m uo(m_data,clk_fpga,miso,ss,mosi,sp_clk,busy_m, m_rece);
    sp1_s u1(s_data,clk_fpga,sp_clk,mosi,ss,miso,busy_s, s_rece);
    
    // define clock
	initial begin
		clk_fpga = 0;
		forever #10 clk_fpga = ~clk_fpga;
	end

	initial begin
		// Initialize Inputs
		//data = 8'b0;
		//data_send = 8'b0;
		
		m_data = 8'b00000000;
		s_data = 8'b00000000;
		//clk = 0;
		ss=1;

		// send something
		
//main_code(Anode_Activate, LED_out, indicator, clk_fpga, m_data, s_data, ss, m_data_send, s_data_send, mosi_indi, miso_indi);
		#40;
		m_data = 8'h45;
        s_data = 8'h35;
		ss=1;
		#40;
		ss=0;
		
		#685;
		ss=1;   //----
		m_data = 8'hf4;
		s_data = 8'h2d;
		#40;
		ss=0;
		
		#1100;//#685;
		m_data = 8'h20;
		s_data = 8'h11;
		#1000;   
		$stop;
        
end
endmodule
