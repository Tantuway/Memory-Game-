`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:  MAYANK TANTUWAY 
// 
// Create Date: 23.10.2019 15:42:07
// Design Name: 
// Module Name: memgame
// Project Name: MEMORY GAME 
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


module memgame(
    input [3:0] predict,
    input clk,
    input startIN,
    input loadIN,
    
    output reg [7:0] led
    );
    
    reg clk_10ms =1'b0 ;
    reg clk_1s   =1'b0;
    reg clk_2s   =1'b0;
    reg [19:0]count_clk = 20'b0 ; 
    reg [6:0]count_clk10ms = 7'b0;
    reg [2:0]count_reset=3'b0;
    reg reset=1'b0;
    reg [1:0]monitor_reset=2'b0;
    
    always@(posedge clk)
        begin 
        if(count_reset<3'b111)
            begin 
            count_reset=count_reset+1;
            end
        else if(monitor_reset<2'b10)
            begin 
            count_reset=3'b0;
            reset=~reset;
            monitor_reset=monitor_reset+1;
            end
        else 
            begin 
            count_reset=3'b0;
            end
        end

    /////////////////////////
    /// always block to get a clock of 10ms from input 100MHZ clk
	always @ (posedge clk ) 
		begin 
		if (count_clk < 19'b1111010000100011111)   //  49,9999
			begin 
				count_clk = count_clk +1 ;
			end 
		else 
			begin 
				clk_10ms = ~clk_10ms ;
				count_clk = 20'b0;
			end 
		end 
    always @ (posedge clk_10ms ) 
		begin 
		if (count_clk10ms < 7'b1111111)   // clk_1s=1.28sec.
			begin 
				count_clk10ms = count_clk10ms +1 ;
			end 
		else 
			begin 
				clk_1s = ~clk_1s ;
				count_clk10ms = 7'b0;
			end 
		end 
    
    ///////////////////////////
       
//////////////////////
    always @(posedge clk_1s)       
        begin 
        clk_2s = ~clk_2s;
             
        end      
////
    wire startOUT;
    wire load;
    debounce FIRST ( clk_10ms , startIN  , startOUT);
	debounce SECOND ( clk_10ms , loadIN  , load);
	
	reg start=1'b0;
	always@(posedge clk_10ms )
	   if(startOUT)start=1'b1;
	   
/// 
    //wire [3:0]rand = 4'b0000;
    reg on = 1'b0;
    reg result_count =1'b0;
    reg on_display = 1'b0;
    reg read =1'b0;
    reg clk_lfsr = 1'b0;
    reg [2:0]count = 3'b000;
    
      

   always @(posedge start)
    begin 
    on <= ~on ; 
    led <= 8'b0000_0000;
    end
    
    
    
    always@*        // when on run at 2sec else run fast 
    if(on)
        clk_lfsr=clk_2s;
     else
        begin  
        clk_lfsr=clk_10ms;
        end 
        
   //lfsr i1 (rand,clk,reset);
   ///////// lfsr ////// 
 

   reg [3:0] lfsr_out;
   reg [3:0]rand1;
   reg [3:0]rand2;
   reg [3:0]rand3;

   
   wire feedback;

  assign feedback = ~(lfsr_out[3] ^ lfsr_out[2]);
    reg [1:0]i=2'b0;
always @(posedge clk_10ms, posedge reset)
  begin
    if (reset)
      lfsr_out = 4'b0;
    else
        begin 
        lfsr_out = {lfsr_out[2:0],feedback};
        if(on)
            begin 
                if(i==2'b00)
                begin 
                    rand1=lfsr_out;
                    i=i+1;
                end
                else if(i==2'b01)
                begin 
                    rand2=lfsr_out;
                    i=i+1;
                end
                else if(i==2'b10)
                begin 
                    rand3=lfsr_out;
                    i=i+1;
                    on_display=~on_display;
                end
             end
        end
  end

   
   
   ////////////
    
    always @(posedge clk_2s)
    begin 
        if(on_display)
        begin 
            if(count==3'b000)
             begin
             led[0] <= rand1[0];
             led[1] <= rand1[1];
             led[2] <= rand1[2];
             led[3] <= rand1[3];
             led[4] <= 1'b0;
             led[5] <= 1'b0;
             led[6] <= 1'b0;
             led[7] <= 1'b0;
             
             count = count +1;
             end
             else if(count==3'b001)
             begin
             led[0] <= rand2[0];
             led[1] <= rand2[1];
             led[2] <= rand2[2];
             led[3] <= rand2[3];
             led[4] <= 1'b0;
             led[5] <= 1'b0;
             led[6] <= 1'b0;
             led[7] <= 1'b0;
             
             count = count +1;
             end
             else if(count==3'b010)
             begin
             led[0] <= rand3[0];
             led[1] <= rand3[1];
             led[2] <= rand3[2];
             led[3] <= rand3[3];
             led[4] <= 1'b0;
             led[5] <= 1'b0;
             led[6] <= 1'b0;
             led[7] <= 1'b0;
             
             count = count +1;
             end
            else if(count == 3'b011)
             begin 
             led=8'b1111_1111;   
             count = count +1;
             end
            else
             begin 
             led = 8'b0000_0000;
             on = ~on;
             on_display = ~on_display;
             read = ~read;
             end 
        end
    end
    
  always @(posedge clk_10ms)
    begin 
        if(read)
            begin 
            
                    led[0] <= predict[0];
                    led[1] <= predict[1];
                    led[2] <= predict[2];
                    led[3] <= predict[3];
                    led[4] <= 1'b0;
                    led[5] <= 1'b0;
                    led[6] <= 1'b0;
                    led[7] <= 1'b0;
            end
      
    end  
 reg [3:0]take1;
 reg [3:0]take2;
 reg [3:0]take3; 
 reg [2:0]takecount=3'b000;
 always @(posedge read, posedge load)
    begin 
        if(read)
            begin 
            if(load)
                begin 
                if(takecount==3'b000)
                    begin 
                    take1=predict;
                    takecount=takecount+1;
                    end
                else if(takecount==3'b001)
                    begin 
                    take2=predict;
                    takecount=takecount+1;
                    end
               else if(takecount==3'b010)
                    begin 
                    take3=predict;
                    takecount=takecount+1;
                    
                    
                    end
               else if(takecount==3'b011)
                    begin 
                    result_count=~result_count;
                    takecount=takecount+1;
                    read=~read;
                    end
 
                end
            end
    end 
always @(posedge clk_1s,posedge load)
    begin 
        if(result_count)
        begin 
            if(load)
                begin 
        ///////////////////result 
             
             if((rand1==take1)&&(rand2==take2)&&(rand3==take3))
             led<=8'b1111_1111;
             else if ((rand1==take2)&&(rand2==take1)&&(rand3==take3))
             led<=8'b1010_1010;
             else if ((rand1==take3)&&(rand2==take2)&&(rand3==take1))
             led<=8'b1010_1010;
             else if ((rand1==take1)&&(rand2==take3)&&(rand3==take2))
             led<=8'b1010_1010;
             else if ((rand1==take2)&&(rand2==take3)&&(rand3==take1))
             led<=8'b1010_1010;
             else if ((rand1==take3)&&(rand2==take1)&&(rand3==take2))
             led<=8'b1010_1010;
             else
             led<=8'b0000_1111;
 
             
        ///////////////////
                end 
        end
    end    
endmodule




module debounce (input clk ,
		 input   PBI ,                // Push Butoon Input   
		 output  reg PBO  );          // Push Butoon Output

	reg  [9:0]count ; 

	//

	always @ (posedge clk or negedge PBI )
	begin 
		if (PBI==0) 
		begin 
			count <= 10'b0 ;
		end 
		else 
		begin 
			count = count +1 ;
		end 
	end 



	
	always @ * 
	begin 
		if ( count >  10'b0000000011 )    ////  30ms check 
		begin 	 PBO <= 1'b1 ; end 
		else 
		begin  PBO <= 1'b0 ;end 
	end
       


endmodule
