`timescale 1ns/10ps

   
   
   
/****************************************************************************************************************************************************/
/*Designer:Dino 2024/01/15						
                                              
Aim : Finish RFILE with least area and timing
Parameter : 
     VA: Distance from T point to A [15:0]
	 VB: Distance from T point to B [15:0]
	 VC: Distance from T point to C [15:0]
Algorithm:                                    
   1. TAB = VA^2 - A_x^2 - A_y^2 - VB^2 + 
/*
/*
/*
/*         
/* 
/*
/*
/*
/*
/*
/*
/*
/*
/*
/*
/*
/*
/****************************************************************************************************************************************************/
module RFILE(clk, rst, A_x, A_y, B_x, B_y, C_x, C_y, rssiA, rssiB, rssiC, valueA, valueB, valueC, expA, expB, expC, busy, out_valid, xt, yt);
input           clk;
input           rst;
input  [7:0]    A_x;
input  [7:0]    A_y; 
input  [7:0]    B_x; 
input  [7:0]    B_y; 
input  [7:0]    C_x; 
input  [7:0]    C_y;
input  [19:0]   rssiA;
input  [19:0]   rssiB;
input  [19:0]   rssiC;
input  [15:0]   valueA;
input  [15:0]   valueB;
input  [15:0]   valueC;
output [11:0]   expA;
output [11:0]   expB;
output [11:0]   expC;
output          busy;
output          out_valid;
output [7:0]    xt;
output [7:0]    yt;

parameter READY       = 6'b00000_0;
parameter COUNTDIST_A = 6'b00000_1;
parameter COUNTDIST_B = 6'b00001_0;
parameter COUNTDIST_C = 6'b00001_1;
parameter COUNT_XAB_1 = 6'b00010_0;
parameter COUNT_XAB_2 = 6'b00010_1;
parameter COUNT_XAB   = 6'b00011_0;
parameter COUNT_YAB_1 = 6'b00011_1;
parameter COUNT_YAB_2 = 6'b00100_0;
parameter COUNT_YAB   = 6'b00100_1;
parameter COUNT_TAB_1 = 6'b00101_0;
parameter COUNT_TAB_2 = 6'b00101_1;
parameter COUNT_TAB_3 = 6'b00110_0;
parameter COUNT_TAB_4 = 6'b00110_1;
parameter COUNT_TAB_5 = 6'b00111_0;
parameter COUNT_TXAB  = 6'b00111_1;
parameter COUNT_YXAB  = 6'b01000_0;
parameter PREPARE_A_1 = 6'b01000_1;
parameter PREPARE_A_2 = 6'b01001_0;
parameter PREPARE_B_1 = 6'b01001_1;
parameter PREPARE_B_2 = 6'b01010_0;
parameter PREPARE_B_3 = 6'b01010_1;
parameter PREPARE_C_1 = 6'b01011_0;
parameter PREPARE_C_2 = 6'b01011_1;
parameter PREPARE_C_3 = 6'b01100_0;
parameter PREPARE_C_4 = 6'b01100_1;
parameter PREPARE_C_5 = 6'b01101_0;
parameter PREPARE_C_6 = 6'b01101_1;
parameter PREPARE_C   = 6'b01110_0;
parameter SQUARE_1    = 6'b01110_1;
parameter SQUARE_2    = 6'b01111_0;
parameter SQUARE_3    = 6'b01111_1;
parameter SQUARE      = 6'b10000_0;
parameter COUNT_Yt_1  = 6'b10000_1;
parameter COUNT_Yt    = 6'b10001_0;
parameter COUNT_Xt_1  = 6'b10001_1;
parameter COUNT_Xt_2  = 6'b10010_0;
parameter COUNT_Xt_3  = 6'b10010_1;
parameter COUNT_Xt_4  = 6'b10011_0;
parameter COUNT_Xt_5  = 6'b10011_1;
parameter CHOOSE_POINT_1 = 6'b101000;
parameter CHOOSE_POINT_2 = 6'b101001;
parameter CHOOSE_POINT_3 = 6'b101010;
parameter CHOOSE_POINT_4 = 6'b101011;
parameter CHOOSE_POINT_5 = 6'b101100;
parameter CHOOSE_POINT_6 = 6'b101101;
parameter CHOOSE_POINT_7 = 6'b101110;
parameter CHOOSE_POINT_8 = 6'b101111;

parameter RETURN      = 6'b110000;//48
                      
wire [19:0] fifnine;
reg [11:0] expA_, expB_, expC_;
wire [19:0] rssiA_comp, rssiB_comp, rssiC_comp;
reg [19:0] value_comp;
reg [9:0] Xab, Yab;
reg [23:0]  TAB, TXAB, YXAB;
reg [22:0] a,b,c;
reg signed [18:0] div2x_0, div2x_1;
reg signed [16:0] multi2x_1, multi2x_0, adder2x_0, adder2x_1, minus2x_0, minus2x_1, compare_square_0;
reg [22:0] square_inside;
reg [7:0] Yt_1, Yt_2, Xt_1, Xt_2;
reg [7:0] Xt, Yt;
reg [5:0] state, nextState;
reg [7:0] origin_square_compare, square_value;
reg [2:0] square_count;
wire [13:0] expValue;
reg [31:0] multi_shift2x_0, multi_shift2x_1, YXAB_square; // for the sake of shifting
reg [15:0] VA, VB, VC, exp_10;
reg finishSquare, finishReady, busy_;
assign rssiA_comp = ~rssiA + 1;
assign rssiB_comp = ~rssiB + 1;
assign rssiC_comp = ~rssiC + 1;
assign fifnine = 20'b0011_1011_0000_0000_0000;//59
reg [7:0] distance1_1, distance1_2, distance2_1, distance2_2, abs_distance1,abs_distance2;
wire [7:0] distance1, distance2;
reg [8:0] distance;
assign distance1 = distance1_1 - distance1_2;
assign distance2 = distance2_1 - distance2_2;


/*
assign t1 = (Yt_1 - A_y)**2 ;
assign t2 = (Xt_1 - A_x)**2;
assign t3 = (Yt_1 - B_y)**2;
assign t4 = (Xt_1 - B_x)**2;
assign t5 = (Yt_1 - C_y)**2;
assign t6 = (Xt_1 - C_x)**2;
assign t0 = t1 + t2 + t3 + t4 + t5 + t6;
assign m1 = (Yt_2 - A_y)**2;
assign m2 = (Xt_2 - A_x)**2;
assign m3 = (Yt_2 - B_y)**2;
assign m4 = (Xt_2 - B_x)**2;
assign m5 = (Yt_2 - C_y)**2;
assign m6 = (Xt_2 - C_x)**2;
assign m0 = m1 + m2 + m3 + m4 + m5 + m6;*/

wire [11:0] expA, expB, expC;

wire [31:0] minus2x, adder2x, multi2x, div2x;
wire [31:0] compare_square_1;
wire [15:0] multi_shift2x;
wire compare_square;

//d = 10 ^ ((abs(RSSI) - alpha) / (10 * n))
assign expA = expA_;
assign expB = expB_;
assign expC = expC_;
assign expValue = ((value_comp - fifnine) / (10));
assign multi2x = multi2x_0 * multi2x_1;
assign div2x = div2x_0 / div2x_1;
assign adder2x = adder2x_0 + adder2x_1;
assign minus2x = minus2x_0 - minus2x_1;

assign multi_shift2x = (multi_shift2x_0 * multi_shift2x_1) >> 12; //(multi_shift2x_0 * multi_shift2x_1) >> 12
assign compare_square = compare_square_0 > compare_square_1;
assign compare_square_1 = (square_value + origin_square_compare) ** 2;
assign xt = Xt ;
assign yt = Yt ;

assign busy = busy_;
assign out_valid = (state == RETURN);

always@(distance1, distance2)begin
	abs_distance1 = (distance1[7] == 1) ? -distance1 : distance1;
	abs_distance2 = (distance2[7] == 1) ? -distance2 : distance2;
end
always@(state, finishSquare, finishReady)begin
	case(state)     
		READY:       nextState = COUNTDIST_A;                      
		COUNTDIST_A: nextState = COUNTDIST_B; 
		COUNTDIST_B: nextState = COUNTDIST_C;
		COUNTDIST_C: nextState = COUNT_XAB_1;
		COUNT_XAB_1: nextState = COUNT_XAB_2;
		COUNT_XAB_2: nextState = COUNT_XAB;
		COUNT_XAB:   nextState = COUNT_YAB_1;
		COUNT_YAB_1:  nextState = COUNT_YAB_2;
		COUNT_YAB_2:  nextState = COUNT_YAB;  
		COUNT_YAB:    nextState = COUNT_TAB_1;
		COUNT_TAB_1:  nextState = COUNT_TAB_2;
		COUNT_TAB_2:  nextState = COUNT_TAB_3;
		COUNT_TAB_3:  nextState = COUNT_TAB_4;
		COUNT_TAB_4:  nextState = COUNT_TAB_5;
		COUNT_TAB_5:  nextState = COUNT_TXAB; 
		COUNT_TXAB:   nextState = COUNT_YXAB; 
		COUNT_YXAB:   nextState = PREPARE_A_1;
		PREPARE_A_1:  nextState = PREPARE_A_2;
		PREPARE_A_2:  nextState = PREPARE_B_1;
		PREPARE_B_1:  nextState = PREPARE_B_2;
		PREPARE_B_2:  nextState = PREPARE_B_3;
		PREPARE_B_3:  nextState = PREPARE_C_1;
		PREPARE_C_1:  nextState = PREPARE_C_2;
		PREPARE_C_2:  nextState = PREPARE_C_3;
		PREPARE_C_3:  nextState = PREPARE_C_4;
		PREPARE_C_4:  nextState = PREPARE_C_5; 
		PREPARE_C_5:  nextState = PREPARE_C_6;
		PREPARE_C_6:  nextState = PREPARE_C;
		PREPARE_C:    nextState = SQUARE_1;   
		SQUARE_1:     nextState = SQUARE_2;   
		SQUARE_2:     nextState = SQUARE_3; 
		SQUARE_3:     nextState = SQUARE;
		SQUARE:begin
					  if(finishSquare)
						nextState = COUNT_Yt_1;
					  else
						nextState = SQUARE;
		end 
		COUNT_Yt_1:   nextState = COUNT_Yt;   
		COUNT_Yt:     nextState = COUNT_Xt_1;
		COUNT_Xt_1:   nextState = COUNT_Xt_2; 
		COUNT_Xt_2:   nextState = COUNT_Xt_3;
		COUNT_Xt_3:   nextState = COUNT_Xt_4;
		COUNT_Xt_4:   nextState = COUNT_Xt_5;
		COUNT_Xt_5:   nextState = CHOOSE_POINT_1;
		CHOOSE_POINT_1: nextState = CHOOSE_POINT_2;
		CHOOSE_POINT_2: nextState = CHOOSE_POINT_3;
		CHOOSE_POINT_3: nextState = CHOOSE_POINT_4;
		CHOOSE_POINT_4: nextState = CHOOSE_POINT_5;
		CHOOSE_POINT_5: nextState = CHOOSE_POINT_6;
		CHOOSE_POINT_6: nextState = CHOOSE_POINT_7;
		CHOOSE_POINT_7: nextState = CHOOSE_POINT_8;
		CHOOSE_POINT_8: nextState = RETURN;
		
		RETURN:       nextState = READY;
		default:	  nextState = 0;
	endcase
end

always@(posedge clk)begin
	if(rst)
		state <= 0;
	else
		state <= nextState;
end

always@(expValue[13:12])begin
	case(expValue[13:12])
		1: exp_10 = 10;
		2: exp_10 = 100;
		3: exp_10 = 1000;
		default: exp_10 = 1;
	endcase
end
always@(posedge clk)begin
	finishReady <= 0;
	finishSquare <= 0;
	if(rst)begin
		a <= 0;
		b <= 0;
		c <= 0;
		VA <= 20'b0;
		VB <= 20'b0;
		VC <= 20'b0;
		origin_square_compare <= 8'b10000000;
		square_count <= 0;
		square_value <= 8'b00000000;
		busy_ <= 0;
	end
	else
		case(state)
			READY:begin
				finishReady <= 1;
				busy_ <= 1;
				square_count <= 0;
				origin_square_compare <= 8'b10000000;
				square_value <= 8'b00000000;
				VA <= 0;
				VB <= 0;
				VC <= 0;
				distance <= 0;
			end
			COUNTDIST_A:begin //1
				
				value_comp <= rssiA_comp;
			end
			COUNTDIST_B:begin //2
				value_comp <= rssiB_comp;
				expA_ <= expValue[11:0];
				VA <= exp_10; 
				
			end
			COUNTDIST_C:begin //3
				value_comp <= rssiC_comp;
				
				multi_shift2x_0 <= VA;//VA <= (VA * valueA) >> 12;
				multi_shift2x_1 <= valueA;
				expB_ <= expValue[11:0];
				VB <= exp_10;
			end
			COUNT_XAB_1:begin // 4
			
				VA <= multi_shift2x;
				multi_shift2x_0 <= VB;
				multi_shift2x_1 <= valueB; //VB <= (valueB * VB) >> 12;
				VC <= exp_10;
				expC_ <= expValue[11:0];
				multi2x_0 <= -2;
				multi2x_1 <= A_x;
			end
			COUNT_XAB_2:begin //5
				VB <= multi_shift2x;
				multi_shift2x_0 <= VC;
				multi_shift2x_1 <= valueC; //VC <= ((valueC * VC) >> 12);
				adder2x_0 <= multi2x;
				multi2x_0 <= 2;
				multi2x_1 <= B_x;
			end
			COUNT_XAB:begin //6
				VC <= multi_shift2x;
				adder2x_1 <= multi2x;
			end
			COUNT_YAB_1:begin // 7
				Xab <= adder2x;
				multi2x_0 <= -2;
				multi2x_1 <= A_y;
			end
			COUNT_YAB_2:begin //8
				adder2x_0 <= multi2x;
				multi2x_0 <= 2;
				multi2x_1 <= B_y;
			end
			COUNT_YAB:begin // 9
				adder2x_1 <= multi2x;
				multi2x_0 <= A_x;
				multi2x_1 <= A_x;
			end
			COUNT_TAB_1:begin //10
				Yab <= adder2x;
				minus2x_0 <= VA;//*VA;
				minus2x_1 <= multi2x;
				multi2x_0 <= A_y;
				multi2x_1 <= A_y;
			end
			COUNT_TAB_2:begin //11
				minus2x_0 <= minus2x;
				minus2x_1 <= multi2x;
			end
			COUNT_TAB_3:begin //12
				minus2x_0 <= minus2x;
				minus2x_1 <= VB;//*VB;
				multi2x_0 <= B_x;
				multi2x_1 <= B_x;
			end
			COUNT_TAB_4:begin //13
				adder2x_0 <= minus2x;
				adder2x_1 <= multi2x; 
				multi2x_0 <= B_y;
				multi2x_1 <= B_y;
			end
			COUNT_TAB_5:begin //14
				adder2x_0 <= adder2x;
				adder2x_1 <= multi2x; 
			end
			COUNT_TXAB:begin //15
				TAB <= adder2x;
				div2x_0 <= adder2x << 3;
				div2x_1 <= Xab;
			end
			COUNT_YXAB:begin //16 //let YXAB 10 bit integer 6 bit float
				TXAB <= div2x;
				//adder2x_1 <= 1;
				div2x_0 <= Yab << 6; 
				div2x_1 <= Xab;
				
			end
			PREPARE_A_1:begin//17
				YXAB <= div2x;
				multi2x_0 <= div2x;
				multi2x_1 <= div2x;
			end
			PREPARE_A_2:begin//18
				adder2x_0 <= multi2x >> 6;
				YXAB_square <= multi2x >> 6;
				adder2x_1 <= 1 << 6;
				multi2x_0 <= C_x;
				multi2x_1 <= YXAB;
			end
			PREPARE_B_1:begin//19
				a <= adder2x ;
				multi2x_0 <= TXAB;
				multi2x_1 <= YXAB;
				minus2x_0 <= multi2x;
				minus2x_1 <= C_y << 6;
			end
			PREPARE_B_2:begin //20
				
				minus2x_0 <= minus2x;
				minus2x_1 <= multi2x >> 3;
				
				
			end
			PREPARE_B_3:begin//21
				multi2x_0 <= 2;
				multi2x_1 <= minus2x;
			end
			PREPARE_C_1:begin//22
				b <= multi2x;
				multi2x_0 <= C_x;
				multi2x_1 <= C_x;
			end
			PREPARE_C_2:begin//23
				
				minus2x_0 <= VC;// * VC;
				minus2x_1 <= multi2x;
				multi2x_0 <= C_y;
				multi2x_1 <= C_y;
			end
			PREPARE_C_3:begin //24
				minus2x_0 <= minus2x;
				minus2x_1 <= multi2x;
				multi2x_0 <= 2;
				multi2x_1 <= C_x;
			end
			PREPARE_C_4:begin //25
				adder2x_0 <= minus2x;
				multi2x_0 <= multi2x;
				multi2x_1 <= TXAB;

			end
			PREPARE_C_5:begin//26
				adder2x_1 <= multi2x >> 3;
				multi2x_0 <= TXAB;
				multi2x_1 <= TXAB;
			end
			PREPARE_C_6:begin//27
				minus2x_0 <= adder2x;
				minus2x_1 <= multi2x >> 6;
				multi2x_0 <= b;
				multi2x_1 <= b;
			end
			PREPARE_C:begin//28
				minus2x_0 <= multi2x >> 12;
				c <= -minus2x;
				multi2x_0 <= 4;
				multi2x_1 <= a;
			end
			SQUARE_1:begin//29
				multi2x_0 <= multi2x;
				multi2x_1 <= c;
				
			end
			SQUARE_2:begin //square(b^2 - 4ac) //30
				minus2x_1 <= multi2x >> 6;
				
				//compare_square_1 <= minus2x;
			end
			SQUARE_3:begin//31
				square_inside <= minus2x;
				compare_square_0 <= minus2x ;
			end
			SQUARE:begin //32
				if(compare_square == 1)begin
					square_value <= square_value + origin_square_compare;
				end
				else begin
					square_value <= square_value;
				end
				origin_square_compare <= origin_square_compare >> 1;
				if(square_count == 7)
					finishSquare <= 1;
				else
					square_count <= square_count + 1;
				
			end
			COUNT_Yt_1:begin//33
				
				adder2x_0 <= (-b >> 6);
				adder2x_1 <= square_value;
				minus2x_0 <= (-b >> 6);
				minus2x_1 <= square_value;
				multi2x_0 <= 2;
				multi2x_1 <= a;
				
			end
			COUNT_Yt:begin//34
				div2x_0 <= minus2x << 6;
				div2x_1 <= multi2x;
			end
			COUNT_Xt_1:begin//35
				Yt_1 <= div2x;
				div2x_0 <= adder2x << 6;
				multi2x_0 <= Yab;
				multi2x_1 <= div2x;
				
			end
			COUNT_Xt_2:begin//36
				Yt_2 <= div2x;
				minus2x_0 <= TAB;
				minus2x_1 <= multi2x;
				multi2x_1 <= div2x;
			end
			COUNT_Xt_3:begin//37
				div2x_0 <= minus2x;
				div2x_1 <= Xab;
				minus2x_1 <= multi2x;
				
			end
			COUNT_Xt_4:begin//38
				div2x_0 <= minus2x;
				Xt_1 <= div2x;
				
			end
			COUNT_Xt_5:begin//39
				Xt_2 <= div2x;
			end
			CHOOSE_POINT_1:begin//40
				distance1_1 <= Yt_1;
				distance1_2 <= A_y;
				distance2_1 <= Yt_2;
				distance2_2 <= A_y;
				
			end
			CHOOSE_POINT_2:begin//41
				distance <= distance + abs_distance1 - abs_distance2;
				distance1_1 <= Xt_1;
				distance1_2 <= A_x;
				distance2_1 <= Xt_2;
				distance2_2 <= A_x;
			end
			CHOOSE_POINT_3:begin//42
				distance <= distance + abs_distance1 - abs_distance2;
				distance1_1 <= Yt_1;
				distance1_2 <= B_y;
				distance2_1 <= Yt_2;
				distance2_2 <= B_y;
			end
			CHOOSE_POINT_4:begin//43
				distance <= distance + abs_distance1 - abs_distance2;
				distance1_1 <= Xt_1;
				distance1_2 <= B_x;
				distance2_1 <= Xt_2;
				distance2_2 <= B_x;
			end
			CHOOSE_POINT_5:begin//44
				distance <= distance + abs_distance1 - abs_distance2;
				distance1_1 <= Yt_1;
				distance1_2 <= C_y;
				distance2_1 <= Yt_2;
				distance2_2 <= C_y;
			end
			CHOOSE_POINT_6:begin//45
				distance <= distance + abs_distance1 - abs_distance2;
				distance1_1 <= Xt_1;
				distance1_2 <= C_x;
				distance2_1 <= Xt_2;
				distance2_2 <= C_x;
			end
			CHOOSE_POINT_7:begin//46
				distance <= distance + abs_distance1 - abs_distance2;
				
				
			end
			CHOOSE_POINT_8:begin//47
				
				if(distance[8] == 0)begin //means Yt_2 min
					Yt <= Yt_2;
					Xt <= Xt_2;
				end
				else begin
					Yt <= Yt_1;
					Xt <= Xt_1;
				end
				
			end
			RETURN:begin//48
				
				busy_ <= 0;
			end
		endcase
end
endmodule
/*
assign t1 = (Yt_1 - A_y)**2 ;
assign t2 = (Xt_1 - A_x)**2;
assign t3 = (Yt_1 - B_y)**2;
assign t4 = (Xt_1 - B_x)**2;
assign t5 = (Yt_1 - C_y)**2;
assign t6 = (Xt_1 - C_x)**2;
assign t0 = t1 + t2 + t3 + t4 + t5 + t6;
assign m1 = (Yt_2 - A_y)**2;
assign m2 = (Xt_2 - A_x)**2;
assign m3 = (Yt_2 - B_y)**2;
assign m4 = (Xt_2 - B_x)**2;
assign m5 = (Yt_2 - C_y)**2;
assign m6 = (Xt_2 - C_x)**2;

*/