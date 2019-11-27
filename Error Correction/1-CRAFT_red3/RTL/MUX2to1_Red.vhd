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

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY MUX2to1_Red IS
	GENERIC (size    : POSITIVE;
	         LFTable : STD_LOGIC_VECTOR(63 downto 0));
	PORT ( sel 	: IN  STD_LOGIC_VECTOR(size-1 downto 0);
			 D0   : IN  STD_LOGIC;
			 D1 	: IN  STD_LOGIC;
			 Q 	: OUT STD_LOGIC);
END MUX2to1_Red;

ARCHITECTURE behavioral OF MUX2to1_Red IS

	signal input          : STD_LOGIC_VECTOR(7 downto 0);
	
	signal Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7 : STD_LOGIC;

	constant LF0			 : NATURAL := to_integer(unsigned(LFTable(63 downto 60)));
	constant LF1			 : NATURAL := to_integer(unsigned(LFTable(59 downto 56)));

BEGIN
	
	size_3:
	IF size = 3 GENERATE
		Q1 <= ((sel(2) and D1) or (D0 and (not sel(2))));
		Q2 <= ((sel(1) and Q1) or (D0 and (not sel(1))));
		Q3 <= ((sel(1) and D1) or (Q1 and (not sel(1))));
		Q  <= ((sel(0) and Q3) or (Q2 and (not sel(0))));	
	END GENERATE;
	
	size_4:
	IF size = 4 GENERATE

		MUXInst_1: ENTITY work.MUX2to1
		PORT Map (sel(3), D0, '0', Q1);

		MUXInst_2: ENTITY work.MUX2to1
		PORT Map (sel(3), '0', D1, Q2);
		
		MUXInst_3: ENTITY work.MUX2to1
		PORT Map (sel(2), D0, Q1, Q3);

		MUXInst_4: ENTITY work.MUX2to1
		PORT Map (sel(2), Q1, Q2, Q4);
		
		MUXInst_5: ENTITY work.MUX2to1
		PORT Map (sel(2), Q2, D1, Q5);

		MUXInst_6: ENTITY work.MUX2to1
		PORT Map (sel(1), Q3, Q4, Q6);

		MUXInst_7: ENTITY work.MUX2to1
		PORT Map (sel(1), Q4, Q5, Q7);
		
		MUXInst_8: ENTITY work.MUX2to1
		PORT Map (sel(0), Q6, Q7, Q);
	END GENERATE;	

END;

