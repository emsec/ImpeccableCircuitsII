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

entity F_SD1_SB is
    generic(StateSize 	: positive := 4;
				Red_size 	: positive := 7;
				LFTable   	: STD_LOGIC_VECTOR (127 DOWNTO 0) := x"000F333C555A66696A6559563F300C03";
				SboxTable   : STD_LOGIC_VECTOR (63 DOWNTO 0) := x"cad3ebf789150246";
				SD1Table  	: STD_LOGIC_VECTOR (511 DOWNTO 0) := x"000000010001011100020400000000010002000000800001022200020002300C0000040000800001040044040A50040000800960808800800002040000800000");
				
   Port (  x 						: in  STD_LOGIC_VECTOR (StateSize*16-1 downto 0);
			  redx					: in  STD_LOGIC_VECTOR (Red_size*16-1 downto 0);
           CipherOut 			: out  STD_LOGIC_VECTOR (StateSize*16-1 downto 0);
           y 						: out  STD_LOGIC_VECTOR (StateSize*16-1 downto 0));
end F_SD1_SB;

architecture Behavioral of F_SD1_SB is

begin
	Gen: FOR i in 0 to 63 GENERATE
		GEN0: IF (i mod StateSize)=0 GENERATE
		
			F_SD1_SB_bit_inst: ENTITY work.F_SD1_SB_bit 
			Generic Map ((i mod StateSize), StateSize, Red_size, LFTable, SboxTable, SD1Table)
			PORT MAP(
				x 				=> x(StateSize*((i / StateSize)+1)-1 downto StateSize*(i / StateSize)),
				redx 			=> redx(Red_size*((i / StateSize)+1)-1 downto Red_size*(i / StateSize)),
				CipherOut 	=> CipherOut(StateSize*((i / StateSize)+1)-1 downto StateSize*(i / StateSize)),
				y 				=> y(i));
			
		END GENERATE;
		
		GEN1: IF (i mod StateSize)/=0 GENERATE
		
			F_SD1_SB_bit_inst: ENTITY work.F_SD1_SB_bit 
			Generic Map ((i mod StateSize), StateSize, Red_size, LFTable, SboxTable, SD1Table)
			PORT MAP(
				x 				=> x(StateSize*((i / StateSize)+1)-1 downto StateSize*(i / StateSize)),
				redx 			=> redx(Red_size*((i / StateSize)+1)-1 downto Red_size*(i / StateSize)),
				CipherOut 	=> open,
				y 				=> y(i));
			
		END GENERATE;
	END GENERATE;
end Behavioral;

