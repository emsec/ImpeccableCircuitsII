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
use work.functions.all;
USE IEEE.NUMERIC_STD.ALL;



ENTITY MUX2to1_Red IS
	GENERIC (size    : POSITIVE := 8);
	PORT ( sel 	: IN  STD_LOGIC_VECTOR(size-1 downto 0);
			 D0   : IN  STD_LOGIC;
			 D1 	: IN  STD_LOGIC;
			 Q 	: OUT STD_LOGIC);
END MUX2to1_Red;

ARCHITECTURE behavioral OF MUX2to1_Red IS

	signal input          : STD_LOGIC_VECTOR(255 downto 0);
	signal O0          		: STD_LOGIC_VECTOR(255 downto 0);
	signal O1          		: STD_LOGIC_VECTOR(63 downto 0);
	signal O2          		: STD_LOGIC_VECTOR(31 downto 0);
	signal O3          		: STD_LOGIC_VECTOR(15 downto 0);
	signal O4          		: STD_LOGIC_VECTOR(7 downto 0);
	signal O5          		: STD_LOGIC_VECTOR(3 downto 0);
	signal O6          		: STD_LOGIC_VECTOR(1 downto 0);
	
	signal Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8 : STD_LOGIC;

--	constant LF0			 : NATURAL;
--	constant LF1			 : NATURAL;

BEGIN
	
	size_3:
	IF size = 3 GENERATE

		MUXInst_1: ENTITY work.MUX2to1
		PORT Map (sel(2), '0', D1, Q1);

		MUXInst_2: ENTITY work.MUX2to1
		PORT Map (sel(1), '0', Q1, Q2);
		
		MUXInst_3: ENTITY work.MUX2to1
		PORT Map (sel(1), Q1, D1, Q3);

		MUXInst_4: ENTITY work.MUX2to1
		PORT Map (sel(0), Q2, Q3, Q);
		
		
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
	-------------------
	size_5:
	IF size = 5 GENERATE
		
		Q1  <= ((sel(0) and D1) or (D0 and (not sel(0))));
		Q2  <= ((sel(1) and Q1) or (D0 and (not sel(1))));
		Q3  <= ((sel(1) and D1) or (Q1 and (not sel(1))));
		Q4  <= ((sel(2) and Q2) or (D0 and (not sel(2))));
		Q5  <= ((sel(2) and Q3) or (Q2 and (not sel(2))));
		Q6  <= ((sel(2) and D1) or (Q3 and (not sel(2))));
		Q7  <= ((sel(3) and Q5) or (Q4 and (not sel(3))));
		Q8  <= ((sel(3) and Q6) or (Q5 and (not sel(3))));
		Q   <= ((sel(4) and Q8) or (Q7 and (not sel(4))));
		
	END GENERATE;	
	-------------------
	size_7:
	IF size = 7 GENERATE
		
		GEN :
		FOR i IN 0 TO 127 GENERATE
			
			GEN0: 
			IF i=0 or i=1 or i=2 or i=4 or i=8 or i=16 or i=32 or i=64 or i=128 or i=3 or i=5 or i=6 or i=9 or i=10 or i=12 or i=17 or i=18 or i=20 or i=24 or i=33 or i=34 or i=36 or i=40 or i=48 or i=65 or i=66 or i=68 or i=72 or i=80 or i=96 or i=129 or i=130 or i=132 or i=136 or i=144 or i=160 or i=192 GENERATE
				input(i) <= '0';
			END GENERATE;
			
			GEN1: 
			IF i=143 or i=142 or i=141 or i=139 or i=135 or i=159 or i=175 or i=207 or i=15 or i=140 or i=138 or i=137 or i=134 or i=133 or i=131 or i=158 or i=157 or i=155 or i=151 or i=174 or i=173 or i=171 or i=167 or i=191 or i=206 or i=205 or i=203 or i=199 or i=223 or i=239 or i=14 or i=13 or i=11 or i=7 or i=31 or i=47 or i=79 GENERATE
				input(i) <= D1;
--				
--			ELSE GENERATE
--				input(i) <= '0';
			END GENERATE;
			
		END GENERATE;
		
		input(19) <= '0'; 
		input(21) <= '0'; 
		input(22) <= '0'; 
		input(23) <= '0'; 
		input(25) <= '0'; 
		input(26) <= '0'; 
		input(27) <= '0'; 
		input(28) <= '0'; 
		input(29) <= '0'; 
		input(30) <= '0'; 
		input(35) <= '0'; 
		input(37) <= '0'; 
		input(38) <= '0'; 
		input(39) <= '0'; 
		input(41) <= '0'; 
		input(42) <= '0'; 
		input(43) <= '0'; 
		input(44) <= '0'; 
		input(45) <= '0'; 
		input(46) <= '0'; 
		input(49) <= '0'; 
		input(50) <= '0'; 
		input(51) <= '0'; 
		input(52) <= '0'; 
		input(53) <= '0'; 
		input(54) <= '0'; 
		input(55) <= '0'; 
		input(56) <= '0'; 
		input(57) <= '0'; 
		input(58) <= '0'; 
		input(59) <= '0'; 
		input(60) <= '0'; 
		input(61) <= '0'; 
		input(62) <= '0'; 
		input(63) <= '0'; 
		input(67) <= '0'; 
		input(69) <= '0'; 
		input(70) <= '0'; 
		input(71) <= '0'; 
		input(73) <= '0'; 
		input(74) <= '0'; 
		input(75) <= '0'; 
		input(76) <= '0'; 
		input(77) <= '0'; 
		input(78) <= '0'; 
		input(81) <= '0'; 
		input(82) <= '0'; 
		input(83) <= '0'; 
		input(84) <= '0'; 
		input(85) <= '0'; 
		input(86) <= '0'; 
		input(87) <= '0'; 
		input(88) <= '0'; 
		input(89) <= '0'; 
		input(90) <= '0'; 
		input(91) <= '0'; 
		input(92) <= '0'; 
		input(93) <= '0'; 
		input(94) <= '0'; 
		input(95) <= '0'; 
		input(97) <= '0'; 
		input(98) <= '0'; 
		input(99) <= '0'; 
		input(100) <= '0'; 
		input(101) <= '0'; 
		input(102) <= '0'; 
		input(103) <= '0'; 
		input(104) <= '0'; 
		input(105) <= '0'; 
		input(106) <= '0'; 
		input(107) <= '0'; 
		input(108) <= '0'; 
		input(109) <= '0'; 
		input(110) <= '0'; 
		input(111) <= '0'; 
		input(112) <= '0'; 
		input(113) <= '0'; 
		input(114) <= '0'; 
		input(115) <= '0'; 
		input(116) <= '0'; 
		input(117) <= '0'; 
		input(118) <= '0'; 
		input(119) <= '0'; 
		input(120) <= '0'; 
		input(121) <= '0'; 
		input(122) <= '0'; 
		input(123) <= '0'; 
		input(124) <= '0'; 
		input(125) <= '0'; 
		input(126) <= '0'; 
		input(127) <= '0'; 
		
		GEN9:
		FOR i IN 0 TO 63 GENERATE
			
			MUXInst_7: ENTITY work.MUX2to1
			PORT Map (sel(0), input(2*i), input(2*i+1), O1(i));
		
		END GENERATE;
		
		GEN8:
		FOR i IN 0 TO 31 GENERATE
			
			MUXInst_6: ENTITY work.MUX2to1
			PORT Map (sel(1), O1(2*i), O1(2*i+1), O2(i));
		
		END GENERATE;
		
		GEN7:
		FOR i IN 0 TO 15 GENERATE
			
			MUXInst_5: ENTITY work.MUX2to1
			PORT Map (sel(2), O2(2*i), O2(2*i+1), O3(i));
		
		END GENERATE;
		
		GEN4:
		FOR i IN 0 TO 7 GENERATE
			
			MUXInst_1: ENTITY work.MUX2to1
			PORT Map (sel(3), O3(2*i), O3(2*i+1), O4(i));
		
		END GENERATE;
		
		GEN5:
		FOR i IN 0 TO 3 GENERATE
			
			MUXInst_2: ENTITY work.MUX2to1
			PORT Map (sel(4), O4(2*i), O4(2*i+1), O5(i));
		
		END GENERATE;
		
		GEN6:
		FOR i IN 0 TO 1 GENERATE
			
			MUXInst_3: ENTITY work.MUX2to1
			PORT Map (sel(5), O5(2*i), O5(2*i+1), O6(i));
		
		END GENERATE;

		MUXInst_4: ENTITY work.MUX2to1
		PORT Map (sel(6), O6(0), O6(1), Q);
		
	END GENERATE;	
	-------------------
	size_8:
	IF size = 8 GENERATE

		GEN :
		FOR i IN 0 TO 255 GENERATE
		
			GEN0: 
			IF i=0 or i=1 or i=2 or i=4 or i=8 or i=16 or i=32 or i=64 or i=128 or i=3 or i=5 or i=6 or i=9 or i=10 or i=12 or i=17 or i=18 or i=20 or i=24 or i=33 or i=34 or i=36 or i=40 or i=48 or i=65 or i=66 or i=68 or i=72 or i=80 or i=96 or i=129 or i=130 or i=132 or i=136 or i=144 or i=160 or i=192 GENERATE
				input(i) <= D0;
			END GENERATE;
			
			GEN1: 
			IF i=143 or i=142 or i=141 or i=139 or i=135 or i=159 or i=175 or i=207 or i=15 or i=140 or i=138 or i=137 or i=134 or i=133 or i=131 or i=158 or i=157 or i=155 or i=151 or i=174 or i=173 or i=171 or i=167 or i=191 or i=206 or i=205 or i=203 or i=199 or i=223 or i=239 or i=14 or i=13 or i=11 or i=7 or i=31 or i=47 or i=79 GENERATE
				input(i) <= D1;
			END GENERATE;
			
		END GENERATE;


		input(19) <= '0'; 
		input(21) <= '0'; 
		input(22) <= '0'; 
		input(23) <= '0'; 
		input(25) <= '0'; 
		input(26) <= '0'; 
		input(27) <= '0'; 
		input(28) <= '0'; 
		input(29) <= '0'; 
		input(30) <= '0'; 
		input(35) <= '0'; 
		input(37) <= '0'; 
		input(38) <= '0'; 
		input(39) <= '0'; 
		input(41) <= '0'; 
		input(42) <= '0'; 
		input(43) <= '0'; 
		input(44) <= '0'; 
		input(45) <= '0'; 
		input(46) <= '0'; 
		input(49) <= '0'; 
		input(50) <= '0'; 
		input(51) <= '0'; 
		input(52) <= '0'; 
		input(53) <= '0'; 
		input(54) <= '0'; 
		input(55) <= '0'; 
		input(56) <= '0'; 
		input(57) <= '0'; 
		input(58) <= '0'; 
		input(59) <= '0'; 
		input(60) <= '0'; 
		input(61) <= '0'; 
		input(62) <= '0'; 
		input(63) <= '0'; 
		input(67) <= '0'; 
		input(69) <= '0'; 
		input(70) <= '0'; 
		input(71) <= '0'; 
		input(73) <= '0'; 
		input(74) <= '0'; 
		input(75) <= '0'; 
		input(76) <= '0'; 
		input(77) <= '0'; 
		input(78) <= '0'; 
		input(81) <= '0'; 
		input(82) <= '0'; 
		input(83) <= '0'; 
		input(84) <= '0'; 
		input(85) <= '0'; 
		input(86) <= '0'; 
		input(87) <= '0'; 
		input(88) <= '0'; 
		input(89) <= '0'; 
		input(90) <= '0'; 
		input(91) <= '0'; 
		input(92) <= '0'; 
		input(93) <= '0'; 
		input(94) <= '0'; 
		input(95) <= '0'; 
		input(97) <= '0'; 
		input(98) <= '0'; 
		input(99) <= '0'; 
		input(100) <= '0'; 
		input(101) <= '0'; 
		input(102) <= '0'; 
		input(103) <= '0'; 
		input(104) <= '0'; 
		input(105) <= '0'; 
		input(106) <= '0'; 
		input(107) <= '0'; 
		input(108) <= '0'; 
		input(109) <= '0'; 
		input(110) <= '0'; 
		input(111) <= '0'; 
		input(112) <= '0'; 
		input(113) <= '0'; 
		input(114) <= '0'; 
		input(115) <= '0'; 
		input(116) <= '0'; 
		input(117) <= '0'; 
		input(118) <= '0'; 
		input(119) <= '0'; 
		input(120) <= '0'; 
		input(121) <= '0'; 
		input(122) <= '0'; 
		input(123) <= '0'; 
		input(124) <= '0'; 
		input(125) <= '0'; 
		input(126) <= '0'; 
		input(127) <= '0'; 
		input(145) <= '0'; 
		input(146) <= '0'; 
		input(147) <= '0'; 
		input(148) <= '0'; 
		input(149) <= '0'; 
		input(150) <= '0'; 
		input(152) <= '0'; 
		input(153) <= '0'; 
		input(154) <= '0'; 
		input(156) <= '0'; 
		input(161) <= '0'; 
		input(162) <= '0'; 
		input(163) <= '0'; 
		input(164) <= '0'; 
		input(165) <= '0'; 
		input(166) <= '0'; 
		input(168) <= '0'; 
		input(169) <= '0'; 
		input(170) <= '0'; 
		input(172) <= '0'; 
		input(176) <= '0'; 
		input(177) <= '0'; 
		input(178) <= '0'; 
		input(179) <= '0'; 
		input(180) <= '0'; 
		input(181) <= '0'; 
		input(182) <= '0'; 
		input(183) <= '0'; 
		input(184) <= '0'; 
		input(185) <= '0'; 
		input(186) <= '0'; 
		input(187) <= '0'; 
		input(188) <= '0'; 
		input(189) <= '0'; 
		input(190) <= '0'; 
		input(193) <= '0'; 
		input(194) <= '0'; 
		input(195) <= '0'; 
		input(196) <= '0'; 
		input(197) <= '0'; 
		input(198) <= '0'; 
		input(200) <= '0'; 
		input(201) <= '0'; 
		input(202) <= '0'; 
		input(204) <= '0'; 
		input(208) <= '0'; 
		input(209) <= '0'; 
		input(210) <= '0'; 
		input(211) <= '0'; 
		input(212) <= '0'; 
		input(213) <= '0'; 
		input(214) <= '0'; 
		input(215) <= '0'; 
		input(216) <= '0'; 
		input(217) <= '0'; 
		input(218) <= '0'; 
		input(219) <= '0'; 
		input(220) <= '0'; 
		input(221) <= '0'; 
		input(222) <= '0'; 
		input(224) <= '0'; 
		input(225) <= '0'; 
		input(226) <= '0'; 
		input(227) <= '0'; 
		input(228) <= '0'; 
		input(229) <= '0'; 
		input(230) <= '0'; 
		input(231) <= '0'; 
		input(232) <= '0'; 
		input(233) <= '0'; 
		input(234) <= '0'; 
		input(235) <= '0'; 
		input(236) <= '0'; 
		input(237) <= '0'; 
		input(238) <= '0'; 
		input(240) <= '0'; 
		input(241) <= '0'; 
		input(242) <= '0'; 
		input(243) <= '0'; 
		input(244) <= '0'; 
		input(245) <= '0'; 
		input(246) <= '0'; 
		input(247) <= '0'; 
		input(248) <= '0'; 
		input(249) <= '0'; 
		input(250) <= '0'; 
		input(251) <= '0'; 
		input(252) <= '0'; 
		input(253) <= '0'; 
		input(254) <= '0'; 
		input(255) <= '0'; 
		
		GEN10:
		FOR i IN 0 TO 127 GENERATE
			
			MUXInst_8: ENTITY work.MUX2to1
			PORT Map (sel(0), input(2*i), input(2*i+1), O0(i));
		
		END GENERATE;
		
		GEN9:
		FOR i IN 0 TO 63 GENERATE
			
			MUXInst_7: ENTITY work.MUX2to1
			PORT Map (sel(1), O0(2*i), O0(2*i+1), O1(i));
		
		END GENERATE;
		
		GEN8:
		FOR i IN 0 TO 31 GENERATE
			
			MUXInst_6: ENTITY work.MUX2to1
			PORT Map (sel(2), O1(2*i), O1(2*i+1), O2(i));
		
		END GENERATE;
		
		GEN7:
		FOR i IN 0 TO 15 GENERATE
			
			MUXInst_5: ENTITY work.MUX2to1
			PORT Map (sel(3), O2(2*i), O2(2*i+1), O3(i));
		
		END GENERATE;
		
		GEN4:
		FOR i IN 0 TO 7 GENERATE
			
			MUXInst_1: ENTITY work.MUX2to1
			PORT Map (sel(4), O3(2*i), O3(2*i+1), O4(i));
		
		END GENERATE;
		
		GEN5:
		FOR i IN 0 TO 3 GENERATE
			
			MUXInst_2: ENTITY work.MUX2to1
			PORT Map (sel(5), O4(2*i), O4(2*i+1), O5(i));
		
		END GENERATE;
		
		GEN6:
		FOR i IN 0 TO 1 GENERATE
			
			MUXInst_3: ENTITY work.MUX2to1
			PORT Map (sel(6), O5(2*i), O5(2*i+1), O6(i));
		
		END GENERATE;

		MUXInst_4: ENTITY work.MUX2to1
		PORT Map (sel(7), O6(0), O6(1), Q);
		
	END GENERATE;	
END;

