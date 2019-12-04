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


entity SD1_Xor_RedStateUpdate_Done_bit is
    generic (BitNumber 		: integer;
			LFSR4doneEnc 	: integer; 
			LFSR3doneEnc 	: integer;
			LFSR4doneDec	: integer;
			LFSR3doneDec 	: integer;
			withDec 		: integer;
			StateSize 		: positive;
			ErrorSize 		: positive;
			Red_Size 		: positive;
			Count		 	: positive;
			LFTable    		: STD_LOGIC_VECTOR (63 DOWNTO 0);
			SD1Table  		: STD_LOGIC_VECTOR (31 DOWNTO 0));
				
     Port (	x 							: in  STD_LOGIC_VECTOR (StateSize*Count-1 downto 0);
			ErrorVec 					: in  STD_LOGIC_VECTOR (ErrorSize*Count-1 downto 0);
			EncDec					: in  STD_LOGIC;
           Red_FSMUpdateBit 			: out STD_LOGIC);
end SD1_Xor_RedStateUpdate_Done_bit;

architecture Behavioral of SD1_Xor_RedStateUpdate_Done_bit is

	constant LFTable0 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		LFTable(60) & LFTable(56) & LFTable(52) & LFTable(48) & LFTable(44) & LFTable(40) & LFTable(36) & LFTable(32) &
		LFTable(28) & LFTable(24) & LFTable(20) & LFTable(16) & LFTable(12) & LFTable(8) & LFTable(4) & LFTable(0);
	
	constant LFTable1 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		LFTable(61) & LFTable(57) & LFTable(53) & LFTable(49) & LFTable(45) & LFTable(41) & LFTable(37) & LFTable(33) &
		LFTable(29) & LFTable(25) & LFTable(21) & LFTable(17) & LFTable(13) & LFTable(9) & LFTable(5) & LFTable(1);

	constant LFTable2 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		LFTable(62) & LFTable(58) & LFTable(54) & LFTable(50) & LFTable(46) & LFTable(42) & LFTable(38) & LFTable(34) &
		LFTable(30) & LFTable(26) & LFTable(22) & LFTable(18) & LFTable(14) & LFTable(10) & LFTable(6) & LFTable(2);

	----
	
	constant SD1Table0 : STD_LOGIC_VECTOR (7 DOWNTO 0) :=
		SD1Table(28) & SD1Table(24) & SD1Table(20) & SD1Table(16) & SD1Table(12) & SD1Table(8) & SD1Table(4) & SD1Table(0);
	
	constant SD1Table1 : STD_LOGIC_VECTOR (7 DOWNTO 0) :=
		SD1Table(29) & SD1Table(25) & SD1Table(21) & SD1Table(17) & SD1Table(13) & SD1Table(9) & SD1Table(5) & SD1Table(1);

	constant SD1Table2 : STD_LOGIC_VECTOR (7 DOWNTO 0) :=
		SD1Table(30) & SD1Table(26) & SD1Table(22) & SD1Table(18) & SD1Table(14) & SD1Table(10) & SD1Table(6) & SD1Table(2);
		
	constant SD1Table3 : STD_LOGIC_VECTOR (7 DOWNTO 0) :=
		SD1Table(31) & SD1Table(27) & SD1Table(23) & SD1Table(19) & SD1Table(15) & SD1Table(11) & SD1Table(7) & SD1Table(3);
	------------------------------------
	signal done_internal				: STD_LOGIC_VECTOR(ErrorSize-1 DOWNTO 0);
	signal SD1Output					: STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal FSMdone						: STD_LOGIC_VECTOR(6 DOWNTO 0);
	signal FSM							: STD_LOGIC_VECTOR(6 DOWNTO 0);
	signal FSMdoneEnc 				: STD_LOGIC_VECTOR (6 downto 0);
	signal FSMdoneDec 				: STD_LOGIC_VECTOR (6 downto 0);
	signal CorrectedFSM				: STD_LOGIC_VECTOR(6 DOWNTO 0);
	signal FSMUpdate					: STD_LOGIC_VECTOR(6 downto 0);
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
	
	Gen0_to_3: IF BitNumber < Red_size GENERATE
--		GenwithoutDec1: IF withDec = 0 GENERATE
--				FSMdone 	<=	std_logic_vector(to_unsigned(LFSR4doneEnc,4)) & std_logic_vector(to_unsigned(LFSR3doneEnc,3));
--		END GENERATE;
--
--		GenwithDec1: IF withDec /= 0 GENERATE
--			FSMdoneEnc 	<=	std_logic_vector(to_unsigned(LFSR4doneEnc,4)) & std_logic_vector(to_unsigned(LFSR3doneEnc,3));
--			FSMdoneDec	<=  std_logic_vector(to_unsigned(LFSR4doneDec,4)) & std_logic_vector(to_unsigned(LFSR3doneDec,3));
--
--			FSMdone		<= FSMdoneEnc WHEN EncDec = '0' ELSE FSMdoneDec;
--		END GENERATE;
--		done_internal(0)	<= '1' WHEN (FSM = FSMdone) ELSE '0';
--		done_internal(ErrorSize-1 downto 1) <= (others => '0');
		
		
		GenwithoutDec: IF withDec = 0 GENERATE
			FSMUpdate(0) <= FSM(1);
			FSMUpdate(1) <= FSM(2);
			FSMUpdate(2) <= (FSM(0) XOR FSM(1));
			FSMUpdate(3) <= '0';		
		END GENERATE;	

--		GenwithDec: IF withDec /= 0 GENERATE
--			FSMUpdate(0) <= FSM(1) 					WHEN EncDec = '0' ELSE (FSM(0) XOR FSM(2));
--			FSMUpdate(1) <= FSM(2) 					WHEN EncDec = '0' ELSE FSM(0);
--			FSMUpdate(2) <= (FSM(0) XOR FSM(1)) 	WHEN EncDec = '0' ELSE FSM(1);
--			FSMUpdate(3) <= '0';
--		END GENERATE;	
		
		--------------------------
		
		GEN0: IF BitNumber=0 GENERATE
			LF_Process: Process (FSMUpdate)
			begin
				Red_FSMUpdateBit <= LFTable0(15-to_integer(unsigned(FSMUpdate(3 downto 0))));
			end process;	
		END GENERATE;

		GEN1: IF BitNumber=1 GENERATE
			
			LF_Process: Process (FSMUpdate)
			begin
				Red_FSMUpdateBit <= LFTable1(15-to_integer(unsigned(FSMUpdate(3 downto 0))));
				Red_FSMUpdateBit <= FSMUpdate(1) xor FSMUpdate(0);
			end process;	
		END GENERATE;

		GEN2: IF BitNumber=2 GENERATE

			LF_Process: Process (FSMUpdate)
			begin
				Red_FSMUpdateBit <= FSMUpdate(2) xor FSMUpdate(0);
			end process;	
		END GENERATE;		
	END GENERATE;	
	
	---
	
	Gen4_to_7: IF BitNumber >= Red_size GENERATE
		GenwithoutDec: IF withDec = 0 GENERATE
			FSMUpdate(3) <= FSM(4);
			FSMUpdate(4) <= FSM(5);
			FSMUpdate(5) <= FSM(6);
			FSMUpdate(6) <= (FSM(3) XOR FSM(4));
		END GENERATE;	

--		GenwithDec: IF withDec /= 0 GENERATE
--			FSMUpdate(3) <= FSM(4) 					WHEN EncDec = '0' ELSE (FSM(3) XOR FSM(6));
--			FSMUpdate(4) <= FSM(5) 					WHEN EncDec = '0' ELSE FSM(3);
--			FSMUpdate(5) <= FSM(6) 					WHEN EncDec = '0' ELSE FSM(4);
--			FSMUpdate(6) <= (FSM(3) XOR FSM(4)) 	WHEN EncDec = '0' ELSE FSM(5);
--		END GENERATE;	
		
		--------------------------
		
		GEN4: IF BitNumber-Red_size=0 GENERATE
			LF_Process: Process (FSMUpdate)
			begin
				Red_FSMUpdateBit <= LFTable0(15-to_integer(unsigned(FSMUpdate(6 downto 3))));
			end process;	
		END GENERATE;

		GEN5: IF BitNumber-Red_size=1 GENERATE
			LF_Process: Process (FSMUpdate)
			begin
				Red_FSMUpdateBit <= LFTable1(15-to_integer(unsigned(FSMUpdate(6 downto 3))));
			end process;	
		END GENERATE;

		GEN6: IF BitNumber-Red_size=2 GENERATE
			LF_Process: Process (FSMUpdate)
			begin
				Red_FSMUpdateBit <= LFTable2(15-to_integer(unsigned(FSMUpdate(6 downto 3))));
			end process;	
		END GENERATE;		
	END GENERATE;
end Behavioral;

