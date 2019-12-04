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


entity F_SD1_SelectsUpdate_Bit is
	Generic (BitNumber   	: integer;
				withDec			: integer;
				StateSize 		: positive ;
				Red_size 		: positive ;
				LFTable   		: STD_LOGIC_VECTOR (127 DOWNTO 0);
				SD1Table  		: STD_LOGIC_VECTOR (511 DOWNTO 0)
				);
    Port (selects   			: in  STD_LOGIC_VECTOR (1 downto 0);
			 redx   			: in  STD_LOGIC_VECTOR (2*Red_size-1 downto 0);
			 EncDec	  				: in  STD_LOGIC;
          selectsNextBit		: out STD_LOGIC);
end F_SD1_SelectsUpdate_Bit;

architecture Behavioral of F_SD1_SelectsUpdate_Bit is
	constant SD1Table0 : STD_LOGIC_VECTOR (127 DOWNTO 0) :=
		SD1Table(508) & SD1Table(504) & SD1Table(500) & SD1Table(496) & SD1Table(492) & SD1Table(488) & SD1Table(484) & SD1Table(480) & SD1Table(476) & SD1Table(472) & SD1Table(468) & SD1Table(464) & SD1Table(460) & SD1Table(456) & SD1Table(452) & SD1Table(448) & SD1Table(444) & SD1Table(440) & SD1Table(436) & SD1Table(432) & SD1Table(428) & SD1Table(424) & '-' & '-' & SD1Table(412) & '-' & '-' & '-' & '-' & '-' & '-' & SD1Table(384) & SD1Table(380) & SD1Table(376) & SD1Table(372) & SD1Table(368) & SD1Table(364) & '-' & '-' & '-' & SD1Table(348) & '-' & SD1Table(340) & '-' & '-' & '-' & '-' & SD1Table(320) & SD1Table(316) & SD1Table(312) & SD1Table(308) & SD1Table(304) & '-' & '-' & '-' & SD1Table(288) & '-' & '-' & '-' & SD1Table(272) & SD1Table(268) & '-' & '-' & SD1Table(256) & SD1Table(252) & SD1Table(248) & SD1Table(244) & '-' & SD1Table(236) & SD1Table(232) & '-' & '-' & SD1Table(220) & '-' & SD1Table(212) & '-' & '-' & '-' & '-' & SD1Table(192) & SD1Table(188) & SD1Table(184) & '-' & '-' & SD1Table(172) & SD1Table(168) & '-' & SD1Table(160) & '-' & SD1Table(152) & SD1Table(148) & '-' & '-' & SD1Table(136) & '-' & '-' & SD1Table(124) & '-' & SD1Table(116) & '-' & '-' & SD1Table(104) & SD1Table(100) & '-' & SD1Table(92) & '-' & SD1Table(84) & SD1Table(80) & '-' & '-' & SD1Table(68) & '-' & '-' & '-' & '-' & SD1Table(48) & '-' & SD1Table(40) & '-' & '-' & '-' & '-' & SD1Table(20) & '-' & '-' & '-' & '-' & '-' ; 

	constant SD1Table1 : STD_LOGIC_VECTOR (127 DOWNTO 0) :=
		SD1Table(509) & SD1Table(505) & SD1Table(501) & SD1Table(497) & SD1Table(493) & SD1Table(489) & SD1Table(485) & SD1Table(481) & SD1Table(477) & SD1Table(473) & SD1Table(469) & SD1Table(465) & SD1Table(461) & SD1Table(457) & SD1Table(453) & SD1Table(449) & SD1Table(445) & SD1Table(441) & SD1Table(437) & SD1Table(433) & SD1Table(429) & SD1Table(425) & '-' & '-' & SD1Table(413) & '-' & '-' & '-' & '-' & '-' & '-' & SD1Table(385) & SD1Table(381) & SD1Table(377) & SD1Table(373) & SD1Table(369) & SD1Table(365) & '-' & '-' & '-' & SD1Table(349) & '-' & SD1Table(341) & '-' & '-' & '-' & '-' & SD1Table(321) & SD1Table(317) & SD1Table(313) & SD1Table(309) & SD1Table(305) & '-' & '-' & '-' & SD1Table(289) & '-' & '-' & '-' & SD1Table(273) & SD1Table(269) & '-' & '-' & SD1Table(257) & SD1Table(253) & SD1Table(249) & SD1Table(245) & '-' & SD1Table(237) & SD1Table(233) & '-' & '-' & SD1Table(221) & '-' & SD1Table(213) & '-' & '-' & '-' & '-' & SD1Table(193) & SD1Table(189) & SD1Table(185) & '-' & '-' & SD1Table(173) & SD1Table(169) & '-' & SD1Table(161) & '-' & SD1Table(153) & SD1Table(149) & '-' & '-' & SD1Table(137) & '-' & '-' & SD1Table(125) & '-' & SD1Table(117) & '-' & '-' & SD1Table(105) & SD1Table(101) & '-' & SD1Table(93) & '-' & SD1Table(85) & SD1Table(81) & '-' & '-' & SD1Table(69) & '-' & '-' & '-' & '-' & SD1Table(49) & '-' & SD1Table(41) & '-' & '-' & '-' & '-' & SD1Table(21) & '-' & '-' & '-' & '-' & '-' ; 

	constant SD1Table2 : STD_LOGIC_VECTOR (127 DOWNTO 0) :=
		SD1Table(510) & SD1Table(506) & SD1Table(502) & SD1Table(498) & SD1Table(494) & SD1Table(490) & SD1Table(486) & SD1Table(482) & SD1Table(478) & SD1Table(474) & SD1Table(470) & SD1Table(466) & SD1Table(462) & SD1Table(458) & SD1Table(454) & SD1Table(450) & SD1Table(446) & SD1Table(442) & SD1Table(438) & SD1Table(434) & SD1Table(430) & SD1Table(426) & '-' & '-' & SD1Table(414) & '-' & '-' & '-' & '-' & '-' & '-' & SD1Table(386) & SD1Table(382) & SD1Table(378) & SD1Table(374) & SD1Table(370) & SD1Table(366) & '-' & '-' & '-' & SD1Table(350) & '-' & SD1Table(342) & '-' & '-' & '-' & '-' & SD1Table(322) & SD1Table(318) & SD1Table(314) & SD1Table(310) & SD1Table(306) & '-' & '-' & '-' & SD1Table(290) & '-' & '-' & '-' & SD1Table(274) & SD1Table(270) & '-' & '-' & SD1Table(258) & SD1Table(254) & SD1Table(250) & SD1Table(246) & '-' & SD1Table(238) & SD1Table(234) & '-' & '-' & SD1Table(222) & '-' & SD1Table(214) & '-' & '-' & '-' & '-' & SD1Table(194) & SD1Table(190) & SD1Table(186) & '-' & '-' & SD1Table(174) & SD1Table(170) & '-' & SD1Table(162) & '-' & SD1Table(154) & SD1Table(150) & '-' & '-' & SD1Table(138) & '-' & '-' & SD1Table(126) & '-' & SD1Table(118) & '-' & '-' & SD1Table(106) & SD1Table(102) & '-' & SD1Table(94) & '-' & SD1Table(86) & SD1Table(82) & '-' & '-' & SD1Table(70) & '-' & '-' & '-' & '-' & SD1Table(50) & '-' & SD1Table(42) & '-' & '-' & '-' & '-' & SD1Table(22) & '-' & '-' & '-' & '-' & '-' ; 

	constant SD1Table3 : STD_LOGIC_VECTOR (127 DOWNTO 0) :=
		SD1Table(511) & SD1Table(507) & SD1Table(503) & SD1Table(499) & SD1Table(495) & SD1Table(491) & SD1Table(487) & SD1Table(483) & SD1Table(479) & SD1Table(475) & SD1Table(471) & SD1Table(467) & SD1Table(463) & SD1Table(459) & SD1Table(455) & SD1Table(451) & SD1Table(447) & SD1Table(443) & SD1Table(439) & SD1Table(435) & SD1Table(431) & SD1Table(427) & '-' & '-' & SD1Table(415) & '-' & '-' & '-' & '-' & '-' & '-' & SD1Table(387) & SD1Table(383) & SD1Table(379) & SD1Table(375) & SD1Table(371) & SD1Table(367) & '-' & '-' & '-' & SD1Table(351) & '-' & SD1Table(343) & '-' & '-' & '-' & '-' & SD1Table(323) & SD1Table(319) & SD1Table(315) & SD1Table(311) & SD1Table(307) & '-' & '-' & '-' & SD1Table(291) & '-' & '-' & '-' & SD1Table(275) & SD1Table(271) & '-' & '-' & SD1Table(259) & SD1Table(255) & SD1Table(251) & SD1Table(247) & '-' & SD1Table(239) & SD1Table(235) & '-' & '-' & SD1Table(223) & '-' & SD1Table(215) & '-' & '-' & '-' & '-' & SD1Table(195) & SD1Table(191) & SD1Table(187) & '-' & '-' & SD1Table(175) & SD1Table(171) & '-' & SD1Table(163) & '-' & SD1Table(155) & SD1Table(151) & '-' & '-' & SD1Table(139) & '-' & '-' & SD1Table(127) & '-' & SD1Table(119) & '-' & '-' & SD1Table(107) & SD1Table(103) & '-' & SD1Table(95) & '-' & SD1Table(87) & SD1Table(83) & '-' & '-' & SD1Table(71) & '-' & '-' & '-' & '-' & SD1Table(51) & '-' & SD1Table(43) & '-' & '-' & '-' & '-' & SD1Table(23) & '-' & '-' & '-' & '-' & '-' ; 
	
	------------------------------------
	constant LFTable0 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		LFTable(120) & LFTable(112) & LFTable(104) & LFTable(96) & LFTable(88) & 
		LFTable(80) & LFTable(72) & LFTable(64) & LFTable(56) & LFTable(48) & LFTable(40) & 
		LFTable(32) & LFTable(24) & LFTable(16) & LFTable(8) & LFTable(0);

	constant LFTable1 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		LFTable(121) & LFTable(113) & LFTable(105) & LFTable(97) & LFTable(89) & 
		LFTable(81) & LFTable(73) & LFTable(65) & LFTable(57) & LFTable(49) & LFTable(41) & 
		LFTable(33) & LFTable(25) & LFTable(17) & LFTable(9) & LFTable(1);

	constant LFTable2 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		LFTable(122) & LFTable(114) & LFTable(106) & LFTable(98) & LFTable(90) & 
		LFTable(82) & LFTable(74) & LFTable(66) & LFTable(58) & LFTable(50) & LFTable(42) & 
		LFTable(34) & LFTable(26) & LFTable(18) & LFTable(10) & LFTable(2);

	constant LFTable3 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		LFTable(123) & LFTable(115) & LFTable(107) & LFTable(99) & LFTable(91) & 
		LFTable(83) & LFTable(75) & LFTable(67) & LFTable(59) & LFTable(51) & LFTable(43) & 
		LFTable(35) & LFTable(27) & LFTable(19) & LFTable(11) & LFTable(3);

	constant LFTable4 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		LFTable(124) & LFTable(116) & LFTable(108) & LFTable(100) & LFTable(92) & 
		LFTable(84) & LFTable(76) & LFTable(68) & LFTable(60) & LFTable(52) & LFTable(44) & 
		LFTable(36) & LFTable(28) & LFTable(20) & LFTable(12) & LFTable(4);

	constant LFTable5 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		LFTable(125) & LFTable(117) & LFTable(109) & LFTable(101) & LFTable(93) & 
		LFTable(85) & LFTable(77) & LFTable(69) & LFTable(61) & LFTable(53) & LFTable(45) & 
		LFTable(37) & LFTable(29) & LFTable(21) & LFTable(13) & LFTable(5);

	constant LFTable6 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		LFTable(126) & LFTable(118) & LFTable(110) & LFTable(102) & LFTable(94) & 
		LFTable(86) & LFTable(78) & LFTable(70) & LFTable(62) & LFTable(54) & LFTable(46) & 
		LFTable(38) & LFTable(30) & LFTable(22) & LFTable(14) & LFTable(6);

	constant LFTable7 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		LFTable(127) & LFTable(119) & LFTable(111) & LFTable(103) & LFTable(95) & 
		LFTable(87) & LFTable(79) & LFTable(71) & LFTable(63) & LFTable(55) & LFTable(47) & 
		LFTable(39) & LFTable(31) & LFTable(23) & LFTable(15) & LFTable(7); 
	------------------------------------
		
		signal x0,x1						: STD_LOGIC_VECTOR(StateSize-1 DOWNTO 0);
		signal F_output0,F_output1		: STD_LOGIC_VECTOR(Red_size-1 DOWNTO 0);
		signal ErrorVec0,ErrorVec1		: STD_LOGIC_VECTOR(Red_size-1 DOWNTO 0);
		signal SD1Output					: STD_LOGIC_VECTOR(1 DOWNTO 0);
begin
	x0(0) <= selects(0);
	x0(StateSize-1 downto 1) <= (others => '0');
	x1(0) <= selects(1);
	x1(StateSize-1 downto 1) <= (others => '0');
	------------------------------------
	LF_Process0: Process (x0)
	begin
		F_output0(0) <= LFTable0(15-to_integer(unsigned(x0)));
	end process;

	LF_Process1: Process (x0)
	begin
		F_output0(1) <= LFTable1(15-to_integer(unsigned(x0)));
	end process;

	LF_Process2: Process (x0)
	begin
		F_output0(2) <= LFTable2(15-to_integer(unsigned(x0)));
	end process;

	LF_Process3: Process (x0)
	begin
		F_output0(3) <= LFTable3(15-to_integer(unsigned(x0)));
	end process;

	LF_Process4: Process (x0)
	begin
		F_output0(4) <= LFTable4(15-to_integer(unsigned(x0)));
	end process;

	LF_Process5: Process (x0)
	begin
		F_output0(5) <= LFTable5(15-to_integer(unsigned(x0)));
	end process;

	LF_Process6: Process (x0)
	begin
		F_output0(6) <= LFTable6(15-to_integer(unsigned(x0)));
	end process;
	------------------------------------
	LF_Processb0: Process (x1)
	begin
		F_output1(0) <= LFTable0(15-to_integer(unsigned(x1)));
	end process;

	LF_Processb1: Process (x1)
	begin
		F_output1(1) <= LFTable1(15-to_integer(unsigned(x1)));
	end process;

	LF_Processb2: Process (x1)
	begin
		F_output1(2) <= LFTable2(15-to_integer(unsigned(x1)));
	end process;

	LF_Processb3: Process (x1)
	begin
		F_output1(3) <= LFTable3(15-to_integer(unsigned(x1)));
	end process;

	LF_Processb4: Process (x1)
	begin
		F_output1(4) <= LFTable4(15-to_integer(unsigned(x1)));
	end process;

	LF_Processb5: Process (x1)
	begin
		F_output1(5) <= LFTable5(15-to_integer(unsigned(x1)));
	end process;

	LF_Processb6: Process (x1)
	begin
		F_output1(6) <= LFTable6(15-to_integer(unsigned(x1)));
	end process;
	------------------------------------
	ErrorVecGen0: FOR i in 0 to Red_size-1 GENERATE
		ErrorVec0(i) <= F_output0(i) xor redx(i);
	END GENERATE;
	ErrorVecGen1: FOR i in 0 to Red_size-1 GENERATE
		ErrorVec1(i) <= F_output1(i) xor redx(i+Red_size);
	END GENERATE;
	------------------------------------
	SD1_Process0: Process (ErrorVec0)
	begin
		SD1Output(0) <= SD1Table0(127-to_integer(unsigned(ErrorVec0)));
	end process;
	
	GEN0: IF BitNumber=0 GENERATE
			selectsNextBit		<= NOT (selects(0) XOR SD1Output(0));
		END GENERATE;	
	
	GEN1: IF BitNumber=1 GENERATE
	
		SD1_Process01: Process (ErrorVec1)
		begin
			SD1Output(1) <= SD1Table0(127-to_integer(unsigned(ErrorVec1)));
		end process;
		
		GenwithoutDecselects: IF withDec = 0 GENERATE
			selectsNextBit		<= selects(1) XOR SD1Output(1) XOR selects(0) XOR SD1Output(0);
		END GENERATE;
		
		GenwithDecselects: IF withDec /= 0 GENERATE
			selectsNextBit		<= selects(1) XOR SD1Output(1) XOR selects(0) XOR SD1Output(0) XOR EncDec;
		END GENERATE;
	END GENERATE;
	
end Behavioral;

