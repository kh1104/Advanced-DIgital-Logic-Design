`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:28:16 03/11/2022 
// Design Name: 
// Module Name:    park_sys 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module park_sys(input sensor1,sensor2,passwd_out,clk,
                output reg gate_open,gate_close
    );
	 reg[2:0] state;
	 parameter idle = 3'b000, check_psswd = 3'b001, open_gate = 3'b010, close_gate = 3'b011;
	 reg psswd_rqst;
	 always@(posedge clk)
	 begin
			  case(state)
					 idle:state <=(sensor1==1)?check_psswd:idle;
					 check_psswd:state <=(passwd_out && psswd_rqst)?open_gate:check_psswd ;
					 open_gate:begin
					 case({sensor1,sensor2})
					 2'b00:state <= open_gate;
					 2'b01,2'b11:state <= close_gate;
					 2'b10:state<=check_psswd;
					 endcase
					 end
					 close_gate:state<=idle;
					 default:state<=idle;
					endcase
	 end
	always@(state)
	       begin
			      case(state)
					 idle:begin psswd_rqst=0;gate_open=0;gate_close=0;end
					 check_psswd: psswd_rqst=1;
					 open_gate:gate_open=1;
					 close_gate:begin gate_close=1;gate_open=0; psswd_rqst = 0;end
					endcase
          end				


endmodule
