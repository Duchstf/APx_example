`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2017 06:57:26 PM
// Design Name: 
// Module Name: tracklet_L2_tb
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

module jet_finding_tb_TS(
     );
    parameter nevents = 109;
    reg clk = 0;

    reg start = 0;
    reg reset = 0;
    wire [1:0] LEDs;

    
    integer i;
    integer j;
    integer k;
    integer i2;
    integer outfile;
    integer outfile2;
    reg [11:0] count=0;
    wire [17:0] all_valid;
    wire jet_ready;
    wire track_in_valid = (all_valid != 17'b0 & start) | count == 0;
    parameter ntracks = 7000; //how many lines in each phi slice
        
    reg [95:0] phi0_n [ntracks-1:0];
    reg [95:0] phi1_n [ntracks-1:0];
    reg [95:0] phi2_n [ntracks-1:0];
    reg [95:0] phi3_n [ntracks-1:0];
    reg [95:0] phi4_n [ntracks-1:0];
    reg [95:0] phi5_n [ntracks-1:0];
    reg [95:0] phi6_n [ntracks-1:0];
    reg [95:0] phi7_n [ntracks-1:0];
    reg [95:0] phi8_n [ntracks-1:0];
    reg [95:0] phi0_p [ntracks-1:0];
    reg [95:0] phi1_p [ntracks-1:0];
    reg [95:0] phi2_p [ntracks-1:0];
    reg [95:0] phi3_p [ntracks-1:0];
    reg [95:0] phi4_p [ntracks-1:0];
    reg [95:0] phi5_p [ntracks-1:0];
    reg [95:0] phi6_p [ntracks-1:0];
    reg [95:0] phi7_p [ntracks-1:0];
    reg [95:0] phi8_p [ntracks-1:0];
    
    always begin
      #1 clk <= !clk;
    end
    
    always @(posedge clk) begin
        if(start && /*(track_in_valid ||*/ jet_ready/*)*/) begin
            if(count != 12'b111111111111)
                count <= count + 1;
        end
    end
    
    initial begin
        //INITIALIZE THE TRACKS_IN MEMORIES!
        $readmemh("phi0_n.dat", phi0_n);
        $readmemh("phi1_n.dat", phi1_n);
        $readmemh("phi2_n.dat", phi2_n);
        $readmemh("phi3_n.dat", phi3_n);
        $readmemh("phi4_n.dat", phi4_n);
        $readmemh("phi5_n.dat", phi5_n);
        $readmemh("phi6_n.dat", phi6_n);
        $readmemh("phi7_n.dat", phi7_n);
        $readmemh("phi8_n.dat", phi8_n);
        $readmemh("phi0_p.dat", phi0_p);
        $readmemh("phi1_p.dat", phi1_p);
        $readmemh("phi2_p.dat", phi2_p);
        $readmemh("phi3_p.dat", phi3_p);
        $readmemh("phi4_p.dat", phi4_p);
        $readmemh("phi5_p.dat", phi5_p);
        $readmemh("phi6_p.dat", phi6_p);
        $readmemh("phi7_p.dat", phi7_p);
        $readmemh("phi8_p.dat", phi8_p);
        
      #10 reset <= 1;
      #10 reset <= 0;
      #10
      start <= 1;
      #15000 start <= 0;
                
    end
    wire [31:0] final_cluster;
    wire final_cluster_valid;
    reg [95:0] track_in[17:0];
   
  
     wire [95:0] track_in0_n = phi0_n[count]   ;
     wire [95:0] track_in1_n = phi1_n[count]   ;
     wire [95:0] track_in2_n = phi2_n[count]   ;
     wire [95:0] track_in3_n = phi3_n[count]   ;
     wire [95:0] track_in4_n = phi4_n[count]   ;
     wire [95:0] track_in5_n = phi5_n[count]   ;
     wire [95:0] track_in6_n = phi6_n[count]   ;
     wire [95:0] track_in7_n = phi7_n[count]   ;
     wire [95:0] track_in8_n = phi8_n[count]   ;
     wire [95:0] track_in0_p = phi0_p[count]   ;
     wire [95:0] track_in1_p = phi1_p[count]   ;
     wire [95:0] track_in2_p = phi2_p[count]   ;
     wire [95:0] track_in3_p = phi3_p[count]   ;
     wire [95:0] track_in4_p = phi4_p[count]   ;
     wire [95:0] track_in5_p = phi5_p[count]   ;
     wire [95:0] track_in6_p = phi6_p[count]   ;
     wire [95:0] track_in7_p = phi7_p[count]   ;
     wire [95:0] track_in8_p = phi8_p[count]   ;


     assign all_valid[0 ] =phi0_n[count] != 96'b0; 
     assign all_valid[1 ] =phi1_n[count] != 96'b0;
     assign all_valid[2 ] =phi2_n[count] != 96'b0;
     assign all_valid[3 ] =phi3_n[count] != 96'b0;
     assign all_valid[4 ] =phi4_n[count] != 96'b0;
     assign all_valid[5 ] =phi5_n[count] != 96'b0;
     assign all_valid[6 ] =phi6_n[count] != 96'b0;
     assign all_valid[7 ] =phi7_n[count] != 96'b0;
     assign all_valid[8 ] =phi8_n[count] != 96'b0;
     assign all_valid[9 ] =phi0_p[count] != 96'b0;
     assign all_valid[10] =phi1_p[count] != 96'b0;
     assign all_valid[11] =phi2_p[count] != 96'b0;
     assign all_valid[12] =phi3_p[count] != 96'b0;
     assign all_valid[13] =phi4_p[count] != 96'b0;
     assign all_valid[14] =phi5_p[count] != 96'b0;
     assign all_valid[15] =phi6_p[count] != 96'b0;
     assign all_valid[16] =phi7_p[count] != 96'b0;
     assign all_valid[17] =phi8_p[count] != 96'b0;


       reg [95:0] track_in0_n_1   ;
       reg [95:0] track_in1_n_1   ;
       reg [95:0] track_in2_n_1   ;
       reg [95:0] track_in3_n_1   ;
       reg [95:0] track_in4_n_1   ;
       reg [95:0] track_in5_n_1   ;
       reg [95:0] track_in6_n_1   ;
       reg [95:0] track_in7_n_1   ;
       reg [95:0] track_in8_n_1   ;
       reg [95:0] track_in0_p_1   ;
       reg [95:0] track_in1_p_1  ;
       reg [95:0] track_in2_p_1  ;
       reg [95:0] track_in3_p_1  ;
       reg [95:0] track_in4_p_1  ;
       reg [95:0] track_in5_p_1  ;
       reg [95:0] track_in6_p_1  ;
       reg [95:0] track_in7_p_1  ;
       reg [95:0] track_in8_p_1  ;

      reg track_in_valid_1;
   always @(posedge clk) begin
            track_in0_n_1  <= track_in0_n;
            track_in1_n_1  <= track_in1_n;
            track_in2_n_1  <= track_in2_n;
            track_in3_n_1  <= track_in3_n;
            track_in4_n_1  <= track_in4_n;
            track_in5_n_1  <= track_in5_n;
            track_in6_n_1  <= track_in6_n;
            track_in7_n_1  <= track_in7_n;
            track_in8_n_1  <= track_in8_n;
            track_in0_p_1  <= track_in0_p;
            track_in1_p_1  <= track_in1_p;
            track_in2_p_1  <= track_in2_p;
            track_in3_p_1  <= track_in3_p;
            track_in4_p_1  <= track_in4_p;
            track_in5_p_1  <= track_in5_p;
            track_in6_p_1  <= track_in6_p;
            track_in7_p_1  <= track_in7_p;
            track_in8_p_1  <= track_in8_p;
            
            track_in_valid_1 <= start; //track_in_valid; 
   end
    
    jet_finding_top2 U2 (
                  .s_clk(clk),
    
                  .start(start),                          //register 0x6201e000
                  .reset(reset),                          //register 0x6201e004
         
      //tracks of each phibin
            .track_in0_n(track_in0_n_1),
            .track_in1_n(track_in1_n_1),
            .track_in2_n(track_in2_n_1),
            .track_in3_n(track_in3_n_1),
            .track_in4_n(track_in4_n_1),
            .track_in5_n(track_in5_n_1),
            .track_in6_n(track_in6_n_1),
            .track_in7_n(track_in7_n_1),
            .track_in8_n(track_in8_n_1),
            .track_in0_p(track_in0_p_1),
            .track_in1_p(track_in1_p_1),
            .track_in2_p(track_in2_p_1),
            .track_in3_p(track_in3_p_1),
            .track_in4_p(track_in4_p_1),
            .track_in5_p(track_in5_p_1),
            .track_in6_p(track_in6_p_1),
            .track_in7_p(track_in7_p_1),
            .track_in8_p(track_in8_p_1),
            .vld_in(track_in_valid_1), //added delay by one clk    
           
            .rdy_out(jet_ready),  //able to receive new signals
            
            .dout(final_cluster),
            .rdy_in(1'b1),   //currently always 1
            .vld_out(final_cluster_valid)
         );
                    
endmodule
