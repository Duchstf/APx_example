`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/20/2019 03:42:52 PM
// Design Name: 
// Module Name: prio_encoder2
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

module prio_encoder2(
    // Inputs:
    input clk,
    input start,
    input has_dat00,
    input has_dat01,
    input has_dat02,
    input has_dat03,
    input has_dat04,
    input has_dat05,
    input has_dat06,
    input has_dat07,
    input has_dat08,
    input has_dat09,
    input has_dat10,
    input has_dat11,
    input has_dat12,
    input has_dat13,
    input has_dat14,
    input has_dat15,
    input has_dat16,
    input has_dat17,
    input has_dat18,
    input has_dat19,
    input has_dat20,
    input has_dat21,
    input has_dat22,
    input has_dat23,
    input has_dat24,
    input has_dat25,
    input has_dat26,
//    input has_dat27,
//    input has_dat28,
//    input has_dat29,
//    input has_dat30,
//    input has_dat31,
    // Outputs:
    output reg [4:0] sel,   // binary encoded
    output reg none
);

//////////////////////////////////////////////////////////////////////////
// Implement a registered priority encoder
// The '00' input has the highest priority
    reg sel00;
    reg sel01;
    reg sel02;
    reg sel03;
    reg sel04;
    reg sel05;
    reg sel06;
    reg sel07;
    reg sel08;
    reg sel09;
    reg sel10;
    reg sel11;
    reg sel12;
    reg sel13;
    reg sel14;
    reg sel15;
    reg sel16;
    reg sel17;
    reg sel18;
    reg sel19;
    reg sel20;
    reg sel21;
    reg sel22;
    reg sel23;
    reg sel24;
    reg sel25;
    reg sel26;
 // reg sel27;
 // reg sel28;
 // reg sel29;
 // reg sel30;
 // reg sel31;
wire wsel00, wsel01, wsel02, wsel03, wsel04, wsel05, wsel06, wsel07, wsel08, wsel09, wsel10, wsel11, wsel12, wsel13, wsel14, wsel15, wsel16, wsel17, wsel18, wsel19, wsel20, wsel21, wsel22, wsel23, wsel24, wsel25, wsel26, wsel27, wsel28, wsel29, wsel30, wsel31;
assign wsel00 = has_dat00;
assign wsel01 = has_dat01 & !has_dat00;
assign wsel02 = has_dat02 & !has_dat00 & !has_dat01;
assign wsel03 = has_dat03 & !has_dat00 & !has_dat01 & !has_dat02;
assign wsel04 = has_dat04 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03;
assign wsel05 = has_dat05 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04;
assign wsel06 = has_dat06 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05;
assign wsel07 = has_dat07 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06;
assign wsel08 = has_dat08 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07;
assign wsel09 = has_dat09 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08;
assign wsel10 = has_dat10 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09;
assign wsel11 = has_dat11 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10;
assign wsel12 = has_dat12 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10 & !has_dat11;
assign wsel13 = has_dat13 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10 & !has_dat11 & !has_dat12;
assign wsel14 = has_dat14 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10 & !has_dat11 & !has_dat12 & !has_dat13;
assign wsel15 = has_dat15 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10 & !has_dat11 & !has_dat12 & !has_dat13 & !has_dat14;
assign wsel16 = has_dat16 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10 & !has_dat11 & !has_dat12 & !has_dat13 & !has_dat14 & !has_dat15;
assign wsel17 = has_dat17 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10 & !has_dat11 & !has_dat12 & !has_dat13 & !has_dat14 & !has_dat15 & !has_dat16;

assign wsel18 = has_dat18 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10 & !has_dat11 & !has_dat12 & !has_dat13 & !has_dat14 & !has_dat15 & !has_dat16 & !has_dat17;
assign wsel19 = has_dat19 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10 & !has_dat11 & !has_dat12 & !has_dat13 & !has_dat14 & !has_dat15 & !has_dat16 & !has_dat17 & !has_dat18;
assign wsel20 = has_dat20 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10 & !has_dat11 & !has_dat12 & !has_dat13 & !has_dat14 & !has_dat15 & !has_dat16 & !has_dat17 & !has_dat18 & !has_dat19;
assign wsel21 = has_dat21 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10 & !has_dat11 & !has_dat12 & !has_dat13 & !has_dat14 & !has_dat15 & !has_dat16 & !has_dat17 & !has_dat18 & !has_dat19 & !has_dat20;
assign wsel22 = has_dat22 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10 & !has_dat11 & !has_dat12 & !has_dat13 & !has_dat14 & !has_dat15 & !has_dat16 & !has_dat17 & !has_dat18 & !has_dat19 & !has_dat20 & !has_dat21;
assign wsel23 = has_dat23 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10 & !has_dat11 & !has_dat12 & !has_dat13 & !has_dat14 & !has_dat15 & !has_dat16 & !has_dat17 & !has_dat18 & !has_dat19 & !has_dat20 & !has_dat21 &!has_dat22;
assign wsel24 = has_dat24 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10 & !has_dat11 & !has_dat12 & !has_dat13 & !has_dat14 & !has_dat15 & !has_dat16 & !has_dat17 & !has_dat18 & !has_dat19 & !has_dat20 & !has_dat21 &!has_dat22 &!has_dat23; 
assign wsel25 = has_dat25 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10 & !has_dat11 & !has_dat12 & !has_dat13 & !has_dat14 & !has_dat15 & !has_dat16 & !has_dat17 & !has_dat18 & !has_dat19 & !has_dat20 & !has_dat21 &!has_dat22 &!has_dat23 &!has_dat24;
assign wsel26 = has_dat26 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10 & !has_dat11 & !has_dat12 & !has_dat13 & !has_dat14 & !has_dat15 & !has_dat16 & !has_dat17 & !has_dat18 & !has_dat19 & !has_dat20 & !has_dat21 &!has_dat22 &!has_dat23 &!has_dat24 &!has_dat25;
//assign wsel27 = has_dat27 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10 & !has_dat11 & !has_dat12 & !has_dat13 & !has_dat14 & !has_dat15 & !has_dat16 & !has_dat17 & !has_dat18 & !has_dat19 & !has_dat20 & !has_dat21 &!has_dat22 &!has_dat23 &!has_dat24 &!has_dat25 &!has_dat26;
//assign wsel28 = has_dat28 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10 & !has_dat11 & !has_dat12 & !has_dat13 & !has_dat14 & !has_dat15 & !has_dat16 & !has_dat17 & !has_dat18 & !has_dat19 & !has_dat20 & !has_dat21 &!has_dat22 &!has_dat23 &!has_dat24 &!has_dat25 &!has_dat26 &!has_dat27;
//assign wsel29 = has_dat29 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10 & !has_dat11 & !has_dat12 & !has_dat13 & !has_dat14 & !has_dat15 & !has_dat16 & !has_dat17 & !has_dat18 & !has_dat19 & !has_dat20 & !has_dat21 &!has_dat22 &!has_dat23 &!has_dat24 &!has_dat25 &!has_dat26 &!has_dat27 &!has_dat28;
//assign wsel30 = has_dat30 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10 & !has_dat11 & !has_dat12 & !has_dat13 & !has_dat14 & !has_dat15 & !has_dat16 & !has_dat17 & !has_dat18 & !has_dat19 & !has_dat20 & !has_dat21 &!has_dat22 &!has_dat23 &!has_dat24 &!has_dat25 &!has_dat26 &!has_dat27 &!has_dat28 &!has_dat29;
//assign wsel31 = has_dat31 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10 & !has_dat11 & !has_dat12 & !has_dat13 & !has_dat14 & !has_dat15 & !has_dat16 & !has_dat17 & !has_dat18 & !has_dat19 & !has_dat20 & !has_dat21 &!has_dat22 &!has_dat23 &!has_dat24 &!has_dat25 &!has_dat26 &!has_dat27 &!has_dat28 &!has_dat29 &!has_dat30;
reg start1;
always @ (posedge clk) begin
    sel00 <= wsel00;
    sel01 <= wsel01;
    sel02 <= wsel02;
    sel03 <= wsel03;
    sel04 <= wsel04;
    sel05 <= wsel05;
    sel06 <= wsel06;
    sel07 <= wsel07;
    sel08 <= wsel08;
    sel09 <= wsel09;
    sel10 <= wsel10;
    sel11 <= wsel11;
    sel12 <= wsel12;
    sel13 <= wsel13;
    sel14 <= wsel14;
    sel15 <= wsel15;
    sel16 <= wsel16;
    sel17 <= wsel17;
    sel18 <= wsel18;
    sel19 <= wsel19;
    sel20 <= wsel20;
    sel21 <= wsel21;
    sel22 <= wsel22;
    sel23 <= wsel23;
    sel24 <= wsel24;
    sel25 <= wsel25;
    sel26 <= wsel26;
    start1 <= start;
//    sel27 <= wsel27;
//    sel28 <= wsel28;
//    sel29 <= wsel29;
//    sel30 <= wsel30;
//    sel31 <= wsel31;
   
   // assert 'none' when all inputs are false
    none <= !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 &
            !has_dat10 & !has_dat11 & !has_dat12 & !has_dat13 & !has_dat14 & !has_dat15 & !has_dat16 & !has_dat17 & !has_dat18 & !has_dat19 &
            !has_dat20 & !has_dat21 & !has_dat22 & !has_dat23 & !has_dat24 & !has_dat25 & !has_dat26 /*& !has_dat27 & !has_dat28 & !has_dat29 & !has_dat30 & !has_dat31*/;
end 

//////////////////////////////////////////////////////////////////////////
// Implement an 2:5 encoder. The final mux that combines the memory streams
// works better with with an encoded select as compared to individual select signals.
always @ (posedge clk) begin
    if(none | (~start & ~start1))    sel <= 5'b11111; //there is no phibin 31, so this is a trick to prevent data from being lost prematurely
    //Need to resolve default issue ^^^^^^^^^^^^^^^^^^^^^^^^^^
    else begin
        if (wsel00) sel <= 5'b00000;
        if (wsel01) sel <= 5'b00001;
        if (wsel02) sel <= 5'b00010;
        if (wsel03) sel <= 5'b00011;
        if (wsel04) sel <= 5'b00100;
        if (wsel05) sel <= 5'b00101;
        if (wsel06) sel <= 5'b00110;
        if (wsel07) sel <= 5'b00111;
        if (wsel08) sel <= 5'b01000;
        if (wsel09) sel <= 5'b01001;
        if (wsel10) sel <= 5'b01010;
        if (wsel11) sel <= 5'b01011;
        if (wsel12) sel <= 5'b01100;
        if (wsel13) sel <= 5'b01101;
        if (wsel14) sel <= 5'b01110;
        if (wsel15) sel <= 5'b01111;
        if (wsel16) sel <= 5'b10000;
        if (wsel17) sel <= 5'b10001;
        if (wsel18) sel <= 5'b10010;
        if (wsel19) sel <= 5'b10011;
        if (wsel20) sel <= 5'b10100;
        if (wsel21) sel <= 5'b10101;
        if (wsel22) sel <= 5'b10110;
        if (wsel23) sel <= 5'b10111;
        if (wsel24) sel <= 5'b11000;
        if (wsel25) sel <= 5'b11001;
        if (wsel26) sel <= 5'b11010;
    //    if (wsel27) sel <= 5'b11011;
    //    if (wsel28) sel <= 5'b11100;
    //    if (wsel29) sel <= 5'b11101;
    //    if (wsel30) sel <= 5'b11110;
    //    if (wsel31) sel <= 5'b11111;  
    end       
end
           
endmodule
