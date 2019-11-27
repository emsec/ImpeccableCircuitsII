----------------------------------------------------------------------------------
-- COMPANY:		Ruhr University Bochum, Embedded Security
-- AUTHOR:		Aein Rezaei Shahmirzadi, Shahram Rasoolzadeh, Amir Moradi "Impeccable Circuits II" 
----------------------------------------------------------------------------------
-- Copyright (c) 2019, Aein Rezaei Shahmirzadi, Amir Moradi 
-- All rights reserved.

-- BSD-3-Clause License
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
--     * Redistributions of source code must retain the above copyright
--       notice, this list of conditions and the following disclaimer.
--     * Redistributions in binary form must reproduce the above copyright
--       notice, this list of conditions and the following disclaimer in the
--       documentation and/or other materials provided with the distribution.
--     * Neither the name of the copyright holder, their organization nor the
--       names of its contributors may be used to endorse or promote products
--       derived from this software without specific prior written permission.
-- 
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
-- ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
-- WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTERS BE LIABLE FOR ANY
-- DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
-- (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
-- LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
-- ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
-- (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity SD1_Xor_FMulti is
    generic( StateSize : positive := 4;
				OutputSize : positive := 4;
				ErrorSize : positive := 3;
				Count		 : positive := 16;
				LFTable   : STD_LOGIC_VECTOR (63 DOWNTO 0);
				SD1Table  : STD_LOGIC_VECTOR (31 DOWNTO 0)
				);
				
   Port (  x 							: in  STD_LOGIC_VECTOR (StateSize*Count-1 downto 0);
           EncryptionErrorVec 	: in  STD_LOGIC_VECTOR (ErrorSize*Count-1 downto 0);
			  CipherOut 				: out  STD_LOGIC_VECTOR (4*Count-1 downto 0);
           y 							: out STD_LOGIC_VECTOR (OutputSize*Count-1 downto 0));
end SD1_Xor_FMulti;

architecture Behavioral of SD1_Xor_FMulti is

begin


	Gen: FOR i in 0 to OutputSize*Count-1 GENERATE

		
		GEN0: IF (i mod OutputSize)/=0 GENERATE
			
			SD1_Xor_FMulti_bit_inst: ENTITY work.SD1_Xor_FMulti_bit 
			Generic Map ((i mod OutputSize), (i / OutputSize), StateSize, ErrorSize, Count, LFTable, SD1Table)
			Port Map (x, EncryptionErrorVec, open, y(i));
			
		END GENERATE;
		
		GEN1: IF (i mod OutputSize)=0 GENERATE
		
			SD1_Xor_FMulti_bit_inst: ENTITY work.SD1_Xor_FMulti_bit 
			Generic Map ((i mod OutputSize), (i / OutputSize), StateSize, ErrorSize, Count, LFTable, SD1Table)
			Port Map (x, EncryptionErrorVec, CipherOut(StateSize*((i / OutputSize)+1)-1 downto StateSize*(i / OutputSize)), y(i));
				
		END GENERATE;
		
		
	END GENERATE;
	
	
end Behavioral;

