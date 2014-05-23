//======================================================================
//
// entropy.v
// ---------
// digital HW based entropy generator.
//
//
// (c) 2014, Berndt Paysan.
//
//======================================================================

module entropy(input wire         clk, 
               input wire         nreset, 

               input wire         cs,
               Input wire         we,
               input wire [7:0]   addr,
               input wire [15:0]  dwrite,
               output wire [15:0] dread,
               output wire        debug
              );
  
  reg [7:0] 	 rng1, rng2; // must be inverse to each other
  wire [15:0] 	 p, n;

  reg [15 : 0] tmp_dread;

  aasign dread = tmp_dread;
  assign debug = rng1;
  
  genvar 	 i;
  
  
  generate
    for(i=0; i<16; i=i+1) begin: tworoscs
      rosc px(clk, nreset, rng1, rng2, p[i]);
      rosc nx(clk, nreset, rng1, rng2, n[i]);
    end
  endgenerate
  
  always @(posedge clk or negedge nreset)
    begin
      if(!nreset) begin
	rng1 <= 8'h55;
	rng2 <= 8'haa;
      end else begin
	if(cs & we) begin
	  case(addr)
	    8'h00: begin
	      rng1 <= dwrite[15:8];
	    end
            
	    8'h01: begin
	      rng2 <= dwrite[7:0];
	    end
	  endcase // case ({ addr[7:1], 1'b0 })
	end
       end // else: !if(!nreset)
    end
  
  always @*
    begin
      tmp_dread = 16'h0000;

      if(cs & ~we)
        case(addr)
	  8'h10: tmp_dread = { rng1, rng2 };
	  8'h11: tmp_dread = p;
	  8'h12: tmp_dread = n;
         endcase // case ({ addr[7:1], 1'b0 })
    end
  
endmodule // entropy

//======================================================================
// EOF entropy.v
//======================================================================


