//////////////////////////////////////////////////////////////////////////////////
// COMPANY:		Ruhr University Bochum, Embedded Security
// AUTHOR:		Aein Rezaei Shahmirzadi, Shahram Rasoolzadeh, Amir Moradi "Impeccable Circuits II" 
//////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, Aein Rezaei Shahmirzadi, Amir Moradi 
// All rights reserved.
//
// BSD-3-Clause License
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in the
//       documentation and/or other materials provided with the distribution.
//     * Neither the name of the copyright holder, their organization nor the
//       names of its contributors may be used to endorse or promote products
//       derived from this software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTERS BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

`timescale 1ns / 1ps

module Cipher_tb;

	// Inputs
	reg clk;
	reg rst;
	reg EncDec;
	reg [63:0] Input;
	reg [127:0] Key;
	reg [63:0] Tweak;

	// Outputs
	wire [63:0] Output;
	wire done;
	
	reg [63:0] correct_output;
	// Instantiate the Unit Under Test (UUT)
	Cipher uut (
		.clk(clk), 
		.rst(rst), 
		.EncDec(EncDec), 
		.Input(Input), 
		.Key(Key), 
		.Tweak(Tweak), 
		.Output(Output), 
		.done(done)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		EncDec = 0;
		Input = 64'h0123456789ABCDEF;
		Key = 128'h18F4EEBDFCED7841D9E0E38CFE6A9405;
		Tweak = 64'h0000000000000000;

		// Wait 100 ns for global reset to finish
		#100;
      rst = 0;
		correct_output = 64'h614D03B82A8A2817;
		// Add stimulus here
		@(posedge done) begin
			@(negedge clk) begin 
				if(Output == correct_output) begin
					$write("------------------PASS---------------\n");
				end
				else begin
					$write("\------------------FAIL---------------\n");
					$write("%x\n%x\n",Output,correct_output);
				end
				$stop;
			end	
		end
		
	end
	always #5 clk = ~clk;
endmodule
