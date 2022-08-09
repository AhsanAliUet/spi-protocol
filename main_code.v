`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UET Lahore
// Engineer: Umer Shahid, Shehzeen Malik, Ahsan Ali
// 
// Create Date: 01/29/2019 10:33:52 AM
// Design Name: SPI Main Code
// Module Name: main_code
// Project Name: SPI Implementation
// Target Devices: Nexys A7 100T
// Tool Versions: Vivado 2019.2
// Description: 
// 
// Dependencies: SPI Master and SPI Slave
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module main_code(Anode_Activate, LED_out, indicator, clk_fpga, m_data, s_data, slave_sel, mosi_indi, miso_indi);
    
	output reg [6:0] LED_out;
	output reg [7:0] Anode_Activate;
    output reg [3:0] indicator; //busy
    input [7:0] m_data, s_data;     //taking their input data
    input clk_fpga;               // Active High status signal to read data from slave
	input slave_sel;                // Slave Selection Signal
	
    // Inputs
	reg clk;               // FPGA clock
	reg ss;                // Slave Selection Signal
	//reg [7:0] data_led;
	
	//reg [7:0] data_send;         //Data send by master to slave using mosi ---
	// Bidirs
	wire miso;              // Master In Slave Out Pin for SPI Interface
	wire mosi;             // Master Out Slave In Pin
	
	output reg miso_indi, mosi_indi;
	
	reg [31:0] counter;
	reg [2:0] toggle;     //to select 7 segment display. / Anode activate ---  3 bit toggle tp drive 8, 7 segments
	
	//wire [7:0] m_data_send;    //declared to get output on 7 seg
	//wire [7:0] s_data_send;    //declared to get output on 7 seg
	
	//master slave variables
	wire sp_clk; // SPI Clock (slower than system clock
	wire busy_m;
	wire busy_s;
	
	wire [7:0] m_rece, s_rece;
	
	integer count = 0;
	
	initial
	begin
	   toggle=0;
	   counter=0;
	end

    sp1_m spm(m_data,clk,miso,ss,mosi,sp_clk,busy_m, m_rece);
    sp1_s sps(s_data,clk,sp_clk,mosi,ss,miso,busy_s, s_rece);



always@(*)
begin
    clk <= clk_fpga;
    ss <= slave_sel;
    
    //m_data_send <= m_data;      //data is to send to 7 segments
    //s_data_send <= s_data;
    
    miso_indi <= miso;
    mosi_indi <= mosi; 
    
    indicator[3] <= ~busy_m;           // GREEN LED16   
    indicator[2] <= ~busy_s;          // GREEN LED17
    indicator[1] <= busy_m;           // RED LED16   
    indicator[0] <= busy_s;          // RED LED17 	
    
    	
end



always @(posedge clk)
begin
    if(counter >= 100000) 
        begin//100000 for implementing on fpga
           counter <= 0;
           //toggle  <= ~ toggle;
           if (toggle > 7) 
                toggle = 0;
           else toggle = toggle + 1;

       end
	 else 
	       counter <= counter + 1;
	 
end 

    // anode activating signals for 8 segments, digit period of 1ms
    // decoder to generate anode signals 
    always @(*)    //block fotr segment 1 and 2
    begin
        case(toggle)
        3'b000: begin
            Anode_Activate <= 8'b01111111; 
            // activate SEGMENT1 and Deactivate all others
            end
        3'b001: begin
            Anode_Activate <= 8'b10111111; 
                // activate SEGMENT2 and Deactivate all others
           end
        3'b010: begin
            Anode_Activate <= 8'b11011111; 
                   // activate SEGMENT3 and Deactivate all others
              end
        3'b011: begin
            Anode_Activate <= 8'b11101111; 
                      // activate SEGMENT4 and Deactivate all others
                 end
        3'b100: begin
            Anode_Activate <= 8'b11110111; 
                         // activate SEGMENT5 and Deactivate all others
            end        
        3'b101: begin
            Anode_Activate <= 8'b11111011; 
                                 // activate SEGMENT6 and Deactivate all others
            end        
        3'b110: begin
           Anode_Activate <= 8'b11111101; 
                                         // activate SEGMENT7 and Deactivate all others
           end
        3'b111: begin
           Anode_Activate <= 8'b11111110; 
                               // activate SEGMENT8 and Deactivate all others
          end
        endcase
      
    end
   
    // Cathode patterns of the 7-segment 1 LED display 
    always @(*)
    begin
	if(toggle == 0) begin	
        case(m_data[7:4])
        4'b0000: LED_out <= 7'b0000001; // "0"     
        4'b0001: LED_out <= 7'b1001111; // "1" 
        4'b0010: LED_out = 7'b0010010; //  "2" 
        4'b0011: LED_out <= 7'b0000110; // "3" 
        4'b0100: LED_out <= 7'b1001100; // "4" 
        4'b0101: LED_out <= 7'b0100100; // "5" 
        4'b0110: LED_out <= 7'b0100000; // "6" 
        4'b0111: LED_out <= 7'b0001111; // "7" 
        4'b1000: LED_out <= 7'b0000000; // "8"     
        4'b1001: LED_out <= 7'b0000100; // "9"
		4'b1010: LED_out <= 7'b0001000; // "A"     
        4'b1011: LED_out <= 7'b1100000; // "b"     
        4'b1100: LED_out <= 7'b0110001; // "C"     
        4'b1101: LED_out <= 7'b1000010; // "d"     
        4'b1110: LED_out <= 7'b0110000; // "E"     
        4'b1111: LED_out <= 7'b0111000; // "F"     
        
        default: LED_out = 7'b1111110; // "-"
        endcase
    end
    

	// Cathode patterns of the 7-segment 2 LED display
    if(toggle == 1) begin	
        case(m_data[3:0])
        4'b0000: LED_out <= 7'b0000001; // "0"     
        4'b0001: LED_out <= 7'b1001111; // "1" 
        4'b0010: LED_out <= 7'b0010010; // "2" 
        4'b0011: LED_out <= 7'b0000110; // "3" 
        4'b0100: LED_out <= 7'b1001100; // "4" 
        4'b0101: LED_out <= 7'b0100100; // "5" 
        4'b0110: LED_out <= 7'b0100000; // "6" 
        4'b0111: LED_out <= 7'b0001111; // "7" 
        4'b1000: LED_out <= 7'b0000000; // "8"     
        4'b1001: LED_out <= 7'b0000100; // "9"
		4'b1010: LED_out <= 7'b0001000; // "A"     
        4'b1011: LED_out <= 7'b1100000; // "b"     
        4'b1100: LED_out <= 7'b0110001; // "C"     
        4'b1101: LED_out <= 7'b1000010; // "d"     
        4'b1110: LED_out <= 7'b0110000; // "E"     
        4'b1111: LED_out <= 7'b0111000; // "F"     
        
        default: LED_out <= 7'b1111110; // "-"
        endcase
 end
        
      if (toggle == 2) begin
        case(s_data[7:4])
      4'b0000: LED_out <= 7'b0000001; // "0"     
      4'b0001: LED_out <= 7'b1001111; // "1" 
      4'b0010: LED_out <= 7'b0010010; // "2" 
      4'b0011: LED_out <= 7'b0000110; // "3" 
      4'b0100: LED_out <= 7'b1001100; // "4" 
      4'b0101: LED_out <= 7'b0100100; // "5" 
      4'b0110: LED_out <= 7'b0100000; // "6" 
      4'b0111: LED_out <= 7'b0001111; // "7" 
      4'b1000: LED_out <= 7'b0000000; // "8"     
      4'b1001: LED_out <= 7'b0000100; // "9"
      4'b1010: LED_out <= 7'b0001000; // "A"     
      4'b1011: LED_out <= 7'b1100000; // "b"     
      4'b1100: LED_out <= 7'b0110001; // "C"     
      4'b1101: LED_out <= 7'b1000010; // "d"     
      4'b1110: LED_out <= 7'b0110000; // "E"     
      4'b1111: LED_out <= 7'b0111000; // "F"     
      
      default: LED_out = 7'b1111110; // "-"
      endcase
      end
      
      if (toggle == 3) begin
        case(s_data[3:0])
      4'b0000: LED_out <= 7'b0000001; // "0"     
      4'b0001: LED_out <= 7'b1001111; // "1" 
      4'b0010: LED_out <= 7'b0010010; // "2" 
      4'b0011: LED_out <= 7'b0000110; // "3" 
      4'b0100: LED_out <= 7'b1001100; // "4" 
      4'b0101: LED_out <= 7'b0100100; // "5" 
      4'b0110: LED_out <= 7'b0100000; // "6" 
      4'b0111: LED_out <= 7'b0001111; // "7" 
      4'b1000: LED_out <= 7'b0000000; // "8"     
      4'b1001: LED_out <= 7'b0000100; // "9"
      4'b1010: LED_out <= 7'b0001000; // "A"     
      4'b1011: LED_out <= 7'b1100000; // "b"     
      4'b1100: LED_out <= 7'b0110001; // "C"     
      4'b1101: LED_out <= 7'b1000010; // "d"     
      4'b1110: LED_out <= 7'b0110000; // "E"     
      4'b1111: LED_out <= 7'b0111000; // "F"     
      
      default: LED_out = 7'b1111110; // "-"
      endcase
      end

      if (toggle == 4) begin
        case(m_rece[7:4])
      4'b0000: LED_out <= 7'b0000001; // "0"     
      4'b0001: LED_out <= 7'b1001111; // "1" 
      4'b0010: LED_out <= 7'b0010010; // "2" 
      4'b0011: LED_out <= 7'b0000110; // "3" 
      4'b0100: LED_out <= 7'b1001100; // "4" 
      4'b0101: LED_out <= 7'b0100100; // "5" 
      4'b0110: LED_out <= 7'b0100000; // "6" 
      4'b0111: LED_out <= 7'b0001111; // "7" 
      4'b1000: LED_out <= 7'b0000000; // "8"     
      4'b1001: LED_out <= 7'b0000100; // "9"
      4'b1010: LED_out <= 7'b0001000; // "A"     
      4'b1011: LED_out <= 7'b1100000; // "b"     
      4'b1100: LED_out <= 7'b0110001; // "C"     
      4'b1101: LED_out <= 7'b1000010; // "d"     
      4'b1110: LED_out <= 7'b0110000; // "E"     
      4'b1111: LED_out <= 7'b0111000; // "F"     
      
      default: LED_out = 7'b1111110; // "-"
      endcase
      end
      if (toggle == 5) begin
        case(m_rece[3:0])
      4'b0000: LED_out <= 7'b0000001; // "0"     
      4'b0001: LED_out <= 7'b1001111; // "1" 
      4'b0010: LED_out <= 7'b0010010; // "2" 
      4'b0011: LED_out <= 7'b0000110; // "3" 
      4'b0100: LED_out <= 7'b1001100; // "4" 
      4'b0101: LED_out <= 7'b0100100; // "5" 
      4'b0110: LED_out <= 7'b0100000; // "6" 
      4'b0111: LED_out <= 7'b0001111; // "7" 
      4'b1000: LED_out <= 7'b0000000; // "8"     
      4'b1001: LED_out <= 7'b0000100; // "9"
      4'b1010: LED_out <= 7'b0001000; // "A"     
      4'b1011: LED_out <= 7'b1100000; // "b"     
      4'b1100: LED_out <= 7'b0110001; // "C"     
      4'b1101: LED_out <= 7'b1000010; // "d"     
      4'b1110: LED_out <= 7'b0110000; // "E"     
      4'b1111: LED_out <= 7'b0111000; // "F"     
      
      default: LED_out = 7'b1111110; // "-"
      endcase
      end
      if (toggle == 6) begin
        case(s_rece[7:4])
      4'b0000: LED_out <= 7'b0000001; // "0"     
      4'b0001: LED_out <= 7'b1001111; // "1" 
      4'b0010: LED_out <= 7'b0010010; // "2" 
      4'b0011: LED_out <= 7'b0000110; // "3" 
      4'b0100: LED_out <= 7'b1001100; // "4" 
      4'b0101: LED_out <= 7'b0100100; // "5" 
      4'b0110: LED_out <= 7'b0100000; // "6" 
      4'b0111: LED_out <= 7'b0001111; // "7" 
      4'b1000: LED_out <= 7'b0000000; // "8"     
      4'b1001: LED_out <= 7'b0000100; // "9"
      4'b1010: LED_out <= 7'b0001000; // "A"     
      4'b1011: LED_out <= 7'b1100000; // "b"     
      4'b1100: LED_out <= 7'b0110001; // "C"     
      4'b1101: LED_out <= 7'b1000010; // "d"     
      4'b1110: LED_out <= 7'b0110000; // "E"     
      4'b1111: LED_out <= 7'b0111000; // "F"     
      
      default: LED_out = 7'b1111110; // "-"
      endcase
      end
      if (toggle == 7) begin
        case(s_rece[3:0])
      4'b0000: LED_out <= 7'b0000001; // "0"     
      4'b0001: LED_out <= 7'b1001111; // "1" 
      4'b0010: LED_out <= 7'b0010010; // "2" 
      4'b0011: LED_out <= 7'b0000110; // "3" 
      4'b0100: LED_out <= 7'b1001100; // "4" 
      4'b0101: LED_out <= 7'b0100100; // "5" 
      4'b0110: LED_out <= 7'b0100000; // "6" 
      4'b0111: LED_out <= 7'b0001111; // "7" 
      4'b1000: LED_out <= 7'b0000000; // "8"     
      4'b1001: LED_out <= 7'b0000100; // "9"
      4'b1010: LED_out <= 7'b0001000; // "A"     
      4'b1011: LED_out <= 7'b1100000; // "b"     
      4'b1100: LED_out <= 7'b0110001; // "C"     
      4'b1101: LED_out <= 7'b1000010; // "d"     
      4'b1110: LED_out <= 7'b0110000; // "E"     
      4'b1111: LED_out <= 7'b0111000; // "F"     
      
      default: LED_out = 7'b1111110; // "-"
      endcase
      end
      
 end
     
endmodule
