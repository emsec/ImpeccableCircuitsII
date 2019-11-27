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

entity F_SD1_StateUpdate_Done is
		generic (LFSR4doneEnc 	: integer;
				LFSR3doneEnc 	: integer;
				LFSR4doneDec	: integer;
				LFSR3doneDec 	: integer;
				withDec 			: integer;
				StateSize 		: positive;
				Red_size 		: positive;
				Count		 		: positive;
				SD1Table  	: STD_LOGIC_VECTOR (511 DOWNTO 0));
				
     Port (x 							: in  STD_LOGIC_VECTOR (StateSize*Count-1 downto 0);
           ErrorVec 	 				: in  STD_LOGIC_VECTOR (Red_size*Count-1 downto 0);
			  EncDec						: in  STD_LOGIC;
           done		 				: out STD_LOGIC;
			  a_b			 				: out STD_LOGIC_VECTOR (7 downto 0);
           y 							: out STD_LOGIC_VECTOR (6 downto 0));
			  
end F_SD1_StateUpdate_Done;

architecture Behavioral of F_SD1_StateUpdate_Done is
	signal LFSROutput 	: STD_LOGIC_VECTOR (6 downto 0);
	signal FSMdone		 	: STD_LOGIC_VECTOR (6 downto 0);
	signal FSMdoneEnc		: STD_LOGIC_VECTOR (6 downto 0);
	signal FSMdoneDec	 	: STD_LOGIC_VECTOR (6 downto 0);
begin
	a_b <= LFSROutput(6 downto 3) & "0" & LFSROutput(2 downto 0);
	
	
	SD1_StateUpdate_Done_bit_0: ENTITY work.F_SD1_StateUpdate_Done_bit 
	Generic Map (0, LFSR4doneEnc, LFSR3doneEnc, LFSR4doneDec, LFSR3doneDec, withDec, StateSize, Red_size, Count, SD1Table)
	Port Map (x, ErrorVec, EncDec, LFSROutput(1), y(0));
	
	SD1_StateUpdate_Done_bit_1: ENTITY work.F_SD1_StateUpdate_Done_bit 
	Generic Map (1, LFSR4doneEnc, LFSR3doneEnc, LFSR4doneDec, LFSR3doneDec, withDec, StateSize, Red_size, Count, SD1Table)
	Port Map (x, ErrorVec, EncDec, LFSROutput(2), y(1));
	
	SD1_StateUpdate_Done_bit_2: ENTITY work.F_SD1_StateUpdate_Done_bit 
	Generic Map (2, LFSR4doneEnc, LFSR3doneEnc, LFSR4doneDec, LFSR3doneDec, withDec, StateSize, Red_size, Count, SD1Table)
	Port Map (x, ErrorVec, EncDec, LFSROutput(0), y(2));
	
	Gen1: FOR i in 3 to 5 GENERATE
		
			SD1_StateUpdate_Done_bit_inst: ENTITY work.F_SD1_StateUpdate_Done_bit 
			Generic Map (i, LFSR4doneEnc, LFSR3doneEnc, LFSR4doneDec, LFSR3doneDec, withDec, StateSize, Red_size, Count, SD1Table)
			Port Map (x, ErrorVec, EncDec, LFSROutput(i+1), y(i));
		
	END GENERATE;
	
	SD1_StateUpdate_Done_bit_6: ENTITY work.F_SD1_StateUpdate_Done_bit 
	Generic Map (6, LFSR4doneEnc, LFSR3doneEnc, LFSR4doneDec, LFSR3doneDec, withDec, StateSize, Red_size, Count, SD1Table)
	Port Map (x, ErrorVec, EncDec, LFSROutput(3), y(6));
	
	
	GenwithoutDec: IF withDec = 0 GENERATE
			FSMdone 		<=	std_logic_vector(to_unsigned(LFSR4doneEnc,4)) & std_logic_vector(to_unsigned(LFSR3doneEnc,3));
	END GENERATE;

	GenwithDec: IF withDec /= 0 GENERATE
		FSMdoneEnc 	<=	std_logic_vector(to_unsigned(LFSR4doneEnc,4)) & std_logic_vector(to_unsigned(LFSR3doneEnc,3));
		FSMdoneDec	<= std_logic_vector(to_unsigned(LFSR4doneDec,4)) & std_logic_vector(to_unsigned(LFSR3doneDec,3));

		FSMdone		<= FSMdoneEnc WHEN EncDec = '0' ELSE FSMdoneDec;
	END GENERATE;

	done	<= '1' WHEN (LFSROutput = FSMdone) ELSE '0';

end Behavioral;

