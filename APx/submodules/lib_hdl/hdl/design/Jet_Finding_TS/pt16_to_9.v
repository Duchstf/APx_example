`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2018 02:12:09 PM
// Design Name: 
// Module Name: pt16_to_9
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

//convert the 14 bits of pT to just 9, make sure to time up correctly with the other modules!
module pt16_to_9(
    input clk,
    input reset,
    input valid,
    input [13:0] pt_in,
    output [8:0] pt_out
    );
    
    //pt delayed
    reg [13:0] pt1=0;
    reg [8:0] pt2=0; 
    reg [8:0] pt3=0;
    //valid delayed
    reg val1=0, val2=0;
    always @(posedge clk) begin
        val2 <= val1;
        pt1 <= pt_in;
        if(reset) begin
            pt1 <= 14'b0;
            pt2 <= 9'b0;
            pt3 <= 9'b0;
        end
        else begin
        //if pt coming in is all 0, it isn't a valid track.
            if(pt_in != 14'b0) begin
                val1 <= valid;
            end
            else begin
                val1 <= 1'b0;
            end
            //We are taking in the magnitude of pT, so this is unnecessary.
            //Take absolute value of pt (negative values should be coming in 2's complement form)
            /*if(pt_in[13]) begin
              pt1 <= 14'b11111111111111 - pt_in; //absolute value of pt_in, only if negative
            end
            else begin
              pt1 <= pt_in; //pt delayed by 1
            end
            */
            //if any of bits 9-15 are used, pT is higher than the max we can handle, so set it to max value
            if(pt1[13:9] == 7'b0) begin
                pt2 <= pt1[8:0];
            end
            else begin
                pt2 <= 9'b111111111; //if any of the most significant bits are 1, then we can treat it like this. For our purposes this properly represents the data
            end
            
            if(val2) begin
                pt3 <= pt2; 
            end
            else begin
                pt3 <= 9'b0;
            end
        end
    end
    
    //pt_out must be pt delayed by 3 to time up with t->eta conversion. See if you can cut out a clk later since we are no longer doing the conversion
    assign pt_out = pt3;
    
endmodule
