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

entity SD1_Xor_StateUpdate_Done_bit is
    generic (BitNumber 		: integer;
			LFSR4doneEnc 	: integer; 
			LFSR3doneEnc 	: integer;
			LFSR4doneDec	: integer;
			LFSR3doneDec 	: integer;
			withDec 			: integer;
			StateSize 		: positive;
			ErrorSize 		: positive;
			DoneSize 		: positive;
			Count		 		: positive;
			SD1Table  		: STD_LOGIC_VECTOR (31 DOWNTO 0));
				
     Port (x 							: in  STD_LOGIC_VECTOR (StateSize*Count-1 downto 0);
           ErrorVec 					: in  STD_LOGIC_VECTOR (ErrorSize*Count-1 downto 0);
			  EncDec						: in  STD_LOGIC;
           a_b			 				: out STD_LOGIC;
           y 							: out STD_LOGIC);
end SD1_Xor_StateUpdate_Done_bit;

architecture Behavioral of SD1_Xor_StateUpdate_Done_bit is

	constant SD1Table0 : STD_LOGIC_VECTOR (7 DOWNTO 0) :=
		SD1Table(28) & SD1Table(24) & SD1Table(20) & SD1Table(16) & SD1Table(12) & SD1Table(8) & SD1Table(4) & SD1Table(0);
	
	constant SD1Table1 : STD_LOGIC_VECTOR (7 DOWNTO 0) :=
		SD1Table(29) & SD1Table(25) & SD1Table(21) & SD1Table(17) & SD1Table(13) & SD1Table(9) & SD1Table(5) & SD1Table(1);

	constant SD1Table2 : STD_LOGIC_VECTOR (7 DOWNTO 0) :=
		SD1Table(30) & SD1Table(26) & SD1Table(22) & SD1Table(18) & SD1Table(14) & SD1Table(10) & SD1Table(6) & SD1Table(2);
		
	constant SD1Table3 : STD_LOGIC_VECTOR (7 DOWNTO 0) :=
		SD1Table(31) & SD1Table(27) & SD1Table(23) & SD1Table(19) & SD1Table(15) & SD1Table(11) & SD1Table(7) & SD1Table(3);
	------------------------------------
	signal SD1Output					: STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal FSMdone						: STD_LOGIC_VECTOR(6 DOWNTO 0);
	signal FSM							: STD_LOGIC_VECTOR(6 DOWNTO 0);
	signal FSMdoneEnc 				: STD_LOGIC_VECTOR (6 downto 0);
	signal FSMdoneDec 				: STD_LOGIC_VECTOR (6 downto 0);
	signal CorrectedFSM				: STD_LOGIC_VECTOR(6 DOWNTO 0);

begin

	SD1_Process0: Process (ErrorVec(ErrorSize*(0+1)-1 downto ErrorSize*0))
		begin
			SD1Output(0) <= SD1Table0(7-to_integer(unsigned(ErrorVec(ErrorSize*(0+1)-1 downto ErrorSize*0))));
		end process;	
	
	SD1_Process1: Process (ErrorVec(ErrorSize*(0+1)-1 downto ErrorSize*0))
		begin
			SD1Output(1) <= SD1Table1(7-to_integer(unsigned(ErrorVec(ErrorSize*(0+1)-1 downto ErrorSize*0))));
		end process;
	
	SD1_Process2: Process (ErrorVec(ErrorSize*(0+1)-1 downto ErrorSize*0))
		begin
			SD1Output(2) <= SD1Table2(7-to_integer(unsigned(ErrorVec(ErrorSize*(0+1)-1 downto ErrorSize*0))));
		end process;
		

		
	---
	
	SD1_Process4: Process (ErrorVec(ErrorSize*(1+1)-1 downto ErrorSize*1))
		begin
			SD1Output(4) <= SD1Table0(7-to_integer(unsigned(ErrorVec(ErrorSize*(1+1)-1 downto ErrorSize*1))));
		end process;	
	
	SD1_Process5: Process (ErrorVec(ErrorSize*(1+1)-1 downto ErrorSize*1))
		begin
			SD1Output(5) <= SD1Table1(7-to_integer(unsigned(ErrorVec(ErrorSize*(1+1)-1 downto ErrorSize*1))));
		end process;
	
	SD1_Process6: Process (ErrorVec(ErrorSize*(1+1)-1 downto ErrorSize*1))
		begin
			SD1Output(6) <= SD1Table2(7-to_integer(unsigned(ErrorVec(ErrorSize*(1+1)-1 downto ErrorSize*1))));
		end process;
		
	SD1_Process7: Process (ErrorVec(ErrorSize*(1+1)-1 downto ErrorSize*1))
		begin
			SD1Output(7) <= SD1Table3(7-to_integer(unsigned(ErrorVec(ErrorSize*(1+1)-1 downto ErrorSize*1))));
		end process;
		
	---
	
	Correcting_b: FOR i in 0 to 2 GENERATE
		CorrectedFSM(i) <= x(i) xor SD1Output(i);
	END GENERATE;

	Correcting_a: FOR i in 4 to 7 GENERATE
		CorrectedFSM(i-1) <= x(i) xor SD1Output(i);
	END GENERATE;
	FSM <= CorrectedFSM;
	---
	GenwithoutDec: IF withDec = 0 GENERATE
		Gen0: IF BitNumber = 0 GENERATE
			y 		<= FSM(1);
			a_b 	<= FSM(1);
			
--			GenwithoutDec: IF withDec = 0 GENERATE
--					FSMdone 		<=	std_logic_vector(to_unsigned(LFSR4doneEnc,4)) & std_logic_vector(to_unsigned(LFSR3doneEnc,3));
--			END GENERATE;
--
--			GenwithDec: IF withDec /= 0 GENERATE
--				FSMdoneEnc 	<=	std_logic_vector(to_unsigned(LFSR4doneEnc,4)) & std_logic_vector(to_unsigned(LFSR3doneEnc,3));
--				FSMdoneDec	<= std_logic_vector(to_unsigned(LFSR4doneDec,4)) & std_logic_vector(to_unsigned(LFSR3doneDec,3));
--
--				FSMdone		<= FSMdoneEnc WHEN EncDec = '0' ELSE FSMdoneDec;
--			END GENERATE;
--
--			done	<= '1' WHEN (FSM = FSMdone) ELSE '0';
			
		END GENERATE;	
		
		Gen1: IF BitNumber = 1 GENERATE 
			y <= FSM(2);
			a_b <= FSM(2);
		END GENERATE;	
		
		Gen2: IF BitNumber = 2 GENERATE
			y <= (FSM(0) XOR FSM(1));
			a_b <= FSM(0);
		END GENERATE;	
		
		------
		
		Gen3: IF BitNumber = 3 GENERATE
			y <= FSM(4);
			a_b <= FSM(4);
		END GENERATE;	
		
		Gen4: IF BitNumber = 4 GENERATE
			y <= FSM(5);
			a_b <= FSM(5);
		END GENERATE;	
		
		Gen5: IF BitNumber = 5 GENERATE
			y <= FSM(6);
			a_b <= FSM(6);
		END GENERATE;	
		
		Gen6: IF BitNumber = 6 GENERATE
			y <= (FSM(3) XOR FSM(4));
			a_b <= FSM(3);
		END GENERATE;		
	END GENERATE;
	
--	GenwithDec: IF withDec /= 0 GENERATE
--		Gen0: IF BitNumber = 0 GENERATE
--			a_b 	<= FSM(6 downto 3) & "0" & FSM(2 downto 0);
--			
--			GenwithoutDec: IF withDec = 0 GENERATE
--					FSMdone 		<=	std_logic_vector(to_unsigned(LFSR4doneEnc,4)) & std_logic_vector(to_unsigned(LFSR3doneEnc,3));
--			END GENERATE;
--
--			GenwithDec: IF withDec /= 0 GENERATE
--				FSMdoneEnc 	<=	std_logic_vector(to_unsigned(LFSR4doneEnc,4)) & std_logic_vector(to_unsigned(LFSR3doneEnc,3));
--				FSMdoneDec	<= std_logic_vector(to_unsigned(LFSR4doneDec,4)) & std_logic_vector(to_unsigned(LFSR3doneDec,3));
--
--				FSMdone		<= FSMdoneEnc WHEN EncDec = '0' ELSE FSMdoneDec;
--			END GENERATE;
--
--			done	<= '1' WHEN (FSM = FSMdone) ELSE '0';
--			
--			y <= FSM(1) WHEN EncDec = '0' ELSE (FSM(0) XOR FSM(2));
--		END GENERATE;	
--		
--		Gen1: IF BitNumber = 1 GENERATE
--			y <= FSM(2) WHEN EncDec = '0' ELSE FSM(0);
--		END GENERATE;	
--		
--		Gen2: IF BitNumber = 2 GENERATE
--			y <= (FSM(0) XOR FSM(1)) WHEN EncDec = '0' ELSE FSM(1);
--		END GENERATE;	
--		
--		------
--		
--		Gen3: IF BitNumber = 3 GENERATE
--			y <= FSM(4) WHEN EncDec = '0' ELSE (FSM(3) XOR FSM(6));
--		END GENERATE;	
--		
--		Gen4: IF BitNumber = 4 GENERATE
--			y <= FSM(5) WHEN EncDec = '0' ELSE FSM(3);
--		END GENERATE;	
--		
--		Gen5: IF BitNumber = 5 GENERATE
--			y <= FSM(6) WHEN EncDec = '0' ELSE FSM(4);
--		END GENERATE;	
--		
--		Gen6: IF BitNumber = 6 GENERATE
--			y <= (FSM(3) XOR FSM(4)) WHEN EncDec = '0' ELSE FSM(5);
--		END GENERATE;	
--	END GENERATE;
	
end Behavioral;

