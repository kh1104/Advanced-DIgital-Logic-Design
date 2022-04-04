module fsm(clock,reset,coin,vend,state,change);
\\these are the inputs AND the outputs
input clock;
input reset;
input [2:0]coin;
output vend;
output [2:0]state;
output [2:0]hange;
\\need to define the registers as change,coin AND vend
reg vend;
reg [2:0]change;
wire [2:0]coin;
\\my coins are declared as parameters to make reading better.
parameter [2:0]NICKEL=3'b001;
parameter [2:0]DIME=3'b010;
parameter [2:0]NICKEL_DIME=3'b011;
parameter [2:0]DIME_DIME=3'b100;
parameter [2:0]QUARTER=3'b101;
\\MY STATES ARE ALSO PARAMETERS. I DONT WANT TO MAKE YOU READ
\\IN MACHINE LANGUAGE
parameter [2:0]IDLE=3'b000;
parameter [2:0]FIVE=3'b001;
parameter [2:0]TEN=3'b010;
parameter [2:0]FIFTEEN=3'b011;
parameter [2:0]TWENTY=3'b100;
parameter [2:0]TWENTYFIVE=3'b101;
\\AS ALWAYS THE STATES ARE DEFINED AS REG
reg [2:0]state,next_state;
\\MY MACHINE WORKS ON STATE AND COIN
always @(state or coin)
begin
next_state=0; \\VERYFIRST NEXT STATE IS GIVEN ZERO
case(state)
IDLE: case(coin)\\THIS IS THE IDLE STATE
NICKEL:next_state=FIVE;
DIME:next_state=TEN;
QUARTER:next_state=TWENTYFIVE;
default:next_state=IDLE;
endcase
FIVE: case(coin)\\this is the second state
NICKEL:next_state=TEN;
DIME:next_state=FIFTEEN;
QUARTER:next_state=TWENTYFIVE;
default:next_state=FIVE;
endcase
TEN:case(coin)\\this is the third state
NICKEL:next_state=FIFTEEN;
DIME:next_state=TWENTY;
QUARTER:next_state=TWENTYFIVE;
default:next_state=TEN;
endcase
FIFTEEN:case(coin)\\this is the fourth state
NICKEL:next_state=TWENTY;
DIME:next_state=TWENTYFIVE;
default:next_state=FIFTEEN;
endcase
TWENTY:case(coin)\\this is the fifth state
NICKEL:next_state=TWENTYFIVE;
DIME:next_state=TWENTYFIVE;//change=NICKEL
QUARTER:next_state=TWENTYFIVE;//change==DIME_DIME
default:next_state=TWENTY;
endcase
TWENTYFIVE:next_state=next_state=IDLE;\\THE NEXT STATE HERE IS THE RESET
default:next_state=IDLE;
endcase
end
always @(clock)
begin \\whenever 1 give a reset 1 have to make the state to idle AND vend to 1
if(reset) begin
state <= IDLE;
vend <= 1'b0;
// change <= 3'b000;
end \\THE CHANGE ALSO HAS TO BECOME NONE
else state <= next_state;
case(state) \\HERE WE DECIDE THE NEXT STATE
\\ALL THE STATES ARE DEFINED HERE AND THE OUTPUT IS ALSO GIVEN
IDLE:begin vend <= 1'b0; change <= 3'd0; end
FIVE: begin vend <= 1'b0; if (coin==QUARTER) change <= NICKEL; else change <=3'd0; end
TEN:begin vend <= 1'b0; if (coin==QUARTER) change <=DIME; else change <=3'd0; end
FIFTEEN: begin vend <= 1'b0; if (coin==QUARTER) change <= NICKEL_DIME; else change <=3'd0; end
TWENTY:begin vend <= 1'b0; if (coin==DIME) change <=NICKEL; else if (coin==QUARTER) change <=3'd0; end
TWENTYFIVE: begin vend <= 1'b1;  change <=3'd0; end
default:state <= IDLE;
endcase
end 
endmodule




