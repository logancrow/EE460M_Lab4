`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2019 11:05:35 PM
// Design Name: 
// Module Name: parkingmeter
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


module parkingmeter(
    input plus10, plus180, plus200, plus550, reset10, reset205, clk,
    output [3:0] an,
    output [6:0] sseg
    );
    
    wire [13:0] seconds;
    
    wire clk1s;
    
    clkdiv1s c0 (clk,clk1s);
    
    counter c1 (plus10,plus180,plus200,plus550,reset10,reset205,clk,clk1s,seconds);
    
    wire [3:0] dig3,dig2,dig1,dig0;
    
    binconverter b0 (seconds,dig3,dig2,dig1,dig0);
    
    wire [6:0] sseg3,sseg2,sseg1,sseg0;
    
    hexto7segment h0 (dig3,sseg3);
    hexto7segment h1 (dig2,sseg2);
    hexto7segment h2 (dig1,sseg1);
    hexto7segment h3 (dig0,sseg0);
    
    wire an0,an1,an2,an3;
    
    displayLogic d0 (clk,sseg0,sseg1,sseg2,sseg3,an0,an1,an2,an3,sseg);
    
    mask m0 (seconds,an0,an1,an2,an3,clk1s,an);
    
endmodule


//controls counter based on system inputs
module counter(
    input plus10, plus180, plus200, plus550, reset10, reset205, clk, clk1s,
    output reg [13:0] seconds
    );
    
    reg [2:0] state, next_state;
    reg [13:0] state_out, holdmux, out;
        
    always@(*) begin 
        case(state)
        3'b000 : case({plus10,plus180,plus200,plus550,reset10,reset205})
                 6'b000000 : begin next_state = 3'b000; state_out = seconds; end
                 6'b100000 : begin next_state = 3'b001; state_out = seconds + 10; end
                 6'b010000 : begin next_state = 3'b010; state_out = seconds + 180; end
                 6'b001000 : begin next_state = 3'b011; state_out = seconds + 200; end
                 6'b000100 : begin next_state = 3'b100; state_out = seconds + 550; end
                 6'b00001X : begin next_state = 3'b101; state_out = 10; end
                 6'b000001 : begin next_state = 3'b110; state_out = 205; end 
                 endcase
        3'b001 : case({plus10,plus180,plus200,plus550,reset10,reset205})
                 6'b000000 : begin next_state = 3'b000; state_out = seconds; end
                 6'b100000 : begin next_state = 3'b000; state_out = seconds; end
                 6'bX10000 : begin next_state = 3'b010; state_out = seconds + 180; end
                 6'bX01000 : begin next_state = 3'b011; state_out = seconds + 200; end
                 6'bX00100 : begin next_state = 3'b100; state_out = seconds + 550; end
                 6'bX0001X : begin next_state = 3'b101; state_out = 10; end
                 6'bX00001 : begin next_state = 3'b110; state_out = 205; end 
                 endcase
        3'b010 : case({plus10,plus180,plus200,plus550,reset10,reset205})
                 6'b000000 : begin next_state = 3'b000; state_out = seconds; end
                 6'b1X0000 : begin next_state = 3'b001; state_out = seconds + 10; end
                 6'b010000 : begin next_state = 3'b000; state_out = seconds; end
                 6'b0X1000 : begin next_state = 3'b011; state_out = seconds + 200; end
                 6'b0X0100 : begin next_state = 3'b100; state_out = seconds + 550; end
                 6'b0X001X : begin next_state = 3'b101; state_out = 10; end
                 6'b0X0001 : begin next_state = 3'b110; state_out = 205; end 
                 endcase
        3'b011 : case({plus10,plus180,plus200,plus550,reset10,reset205})
                 6'b000000 : begin next_state = 3'b000; state_out = seconds; end
                 6'b10X000 : begin next_state = 3'b001; state_out = seconds + 10; end
                 6'b01X000 : begin next_state = 3'b010; state_out = seconds + 180; end
                 6'b001000 : begin next_state = 3'b000; state_out = seconds; end
                 6'b00X100 : begin next_state = 3'b100; state_out = seconds + 550; end
                 6'b00X01X : begin next_state = 3'b101; state_out = 10; end
                 6'b00X001 : begin next_state = 3'b110; state_out = 205; end 
                 endcase
        3'b100 : case({plus10,plus180,plus200,plus550,reset10,reset205})
                 6'b000000 : begin next_state = 3'b000; state_out = seconds; end
                 6'b100X00 : begin next_state = 3'b001; state_out = seconds + 10; end
                 6'b010X00 : begin next_state = 3'b010; state_out = seconds + 180; end
                 6'b001X00 : begin next_state = 3'b011; state_out = seconds + 200; end
                 6'b000100 : begin next_state = 3'b000; state_out = seconds; end
                 6'b000X1X : begin next_state = 3'b101; state_out = 10; end
                 6'b000X01 : begin next_state = 3'b110; state_out = 205; end 
                 endcase
        3'b101 : case({plus10,plus180,plus200,plus550,reset10,reset205})
                 6'b000000 : begin next_state = 3'b000; state_out = seconds; end
                 6'b100000 : begin next_state = 3'b001; state_out = seconds + 10; end
                 6'b010000 : begin next_state = 3'b010; state_out = seconds + 180; end
                 6'b001000 : begin next_state = 3'b011; state_out = seconds + 200; end
                 6'b000100 : begin next_state = 3'b100; state_out = seconds + 550; end
                 6'b00001X : begin next_state = 3'b101; state_out = 10; end
                 6'b000001 : begin next_state = 3'b110; state_out = 205; end
                 6'b100010 : begin next_state = 3'b111; state_out = seconds + 10; end
                 6'b010010 : begin next_state = 3'b111; state_out = seconds + 180; end
                 6'b001010 : begin next_state = 3'b111; state_out = seconds + 200; end
                 6'b000110 : begin next_state = 3'b111; state_out = seconds + 550; end 
                 endcase
        3'b110 : case({plus10,plus180,plus200,plus550,reset10,reset205})
                 6'b000000 : begin next_state = 3'b000; state_out = seconds; end
                 6'b100000 : begin next_state = 3'b001; state_out = seconds + 10; end
                 6'b010000 : begin next_state = 3'b010; state_out = seconds + 180; end
                 6'b001000 : begin next_state = 3'b011; state_out = seconds + 200; end
                 6'b000100 : begin next_state = 3'b100; state_out = seconds + 550; end
                 6'b00001X : begin next_state = 3'b101; state_out = 10; end
                 6'b000001 : begin next_state = 3'b110; state_out = 205; end
                 6'b100001 : begin next_state = 3'b111; state_out = seconds + 10; end
                 6'b010001 : begin next_state = 3'b111; state_out = seconds + 180; end
                 6'b001001 : begin next_state = 3'b111; state_out = seconds + 200; end
                 6'b000101 : begin next_state = 3'b111; state_out = seconds + 550; end 
                 endcase
        3'b111 : case({plus10,plus180,plus200,plus550,reset10,reset205})
                 6'b000000 : begin next_state = 3'b000; state_out = seconds; end
                 6'b100000 : begin next_state = 3'b001; state_out = seconds + 10; end
                 6'b010000 : begin next_state = 3'b010; state_out = seconds + 180; end
                 6'b001000 : begin next_state = 3'b011; state_out = seconds + 200; end
                 6'b000100 : begin next_state = 3'b100; state_out = seconds + 550; end
                 6'b00001X : begin next_state = 3'b101; state_out = seconds; end
                 6'b000001 : begin next_state = 3'b110; state_out = seconds; end
                 6'b10001X : begin next_state = 3'b111; state_out = seconds; end
                 6'b01001X : begin next_state = 3'b111; state_out = seconds; end
                 6'b00101X : begin next_state = 3'b111; state_out = seconds; end
                 6'b00011X : begin next_state = 3'b111; state_out = seconds; end 
                 6'b1000X1 : begin next_state = 3'b111; state_out = seconds; end
                 6'b0100X1 : begin next_state = 3'b111; state_out = seconds; end
                 6'b0010X1 : begin next_state = 3'b111; state_out = seconds; end
                 6'b0001X1 : begin next_state = 3'b111; state_out = seconds; end
                 endcase
        endcase
    end
    
    always@(posedge clk) state <= next_state;
    
    always@(*) begin
    if(reset10 | reset205 | (seconds == 0)) holdmux <= state_out;
    else holdmux <= state_out - 1;
    end
    
    always@(posedge clk1s) out <= holdmux;
    
    always@(*) begin
    if(seconds >= 9999) seconds <= 9999;
    else seconds <= out;
    end
endmodule


//divides clock to 1hz
module clkdiv1s(
    input clk,
    output clkout
    );
endmodule


//converts binary number to 4 seperate digits
module binconverter(
    input [13:0] in,
    output [3:0] out3, 
    inout [3:0] out2, out1, out0
    );
    
    assign out0 = in%10;
    assign out1 = ((in%100) - out0)/10;
    assign out2 = ((in%1000) - (out1*10) - out0)/100;
    assign out3 = (in - (out2*100) - (out1*10) - out0)/1000;    
endmodule


//send a hex value, returns seven segment
module hexto7segment(
    input [3:0] x,
    output reg [6:0] r
    );
    always@(*)
        case(x)
            4'b0000 : r = 7'b1000000;
            4'b0001 : r = 7'b1111001;
            4'b0010 : r = 7'b0100100;
            4'b0011 : r = 7'b0110000;
            4'b0100 : r = 7'b0011001;
            4'b0101 : r = 7'b0010010;
            4'b0110 : r = 7'b0000010;
            4'b0111 : r = 7'b1111000;
            4'b1000 : r = 7'b0000000;
            4'b1001 : r = 7'b0010000;
            4'b1010 : r = 7'b0001000;
            4'b1011 : r = 7'b0000011;
            4'b1100 : r = 7'b1000110;
            4'b1101 : r = 7'b0100001;
            4'b1110 : r = 7'b0000110;
            4'b1111 : r = 7'b0001110;
        endcase   
endmodule


//rotates 4 digits on 4 seven segment displays
module displayLogic(
    input clk,
    input [6:0] sseg0, sseg1, sseg2, sseg3,
    output reg an0, an1, an2, an3, 
    output reg [6:0] sseg
    );
    reg [1:0] state, next_state;
    initial begin
        state = 2'b00;
    end 
    
    always@(*) begin
    case(state)
        2'b00 : begin {an3, an2, an1, an0} = 4'b1110; next_state = 2'b01; sseg = sseg0; end
        2'b01 : begin {an3, an2, an1, an0} = 4'b1101; next_state = 2'b10; sseg = sseg1; end
        2'b10 : begin {an3, an2, an1, an0} = 4'b1011; next_state = 2'b11; sseg = sseg2; end
        2'b11 : begin {an3, an2, an1, an0} = 4'b0111; next_state = 2'b00; sseg = sseg3; end
        endcase
    end
    
    always@(posedge clk) begin
        state <= next_state;
        end              
endmodule


//mask allows for digits to flash as they are counting down
module mask(
    input counter, an0, an1, an2, an3, clk1s,
    output reg [3:0] anout
    );
    
    wire [3:0] clkvector;
    assign clkvector = {4{clk1s}};
    
    always@(*) begin
        if(counter < 201) begin
            if(counter == 0) anout <= {an3,an2,an1,an0} | clkvector;
            else if(counter%2) anout <= 4'b1111;
                else anout <= {an3,an2,an1,an0};
        end
        else anout <= {an3,an2,an1,an0};
    end
endmodule