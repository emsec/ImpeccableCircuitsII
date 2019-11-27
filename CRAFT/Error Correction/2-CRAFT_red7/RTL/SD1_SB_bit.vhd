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

entity SD1_SB_bit is
   generic( r 				: integer;
				StateSize 	: positive ;
				Red_size 	: positive ;
				SboxTable   : STD_LOGIC_VECTOR (63 DOWNTO 0);
				SD1Table  	: STD_LOGIC_VECTOR (511 DOWNTO 0));
				
   Port (  x 						: in  STD_LOGIC_VECTOR (StateSize-1 downto 0);
			  ErrorVec					: in  STD_LOGIC_VECTOR (7-1 downto 0);
           CipherOut 			: out  STD_LOGIC_VECTOR (3 downto 0);
           y 						: out  STD_LOGIC);
end SD1_SB_bit;

architecture Behavioral of SD1_SB_bit is

	constant SboxTable0 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		SboxTable(60) & SboxTable(56) & SboxTable(52) & SboxTable(48) & SboxTable(44) & SboxTable(40) & SboxTable(36) & SboxTable(32) &
		SboxTable(28) & SboxTable(24) & SboxTable(20) & SboxTable(16) & SboxTable(12) & SboxTable(8) & SboxTable(4) & SboxTable(0);
	
	constant SboxTable1 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		SboxTable(61) & SboxTable(57) & SboxTable(53) & SboxTable(49) & SboxTable(45) & SboxTable(41) & SboxTable(37) & SboxTable(33) &
		SboxTable(29) & SboxTable(25) & SboxTable(21) & SboxTable(17) & SboxTable(13) & SboxTable(9) & SboxTable(5) & SboxTable(1);

	constant SboxTable2 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		SboxTable(62) & SboxTable(58) & SboxTable(54) & SboxTable(50) & SboxTable(46) & SboxTable(42) & SboxTable(38) & SboxTable(34) &
		SboxTable(30) & SboxTable(26) & SboxTable(22) & SboxTable(18) & SboxTable(14) & SboxTable(10) & SboxTable(6) & SboxTable(2);
		
	constant SboxTable3 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		SboxTable(62+1) & SboxTable(58+1) & SboxTable(54+1) & SboxTable(50+1) & SboxTable(46+1) & SboxTable(42+1) & SboxTable(38+1) & SboxTable(34+1) &
		SboxTable(30+1) & SboxTable(26+1) & SboxTable(22+1) & SboxTable(18+1) & SboxTable(14+1) & SboxTable(10+1) & SboxTable(6+1) & SboxTable(2+1);
	------------------------------------
	constant SD1Table0 : STD_LOGIC_VECTOR (127 DOWNTO 0) :=
		SD1Table(508) & SD1Table(504) & SD1Table(500) & SD1Table(496) & SD1Table(492) & SD1Table(488) & SD1Table(484) & SD1Table(480) & SD1Table(476) & SD1Table(472) & SD1Table(468) & SD1Table(464) & SD1Table(460) & SD1Table(456) & SD1Table(452) & SD1Table(448) & SD1Table(444) & SD1Table(440) & SD1Table(436) & SD1Table(432) & SD1Table(428) & SD1Table(424) & '-' & '-' & SD1Table(412) & '-' & '-' & '-' & '-' & '-' & '-' & SD1Table(384) & SD1Table(380) & SD1Table(376) & SD1Table(372) & SD1Table(368) & SD1Table(364) & '-' & '-' & '-' & SD1Table(348) & '-' & SD1Table(340) & '-' & '-' & '-' & '-' & SD1Table(320) & SD1Table(316) & SD1Table(312) & SD1Table(308) & SD1Table(304) & '-' & '-' & '-' & SD1Table(288) & '-' & '-' & '-' & SD1Table(272) & SD1Table(268) & '-' & '-' & SD1Table(256) & SD1Table(252) & SD1Table(248) & SD1Table(244) & '-' & SD1Table(236) & SD1Table(232) & '-' & '-' & SD1Table(220) & '-' & SD1Table(212) & '-' & '-' & '-' & '-' & SD1Table(192) & SD1Table(188) & SD1Table(184) & '-' & '-' & SD1Table(172) & SD1Table(168) & '-' & SD1Table(160) & '-' & SD1Table(152) & SD1Table(148) & '-' & '-' & SD1Table(136) & '-' & '-' & SD1Table(124) & '-' & SD1Table(116) & '-' & '-' & SD1Table(104) & SD1Table(100) & '-' & SD1Table(92) & '-' & SD1Table(84) & SD1Table(80) & '-' & '-' & SD1Table(68) & '-' & '-' & '-' & '-' & SD1Table(48) & '-' & SD1Table(40) & '-' & '-' & '-' & '-' & SD1Table(20) & '-' & '-' & '-' & '-' & '-' ; 

	constant SD1Table1 : STD_LOGIC_VECTOR (127 DOWNTO 0) :=
		SD1Table(509) & SD1Table(505) & SD1Table(501) & SD1Table(497) & SD1Table(493) & SD1Table(489) & SD1Table(485) & SD1Table(481) & SD1Table(477) & SD1Table(473) & SD1Table(469) & SD1Table(465) & SD1Table(461) & SD1Table(457) & SD1Table(453) & SD1Table(449) & SD1Table(445) & SD1Table(441) & SD1Table(437) & SD1Table(433) & SD1Table(429) & SD1Table(425) & '-' & '-' & SD1Table(413) & '-' & '-' & '-' & '-' & '-' & '-' & SD1Table(385) & SD1Table(381) & SD1Table(377) & SD1Table(373) & SD1Table(369) & SD1Table(365) & '-' & '-' & '-' & SD1Table(349) & '-' & SD1Table(341) & '-' & '-' & '-' & '-' & SD1Table(321) & SD1Table(317) & SD1Table(313) & SD1Table(309) & SD1Table(305) & '-' & '-' & '-' & SD1Table(289) & '-' & '-' & '-' & SD1Table(273) & SD1Table(269) & '-' & '-' & SD1Table(257) & SD1Table(253) & SD1Table(249) & SD1Table(245) & '-' & SD1Table(237) & SD1Table(233) & '-' & '-' & SD1Table(221) & '-' & SD1Table(213) & '-' & '-' & '-' & '-' & SD1Table(193) & SD1Table(189) & SD1Table(185) & '-' & '-' & SD1Table(173) & SD1Table(169) & '-' & SD1Table(161) & '-' & SD1Table(153) & SD1Table(149) & '-' & '-' & SD1Table(137) & '-' & '-' & SD1Table(125) & '-' & SD1Table(117) & '-' & '-' & SD1Table(105) & SD1Table(101) & '-' & SD1Table(93) & '-' & SD1Table(85) & SD1Table(81) & '-' & '-' & SD1Table(69) & '-' & '-' & '-' & '-' & SD1Table(49) & '-' & SD1Table(41) & '-' & '-' & '-' & '-' & SD1Table(21) & '-' & '-' & '-' & '-' & '-' ; 

	constant SD1Table2 : STD_LOGIC_VECTOR (127 DOWNTO 0) :=
		SD1Table(510) & SD1Table(506) & SD1Table(502) & SD1Table(498) & SD1Table(494) & SD1Table(490) & SD1Table(486) & SD1Table(482) & SD1Table(478) & SD1Table(474) & SD1Table(470) & SD1Table(466) & SD1Table(462) & SD1Table(458) & SD1Table(454) & SD1Table(450) & SD1Table(446) & SD1Table(442) & SD1Table(438) & SD1Table(434) & SD1Table(430) & SD1Table(426) & '-' & '-' & SD1Table(414) & '-' & '-' & '-' & '-' & '-' & '-' & SD1Table(386) & SD1Table(382) & SD1Table(378) & SD1Table(374) & SD1Table(370) & SD1Table(366) & '-' & '-' & '-' & SD1Table(350) & '-' & SD1Table(342) & '-' & '-' & '-' & '-' & SD1Table(322) & SD1Table(318) & SD1Table(314) & SD1Table(310) & SD1Table(306) & '-' & '-' & '-' & SD1Table(290) & '-' & '-' & '-' & SD1Table(274) & SD1Table(270) & '-' & '-' & SD1Table(258) & SD1Table(254) & SD1Table(250) & SD1Table(246) & '-' & SD1Table(238) & SD1Table(234) & '-' & '-' & SD1Table(222) & '-' & SD1Table(214) & '-' & '-' & '-' & '-' & SD1Table(194) & SD1Table(190) & SD1Table(186) & '-' & '-' & SD1Table(174) & SD1Table(170) & '-' & SD1Table(162) & '-' & SD1Table(154) & SD1Table(150) & '-' & '-' & SD1Table(138) & '-' & '-' & SD1Table(126) & '-' & SD1Table(118) & '-' & '-' & SD1Table(106) & SD1Table(102) & '-' & SD1Table(94) & '-' & SD1Table(86) & SD1Table(82) & '-' & '-' & SD1Table(70) & '-' & '-' & '-' & '-' & SD1Table(50) & '-' & SD1Table(42) & '-' & '-' & '-' & '-' & SD1Table(22) & '-' & '-' & '-' & '-' & '-' ; 

	constant SD1Table3 : STD_LOGIC_VECTOR (127 DOWNTO 0) :=
		SD1Table(511) & SD1Table(507) & SD1Table(503) & SD1Table(499) & SD1Table(495) & SD1Table(491) & SD1Table(487) & SD1Table(483) & SD1Table(479) & SD1Table(475) & SD1Table(471) & SD1Table(467) & SD1Table(463) & SD1Table(459) & SD1Table(455) & SD1Table(451) & SD1Table(447) & SD1Table(443) & SD1Table(439) & SD1Table(435) & SD1Table(431) & SD1Table(427) & '-' & '-' & SD1Table(415) & '-' & '-' & '-' & '-' & '-' & '-' & SD1Table(387) & SD1Table(383) & SD1Table(379) & SD1Table(375) & SD1Table(371) & SD1Table(367) & '-' & '-' & '-' & SD1Table(351) & '-' & SD1Table(343) & '-' & '-' & '-' & '-' & SD1Table(323) & SD1Table(319) & SD1Table(315) & SD1Table(311) & SD1Table(307) & '-' & '-' & '-' & SD1Table(291) & '-' & '-' & '-' & SD1Table(275) & SD1Table(271) & '-' & '-' & SD1Table(259) & SD1Table(255) & SD1Table(251) & SD1Table(247) & '-' & SD1Table(239) & SD1Table(235) & '-' & '-' & SD1Table(223) & '-' & SD1Table(215) & '-' & '-' & '-' & '-' & SD1Table(195) & SD1Table(191) & SD1Table(187) & '-' & '-' & SD1Table(175) & SD1Table(171) & '-' & SD1Table(163) & '-' & SD1Table(155) & SD1Table(151) & '-' & '-' & SD1Table(139) & '-' & '-' & SD1Table(127) & '-' & SD1Table(119) & '-' & '-' & SD1Table(107) & SD1Table(103) & '-' & SD1Table(95) & '-' & SD1Table(87) & SD1Table(83) & '-' & '-' & SD1Table(71) & '-' & '-' & '-' & '-' & SD1Table(51) & '-' & SD1Table(43) & '-' & '-' & '-' & '-' & SD1Table(23) & '-' & '-' & '-' & '-' & '-' ; 

	------------------------------------
	
	signal F_output		: STD_LOGIC_VECTOR(Red_size-1 DOWNTO 0);
	signal SD1Output		: STD_LOGIC_VECTOR(StateSize-1 DOWNTO 0);
	signal CorrectedX		: STD_LOGIC_VECTOR(StateSize-1 DOWNTO 0);



begin


	SD1_CASE_0 : process (ErrorVec)
	begin
		case ErrorVec is
			when "0000000" =>
				SD1Output(0) <= '0';
			when "0000001" =>
				SD1Output(0) <= '0';
			when "0000010" =>
				SD1Output(0) <= '0';
			when "0000011" =>
				SD1Output(0) <= '0';
			when "0000100" =>
				SD1Output(0) <= '0';
			when "0000101" =>
				SD1Output(0) <= '0';
			when "0000110" =>
				SD1Output(0) <= '0';
			when "0000111" =>
				SD1Output(0) <= '1';
			when "0001000" =>
				SD1Output(0) <= '0';
			when "0001001" =>
				SD1Output(0) <= '0';
			when "0001010" =>
				SD1Output(0) <= '0';
			when "0001011" =>
				SD1Output(0) <= '1';
			when "0001100" =>
				SD1Output(0) <= '0';
			when "0001101" =>
				SD1Output(0) <= '1';
			when "0001110" =>
				SD1Output(0) <= '1';
			when "0001111" =>
				SD1Output(0) <= '1';
			when "0010000" =>
				SD1Output(0) <= '0';
			when "0010001" =>
				SD1Output(0) <= '0';
			when "0010010" =>
				SD1Output(0) <= '0';
			when "0010011" =>
				SD1Output(0) <= '0';
			when "0010100" =>
				SD1Output(0) <= '0';
			when "0010101" =>
				SD1Output(0) <= '0';
			when "0010110" =>
				SD1Output(0) <= '-';
			when "0010111" =>
				SD1Output(0) <= '-';
			when "0011000" =>
				SD1Output(0) <= '0';
			when "0011001" =>
				SD1Output(0) <= '-';
			when "0011010" =>
				SD1Output(0) <= '-';
			when "0011011" =>
				SD1Output(0) <= '-';
			when "0011100" =>
				SD1Output(0) <= '-';
			when "0011101" =>
				SD1Output(0) <= '-';
			when "0011110" =>
				SD1Output(0) <= '-';
			when "0011111" =>
				SD1Output(0) <= '1';
			when "0100000" =>
				SD1Output(0) <= '0';
			when "0100001" =>
				SD1Output(0) <= '0';
			when "0100010" =>
				SD1Output(0) <= '0';
			when "0100011" =>
				SD1Output(0) <= '0';
			when "0100100" =>
				SD1Output(0) <= '0';
			when "0100101" =>
				SD1Output(0) <= '-';
			when "0100110" =>
				SD1Output(0) <= '-';
			when "0100111" =>
				SD1Output(0) <= '-';
			when "0101000" =>
				SD1Output(0) <= '0';
			when "0101001" =>
				SD1Output(0) <= '-';
			when "0101010" =>
				SD1Output(0) <= '0';
			when "0101011" =>
				SD1Output(0) <= '-';
			when "0101100" =>
				SD1Output(0) <= '-';
			when "0101101" =>
				SD1Output(0) <= '-';
			when "0101110" =>
				SD1Output(0) <= '-';
			when "0101111" =>
				SD1Output(0) <= '1';
			when "0110000" =>
				SD1Output(0) <= '0';
			when "0110001" =>
				SD1Output(0) <= '0';
			when "0110010" =>
				SD1Output(0) <= '0';
			when "0110011" =>
				SD1Output(0) <= '0';
			when "0110100" =>
				SD1Output(0) <= '-';
			when "0110101" =>
				SD1Output(0) <= '-';
			when "0110110" =>
				SD1Output(0) <= '-';
			when "0110111" =>
				SD1Output(0) <= '0';
			when "0111000" =>
				SD1Output(0) <= '-';
			when "0111001" =>
				SD1Output(0) <= '-';
			when "0111010" =>
				SD1Output(0) <= '-';
			when "0111011" =>
				SD1Output(0) <= '0';
			when "0111100" =>
				SD1Output(0) <= '1';
			when "0111101" =>
				SD1Output(0) <= '-';
			when "0111110" =>
				SD1Output(0) <= '-';
			when "0111111" =>
				SD1Output(0) <= '0';
			when "1000000" =>
				SD1Output(0) <= '0';
			when "1000001" =>
				SD1Output(0) <= '0';
			when "1000010" =>
				SD1Output(0) <= '0';
			when "1000011" =>
				SD1Output(0) <= '-';
			when "1000100" =>
				SD1Output(0) <= '0';
			when "1000101" =>
				SD1Output(0) <= '0';
			when "1000110" =>
				SD1Output(0) <= '-';
			when "1000111" =>
				SD1Output(0) <= '-';
			when "1001000" =>
				SD1Output(0) <= '0';
			when "1001001" =>
				SD1Output(0) <= '-';
			when "1001010" =>
				SD1Output(0) <= '0';
			when "1001011" =>
				SD1Output(0) <= '-';
			when "1001100" =>
				SD1Output(0) <= '-';
			when "1001101" =>
				SD1Output(0) <= '-';
			when "1001110" =>
				SD1Output(0) <= '-';
			when "1001111" =>
				SD1Output(0) <= '1';
			when "1010000" =>
				SD1Output(0) <= '0';
			when "1010001" =>
				SD1Output(0) <= '0';
			when "1010010" =>
				SD1Output(0) <= '-';
			when "1010011" =>
				SD1Output(0) <= '-';
			when "1010100" =>
				SD1Output(0) <= '0';
			when "1010101" =>
				SD1Output(0) <= '0';
			when "1010110" =>
				SD1Output(0) <= '-';
			when "1010111" =>
				SD1Output(0) <= '0';
			when "1011000" =>
				SD1Output(0) <= '-';
			when "1011001" =>
				SD1Output(0) <= '0';
			when "1011010" =>
				SD1Output(0) <= '1';
			when "1011011" =>
				SD1Output(0) <= '-';
			when "1011100" =>
				SD1Output(0) <= '-';
			when "1011101" =>
				SD1Output(0) <= '0';
			when "1011110" =>
				SD1Output(0) <= '-';
			when "1011111" =>
				SD1Output(0) <= '-';
			when "1100000" =>
				SD1Output(0) <= '0';
			when "1100001" =>
				SD1Output(0) <= '-';
			when "1100010" =>
				SD1Output(0) <= '0';
			when "1100011" =>
				SD1Output(0) <= '-';
			when "1100100" =>
				SD1Output(0) <= '-';
			when "1100101" =>
				SD1Output(0) <= '1';
			when "1100110" =>
				SD1Output(0) <= '0';
			when "1100111" =>
				SD1Output(0) <= '-';
			when "1101000" =>
				SD1Output(0) <= '0';
			when "1101001" =>
				SD1Output(0) <= '-';
			when "1101010" =>
				SD1Output(0) <= '0';
			when "1101011" =>
				SD1Output(0) <= '0';
			when "1101100" =>
				SD1Output(0) <= '-';
			when "1101101" =>
				SD1Output(0) <= '-';
			when "1101110" =>
				SD1Output(0) <= '0';
			when "1101111" =>
				SD1Output(0) <= '-';
			when "1110000" =>
				SD1Output(0) <= '-';
			when "1110001" =>
				SD1Output(0) <= '-';
			when "1110010" =>
				SD1Output(0) <= '-';
			when "1110011" =>
				SD1Output(0) <= '0';
			when "1110100" =>
				SD1Output(0) <= '-';
			when "1110101" =>
				SD1Output(0) <= '0';
			when "1110110" =>
				SD1Output(0) <= '-';
			when "1110111" =>
				SD1Output(0) <= '-';
			when "1111000" =>
				SD1Output(0) <= '-';
			when "1111001" =>
				SD1Output(0) <= '-';
			when "1111010" =>
				SD1Output(0) <= '0';
			when "1111011" =>
				SD1Output(0) <= '-';
			when "1111100" =>
				SD1Output(0) <= '-';
			when "1111101" =>
				SD1Output(0) <= '-';
			when "1111110" =>
				SD1Output(0) <= '-';
			when others =>
				SD1Output(0) <= '-';
		end case;
	end process;

	SD1_CASE_1 : process (ErrorVec)
	begin
		case ErrorVec is
			when "0000000" =>
				SD1Output(1) <= '0';
			when "0000001" =>
				SD1Output(1) <= '0';
			when "0000010" =>
				SD1Output(1) <= '0';
			when "0000011" =>
				SD1Output(1) <= '0';
			when "0000100" =>
				SD1Output(1) <= '0';
			when "0000101" =>
				SD1Output(1) <= '0';
			when "0000110" =>
				SD1Output(1) <= '0';
			when "0000111" =>
				SD1Output(1) <= '0';
			when "0001000" =>
				SD1Output(1) <= '0';
			when "0001001" =>
				SD1Output(1) <= '0';
			when "0001010" =>
				SD1Output(1) <= '0';
			when "0001011" =>
				SD1Output(1) <= '0';
			when "0001100" =>
				SD1Output(1) <= '0';
			when "0001101" =>
				SD1Output(1) <= '0';
			when "0001110" =>
				SD1Output(1) <= '0';
			when "0001111" =>
				SD1Output(1) <= '0';
			when "0010000" =>
				SD1Output(1) <= '0';
			when "0010001" =>
				SD1Output(1) <= '0';
			when "0010010" =>
				SD1Output(1) <= '0';
			when "0010011" =>
				SD1Output(1) <= '1';
			when "0010100" =>
				SD1Output(1) <= '0';
			when "0010101" =>
				SD1Output(1) <= '0';
			when "0010110" =>
				SD1Output(1) <= '-';
			when "0010111" =>
				SD1Output(1) <= '-';
			when "0011000" =>
				SD1Output(1) <= '0';
			when "0011001" =>
				SD1Output(1) <= '-';
			when "0011010" =>
				SD1Output(1) <= '-';
			when "0011011" =>
				SD1Output(1) <= '-';
			when "0011100" =>
				SD1Output(1) <= '-';
			when "0011101" =>
				SD1Output(1) <= '-';
			when "0011110" =>
				SD1Output(1) <= '-';
			when "0011111" =>
				SD1Output(1) <= '0';
			when "0100000" =>
				SD1Output(1) <= '0';
			when "0100001" =>
				SD1Output(1) <= '0';
			when "0100010" =>
				SD1Output(1) <= '0';
			when "0100011" =>
				SD1Output(1) <= '1';
			when "0100100" =>
				SD1Output(1) <= '0';
			when "0100101" =>
				SD1Output(1) <= '-';
			when "0100110" =>
				SD1Output(1) <= '-';
			when "0100111" =>
				SD1Output(1) <= '-';
			when "0101000" =>
				SD1Output(1) <= '0';
			when "0101001" =>
				SD1Output(1) <= '-';
			when "0101010" =>
				SD1Output(1) <= '0';
			when "0101011" =>
				SD1Output(1) <= '-';
			when "0101100" =>
				SD1Output(1) <= '-';
			when "0101101" =>
				SD1Output(1) <= '-';
			when "0101110" =>
				SD1Output(1) <= '-';
			when "0101111" =>
				SD1Output(1) <= '0';
			when "0110000" =>
				SD1Output(1) <= '0';
			when "0110001" =>
				SD1Output(1) <= '1';
			when "0110010" =>
				SD1Output(1) <= '1';
			when "0110011" =>
				SD1Output(1) <= '1';
			when "0110100" =>
				SD1Output(1) <= '-';
			when "0110101" =>
				SD1Output(1) <= '-';
			when "0110110" =>
				SD1Output(1) <= '-';
			when "0110111" =>
				SD1Output(1) <= '1';
			when "0111000" =>
				SD1Output(1) <= '-';
			when "0111001" =>
				SD1Output(1) <= '-';
			when "0111010" =>
				SD1Output(1) <= '-';
			when "0111011" =>
				SD1Output(1) <= '1';
			when "0111100" =>
				SD1Output(1) <= '1';
			when "0111101" =>
				SD1Output(1) <= '-';
			when "0111110" =>
				SD1Output(1) <= '-';
			when "0111111" =>
				SD1Output(1) <= '0';
			when "1000000" =>
				SD1Output(1) <= '0';
			when "1000001" =>
				SD1Output(1) <= '0';
			when "1000010" =>
				SD1Output(1) <= '0';
			when "1000011" =>
				SD1Output(1) <= '-';
			when "1000100" =>
				SD1Output(1) <= '0';
			when "1000101" =>
				SD1Output(1) <= '0';
			when "1000110" =>
				SD1Output(1) <= '-';
			when "1000111" =>
				SD1Output(1) <= '-';
			when "1001000" =>
				SD1Output(1) <= '0';
			when "1001001" =>
				SD1Output(1) <= '-';
			when "1001010" =>
				SD1Output(1) <= '0';
			when "1001011" =>
				SD1Output(1) <= '-';
			when "1001100" =>
				SD1Output(1) <= '-';
			when "1001101" =>
				SD1Output(1) <= '-';
			when "1001110" =>
				SD1Output(1) <= '-';
			when "1001111" =>
				SD1Output(1) <= '0';
			when "1010000" =>
				SD1Output(1) <= '0';
			when "1010001" =>
				SD1Output(1) <= '0';
			when "1010010" =>
				SD1Output(1) <= '-';
			when "1010011" =>
				SD1Output(1) <= '-';
			when "1010100" =>
				SD1Output(1) <= '0';
			when "1010101" =>
				SD1Output(1) <= '0';
			when "1010110" =>
				SD1Output(1) <= '-';
			when "1010111" =>
				SD1Output(1) <= '0';
			when "1011000" =>
				SD1Output(1) <= '-';
			when "1011001" =>
				SD1Output(1) <= '1';
			when "1011010" =>
				SD1Output(1) <= '0';
			when "1011011" =>
				SD1Output(1) <= '-';
			when "1011100" =>
				SD1Output(1) <= '-';
			when "1011101" =>
				SD1Output(1) <= '0';
			when "1011110" =>
				SD1Output(1) <= '-';
			when "1011111" =>
				SD1Output(1) <= '-';
			when "1100000" =>
				SD1Output(1) <= '0';
			when "1100001" =>
				SD1Output(1) <= '-';
			when "1100010" =>
				SD1Output(1) <= '0';
			when "1100011" =>
				SD1Output(1) <= '-';
			when "1100100" =>
				SD1Output(1) <= '-';
			when "1100101" =>
				SD1Output(1) <= '0';
			when "1100110" =>
				SD1Output(1) <= '1';
			when "1100111" =>
				SD1Output(1) <= '-';
			when "1101000" =>
				SD1Output(1) <= '0';
			when "1101001" =>
				SD1Output(1) <= '-';
			when "1101010" =>
				SD1Output(1) <= '0';
			when "1101011" =>
				SD1Output(1) <= '0';
			when "1101100" =>
				SD1Output(1) <= '-';
			when "1101101" =>
				SD1Output(1) <= '-';
			when "1101110" =>
				SD1Output(1) <= '0';
			when "1101111" =>
				SD1Output(1) <= '-';
			when "1110000" =>
				SD1Output(1) <= '-';
			when "1110001" =>
				SD1Output(1) <= '-';
			when "1110010" =>
				SD1Output(1) <= '-';
			when "1110011" =>
				SD1Output(1) <= '1';
			when "1110100" =>
				SD1Output(1) <= '-';
			when "1110101" =>
				SD1Output(1) <= '0';
			when "1110110" =>
				SD1Output(1) <= '-';
			when "1110111" =>
				SD1Output(1) <= '-';
			when "1111000" =>
				SD1Output(1) <= '-';
			when "1111001" =>
				SD1Output(1) <= '-';
			when "1111010" =>
				SD1Output(1) <= '0';
			when "1111011" =>
				SD1Output(1) <= '-';
			when "1111100" =>
				SD1Output(1) <= '-';
			when "1111101" =>
				SD1Output(1) <= '-';
			when "1111110" =>
				SD1Output(1) <= '-';
			when others =>
				SD1Output(1) <= '-';
		end case;
	end process;

	SD1_CASE_2 : process (ErrorVec)
	begin
		case ErrorVec is
			when "0000000" =>
				SD1Output(2) <= '0';
			when "0000001" =>
				SD1Output(2) <= '0';
			when "0000010" =>
				SD1Output(2) <= '0';
			when "0000011" =>
				SD1Output(2) <= '0';
			when "0000100" =>
				SD1Output(2) <= '0';
			when "0000101" =>
				SD1Output(2) <= '0';
			when "0000110" =>
				SD1Output(2) <= '0';
			when "0000111" =>
				SD1Output(2) <= '0';
			when "0001000" =>
				SD1Output(2) <= '0';
			when "0001001" =>
				SD1Output(2) <= '0';
			when "0001010" =>
				SD1Output(2) <= '0';
			when "0001011" =>
				SD1Output(2) <= '0';
			when "0001100" =>
				SD1Output(2) <= '0';
			when "0001101" =>
				SD1Output(2) <= '0';
			when "0001110" =>
				SD1Output(2) <= '0';
			when "0001111" =>
				SD1Output(2) <= '0';
			when "0010000" =>
				SD1Output(2) <= '0';
			when "0010001" =>
				SD1Output(2) <= '0';
			when "0010010" =>
				SD1Output(2) <= '0';
			when "0010011" =>
				SD1Output(2) <= '0';
			when "0010100" =>
				SD1Output(2) <= '0';
			when "0010101" =>
				SD1Output(2) <= '1';
			when "0010110" =>
				SD1Output(2) <= '-';
			when "0010111" =>
				SD1Output(2) <= '-';
			when "0011000" =>
				SD1Output(2) <= '0';
			when "0011001" =>
				SD1Output(2) <= '-';
			when "0011010" =>
				SD1Output(2) <= '-';
			when "0011011" =>
				SD1Output(2) <= '-';
			when "0011100" =>
				SD1Output(2) <= '-';
			when "0011101" =>
				SD1Output(2) <= '-';
			when "0011110" =>
				SD1Output(2) <= '-';
			when "0011111" =>
				SD1Output(2) <= '0';
			when "0100000" =>
				SD1Output(2) <= '0';
			when "0100001" =>
				SD1Output(2) <= '0';
			when "0100010" =>
				SD1Output(2) <= '0';
			when "0100011" =>
				SD1Output(2) <= '0';
			when "0100100" =>
				SD1Output(2) <= '0';
			when "0100101" =>
				SD1Output(2) <= '-';
			when "0100110" =>
				SD1Output(2) <= '-';
			when "0100111" =>
				SD1Output(2) <= '-';
			when "0101000" =>
				SD1Output(2) <= '0';
			when "0101001" =>
				SD1Output(2) <= '-';
			when "0101010" =>
				SD1Output(2) <= '0';
			when "0101011" =>
				SD1Output(2) <= '-';
			when "0101100" =>
				SD1Output(2) <= '-';
			when "0101101" =>
				SD1Output(2) <= '-';
			when "0101110" =>
				SD1Output(2) <= '-';
			when "0101111" =>
				SD1Output(2) <= '0';
			when "0110000" =>
				SD1Output(2) <= '0';
			when "0110001" =>
				SD1Output(2) <= '0';
			when "0110010" =>
				SD1Output(2) <= '0';
			when "0110011" =>
				SD1Output(2) <= '0';
			when "0110100" =>
				SD1Output(2) <= '-';
			when "0110101" =>
				SD1Output(2) <= '-';
			when "0110110" =>
				SD1Output(2) <= '-';
			when "0110111" =>
				SD1Output(2) <= '0';
			when "0111000" =>
				SD1Output(2) <= '-';
			when "0111001" =>
				SD1Output(2) <= '-';
			when "0111010" =>
				SD1Output(2) <= '-';
			when "0111011" =>
				SD1Output(2) <= '0';
			when "0111100" =>
				SD1Output(2) <= '0';
			when "0111101" =>
				SD1Output(2) <= '-';
			when "0111110" =>
				SD1Output(2) <= '-';
			when "0111111" =>
				SD1Output(2) <= '1';
			when "1000000" =>
				SD1Output(2) <= '0';
			when "1000001" =>
				SD1Output(2) <= '0';
			when "1000010" =>
				SD1Output(2) <= '0';
			when "1000011" =>
				SD1Output(2) <= '-';
			when "1000100" =>
				SD1Output(2) <= '0';
			when "1000101" =>
				SD1Output(2) <= '1';
			when "1000110" =>
				SD1Output(2) <= '-';
			when "1000111" =>
				SD1Output(2) <= '-';
			when "1001000" =>
				SD1Output(2) <= '0';
			when "1001001" =>
				SD1Output(2) <= '-';
			when "1001010" =>
				SD1Output(2) <= '0';
			when "1001011" =>
				SD1Output(2) <= '-';
			when "1001100" =>
				SD1Output(2) <= '-';
			when "1001101" =>
				SD1Output(2) <= '-';
			when "1001110" =>
				SD1Output(2) <= '-';
			when "1001111" =>
				SD1Output(2) <= '0';
			when "1010000" =>
				SD1Output(2) <= '0';
			when "1010001" =>
				SD1Output(2) <= '1';
			when "1010010" =>
				SD1Output(2) <= '-';
			when "1010011" =>
				SD1Output(2) <= '-';
			when "1010100" =>
				SD1Output(2) <= '1';
			when "1010101" =>
				SD1Output(2) <= '1';
			when "1010110" =>
				SD1Output(2) <= '-';
			when "1010111" =>
				SD1Output(2) <= '1';
			when "1011000" =>
				SD1Output(2) <= '-';
			when "1011001" =>
				SD1Output(2) <= '0';
			when "1011010" =>
				SD1Output(2) <= '1';
			when "1011011" =>
				SD1Output(2) <= '-';
			when "1011100" =>
				SD1Output(2) <= '-';
			when "1011101" =>
				SD1Output(2) <= '1';
			when "1011110" =>
				SD1Output(2) <= '-';
			when "1011111" =>
				SD1Output(2) <= '-';
			when "1100000" =>
				SD1Output(2) <= '0';
			when "1100001" =>
				SD1Output(2) <= '-';
			when "1100010" =>
				SD1Output(2) <= '0';
			when "1100011" =>
				SD1Output(2) <= '-';
			when "1100100" =>
				SD1Output(2) <= '-';
			when "1100101" =>
				SD1Output(2) <= '0';
			when "1100110" =>
				SD1Output(2) <= '1';
			when "1100111" =>
				SD1Output(2) <= '-';
			when "1101000" =>
				SD1Output(2) <= '0';
			when "1101001" =>
				SD1Output(2) <= '-';
			when "1101010" =>
				SD1Output(2) <= '0';
			when "1101011" =>
				SD1Output(2) <= '0';
			when "1101100" =>
				SD1Output(2) <= '-';
			when "1101101" =>
				SD1Output(2) <= '-';
			when "1101110" =>
				SD1Output(2) <= '0';
			when "1101111" =>
				SD1Output(2) <= '-';
			when "1110000" =>
				SD1Output(2) <= '-';
			when "1110001" =>
				SD1Output(2) <= '-';
			when "1110010" =>
				SD1Output(2) <= '-';
			when "1110011" =>
				SD1Output(2) <= '0';
			when "1110100" =>
				SD1Output(2) <= '-';
			when "1110101" =>
				SD1Output(2) <= '1';
			when "1110110" =>
				SD1Output(2) <= '-';
			when "1110111" =>
				SD1Output(2) <= '-';
			when "1111000" =>
				SD1Output(2) <= '-';
			when "1111001" =>
				SD1Output(2) <= '-';
			when "1111010" =>
				SD1Output(2) <= '0';
			when "1111011" =>
				SD1Output(2) <= '-';
			when "1111100" =>
				SD1Output(2) <= '-';
			when "1111101" =>
				SD1Output(2) <= '-';
			when "1111110" =>
				SD1Output(2) <= '-';
			when others =>
				SD1Output(2) <= '-';
		end case;
	end process;

	SD1_CASE_3 : process (ErrorVec)
	begin
		case ErrorVec is
			when "0000000" =>
				SD1Output(3) <= '0';
			when "0000001" =>
				SD1Output(3) <= '0';
			when "0000010" =>
				SD1Output(3) <= '0';
			when "0000011" =>
				SD1Output(3) <= '0';
			when "0000100" =>
				SD1Output(3) <= '0';
			when "0000101" =>
				SD1Output(3) <= '0';
			when "0000110" =>
				SD1Output(3) <= '0';
			when "0000111" =>
				SD1Output(3) <= '0';
			when "0001000" =>
				SD1Output(3) <= '0';
			when "0001001" =>
				SD1Output(3) <= '0';
			when "0001010" =>
				SD1Output(3) <= '0';
			when "0001011" =>
				SD1Output(3) <= '0';
			when "0001100" =>
				SD1Output(3) <= '0';
			when "0001101" =>
				SD1Output(3) <= '0';
			when "0001110" =>
				SD1Output(3) <= '0';
			when "0001111" =>
				SD1Output(3) <= '0';
			when "0010000" =>
				SD1Output(3) <= '0';
			when "0010001" =>
				SD1Output(3) <= '0';
			when "0010010" =>
				SD1Output(3) <= '0';
			when "0010011" =>
				SD1Output(3) <= '0';
			when "0010100" =>
				SD1Output(3) <= '0';
			when "0010101" =>
				SD1Output(3) <= '0';
			when "0010110" =>
				SD1Output(3) <= '-';
			when "0010111" =>
				SD1Output(3) <= '-';
			when "0011000" =>
				SD1Output(3) <= '0';
			when "0011001" =>
				SD1Output(3) <= '-';
			when "0011010" =>
				SD1Output(3) <= '-';
			when "0011011" =>
				SD1Output(3) <= '-';
			when "0011100" =>
				SD1Output(3) <= '-';
			when "0011101" =>
				SD1Output(3) <= '-';
			when "0011110" =>
				SD1Output(3) <= '-';
			when "0011111" =>
				SD1Output(3) <= '0';
			when "0100000" =>
				SD1Output(3) <= '0';
			when "0100001" =>
				SD1Output(3) <= '0';
			when "0100010" =>
				SD1Output(3) <= '0';
			when "0100011" =>
				SD1Output(3) <= '0';
			when "0100100" =>
				SD1Output(3) <= '0';
			when "0100101" =>
				SD1Output(3) <= '-';
			when "0100110" =>
				SD1Output(3) <= '-';
			when "0100111" =>
				SD1Output(3) <= '-';
			when "0101000" =>
				SD1Output(3) <= '0';
			when "0101001" =>
				SD1Output(3) <= '-';
			when "0101010" =>
				SD1Output(3) <= '1';
			when "0101011" =>
				SD1Output(3) <= '-';
			when "0101100" =>
				SD1Output(3) <= '-';
			when "0101101" =>
				SD1Output(3) <= '-';
			when "0101110" =>
				SD1Output(3) <= '-';
			when "0101111" =>
				SD1Output(3) <= '0';
			when "0110000" =>
				SD1Output(3) <= '0';
			when "0110001" =>
				SD1Output(3) <= '0';
			when "0110010" =>
				SD1Output(3) <= '0';
			when "0110011" =>
				SD1Output(3) <= '0';
			when "0110100" =>
				SD1Output(3) <= '-';
			when "0110101" =>
				SD1Output(3) <= '-';
			when "0110110" =>
				SD1Output(3) <= '-';
			when "0110111" =>
				SD1Output(3) <= '0';
			when "0111000" =>
				SD1Output(3) <= '-';
			when "0111001" =>
				SD1Output(3) <= '-';
			when "0111010" =>
				SD1Output(3) <= '-';
			when "0111011" =>
				SD1Output(3) <= '0';
			when "0111100" =>
				SD1Output(3) <= '0';
			when "0111101" =>
				SD1Output(3) <= '-';
			when "0111110" =>
				SD1Output(3) <= '-';
			when "0111111" =>
				SD1Output(3) <= '1';
			when "1000000" =>
				SD1Output(3) <= '0';
			when "1000001" =>
				SD1Output(3) <= '0';
			when "1000010" =>
				SD1Output(3) <= '0';
			when "1000011" =>
				SD1Output(3) <= '-';
			when "1000100" =>
				SD1Output(3) <= '0';
			when "1000101" =>
				SD1Output(3) <= '0';
			when "1000110" =>
				SD1Output(3) <= '-';
			when "1000111" =>
				SD1Output(3) <= '-';
			when "1001000" =>
				SD1Output(3) <= '0';
			when "1001001" =>
				SD1Output(3) <= '-';
			when "1001010" =>
				SD1Output(3) <= '1';
			when "1001011" =>
				SD1Output(3) <= '-';
			when "1001100" =>
				SD1Output(3) <= '-';
			when "1001101" =>
				SD1Output(3) <= '-';
			when "1001110" =>
				SD1Output(3) <= '-';
			when "1001111" =>
				SD1Output(3) <= '0';
			when "1010000" =>
				SD1Output(3) <= '0';
			when "1010001" =>
				SD1Output(3) <= '0';
			when "1010010" =>
				SD1Output(3) <= '-';
			when "1010011" =>
				SD1Output(3) <= '-';
			when "1010100" =>
				SD1Output(3) <= '0';
			when "1010101" =>
				SD1Output(3) <= '0';
			when "1010110" =>
				SD1Output(3) <= '-';
			when "1010111" =>
				SD1Output(3) <= '0';
			when "1011000" =>
				SD1Output(3) <= '-';
			when "1011001" =>
				SD1Output(3) <= '1';
			when "1011010" =>
				SD1Output(3) <= '0';
			when "1011011" =>
				SD1Output(3) <= '-';
			when "1011100" =>
				SD1Output(3) <= '-';
			when "1011101" =>
				SD1Output(3) <= '0';
			when "1011110" =>
				SD1Output(3) <= '-';
			when "1011111" =>
				SD1Output(3) <= '-';
			when "1100000" =>
				SD1Output(3) <= '0';
			when "1100001" =>
				SD1Output(3) <= '-';
			when "1100010" =>
				SD1Output(3) <= '1';
			when "1100011" =>
				SD1Output(3) <= '-';
			when "1100100" =>
				SD1Output(3) <= '-';
			when "1100101" =>
				SD1Output(3) <= '1';
			when "1100110" =>
				SD1Output(3) <= '0';
			when "1100111" =>
				SD1Output(3) <= '-';
			when "1101000" =>
				SD1Output(3) <= '1';
			when "1101001" =>
				SD1Output(3) <= '-';
			when "1101010" =>
				SD1Output(3) <= '1';
			when "1101011" =>
				SD1Output(3) <= '1';
			when "1101100" =>
				SD1Output(3) <= '-';
			when "1101101" =>
				SD1Output(3) <= '-';
			when "1101110" =>
				SD1Output(3) <= '1';
			when "1101111" =>
				SD1Output(3) <= '-';
			when "1110000" =>
				SD1Output(3) <= '-';
			when "1110001" =>
				SD1Output(3) <= '-';
			when "1110010" =>
				SD1Output(3) <= '-';
			when "1110011" =>
				SD1Output(3) <= '0';
			when "1110100" =>
				SD1Output(3) <= '-';
			when "1110101" =>
				SD1Output(3) <= '0';
			when "1110110" =>
				SD1Output(3) <= '-';
			when "1110111" =>
				SD1Output(3) <= '-';
			when "1111000" =>
				SD1Output(3) <= '-';
			when "1111001" =>
				SD1Output(3) <= '-';
			when "1111010" =>
				SD1Output(3) <= '1';
			when "1111011" =>
				SD1Output(3) <= '-';
			when "1111100" =>
				SD1Output(3) <= '-';
			when "1111101" =>
				SD1Output(3) <= '-';
			when "1111110" =>
				SD1Output(3) <= '-';
			when others =>
				SD1Output(3) <= '-';
		end case;
	end process;

	------------------------------------
	CorrectedXGen: FOR i in 0 to StateSize-1 GENERATE
		CorrectedX(i) <= SD1Output(i) xor x(i);
	END GENERATE;
	------------------------------------
	CipherOutput: IF r = 0 GENERATE
		CipherOut 	  <= CorrectedX;
	END GENERATE;
	------------------------------------
	GEN0: IF r=0 GENERATE
				Sbox_Process: Process (CorrectedX)
				begin
					y <= SboxTable0(15-to_integer(unsigned(CorrectedX)));
				end process;	
			END GENERATE;
	
	GEN1: IF r=1 GENERATE
				Sbox_Process: Process (CorrectedX)
				begin
					y <= SboxTable1(15-to_integer(unsigned(CorrectedX)));
				end process;	
			END GENERATE;
		
	GEN2: IF r=2 GENERATE
				Sbox_Process: Process (CorrectedX)
				begin
					y <= SboxTable2(15-to_integer(unsigned(CorrectedX)));
				end process;	
			END GENERATE;
		
	GEN3: IF r=3 GENERATE
				Sbox_Process: Process (CorrectedX)
				begin
					y <= SboxTable3(15-to_integer(unsigned(CorrectedX)));
				end process;	
			END GENERATE;
end Behavioral;

