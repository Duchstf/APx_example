`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/10/2016 04:38:59 PM
// Design Name: 
// Module Name: FoundJets
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

//write all final clusters to memory so they can be read out at end of the event
module FoundJets(
    input clk,
    input reset,
    input valid,
    input [31:0] din,
    input [7:0]  addr,
    
    output [31:0] dout,
    output [7:0]  num
    );
    
    reg new_event=0;
    reg [7:0] addra; //increments with each valid
    always @(posedge clk) begin
      if(reset | new_event) begin
        addra <= 8'b0;
      end
      else
        if(valid) begin
          addra <= addra + 1;
        end
    end
    
    reg [7:0] num_reg;
    reg [7:0] num_reg1;
    always @(posedge clk) begin
      num_reg <= addra;
      num_reg1 <= num_reg;
      //ready for a new event once all data from this event has been read.
      if(addr == 1) begin //addr == num_reg1 && num_reg1 != 0
         new_event <= 1;
      end
      else begin
         new_event <= 0;
      end
    end
    assign num = num_reg;
    
    Memory #(  
        .RAM_WIDTH(32),
        .RAM_DEPTH(256),
       .RAM_PERFORMANCE("HIGH_PERFORMANCE")
      ) jet_mem
      (
        .clka(clk),
        .clkb(clk),
        .addra(addra),
        .dina(din),
        .wea (valid),
        
        .rstb(reset),
        .enb(1'b1),
        .regceb(1'b1),
        .addrb(addr),
        .doutb(dout)
      );
     
endmodule
