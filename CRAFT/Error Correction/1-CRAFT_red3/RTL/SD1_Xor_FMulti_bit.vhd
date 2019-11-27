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


entity SD1_Xor_FMulti_bit is
    generic (r 			: integer;
				q 				: integer;
				StateSize 	: positive := 4;
				ErrorSize 	: positive := 3;
				Count		 	: positive := 16;
				LFTable   	: STD_LOGIC_VECTOR (63 DOWNTO 0);
				SD1Table  	: STD_LOGIC_VECTOR (31 DOWNTO 0)
				);
				
   Port (  x 						: in  STD_LOGIC_VECTOR (StateSize*Count-1 downto 0);
           EncryptionErrorVec : in  STD_LOGIC_VECTOR (ErrorSize*Count-1 downto 0);
           CipherOut 			: out  STD_LOGIC_VECTOR (3 downto 0);
           y 						: out  STD_LOGIC);
			  
end SD1_Xor_FMulti_bit;

architecture Behavioral of SD1_Xor_FMulti_bit is
	
	constant LFTable0 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		LFTable(60) & LFTable(56) & LFTable(52) & LFTable(48) & LFTable(44) & LFTable(40) & LFTable(36) & LFTable(32) &
		LFTable(28) & LFTable(24) & LFTable(20) & LFTable(16) & LFTable(12) & LFTable(8) & LFTable(4) & LFTable(0);
	
	constant LFTable1 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		LFTable(61) & LFTable(57) & LFTable(53) & LFTable(49) & LFTable(45) & LFTable(41) & LFTable(37) & LFTable(33) &
		LFTable(29) & LFTable(25) & LFTable(21) & LFTable(17) & LFTable(13) & LFTable(9) & LFTable(5) & LFTable(1);

	constant LFTable2 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		LFTable(62) & LFTable(58) & LFTable(54) & LFTable(50) & LFTable(46) & LFTable(42) & LFTable(38) & LFTable(34) &
		LFTable(30) & LFTable(26) & LFTable(22) & LFTable(18) & LFTable(14) & LFTable(10) & LFTable(6) & LFTable(2);
		
	constant LFTable3 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		LFTable(63) & LFTable(59) & LFTable(55) & LFTable(51) & LFTable(47) & LFTable(43) & LFTable(39) & LFTable(35) &
		LFTable(31) & LFTable(27) & LFTable(23) & LFTable(19) & LFTable(15) & LFTable(11) & LFTable(7) & LFTable(3);
	------------------------------------
	
	constant SD1Table0 : STD_LOGIC_VECTOR (7 DOWNTO 0) :=
		SD1Table(28) & SD1Table(24) & SD1Table(20) & SD1Table(16) & SD1Table(12) & SD1Table(8) & SD1Table(4) & SD1Table(0);
	
	constant SD1Table1 : STD_LOGIC_VECTOR (7 DOWNTO 0) :=
		SD1Table(29) & SD1Table(25) & SD1Table(21) & SD1Table(17) & SD1Table(13) & SD1Table(9) & SD1Table(5) & SD1Table(1);

	constant SD1Table2 : STD_LOGIC_VECTOR (7 DOWNTO 0) :=
		SD1Table(30) & SD1Table(26) & SD1Table(22) & SD1Table(18) & SD1Table(14) & SD1Table(10) & SD1Table(6) & SD1Table(2);
		
	constant SD1Table3 : STD_LOGIC_VECTOR (7 DOWNTO 0) :=
		SD1Table(31) & SD1Table(27) & SD1Table(23) & SD1Table(19) & SD1Table(15) & SD1Table(11) & SD1Table(7) & SD1Table(3);
		
	signal SD1Output					: STD_LOGIC_VECTOR(StateSize-1 DOWNTO 0);
	signal CorrectedX					: STD_LOGIC_VECTOR(StateSize-1 DOWNTO 0);
begin

		
	SD1_Process0: Process (EncryptionErrorVec(ErrorSize*(q+1)-1 downto ErrorSize*q))
		begin
			SD1Output(0) <= SD1Table0(7-to_integer(unsigned(EncryptionErrorVec(ErrorSize*(q+1)-1 downto ErrorSize*q))));
		end process;	
	
	SD1_Process1: Process (EncryptionErrorVec(ErrorSize*(q+1)-1 downto ErrorSize*q))
		begin
			SD1Output(1) <= SD1Table1(7-to_integer(unsigned(EncryptionErrorVec(ErrorSize*(q+1)-1 downto ErrorSize*q))));
		end process;
	
	SD1_Process2: Process (EncryptionErrorVec(ErrorSize*(q+1)-1 downto ErrorSize*q))
		begin
			SD1Output(2) <= SD1Table2(7-to_integer(unsigned(EncryptionErrorVec(ErrorSize*(q+1)-1 downto ErrorSize*q))));
		end process;
		
	SD1_Process3: Process (EncryptionErrorVec(ErrorSize*(q+1)-1 downto ErrorSize*q))
		begin
			SD1Output(3) <= SD1Table3(7-to_integer(unsigned(EncryptionErrorVec(ErrorSize*(q+1)-1 downto ErrorSize*q))));
		end process;
				
	------------------------------------
	CorrectedX(0) <= x(StateSize*q+0) xor SD1Output(0);
	CorrectedX(1) <= x(StateSize*q+1) xor SD1Output(1);
	CorrectedX(2) <= x(StateSize*q+2) xor SD1Output(2);
	CorrectedX(3) <= x(StateSize*q+3) xor SD1Output(3);
	
	CipherOutput: IF r = 0 GENERATE
		CipherOut 	  <= CorrectedX;
	END GENERATE;
	------------------------------------
	GEN0: IF r=0 GENERATE
				LF_Process: Process (CorrectedX)
				begin
					y <= LFTable0(15-to_integer(unsigned(CorrectedX)));
				end process;	
			END GENERATE;
	
	GEN1: IF r=1 GENERATE
			LF_Process: Process (CorrectedX)
			begin
				y <= LFTable1(15-to_integer(unsigned(CorrectedX)));
			end process;	
		END GENERATE;
		
	GEN2: IF r=2 GENERATE
			LF_Process: Process (CorrectedX)
			begin
				y <= LFTable2(15-to_integer(unsigned(CorrectedX)));
			end process;	
		END GENERATE;
		
	GEN3: IF r=3 GENERATE
			LF_Process: Process (CorrectedX)
			begin
				y <= LFTable3(15-to_integer(unsigned(CorrectedX)));
			end process;	
		END GENERATE;
			
end Behavioral;

