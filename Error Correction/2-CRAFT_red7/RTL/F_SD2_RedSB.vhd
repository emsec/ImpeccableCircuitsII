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

entity F_SD2_RedSB is
   generic( StateSize 	: positive ;
				Red_size 	: positive ;
				LFTable   	: STD_LOGIC_VECTOR (127 DOWNTO 0);
				Red_SboxTable   : STD_LOGIC_VECTOR (127 DOWNTO 0);
				SD2Table  	: STD_LOGIC_VECTOR (1023 DOWNTO 0));
				
   Port (  x 						: in  STD_LOGIC_VECTOR (StateSize*16-1 downto 0);
			  redx					: in  STD_LOGIC_VECTOR (Red_size*16-1 downto 0);
           y 						: out  STD_LOGIC_VECTOR (Red_size*16-1 downto 0));
end F_SD2_RedSB;

architecture Behavioral of F_SD2_RedSB is

begin
	Gen: FOR i in 0 to Red_size*16-1 GENERATE
	
		F_SD2_RedSB_bit_inst: ENTITY work.F_SD2_RedSB_bit
		Generic Map ((i mod Red_size), StateSize, Red_size, LFTable, Red_SboxTable, SD2Table)
		PORT MAP(
			x 				=> x(StateSize*((i / Red_size)+1)-1 downto StateSize*(i / Red_size)),
			redx 			=> redx(Red_size*((i / Red_size)+1)-1 downto Red_size*(i / Red_size)),
			y 				=> y(i));

	END GENERATE;

end Behavioral;

