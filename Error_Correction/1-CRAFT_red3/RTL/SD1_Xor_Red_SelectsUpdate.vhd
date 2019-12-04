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


entity SD1_Xor_Red_SelectsUpdate is
    Generic (
				withDec			: integer;
				ErrorSize		: positive;
				LFTable  		: STD_LOGIC_VECTOR (63 DOWNTO 0);
				SD1Table  		: STD_LOGIC_VECTOR (31 DOWNTO 0));
				
    Port ( selects   			: in  STD_LOGIC_VECTOR (1 downto 0);
			 ErrorVec   			: in  STD_LOGIC_VECTOR (2*ErrorSize-1 downto 0);
			 EncDec	  				: in  STD_LOGIC;
          Red_selectsNextBit	: out STD_LOGIC_VECTOR (2*ErrorSize-1 downto 0));
end SD1_Xor_Red_SelectsUpdate;

architecture Behavioral of SD1_Xor_Red_SelectsUpdate is

begin

	Gen: FOR i in 0 to ErrorSize*1-1 GENERATE
		SD1_Xor_Red_SelectsUpdate_Bit_Inst: ENTITY work.SD1_Xor_Red_SelectsUpdate_Bit
		Generic Map (i, withDec, ErrorSize, LFTable, SD1Table)
		Port Map (selects, ErrorVec, EncDec, Red_selectsNextBit(i));
	END GENERATE;

end Behavioral;

