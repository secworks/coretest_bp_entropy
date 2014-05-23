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

module entropy(clk, nreset, sel, addr, r, w, dwrite, dread);
   input clk, nreset, sel, r;
   input [7:0] addr;
   input [15:0] dwrite;
   input [1:0] 	w;
   output reg [15:0] dread;

   reg [7:0] 	 rng1, rng2; // must be inverse to each other
   wire [15:0] 	 p, n;

   genvar 	 i;

   generate
      for(i=0; i<16; i=i+1) begin: tworoscs
	 rosc px(clk, nreset, rng1, rng2, p[i]);
	 rosc nx(clk, nreset, rng1, rng2, n[i]);
      end
   endgenerate

   always @(posedge clk or negedge nreset)
     if(!nreset) begin
	rng1 <= 8'h55;
	rng2 <= 8'haa;
     end else begin
	if(sel) begin
	   case({ addr[7:1], 1'b0 })
	     8'h00: begin
		if(w[1]) rng1 <= dwrite[15:8];
		if(w[0]) rng2 <= dwrite[7:0];
	     end
	   endcase // case ({ addr[7:1], 1'b0 })
	end
     end // else: !if(!nreset)

   always @*
     if(r & sel)
       case({ addr[7:1], 1'b0 })
	 8'h00: dread = { rng1, rng2 };
	 8'h04: dread = p;
	 8'h06: dread = n;
       endcase // case ({ addr[7:1], 1'b0 })
   
endmodule // entropy

//======================================================================
// EOF entropy.v
//======================================================================


