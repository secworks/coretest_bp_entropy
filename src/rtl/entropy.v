//======================================================================
//
// entropy.v
// ---------
// digital HW based entropy generator.
//
//
// (c) 2014, Berndt Paysan, Joachim Strömbergson
//
//======================================================================

module entropy(input wire          clk, 
               input wire          nreset, 

               input wire          cs,
               input wire          we,
               input wire [7:0]    addr,
               input wire [15:0]   dwrite,
               output wire [15:0]  dread,
               output wire [7 : 0] debug
              );

  //----------------------------------------------------------------
  //----------------------------------------------------------------
  parameter DELAY_MAX             = 32'h004c4b40;

  parameter ADDR_ENT_WR_RNG1      = 8'h00;
  parameter ADDR_ENT_WR_RNG2      = 8'h01;
  
  parameter ADDR_ENT_RD_RNG1_RNG2 = 8'h10;
  parameter ADDR_ENT_RD_P         = 8'h11;
  parameter ADDR_ENT_RD_N         = 8'h12;

  
  //----------------------------------------------------------------
  //----------------------------------------------------------------
  reg [7:0]    rng1, rng2; // must be inverse to each other
  reg [31 : 0] delay_ctr_reg;  
  reg [31 : 0] delay_ctr_new;  
  reg [7 : 0]  debug_reg;

  wire [15:0] 	 p, n;
  reg [15 : 0] tmp_dread;
  
  
  //----------------------------------------------------------------
  //----------------------------------------------------------------
  genvar i;
  generate
    for(i=0; i<16; i=i+1) begin: tworoscs
      rosc px(clk, nreset, rng1, rng2, p[i]);
      rosc nx(clk, nreset, rng1, rng2, n[i]);
    end
  endgenerate

  
  //----------------------------------------------------------------
  //----------------------------------------------------------------
  assign dread = tmp_dread;
  assign debug = debug_reg;

  
  //----------------------------------------------------------------
  // reg updates
  //----------------------------------------------------------------
  always @(posedge clk or negedge nreset)
    begin
      if(!nreset) 
        begin
	  rng1          <= 8'h55;
	  rng2          <= 8'haa;
          delay_ctr_reg <= 32'h00000000;
          debug_reg     <= 8'h00;
        end 
      else 
        begin
          delay_ctr_reg <= delay_ctr_new;

          if (delay_ctr_reg == 32'h00000000)
            begin
              debug_reg <= n[7 : 0];
            end
          
	  if(cs & we) begin
	    case(addr)
	      ADDR_ENT_WR_RNG1: rng1 <= dwrite[15:8];
	      ADDR_ENT_WR_RNG2: rng2 <= dwrite[7:0];
              default:;
	    endcase
	  end
        end // else: !if(!nreset)
    end

  
  //----------------------------------------------------------------
  // read_data
  //----------------------------------------------------------------
  always @*
    begin : read_data
      tmp_dread = 16'h0000;

      if(cs & ~we)
        case(addr)
	  ADDR_ENT_RD_RNG1_RNG2: tmp_dread = { rng1, rng2 };
	  ADDR_ENT_RD_P:         tmp_dread = p;
	  ADDR_ENT_RD_N:         tmp_dread = n;
          default:;
         endcase
    end


  //----------------------------------------------------------------
  // delay_ctr
  //
  // Simple counter that counts to DELAY_MAC. Used to slow down
  // the debug port updates to human speeds.
  //----------------------------------------------------------------
  always @*
    begin : delay_ctr
      if (delay_ctr_reg == DELAY_MAX)
        begin
          delay_ctr_new = 32'h00000000;
        end
      else
        begin
          delay_ctr_new = delay_ctr_reg + 1'b1;
        end
    end // delay_ctr
  
endmodule // entropy

//======================================================================
// EOF entropy.v
//======================================================================
