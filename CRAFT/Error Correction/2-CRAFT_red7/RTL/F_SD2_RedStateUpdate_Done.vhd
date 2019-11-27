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


entity F_SD2_RedStateUpdate_Done is
    generic (
				LFSR4doneEnc 	: integer; 
				LFSR3doneEnc 	: integer;
				LFSR4doneDec	: integer;
				LFSR3doneDec 	: integer;
				withDec 			: integer;
				StateSize 		: positive ;
				Red_size 		: positive ;
				Count		 		: positive;
				LFTable   		: STD_LOGIC_VECTOR (127 DOWNTO 0);
				LFTable_inv	 	: STD_LOGIC_VECTOR (63 DOWNTO 0);
				SD2Table  		: STD_LOGIC_VECTOR (1023 DOWNTO 0));
				
     Port (	x 								: in  STD_LOGIC_VECTOR (StateSize*Count-1 downto 0);
				redx 							: in  STD_LOGIC_VECTOR (Red_size*Count-1 downto 0);
				EncDec						: in  STD_LOGIC;
				Red_done		 				: out STD_LOGIC_VECTOR (Red_size-1 downto 0);
				Red_a_b		 				: out STD_LOGIC_VECTOR (2*Red_size-1 downto 0);
				y					 			: out STD_LOGIC_VECTOR (Red_size*Count-1 downto 0));
end F_SD2_RedStateUpdate_Done;

architecture Behavioral of F_SD2_RedStateUpdate_Done is

begin
	Red_a_b <= redx;
	
	F_SD2_RedStateUpdate_Done_bit_inst_0: ENTITY work.F_SD2_RedStateUpdate_Done_bit 
		Generic Map (0, LFSR4doneEnc, LFSR3doneEnc, LFSR4doneDec, LFSR3doneDec, withDec, StateSize, Red_size, Count, LFTable, LFTable_inv, SD2Table)
		Port Map (x, redx, EncDec, Red_done(0), open, y(0));
		
	F_SD2_RedStateUpdate_Done_bit_inst_1: ENTITY work.F_SD2_RedStateUpdate_Done_bit 
		Generic Map (1, LFSR4doneEnc, LFSR3doneEnc, LFSR4doneDec, LFSR3doneDec, withDec, StateSize, Red_size, Count, LFTable, LFTable_inv, SD2Table)
		Port Map (x, redx, EncDec, Red_done(1), open, y(1));
		
	
	Gen0: FOR i in 2 to Red_size-1 GENERATE
		
		F_SD2_RedStateUpdate_Done_bit_inst: ENTITY work.F_SD2_RedStateUpdate_Done_bit 
		Generic Map (i, LFSR4doneEnc, LFSR3doneEnc, LFSR4doneDec, LFSR3doneDec, withDec, StateSize, Red_size, Count, LFTable, LFTable_inv, SD2Table)
		Port Map (x, redx, EncDec, open, open, y(i));
		
	END GENERATE;
	
	Gen1: FOR i in Red_size to Count*Red_size-1 GENERATE
		
		F_SD2_RedStateUpdate_Done_bit_inst: ENTITY work.F_SD2_RedStateUpdate_Done_bit 
		Generic Map (i, LFSR4doneEnc, LFSR3doneEnc, LFSR4doneDec, LFSR3doneDec, withDec, StateSize, Red_size, Count, LFTable, LFTable_inv, SD2Table)
		Port Map (x, redx, EncDec, open, open, y(i));
		
	END GENERATE;

end Behavioral;

