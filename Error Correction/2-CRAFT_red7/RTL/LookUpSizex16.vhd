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


ENTITY LookUpSizex16 IS
	GENERIC ( 
		size  : POSITIVE;
		Table : STD_LOGIC_VECTOR (127 DOWNTO 0));
	PORT ( input:  IN  STD_LOGIC_VECTOR (3      DOWNTO 0);
			 output: OUT STD_LOGIC_VECTOR (size-1 DOWNTO 0));
END LookUpSizex16;

ARCHITECTURE behavioral OF LookUpSizex16 IS

	constant Table0 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
	Table(120) & Table(112) & Table(104) & Table(96) & Table(88) & 
	Table(80) & Table(72) & Table(64) & Table(56) & Table(48) & Table(40) & 
	Table(32) & Table(24) & Table(16) & Table(8) & Table(0);

	constant Table1 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		Table(121) & Table(113) & Table(105) & Table(97) & Table(89) & 
		Table(81) & Table(73) & Table(65) & Table(57) & Table(49) & Table(41) & 
		Table(33) & Table(25) & Table(17) & Table(9) & Table(1);

	constant Table2 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		Table(122) & Table(114) & Table(106) & Table(98) & Table(90) & 
		Table(82) & Table(74) & Table(66) & Table(58) & Table(50) & Table(42) & 
		Table(34) & Table(26) & Table(18) & Table(10) & Table(2);

	constant Table3 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		Table(123) & Table(115) & Table(107) & Table(99) & Table(91) & 
		Table(83) & Table(75) & Table(67) & Table(59) & Table(51) & Table(43) & 
		Table(35) & Table(27) & Table(19) & Table(11) & Table(3);

	constant Table4 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		Table(124) & Table(116) & Table(108) & Table(100) & Table(92) & 
		Table(84) & Table(76) & Table(68) & Table(60) & Table(52) & Table(44) & 
		Table(36) & Table(28) & Table(20) & Table(12) & Table(4);

	constant Table5 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		Table(125) & Table(117) & Table(109) & Table(101) & Table(93) & 
		Table(85) & Table(77) & Table(69) & Table(61) & Table(53) & Table(45) & 
		Table(37) & Table(29) & Table(21) & Table(13) & Table(5);

	constant Table6 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		Table(126) & Table(118) & Table(110) & Table(102) & Table(94) & 
		Table(86) & Table(78) & Table(70) & Table(62) & Table(54) & Table(46) & 
		Table(38) & Table(30) & Table(22) & Table(14) & Table(6);

	constant Table7 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		Table(127) & Table(119) & Table(111) & Table(103) & Table(95) & 
		Table(87) & Table(79) & Table(71) & Table(63) & Table(55) & Table(47) & 
		Table(39) & Table(31) & Table(23) & Table(15) & Table(7); 

BEGIN

	LFInst_0: ENTITY work.LookUp
	GENERIC Map (size => size, Table => Table0)
	PORT Map (input, output(0));
	
	Red_2:
	IF size > 1 GENERATE
		LFInst_1: ENTITY work.LookUp
		GENERIC Map (size => size, Table => Table1)
		PORT Map (input, output(1));
	END GENERATE;

	Red_3:
	IF size > 2 GENERATE
		LFInst_2: ENTITY work.LookUp
		GENERIC Map (size => size, Table => Table2)
		PORT Map (input, output(2));
	END GENERATE;

	Red_4:
	IF size > 3 GENERATE
		LFInst_3: ENTITY work.LookUp
		GENERIC Map (size => size, Table => Table3)
		PORT Map (input, output(3));
	END GENERATE;
	
	Red_5:
	IF size > 4 GENERATE
		LFInst_4: ENTITY work.LookUp
		GENERIC Map (size => size, Table => Table4)
		PORT Map (input, output(4));
	END GENERATE;
	
	Red_6:
	IF size > 5 GENERATE
		LFInst_5: ENTITY work.LookUp
		GENERIC Map (size => size, Table => Table5)
		PORT Map (input, output(5));
	END GENERATE;
	
	Red_7:
	IF size > 6 GENERATE
		LFInst_6: ENTITY work.LookUp
		GENERIC Map (size => size, Table => Table6)
		PORT Map (input, output(6));
	END GENERATE;
	
	
			
END behavioral;

