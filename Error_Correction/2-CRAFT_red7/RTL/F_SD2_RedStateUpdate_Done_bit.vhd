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


entity F_SD2_RedStateUpdate_Done_bit is
    generic (BitNumber 		: integer;
				LFSR4doneEnc 	: integer; 
				LFSR3doneEnc 	: integer;
				LFSR4doneDec	: integer;
				LFSR3doneDec 	: integer;
				withDec 			: integer;
				StateSize 		: positive ;
				Red_size 		: positive ;
				Count		 		: positive;
				LFTable   		: STD_LOGIC_VECTOR (127 DOWNTO 0);
				LFTable_inv	 	: STD_LOGIC_VECTOR (63 DOWNTO 0);
				SD2Table  		: STD_LOGIC_VECTOR (1023 DOWNTO 0));
				
     Port (	x 								: in  STD_LOGIC_VECTOR (StateSize*Count-1 downto 0);
				redx		 					: in  STD_LOGIC_VECTOR (Red_size*Count-1 downto 0);
				EncDec						: in  STD_LOGIC;
				done		 					: out STD_LOGIC;
				Red_a_b		 				: out STD_LOGIC;
				Red_FSMUpdateBit 			: out STD_LOGIC);
end F_SD2_RedStateUpdate_Done_bit;

architecture Behavioral of F_SD2_RedStateUpdate_Done_bit is

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
	constant SD2Table0 : STD_LOGIC_VECTOR (127 DOWNTO 0) :=
		SD2Table(1016) & SD2Table(1008) & SD2Table(1000) & SD2Table(992) & SD2Table(984) & SD2Table(976) & SD2Table(968) & SD2Table(960) & SD2Table(952) & SD2Table(944) & SD2Table(936) & SD2Table(928) & SD2Table(920) & SD2Table(912) & SD2Table(904) & SD2Table(896) & SD2Table(888) & SD2Table(880) & SD2Table(872) & SD2Table(864) & SD2Table(856) & SD2Table(848) & '-' & '-' & SD2Table(824) & '-' & '-' & '-' & '-' & '-' & '-' & SD2Table(768) & SD2Table(760) & SD2Table(752) & SD2Table(744) & SD2Table(736) & SD2Table(728) & '-' & '-' & '-' & SD2Table(696) & '-' & SD2Table(680) & '-' & '-' & '-' & '-' & SD2Table(640) & SD2Table(632) & SD2Table(624) & SD2Table(616) & SD2Table(608) & '-' & '-' & '-' & SD2Table(576) & '-' & '-' & '-' & SD2Table(544) & SD2Table(536) & '-' & '-' & SD2Table(512) & SD2Table(504) & SD2Table(496) & SD2Table(488) & '-' & SD2Table(472) & SD2Table(464) & '-' & '-' & SD2Table(440) & '-' & SD2Table(424) & '-' & '-' & '-' & '-' & SD2Table(384) & SD2Table(376) & SD2Table(368) & '-' & '-' & SD2Table(344) & SD2Table(336) & '-' & SD2Table(320) & '-' & SD2Table(304) & SD2Table(296) & '-' & '-' & SD2Table(272) & '-' & '-' & SD2Table(248) & '-' & SD2Table(232) & '-' & '-' & SD2Table(208) & SD2Table(200) & '-' & SD2Table(184) & '-' & SD2Table(168) & SD2Table(160) & '-' & '-' & SD2Table(136) & '-' & '-' & '-' & '-' & SD2Table(96) & '-' & SD2Table(80) & '-' & '-' & '-' & '-' & SD2Table(40) & '-' & '-' & '-' & '-' & '-' ; 

	constant SD2Table1 : STD_LOGIC_VECTOR (127 DOWNTO 0) :=
		SD2Table(1017) & SD2Table(1009) & SD2Table(1001) & SD2Table(993) & SD2Table(985) & SD2Table(977) & SD2Table(969) & SD2Table(961) & SD2Table(953) & SD2Table(945) & SD2Table(937) & SD2Table(929) & SD2Table(921) & SD2Table(913) & SD2Table(905) & SD2Table(897) & SD2Table(889) & SD2Table(881) & SD2Table(873) & SD2Table(865) & SD2Table(857) & SD2Table(849) & '-' & '-' & SD2Table(825) & '-' & '-' & '-' & '-' & '-' & '-' & SD2Table(769) & SD2Table(761) & SD2Table(753) & SD2Table(745) & SD2Table(737) & SD2Table(729) & '-' & '-' & '-' & SD2Table(697) & '-' & SD2Table(681) & '-' & '-' & '-' & '-' & SD2Table(641) & SD2Table(633) & SD2Table(625) & SD2Table(617) & SD2Table(609) & '-' & '-' & '-' & SD2Table(577) & '-' & '-' & '-' & SD2Table(545) & SD2Table(537) & '-' & '-' & SD2Table(513) & SD2Table(505) & SD2Table(497) & SD2Table(489) & '-' & SD2Table(473) & SD2Table(465) & '-' & '-' & SD2Table(441) & '-' & SD2Table(425) & '-' & '-' & '-' & '-' & SD2Table(385) & SD2Table(377) & SD2Table(369) & '-' & '-' & SD2Table(345) & SD2Table(337) & '-' & SD2Table(321) & '-' & SD2Table(305) & SD2Table(297) & '-' & '-' & SD2Table(273) & '-' & '-' & SD2Table(249) & '-' & SD2Table(233) & '-' & '-' & SD2Table(209) & SD2Table(201) & '-' & SD2Table(185) & '-' & SD2Table(169) & SD2Table(161) & '-' & '-' & SD2Table(137) & '-' & '-' & '-' & '-' & SD2Table(97) & '-' & SD2Table(81) & '-' & '-' & '-' & '-' & SD2Table(41) & '-' & '-' & '-' & '-' & '-' ; 

	constant SD2Table2 : STD_LOGIC_VECTOR (127 DOWNTO 0) :=
		SD2Table(1018) & SD2Table(1010) & SD2Table(1002) & SD2Table(994) & SD2Table(986) & SD2Table(978) & SD2Table(970) & SD2Table(962) & SD2Table(954) & SD2Table(946) & SD2Table(938) & SD2Table(930) & SD2Table(922) & SD2Table(914) & SD2Table(906) & SD2Table(898) & SD2Table(890) & SD2Table(882) & SD2Table(874) & SD2Table(866) & SD2Table(858) & SD2Table(850) & '-' & '-' & SD2Table(826) & '-' & '-' & '-' & '-' & '-' & '-' & SD2Table(770) & SD2Table(762) & SD2Table(754) & SD2Table(746) & SD2Table(738) & SD2Table(730) & '-' & '-' & '-' & SD2Table(698) & '-' & SD2Table(682) & '-' & '-' & '-' & '-' & SD2Table(642) & SD2Table(634) & SD2Table(626) & SD2Table(618) & SD2Table(610) & '-' & '-' & '-' & SD2Table(578) & '-' & '-' & '-' & SD2Table(546) & SD2Table(538) & '-' & '-' & SD2Table(514) & SD2Table(506) & SD2Table(498) & SD2Table(490) & '-' & SD2Table(474) & SD2Table(466) & '-' & '-' & SD2Table(442) & '-' & SD2Table(426) & '-' & '-' & '-' & '-' & SD2Table(386) & SD2Table(378) & SD2Table(370) & '-' & '-' & SD2Table(346) & SD2Table(338) & '-' & SD2Table(322) & '-' & SD2Table(306) & SD2Table(298) & '-' & '-' & SD2Table(274) & '-' & '-' & SD2Table(250) & '-' & SD2Table(234) & '-' & '-' & SD2Table(210) & SD2Table(202) & '-' & SD2Table(186) & '-' & SD2Table(170) & SD2Table(162) & '-' & '-' & SD2Table(138) & '-' & '-' & '-' & '-' & SD2Table(98) & '-' & SD2Table(82) & '-' & '-' & '-' & '-' & SD2Table(42) & '-' & '-' & '-' & '-' & '-' ; 

	constant SD2Table3 : STD_LOGIC_VECTOR (127 DOWNTO 0) :=
		SD2Table(1019) & SD2Table(1011) & SD2Table(1003) & SD2Table(995) & SD2Table(987) & SD2Table(979) & SD2Table(971) & SD2Table(963) & SD2Table(955) & SD2Table(947) & SD2Table(939) & SD2Table(931) & SD2Table(923) & SD2Table(915) & SD2Table(907) & SD2Table(899) & SD2Table(891) & SD2Table(883) & SD2Table(875) & SD2Table(867) & SD2Table(859) & SD2Table(851) & '-' & '-' & SD2Table(827) & '-' & '-' & '-' & '-' & '-' & '-' & SD2Table(771) & SD2Table(763) & SD2Table(755) & SD2Table(747) & SD2Table(739) & SD2Table(731) & '-' & '-' & '-' & SD2Table(699) & '-' & SD2Table(683) & '-' & '-' & '-' & '-' & SD2Table(643) & SD2Table(635) & SD2Table(627) & SD2Table(619) & SD2Table(611) & '-' & '-' & '-' & SD2Table(579) & '-' & '-' & '-' & SD2Table(547) & SD2Table(539) & '-' & '-' & SD2Table(515) & SD2Table(507) & SD2Table(499) & SD2Table(491) & '-' & SD2Table(475) & SD2Table(467) & '-' & '-' & SD2Table(443) & '-' & SD2Table(427) & '-' & '-' & '-' & '-' & SD2Table(387) & SD2Table(379) & SD2Table(371) & '-' & '-' & SD2Table(347) & SD2Table(339) & '-' & SD2Table(323) & '-' & SD2Table(307) & SD2Table(299) & '-' & '-' & SD2Table(275) & '-' & '-' & SD2Table(251) & '-' & SD2Table(235) & '-' & '-' & SD2Table(211) & SD2Table(203) & '-' & SD2Table(187) & '-' & SD2Table(171) & SD2Table(163) & '-' & '-' & SD2Table(139) & '-' & '-' & '-' & '-' & SD2Table(99) & '-' & SD2Table(83) & '-' & '-' & '-' & '-' & SD2Table(43) & '-' & '-' & '-' & '-' & '-' ; 

	constant SD2Table4 : STD_LOGIC_VECTOR (127 DOWNTO 0) :=
		SD2Table(1020) & SD2Table(1012) & SD2Table(1004) & SD2Table(996) & SD2Table(988) & SD2Table(980) & SD2Table(972) & SD2Table(964) & SD2Table(956) & SD2Table(948) & SD2Table(940) & SD2Table(932) & SD2Table(924) & SD2Table(916) & SD2Table(908) & SD2Table(900) & SD2Table(892) & SD2Table(884) & SD2Table(876) & SD2Table(868) & SD2Table(860) & SD2Table(852) & '-' & '-' & SD2Table(828) & '-' & '-' & '-' & '-' & '-' & '-' & SD2Table(772) & SD2Table(764) & SD2Table(756) & SD2Table(748) & SD2Table(740) & SD2Table(732) & '-' & '-' & '-' & SD2Table(700) & '-' & SD2Table(684) & '-' & '-' & '-' & '-' & SD2Table(644) & SD2Table(636) & SD2Table(628) & SD2Table(620) & SD2Table(612) & '-' & '-' & '-' & SD2Table(580) & '-' & '-' & '-' & SD2Table(548) & SD2Table(540) & '-' & '-' & SD2Table(516) & SD2Table(508) & SD2Table(500) & SD2Table(492) & '-' & SD2Table(476) & SD2Table(468) & '-' & '-' & SD2Table(444) & '-' & SD2Table(428) & '-' & '-' & '-' & '-' & SD2Table(388) & SD2Table(380) & SD2Table(372) & '-' & '-' & SD2Table(348) & SD2Table(340) & '-' & SD2Table(324) & '-' & SD2Table(308) & SD2Table(300) & '-' & '-' & SD2Table(276) & '-' & '-' & SD2Table(252) & '-' & SD2Table(236) & '-' & '-' & SD2Table(212) & SD2Table(204) & '-' & SD2Table(188) & '-' & SD2Table(172) & SD2Table(164) & '-' & '-' & SD2Table(140) & '-' & '-' & '-' & '-' & SD2Table(100) & '-' & SD2Table(84) & '-' & '-' & '-' & '-' & SD2Table(44) & '-' & '-' & '-' & '-' & '-' ; 

	constant SD2Table5 : STD_LOGIC_VECTOR (127 DOWNTO 0) :=
		SD2Table(1021) & SD2Table(1013) & SD2Table(1005) & SD2Table(997) & SD2Table(989) & SD2Table(981) & SD2Table(973) & SD2Table(965) & SD2Table(957) & SD2Table(949) & SD2Table(941) & SD2Table(933) & SD2Table(925) & SD2Table(917) & SD2Table(909) & SD2Table(901) & SD2Table(893) & SD2Table(885) & SD2Table(877) & SD2Table(869) & SD2Table(861) & SD2Table(853) & '-' & '-' & SD2Table(829) & '-' & '-' & '-' & '-' & '-' & '-' & SD2Table(773) & SD2Table(765) & SD2Table(757) & SD2Table(749) & SD2Table(741) & SD2Table(733) & '-' & '-' & '-' & SD2Table(701) & '-' & SD2Table(685) & '-' & '-' & '-' & '-' & SD2Table(645) & SD2Table(637) & SD2Table(629) & SD2Table(621) & SD2Table(613) & '-' & '-' & '-' & SD2Table(581) & '-' & '-' & '-' & SD2Table(549) & SD2Table(541) & '-' & '-' & SD2Table(517) & SD2Table(509) & SD2Table(501) & SD2Table(493) & '-' & SD2Table(477) & SD2Table(469) & '-' & '-' & SD2Table(445) & '-' & SD2Table(429) & '-' & '-' & '-' & '-' & SD2Table(389) & SD2Table(381) & SD2Table(373) & '-' & '-' & SD2Table(349) & SD2Table(341) & '-' & SD2Table(325) & '-' & SD2Table(309) & SD2Table(301) & '-' & '-' & SD2Table(277) & '-' & '-' & SD2Table(253) & '-' & SD2Table(237) & '-' & '-' & SD2Table(213) & SD2Table(205) & '-' & SD2Table(189) & '-' & SD2Table(173) & SD2Table(165) & '-' & '-' & SD2Table(141) & '-' & '-' & '-' & '-' & SD2Table(101) & '-' & SD2Table(85) & '-' & '-' & '-' & '-' & SD2Table(45) & '-' & '-' & '-' & '-' & '-' ; 

	constant SD2Table6 : STD_LOGIC_VECTOR (127 DOWNTO 0) :=
		SD2Table(1022) & SD2Table(1014) & SD2Table(1006) & SD2Table(998) & SD2Table(990) & SD2Table(982) & SD2Table(974) & SD2Table(966) & SD2Table(958) & SD2Table(950) & SD2Table(942) & SD2Table(934) & SD2Table(926) & SD2Table(918) & SD2Table(910) & SD2Table(902) & SD2Table(894) & SD2Table(886) & SD2Table(878) & SD2Table(870) & SD2Table(862) & SD2Table(854) & '-' & '-' & SD2Table(830) & '-' & '-' & '-' & '-' & '-' & '-' & SD2Table(774) & SD2Table(766) & SD2Table(758) & SD2Table(750) & SD2Table(742) & SD2Table(734) & '-' & '-' & '-' & SD2Table(702) & '-' & SD2Table(686) & '-' & '-' & '-' & '-' & SD2Table(646) & SD2Table(638) & SD2Table(630) & SD2Table(622) & SD2Table(614) & '-' & '-' & '-' & SD2Table(582) & '-' & '-' & '-' & SD2Table(550) & SD2Table(542) & '-' & '-' & SD2Table(518) & SD2Table(510) & SD2Table(502) & SD2Table(494) & '-' & SD2Table(478) & SD2Table(470) & '-' & '-' & SD2Table(446) & '-' & SD2Table(430) & '-' & '-' & '-' & '-' & SD2Table(390) & SD2Table(382) & SD2Table(374) & '-' & '-' & SD2Table(350) & SD2Table(342) & '-' & SD2Table(326) & '-' & SD2Table(310) & SD2Table(302) & '-' & '-' & SD2Table(278) & '-' & '-' & SD2Table(254) & '-' & SD2Table(238) & '-' & '-' & SD2Table(214) & SD2Table(206) & '-' & SD2Table(190) & '-' & SD2Table(174) & SD2Table(166) & '-' & '-' & SD2Table(142) & '-' & '-' & '-' & '-' & SD2Table(102) & '-' & SD2Table(86) & '-' & '-' & '-' & '-' & SD2Table(46) & '-' & '-' & '-' & '-' & '-' ; 

	------------------------------------
	constant LFTable_inv0 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		LFTable_inv(60) & LFTable_inv(56) & LFTable_inv(52) & LFTable_inv(48) & LFTable_inv(44) & LFTable_inv(40) & LFTable_inv(36) & LFTable_inv(32) &
		LFTable_inv(28) & LFTable_inv(24) & LFTable_inv(20) & LFTable_inv(16) & LFTable_inv(12) & LFTable_inv(8) & LFTable_inv(4) & LFTable_inv(0);
	
	constant LFTable_inv1 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		LFTable_inv(61) & LFTable_inv(57) & LFTable_inv(53) & LFTable_inv(49) & LFTable_inv(45) & LFTable_inv(41) & LFTable_inv(37) & LFTable_inv(33) &
		LFTable_inv(29) & LFTable_inv(25) & LFTable_inv(21) & LFTable_inv(17) & LFTable_inv(13) & LFTable_inv(9) & LFTable_inv(5) & LFTable_inv(1);

	constant LFTable_inv2 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		LFTable_inv(62) & LFTable_inv(58) & LFTable_inv(54) & LFTable_inv(50) & LFTable_inv(46) & LFTable_inv(42) & LFTable_inv(38) & LFTable_inv(34) &
		LFTable_inv(30) & LFTable_inv(26) & LFTable_inv(22) & LFTable_inv(18) & LFTable_inv(14) & LFTable_inv(10) & LFTable_inv(6) & LFTable_inv(2);
		
	constant LFTable_inv3 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		LFTable_inv(62+1) & LFTable_inv(58+1) & LFTable_inv(54+1) & LFTable_inv(50+1) & LFTable_inv(46+1) & LFTable_inv(42+1) & LFTable_inv(38+1) & LFTable_inv(34+1) &
		LFTable_inv(30+1) & LFTable_inv(26+1) & LFTable_inv(22+1) & LFTable_inv(18+1) & LFTable_inv(14+1) & LFTable_inv(10+1) & LFTable_inv(6+1) & LFTable_inv(2+1);
	------------------------------------
	signal done_internal				: STD_LOGIC_VECTOR(Red_size-1 DOWNTO 0);
	signal SD1Output					: STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal FSMdone						: STD_LOGIC_VECTOR(6 DOWNTO 0);
	signal FSM							: STD_LOGIC_VECTOR(6 DOWNTO 0);
	signal FSMdoneEnc 				: STD_LOGIC_VECTOR (6 downto 0);
	signal FSMdoneDec 				: STD_LOGIC_VECTOR (6 downto 0);
	
	signal FSMUpdate					: STD_LOGIC_VECTOR(6 downto 0);
	
	
	signal x0, x1								: STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal F_output0, F_output1			: STD_LOGIC_VECTOR(Red_size-1 DOWNTO 0);
	signal ErrorVec							: STD_LOGIC_VECTOR(2*Red_size-1 DOWNTO 0);
	signal ErrorVec0							: STD_LOGIC_VECTOR(7-1 DOWNTO 0);
	signal ErrorVec1							: STD_LOGIC_VECTOR(7-1 DOWNTO 0);
	signal SD2Output0							: STD_LOGIC_VECTOR(Red_size-1 DOWNTO 0);
	signal SD2Output1							: STD_LOGIC_VECTOR(Red_size-1 DOWNTO 0);
	signal Corrected_RedFSM0				: STD_LOGIC_VECTOR(StateSize-1 DOWNTO 0);
	signal Corrected_RedFSM1				: STD_LOGIC_VECTOR(StateSize-1 DOWNTO 0);
	signal F_inv0								: STD_LOGIC_VECTOR(StateSize-1 DOWNTO 0);
	signal F_inv1								: STD_LOGIC_VECTOR(StateSize-1 DOWNTO 0);
begin


	x0(2 downto 0) <= x(2 downto 0);
	x0(3) 			<= '0';
	x1 				<= x(7 downto 4);
	
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
	SD2_CASE_b_0 : process (ErrorVec0) is
	begin
		case ErrorVec0 is
			when "0000000" =>
				SD2Output0(0) <= '0';
			when "0000001" =>
				SD2Output0(0) <= '1';
			when "0000010" =>
				SD2Output0(0) <= '0';
			when "0000011" =>
				SD2Output0(0) <= '1';
			when "0000100" =>
				SD2Output0(0) <= '0';
			when "0000101" =>
				SD2Output0(0) <= '1';
			when "0000110" =>
				SD2Output0(0) <= '0';
			when "0000111" =>
				SD2Output0(0) <= '0';
			when "0001000" =>
				SD2Output0(0) <= '0';
			when "0001001" =>
				SD2Output0(0) <= '1';
			when "0001010" =>
				SD2Output0(0) <= '0';
			when "0001011" =>
				SD2Output0(0) <= '0';
			when "0001100" =>
				SD2Output0(0) <= '0';
			when "0001101" =>
				SD2Output0(0) <= '0';
			when "0001110" =>
				SD2Output0(0) <= '1';
			when "0001111" =>
				SD2Output0(0) <= '0';
			when "0010000" =>
				SD2Output0(0) <= '0';
			when "0010001" =>
				SD2Output0(0) <= '1';
			when "0010010" =>
				SD2Output0(0) <= '0';
			when "0010011" =>
				SD2Output0(0) <= '0';
			when "0010100" =>
				SD2Output0(0) <= '0';
			when "0010101" =>
				SD2Output0(0) <= '0';
			when "0010110" =>
				SD2Output0(0) <= '-';
			when "0010111" =>
				SD2Output0(0) <= '-';
			when "0011000" =>
				SD2Output0(0) <= '0';
			when "0011001" =>
				SD2Output0(0) <= '-';
			when "0011010" =>
				SD2Output0(0) <= '-';
			when "0011011" =>
				SD2Output0(0) <= '-';
			when "0011100" =>
				SD2Output0(0) <= '-';
			when "0011101" =>
				SD2Output0(0) <= '-';
			when "0011110" =>
				SD2Output0(0) <= '-';
			when "0011111" =>
				SD2Output0(0) <= '0';
			when "0100000" =>
				SD2Output0(0) <= '0';
			when "0100001" =>
				SD2Output0(0) <= '1';
			when "0100010" =>
				SD2Output0(0) <= '0';
			when "0100011" =>
				SD2Output0(0) <= '0';
			when "0100100" =>
				SD2Output0(0) <= '0';
			when "0100101" =>
				SD2Output0(0) <= '-';
			when "0100110" =>
				SD2Output0(0) <= '-';
			when "0100111" =>
				SD2Output0(0) <= '-';
			when "0101000" =>
				SD2Output0(0) <= '0';
			when "0101001" =>
				SD2Output0(0) <= '-';
			when "0101010" =>
				SD2Output0(0) <= '0';
			when "0101011" =>
				SD2Output0(0) <= '-';
			when "0101100" =>
				SD2Output0(0) <= '-';
			when "0101101" =>
				SD2Output0(0) <= '-';
			when "0101110" =>
				SD2Output0(0) <= '-';
			when "0101111" =>
				SD2Output0(0) <= '0';
			when "0110000" =>
				SD2Output0(0) <= '0';
			when "0110001" =>
				SD2Output0(0) <= '0';
			when "0110010" =>
				SD2Output0(0) <= '1';
			when "0110011" =>
				SD2Output0(0) <= '0';
			when "0110100" =>
				SD2Output0(0) <= '-';
			when "0110101" =>
				SD2Output0(0) <= '-';
			when "0110110" =>
				SD2Output0(0) <= '-';
			when "0110111" =>
				SD2Output0(0) <= '0';
			when "0111000" =>
				SD2Output0(0) <= '-';
			when "0111001" =>
				SD2Output0(0) <= '-';
			when "0111010" =>
				SD2Output0(0) <= '-';
			when "0111011" =>
				SD2Output0(0) <= '0';
			when "0111100" =>
				SD2Output0(0) <= '0';
			when "0111101" =>
				SD2Output0(0) <= '-';
			when "0111110" =>
				SD2Output0(0) <= '-';
			when "0111111" =>
				SD2Output0(0) <= '0';
			when "1000000" =>
				SD2Output0(0) <= '0';
			when "1000001" =>
				SD2Output0(0) <= '1';
			when "1000010" =>
				SD2Output0(0) <= '0';
			when "1000011" =>
				SD2Output0(0) <= '-';
			when "1000100" =>
				SD2Output0(0) <= '0';
			when "1000101" =>
				SD2Output0(0) <= '0';
			when "1000110" =>
				SD2Output0(0) <= '-';
			when "1000111" =>
				SD2Output0(0) <= '-';
			when "1001000" =>
				SD2Output0(0) <= '0';
			when "1001001" =>
				SD2Output0(0) <= '-';
			when "1001010" =>
				SD2Output0(0) <= '0';
			when "1001011" =>
				SD2Output0(0) <= '-';
			when "1001100" =>
				SD2Output0(0) <= '-';
			when "1001101" =>
				SD2Output0(0) <= '-';
			when "1001110" =>
				SD2Output0(0) <= '-';
			when "1001111" =>
				SD2Output0(0) <= '0';
			when "1010000" =>
				SD2Output0(0) <= '0';
			when "1010001" =>
				SD2Output0(0) <= '0';
			when "1010010" =>
				SD2Output0(0) <= '-';
			when "1010011" =>
				SD2Output0(0) <= '-';
			when "1010100" =>
				SD2Output0(0) <= '1';
			when "1010101" =>
				SD2Output0(0) <= '0';
			when "1010110" =>
				SD2Output0(0) <= '-';
			when "1010111" =>
				SD2Output0(0) <= '0';
			when "1011000" =>
				SD2Output0(0) <= '-';
			when "1011001" =>
				SD2Output0(0) <= '0';
			when "1011010" =>
				SD2Output0(0) <= '0';
			when "1011011" =>
				SD2Output0(0) <= '-';
			when "1011100" =>
				SD2Output0(0) <= '-';
			when "1011101" =>
				SD2Output0(0) <= '0';
			when "1011110" =>
				SD2Output0(0) <= '-';
			when "1011111" =>
				SD2Output0(0) <= '-';
			when "1100000" =>
				SD2Output0(0) <= '0';
			when "1100001" =>
				SD2Output0(0) <= '-';
			when "1100010" =>
				SD2Output0(0) <= '0';
			when "1100011" =>
				SD2Output0(0) <= '-';
			when "1100100" =>
				SD2Output0(0) <= '-';
			when "1100101" =>
				SD2Output0(0) <= '0';
			when "1100110" =>
				SD2Output0(0) <= '0';
			when "1100111" =>
				SD2Output0(0) <= '-';
			when "1101000" =>
				SD2Output0(0) <= '0';
			when "1101001" =>
				SD2Output0(0) <= '-';
			when "1101010" =>
				SD2Output0(0) <= '0';
			when "1101011" =>
				SD2Output0(0) <= '1';
			when "1101100" =>
				SD2Output0(0) <= '-';
			when "1101101" =>
				SD2Output0(0) <= '-';
			when "1101110" =>
				SD2Output0(0) <= '0';
			when "1101111" =>
				SD2Output0(0) <= '-';
			when "1110000" =>
				SD2Output0(0) <= '-';
			when "1110001" =>
				SD2Output0(0) <= '-';
			when "1110010" =>
				SD2Output0(0) <= '-';
			when "1110011" =>
				SD2Output0(0) <= '0';
			when "1110100" =>
				SD2Output0(0) <= '-';
			when "1110101" =>
				SD2Output0(0) <= '0';
			when "1110110" =>
				SD2Output0(0) <= '-';
			when "1110111" =>
				SD2Output0(0) <= '-';
			when "1111000" =>
				SD2Output0(0) <= '-';
			when "1111001" =>
				SD2Output0(0) <= '-';
			when "1111010" =>
				SD2Output0(0) <= '0';
			when "1111011" =>
				SD2Output0(0) <= '-';
			when "1111100" =>
				SD2Output0(0) <= '-';
			when "1111101" =>
				SD2Output0(0) <= '-';
			when "1111110" =>
				SD2Output0(0) <= '-';
			when "1111111" =>
				SD2Output0(0) <= '-';
			when others =>
				SD2Output0(0) <= '-';
		end case;
	end process;

	SD2_CASE_b_1 : process (ErrorVec0) is
	begin
		case ErrorVec0 is
			when "0000000" =>
				SD2Output0(1) <= '0';
			when "0000001" =>
				SD2Output0(1) <= '0';
			when "0000010" =>
				SD2Output0(1) <= '1';
			when "0000011" =>
				SD2Output0(1) <= '1';
			when "0000100" =>
				SD2Output0(1) <= '0';
			when "0000101" =>
				SD2Output0(1) <= '0';
			when "0000110" =>
				SD2Output0(1) <= '1';
			when "0000111" =>
				SD2Output0(1) <= '0';
			when "0001000" =>
				SD2Output0(1) <= '0';
			when "0001001" =>
				SD2Output0(1) <= '0';
			when "0001010" =>
				SD2Output0(1) <= '1';
			when "0001011" =>
				SD2Output0(1) <= '0';
			when "0001100" =>
				SD2Output0(1) <= '0';
			when "0001101" =>
				SD2Output0(1) <= '1';
			when "0001110" =>
				SD2Output0(1) <= '0';
			when "0001111" =>
				SD2Output0(1) <= '0';
			when "0010000" =>
				SD2Output0(1) <= '0';
			when "0010001" =>
				SD2Output0(1) <= '0';
			when "0010010" =>
				SD2Output0(1) <= '1';
			when "0010011" =>
				SD2Output0(1) <= '0';
			when "0010100" =>
				SD2Output0(1) <= '0';
			when "0010101" =>
				SD2Output0(1) <= '0';
			when "0010110" =>
				SD2Output0(1) <= '-';
			when "0010111" =>
				SD2Output0(1) <= '-';
			when "0011000" =>
				SD2Output0(1) <= '0';
			when "0011001" =>
				SD2Output0(1) <= '-';
			when "0011010" =>
				SD2Output0(1) <= '-';
			when "0011011" =>
				SD2Output0(1) <= '-';
			when "0011100" =>
				SD2Output0(1) <= '-';
			when "0011101" =>
				SD2Output0(1) <= '-';
			when "0011110" =>
				SD2Output0(1) <= '-';
			when "0011111" =>
				SD2Output0(1) <= '0';
			when "0100000" =>
				SD2Output0(1) <= '0';
			when "0100001" =>
				SD2Output0(1) <= '0';
			when "0100010" =>
				SD2Output0(1) <= '1';
			when "0100011" =>
				SD2Output0(1) <= '0';
			when "0100100" =>
				SD2Output0(1) <= '0';
			when "0100101" =>
				SD2Output0(1) <= '-';
			when "0100110" =>
				SD2Output0(1) <= '-';
			when "0100111" =>
				SD2Output0(1) <= '-';
			when "0101000" =>
				SD2Output0(1) <= '0';
			when "0101001" =>
				SD2Output0(1) <= '-';
			when "0101010" =>
				SD2Output0(1) <= '0';
			when "0101011" =>
				SD2Output0(1) <= '-';
			when "0101100" =>
				SD2Output0(1) <= '-';
			when "0101101" =>
				SD2Output0(1) <= '-';
			when "0101110" =>
				SD2Output0(1) <= '-';
			when "0101111" =>
				SD2Output0(1) <= '0';
			when "0110000" =>
				SD2Output0(1) <= '0';
			when "0110001" =>
				SD2Output0(1) <= '1';
			when "0110010" =>
				SD2Output0(1) <= '0';
			when "0110011" =>
				SD2Output0(1) <= '0';
			when "0110100" =>
				SD2Output0(1) <= '-';
			when "0110101" =>
				SD2Output0(1) <= '-';
			when "0110110" =>
				SD2Output0(1) <= '-';
			when "0110111" =>
				SD2Output0(1) <= '0';
			when "0111000" =>
				SD2Output0(1) <= '-';
			when "0111001" =>
				SD2Output0(1) <= '-';
			when "0111010" =>
				SD2Output0(1) <= '-';
			when "0111011" =>
				SD2Output0(1) <= '0';
			when "0111100" =>
				SD2Output0(1) <= '0';
			when "0111101" =>
				SD2Output0(1) <= '-';
			when "0111110" =>
				SD2Output0(1) <= '-';
			when "0111111" =>
				SD2Output0(1) <= '0';
			when "1000000" =>
				SD2Output0(1) <= '0';
			when "1000001" =>
				SD2Output0(1) <= '0';
			when "1000010" =>
				SD2Output0(1) <= '1';
			when "1000011" =>
				SD2Output0(1) <= '-';
			when "1000100" =>
				SD2Output0(1) <= '0';
			when "1000101" =>
				SD2Output0(1) <= '0';
			when "1000110" =>
				SD2Output0(1) <= '-';
			when "1000111" =>
				SD2Output0(1) <= '-';
			when "1001000" =>
				SD2Output0(1) <= '0';
			when "1001001" =>
				SD2Output0(1) <= '-';
			when "1001010" =>
				SD2Output0(1) <= '0';
			when "1001011" =>
				SD2Output0(1) <= '-';
			when "1001100" =>
				SD2Output0(1) <= '-';
			when "1001101" =>
				SD2Output0(1) <= '-';
			when "1001110" =>
				SD2Output0(1) <= '-';
			when "1001111" =>
				SD2Output0(1) <= '0';
			when "1010000" =>
				SD2Output0(1) <= '0';
			when "1010001" =>
				SD2Output0(1) <= '0';
			when "1010010" =>
				SD2Output0(1) <= '-';
			when "1010011" =>
				SD2Output0(1) <= '-';
			when "1010100" =>
				SD2Output0(1) <= '0';
			when "1010101" =>
				SD2Output0(1) <= '0';
			when "1010110" =>
				SD2Output0(1) <= '-';
			when "1010111" =>
				SD2Output0(1) <= '1';
			when "1011000" =>
				SD2Output0(1) <= '-';
			when "1011001" =>
				SD2Output0(1) <= '0';
			when "1011010" =>
				SD2Output0(1) <= '0';
			when "1011011" =>
				SD2Output0(1) <= '-';
			when "1011100" =>
				SD2Output0(1) <= '-';
			when "1011101" =>
				SD2Output0(1) <= '0';
			when "1011110" =>
				SD2Output0(1) <= '-';
			when "1011111" =>
				SD2Output0(1) <= '-';
			when "1100000" =>
				SD2Output0(1) <= '0';
			when "1100001" =>
				SD2Output0(1) <= '-';
			when "1100010" =>
				SD2Output0(1) <= '0';
			when "1100011" =>
				SD2Output0(1) <= '-';
			when "1100100" =>
				SD2Output0(1) <= '-';
			when "1100101" =>
				SD2Output0(1) <= '0';
			when "1100110" =>
				SD2Output0(1) <= '0';
			when "1100111" =>
				SD2Output0(1) <= '-';
			when "1101000" =>
				SD2Output0(1) <= '1';
			when "1101001" =>
				SD2Output0(1) <= '-';
			when "1101010" =>
				SD2Output0(1) <= '0';
			when "1101011" =>
				SD2Output0(1) <= '0';
			when "1101100" =>
				SD2Output0(1) <= '-';
			when "1101101" =>
				SD2Output0(1) <= '-';
			when "1101110" =>
				SD2Output0(1) <= '0';
			when "1101111" =>
				SD2Output0(1) <= '-';
			when "1110000" =>
				SD2Output0(1) <= '-';
			when "1110001" =>
				SD2Output0(1) <= '-';
			when "1110010" =>
				SD2Output0(1) <= '-';
			when "1110011" =>
				SD2Output0(1) <= '0';
			when "1110100" =>
				SD2Output0(1) <= '-';
			when "1110101" =>
				SD2Output0(1) <= '0';
			when "1110110" =>
				SD2Output0(1) <= '-';
			when "1110111" =>
				SD2Output0(1) <= '-';
			when "1111000" =>
				SD2Output0(1) <= '-';
			when "1111001" =>
				SD2Output0(1) <= '-';
			when "1111010" =>
				SD2Output0(1) <= '0';
			when "1111011" =>
				SD2Output0(1) <= '-';
			when "1111100" =>
				SD2Output0(1) <= '-';
			when "1111101" =>
				SD2Output0(1) <= '-';
			when "1111110" =>
				SD2Output0(1) <= '-';
			when "1111111" =>
				SD2Output0(1) <= '-';
			when others =>
				SD2Output0(1) <= '-';
		end case;
	end process;

	SD2_CASE_b_2 : process (ErrorVec0) is
	begin
		case ErrorVec0 is
			when "0000000" =>
				SD2Output0(2) <= '0';
			when "0000001" =>
				SD2Output0(2) <= '0';
			when "0000010" =>
				SD2Output0(2) <= '0';
			when "0000011" =>
				SD2Output0(2) <= '0';
			when "0000100" =>
				SD2Output0(2) <= '1';
			when "0000101" =>
				SD2Output0(2) <= '1';
			when "0000110" =>
				SD2Output0(2) <= '1';
			when "0000111" =>
				SD2Output0(2) <= '0';
			when "0001000" =>
				SD2Output0(2) <= '0';
			when "0001001" =>
				SD2Output0(2) <= '0';
			when "0001010" =>
				SD2Output0(2) <= '0';
			when "0001011" =>
				SD2Output0(2) <= '1';
			when "0001100" =>
				SD2Output0(2) <= '1';
			when "0001101" =>
				SD2Output0(2) <= '0';
			when "0001110" =>
				SD2Output0(2) <= '0';
			when "0001111" =>
				SD2Output0(2) <= '0';
			when "0010000" =>
				SD2Output0(2) <= '0';
			when "0010001" =>
				SD2Output0(2) <= '0';
			when "0010010" =>
				SD2Output0(2) <= '0';
			when "0010011" =>
				SD2Output0(2) <= '0';
			when "0010100" =>
				SD2Output0(2) <= '1';
			when "0010101" =>
				SD2Output0(2) <= '0';
			when "0010110" =>
				SD2Output0(2) <= '-';
			when "0010111" =>
				SD2Output0(2) <= '-';
			when "0011000" =>
				SD2Output0(2) <= '0';
			when "0011001" =>
				SD2Output0(2) <= '-';
			when "0011010" =>
				SD2Output0(2) <= '-';
			when "0011011" =>
				SD2Output0(2) <= '-';
			when "0011100" =>
				SD2Output0(2) <= '-';
			when "0011101" =>
				SD2Output0(2) <= '-';
			when "0011110" =>
				SD2Output0(2) <= '-';
			when "0011111" =>
				SD2Output0(2) <= '0';
			when "0100000" =>
				SD2Output0(2) <= '0';
			when "0100001" =>
				SD2Output0(2) <= '0';
			when "0100010" =>
				SD2Output0(2) <= '0';
			when "0100011" =>
				SD2Output0(2) <= '0';
			when "0100100" =>
				SD2Output0(2) <= '1';
			when "0100101" =>
				SD2Output0(2) <= '-';
			when "0100110" =>
				SD2Output0(2) <= '-';
			when "0100111" =>
				SD2Output0(2) <= '-';
			when "0101000" =>
				SD2Output0(2) <= '0';
			when "0101001" =>
				SD2Output0(2) <= '-';
			when "0101010" =>
				SD2Output0(2) <= '0';
			when "0101011" =>
				SD2Output0(2) <= '-';
			when "0101100" =>
				SD2Output0(2) <= '-';
			when "0101101" =>
				SD2Output0(2) <= '-';
			when "0101110" =>
				SD2Output0(2) <= '-';
			when "0101111" =>
				SD2Output0(2) <= '0';
			when "0110000" =>
				SD2Output0(2) <= '0';
			when "0110001" =>
				SD2Output0(2) <= '0';
			when "0110010" =>
				SD2Output0(2) <= '0';
			when "0110011" =>
				SD2Output0(2) <= '0';
			when "0110100" =>
				SD2Output0(2) <= '-';
			when "0110101" =>
				SD2Output0(2) <= '-';
			when "0110110" =>
				SD2Output0(2) <= '-';
			when "0110111" =>
				SD2Output0(2) <= '1';
			when "0111000" =>
				SD2Output0(2) <= '-';
			when "0111001" =>
				SD2Output0(2) <= '-';
			when "0111010" =>
				SD2Output0(2) <= '-';
			when "0111011" =>
				SD2Output0(2) <= '0';
			when "0111100" =>
				SD2Output0(2) <= '0';
			when "0111101" =>
				SD2Output0(2) <= '-';
			when "0111110" =>
				SD2Output0(2) <= '-';
			when "0111111" =>
				SD2Output0(2) <= '0';
			when "1000000" =>
				SD2Output0(2) <= '0';
			when "1000001" =>
				SD2Output0(2) <= '0';
			when "1000010" =>
				SD2Output0(2) <= '0';
			when "1000011" =>
				SD2Output0(2) <= '-';
			when "1000100" =>
				SD2Output0(2) <= '1';
			when "1000101" =>
				SD2Output0(2) <= '0';
			when "1000110" =>
				SD2Output0(2) <= '-';
			when "1000111" =>
				SD2Output0(2) <= '-';
			when "1001000" =>
				SD2Output0(2) <= '0';
			when "1001001" =>
				SD2Output0(2) <= '-';
			when "1001010" =>
				SD2Output0(2) <= '0';
			when "1001011" =>
				SD2Output0(2) <= '-';
			when "1001100" =>
				SD2Output0(2) <= '-';
			when "1001101" =>
				SD2Output0(2) <= '-';
			when "1001110" =>
				SD2Output0(2) <= '-';
			when "1001111" =>
				SD2Output0(2) <= '0';
			when "1010000" =>
				SD2Output0(2) <= '0';
			when "1010001" =>
				SD2Output0(2) <= '1';
			when "1010010" =>
				SD2Output0(2) <= '-';
			when "1010011" =>
				SD2Output0(2) <= '-';
			when "1010100" =>
				SD2Output0(2) <= '0';
			when "1010101" =>
				SD2Output0(2) <= '0';
			when "1010110" =>
				SD2Output0(2) <= '-';
			when "1010111" =>
				SD2Output0(2) <= '0';
			when "1011000" =>
				SD2Output0(2) <= '-';
			when "1011001" =>
				SD2Output0(2) <= '0';
			when "1011010" =>
				SD2Output0(2) <= '0';
			when "1011011" =>
				SD2Output0(2) <= '-';
			when "1011100" =>
				SD2Output0(2) <= '-';
			when "1011101" =>
				SD2Output0(2) <= '0';
			when "1011110" =>
				SD2Output0(2) <= '-';
			when "1011111" =>
				SD2Output0(2) <= '-';
			when "1100000" =>
				SD2Output0(2) <= '0';
			when "1100001" =>
				SD2Output0(2) <= '-';
			when "1100010" =>
				SD2Output0(2) <= '0';
			when "1100011" =>
				SD2Output0(2) <= '-';
			when "1100100" =>
				SD2Output0(2) <= '-';
			when "1100101" =>
				SD2Output0(2) <= '0';
			when "1100110" =>
				SD2Output0(2) <= '0';
			when "1100111" =>
				SD2Output0(2) <= '-';
			when "1101000" =>
				SD2Output0(2) <= '0';
			when "1101001" =>
				SD2Output0(2) <= '-';
			when "1101010" =>
				SD2Output0(2) <= '0';
			when "1101011" =>
				SD2Output0(2) <= '0';
			when "1101100" =>
				SD2Output0(2) <= '-';
			when "1101101" =>
				SD2Output0(2) <= '-';
			when "1101110" =>
				SD2Output0(2) <= '1';
			when "1101111" =>
				SD2Output0(2) <= '-';
			when "1110000" =>
				SD2Output0(2) <= '-';
			when "1110001" =>
				SD2Output0(2) <= '-';
			when "1110010" =>
				SD2Output0(2) <= '-';
			when "1110011" =>
				SD2Output0(2) <= '0';
			when "1110100" =>
				SD2Output0(2) <= '-';
			when "1110101" =>
				SD2Output0(2) <= '0';
			when "1110110" =>
				SD2Output0(2) <= '-';
			when "1110111" =>
				SD2Output0(2) <= '-';
			when "1111000" =>
				SD2Output0(2) <= '-';
			when "1111001" =>
				SD2Output0(2) <= '-';
			when "1111010" =>
				SD2Output0(2) <= '0';
			when "1111011" =>
				SD2Output0(2) <= '-';
			when "1111100" =>
				SD2Output0(2) <= '-';
			when "1111101" =>
				SD2Output0(2) <= '-';
			when "1111110" =>
				SD2Output0(2) <= '-';
			when "1111111" =>
				SD2Output0(2) <= '-';
			when others =>
				SD2Output0(2) <= '-';
		end case;
	end process;

	SD2_CASE_b_5 : process (ErrorVec0) is
	begin
		case ErrorVec0 is
			when "0000000" =>
				SD2Output0(5) <= '0';
			when "0000001" =>
				SD2Output0(5) <= '0';
			when "0000010" =>
				SD2Output0(5) <= '0';
			when "0000011" =>
				SD2Output0(5) <= '0';
			when "0000100" =>
				SD2Output0(5) <= '0';
			when "0000101" =>
				SD2Output0(5) <= '0';
			when "0000110" =>
				SD2Output0(5) <= '0';
			when "0000111" =>
				SD2Output0(5) <= '0';
			when "0001000" =>
				SD2Output0(5) <= '0';
			when "0001001" =>
				SD2Output0(5) <= '0';
			when "0001010" =>
				SD2Output0(5) <= '0';
			when "0001011" =>
				SD2Output0(5) <= '0';
			when "0001100" =>
				SD2Output0(5) <= '0';
			when "0001101" =>
				SD2Output0(5) <= '0';
			when "0001110" =>
				SD2Output0(5) <= '0';
			when "0001111" =>
				SD2Output0(5) <= '0';
			when "0010000" =>
				SD2Output0(5) <= '0';
			when "0010001" =>
				SD2Output0(5) <= '0';
			when "0010010" =>
				SD2Output0(5) <= '0';
			when "0010011" =>
				SD2Output0(5) <= '1';
			when "0010100" =>
				SD2Output0(5) <= '0';
			when "0010101" =>
				SD2Output0(5) <= '0';
			when "0010110" =>
				SD2Output0(5) <= '-';
			when "0010111" =>
				SD2Output0(5) <= '-';
			when "0011000" =>
				SD2Output0(5) <= '0';
			when "0011001" =>
				SD2Output0(5) <= '-';
			when "0011010" =>
				SD2Output0(5) <= '-';
			when "0011011" =>
				SD2Output0(5) <= '-';
			when "0011100" =>
				SD2Output0(5) <= '-';
			when "0011101" =>
				SD2Output0(5) <= '-';
			when "0011110" =>
				SD2Output0(5) <= '-';
			when "0011111" =>
				SD2Output0(5) <= '0';
			when "0100000" =>
				SD2Output0(5) <= '1';
			when "0100001" =>
				SD2Output0(5) <= '1';
			when "0100010" =>
				SD2Output0(5) <= '1';
			when "0100011" =>
				SD2Output0(5) <= '0';
			when "0100100" =>
				SD2Output0(5) <= '1';
			when "0100101" =>
				SD2Output0(5) <= '-';
			when "0100110" =>
				SD2Output0(5) <= '-';
			when "0100111" =>
				SD2Output0(5) <= '-';
			when "0101000" =>
				SD2Output0(5) <= '1';
			when "0101001" =>
				SD2Output0(5) <= '-';
			when "0101010" =>
				SD2Output0(5) <= '0';
			when "0101011" =>
				SD2Output0(5) <= '-';
			when "0101100" =>
				SD2Output0(5) <= '-';
			when "0101101" =>
				SD2Output0(5) <= '-';
			when "0101110" =>
				SD2Output0(5) <= '-';
			when "0101111" =>
				SD2Output0(5) <= '1';
			when "0110000" =>
				SD2Output0(5) <= '1';
			when "0110001" =>
				SD2Output0(5) <= '0';
			when "0110010" =>
				SD2Output0(5) <= '0';
			when "0110011" =>
				SD2Output0(5) <= '0';
			when "0110100" =>
				SD2Output0(5) <= '-';
			when "0110101" =>
				SD2Output0(5) <= '-';
			when "0110110" =>
				SD2Output0(5) <= '-';
			when "0110111" =>
				SD2Output0(5) <= '0';
			when "0111000" =>
				SD2Output0(5) <= '-';
			when "0111001" =>
				SD2Output0(5) <= '-';
			when "0111010" =>
				SD2Output0(5) <= '-';
			when "0111011" =>
				SD2Output0(5) <= '0';
			when "0111100" =>
				SD2Output0(5) <= '0';
			when "0111101" =>
				SD2Output0(5) <= '-';
			when "0111110" =>
				SD2Output0(5) <= '-';
			when "0111111" =>
				SD2Output0(5) <= '0';
			when "1000000" =>
				SD2Output0(5) <= '0';
			when "1000001" =>
				SD2Output0(5) <= '0';
			when "1000010" =>
				SD2Output0(5) <= '0';
			when "1000011" =>
				SD2Output0(5) <= '-';
			when "1000100" =>
				SD2Output0(5) <= '0';
			when "1000101" =>
				SD2Output0(5) <= '0';
			when "1000110" =>
				SD2Output0(5) <= '-';
			when "1000111" =>
				SD2Output0(5) <= '-';
			when "1001000" =>
				SD2Output0(5) <= '0';
			when "1001001" =>
				SD2Output0(5) <= '-';
			when "1001010" =>
				SD2Output0(5) <= '1';
			when "1001011" =>
				SD2Output0(5) <= '-';
			when "1001100" =>
				SD2Output0(5) <= '-';
			when "1001101" =>
				SD2Output0(5) <= '-';
			when "1001110" =>
				SD2Output0(5) <= '-';
			when "1001111" =>
				SD2Output0(5) <= '0';
			when "1010000" =>
				SD2Output0(5) <= '0';
			when "1010001" =>
				SD2Output0(5) <= '0';
			when "1010010" =>
				SD2Output0(5) <= '-';
			when "1010011" =>
				SD2Output0(5) <= '-';
			when "1010100" =>
				SD2Output0(5) <= '0';
			when "1010101" =>
				SD2Output0(5) <= '0';
			when "1010110" =>
				SD2Output0(5) <= '-';
			when "1010111" =>
				SD2Output0(5) <= '0';
			when "1011000" =>
				SD2Output0(5) <= '-';
			when "1011001" =>
				SD2Output0(5) <= '0';
			when "1011010" =>
				SD2Output0(5) <= '0';
			when "1011011" =>
				SD2Output0(5) <= '-';
			when "1011100" =>
				SD2Output0(5) <= '-';
			when "1011101" =>
				SD2Output0(5) <= '0';
			when "1011110" =>
				SD2Output0(5) <= '-';
			when "1011111" =>
				SD2Output0(5) <= '-';
			when "1100000" =>
				SD2Output0(5) <= '1';
			when "1100001" =>
				SD2Output0(5) <= '-';
			when "1100010" =>
				SD2Output0(5) <= '0';
			when "1100011" =>
				SD2Output0(5) <= '-';
			when "1100100" =>
				SD2Output0(5) <= '-';
			when "1100101" =>
				SD2Output0(5) <= '0';
			when "1100110" =>
				SD2Output0(5) <= '0';
			when "1100111" =>
				SD2Output0(5) <= '-';
			when "1101000" =>
				SD2Output0(5) <= '0';
			when "1101001" =>
				SD2Output0(5) <= '-';
			when "1101010" =>
				SD2Output0(5) <= '0';
			when "1101011" =>
				SD2Output0(5) <= '0';
			when "1101100" =>
				SD2Output0(5) <= '-';
			when "1101101" =>
				SD2Output0(5) <= '-';
			when "1101110" =>
				SD2Output0(5) <= '0';
			when "1101111" =>
				SD2Output0(5) <= '-';
			when "1110000" =>
				SD2Output0(5) <= '-';
			when "1110001" =>
				SD2Output0(5) <= '-';
			when "1110010" =>
				SD2Output0(5) <= '-';
			when "1110011" =>
				SD2Output0(5) <= '0';
			when "1110100" =>
				SD2Output0(5) <= '-';
			when "1110101" =>
				SD2Output0(5) <= '1';
			when "1110110" =>
				SD2Output0(5) <= '-';
			when "1110111" =>
				SD2Output0(5) <= '-';
			when "1111000" =>
				SD2Output0(5) <= '-';
			when "1111001" =>
				SD2Output0(5) <= '-';
			when "1111010" =>
				SD2Output0(5) <= '0';
			when "1111011" =>
				SD2Output0(5) <= '-';
			when "1111100" =>
				SD2Output0(5) <= '-';
			when "1111101" =>
				SD2Output0(5) <= '-';
			when "1111110" =>
				SD2Output0(5) <= '-';
			when "1111111" =>
				SD2Output0(5) <= '-';
			when others =>
				SD2Output0(5) <= '-';
		end case;
	end process;

	--------------
	SD2_CASE_a_0 : process (ErrorVec1) is
	begin
		case ErrorVec1 is
			when "0000000" =>
				SD2Output1(0) <= '0';
			when "0000001" =>
				SD2Output1(0) <= '1';
			when "0000010" =>
				SD2Output1(0) <= '0';
			when "0000011" =>
				SD2Output1(0) <= '1';
			when "0000100" =>
				SD2Output1(0) <= '0';
			when "0000101" =>
				SD2Output1(0) <= '1';
			when "0000110" =>
				SD2Output1(0) <= '0';
			when "0000111" =>
				SD2Output1(0) <= '0';
			when "0001000" =>
				SD2Output1(0) <= '0';
			when "0001001" =>
				SD2Output1(0) <= '1';
			when "0001010" =>
				SD2Output1(0) <= '0';
			when "0001011" =>
				SD2Output1(0) <= '0';
			when "0001100" =>
				SD2Output1(0) <= '0';
			when "0001101" =>
				SD2Output1(0) <= '0';
			when "0001110" =>
				SD2Output1(0) <= '1';
			when "0001111" =>
				SD2Output1(0) <= '0';
			when "0010000" =>
				SD2Output1(0) <= '0';
			when "0010001" =>
				SD2Output1(0) <= '1';
			when "0010010" =>
				SD2Output1(0) <= '0';
			when "0010011" =>
				SD2Output1(0) <= '0';
			when "0010100" =>
				SD2Output1(0) <= '0';
			when "0010101" =>
				SD2Output1(0) <= '0';
			when "0010110" =>
				SD2Output1(0) <= '-';
			when "0010111" =>
				SD2Output1(0) <= '-';
			when "0011000" =>
				SD2Output1(0) <= '0';
			when "0011001" =>
				SD2Output1(0) <= '-';
			when "0011010" =>
				SD2Output1(0) <= '-';
			when "0011011" =>
				SD2Output1(0) <= '-';
			when "0011100" =>
				SD2Output1(0) <= '-';
			when "0011101" =>
				SD2Output1(0) <= '-';
			when "0011110" =>
				SD2Output1(0) <= '-';
			when "0011111" =>
				SD2Output1(0) <= '0';
			when "0100000" =>
				SD2Output1(0) <= '0';
			when "0100001" =>
				SD2Output1(0) <= '1';
			when "0100010" =>
				SD2Output1(0) <= '0';
			when "0100011" =>
				SD2Output1(0) <= '0';
			when "0100100" =>
				SD2Output1(0) <= '0';
			when "0100101" =>
				SD2Output1(0) <= '-';
			when "0100110" =>
				SD2Output1(0) <= '-';
			when "0100111" =>
				SD2Output1(0) <= '-';
			when "0101000" =>
				SD2Output1(0) <= '0';
			when "0101001" =>
				SD2Output1(0) <= '-';
			when "0101010" =>
				SD2Output1(0) <= '0';
			when "0101011" =>
				SD2Output1(0) <= '-';
			when "0101100" =>
				SD2Output1(0) <= '-';
			when "0101101" =>
				SD2Output1(0) <= '-';
			when "0101110" =>
				SD2Output1(0) <= '-';
			when "0101111" =>
				SD2Output1(0) <= '0';
			when "0110000" =>
				SD2Output1(0) <= '0';
			when "0110001" =>
				SD2Output1(0) <= '0';
			when "0110010" =>
				SD2Output1(0) <= '1';
			when "0110011" =>
				SD2Output1(0) <= '0';
			when "0110100" =>
				SD2Output1(0) <= '-';
			when "0110101" =>
				SD2Output1(0) <= '-';
			when "0110110" =>
				SD2Output1(0) <= '-';
			when "0110111" =>
				SD2Output1(0) <= '0';
			when "0111000" =>
				SD2Output1(0) <= '-';
			when "0111001" =>
				SD2Output1(0) <= '-';
			when "0111010" =>
				SD2Output1(0) <= '-';
			when "0111011" =>
				SD2Output1(0) <= '0';
			when "0111100" =>
				SD2Output1(0) <= '0';
			when "0111101" =>
				SD2Output1(0) <= '-';
			when "0111110" =>
				SD2Output1(0) <= '-';
			when "0111111" =>
				SD2Output1(0) <= '0';
			when "1000000" =>
				SD2Output1(0) <= '0';
			when "1000001" =>
				SD2Output1(0) <= '1';
			when "1000010" =>
				SD2Output1(0) <= '0';
			when "1000011" =>
				SD2Output1(0) <= '-';
			when "1000100" =>
				SD2Output1(0) <= '0';
			when "1000101" =>
				SD2Output1(0) <= '0';
			when "1000110" =>
				SD2Output1(0) <= '-';
			when "1000111" =>
				SD2Output1(0) <= '-';
			when "1001000" =>
				SD2Output1(0) <= '0';
			when "1001001" =>
				SD2Output1(0) <= '-';
			when "1001010" =>
				SD2Output1(0) <= '0';
			when "1001011" =>
				SD2Output1(0) <= '-';
			when "1001100" =>
				SD2Output1(0) <= '-';
			when "1001101" =>
				SD2Output1(0) <= '-';
			when "1001110" =>
				SD2Output1(0) <= '-';
			when "1001111" =>
				SD2Output1(0) <= '0';
			when "1010000" =>
				SD2Output1(0) <= '0';
			when "1010001" =>
				SD2Output1(0) <= '0';
			when "1010010" =>
				SD2Output1(0) <= '-';
			when "1010011" =>
				SD2Output1(0) <= '-';
			when "1010100" =>
				SD2Output1(0) <= '1';
			when "1010101" =>
				SD2Output1(0) <= '0';
			when "1010110" =>
				SD2Output1(0) <= '-';
			when "1010111" =>
				SD2Output1(0) <= '0';
			when "1011000" =>
				SD2Output1(0) <= '-';
			when "1011001" =>
				SD2Output1(0) <= '0';
			when "1011010" =>
				SD2Output1(0) <= '0';
			when "1011011" =>
				SD2Output1(0) <= '-';
			when "1011100" =>
				SD2Output1(0) <= '-';
			when "1011101" =>
				SD2Output1(0) <= '0';
			when "1011110" =>
				SD2Output1(0) <= '-';
			when "1011111" =>
				SD2Output1(0) <= '-';
			when "1100000" =>
				SD2Output1(0) <= '0';
			when "1100001" =>
				SD2Output1(0) <= '-';
			when "1100010" =>
				SD2Output1(0) <= '0';
			when "1100011" =>
				SD2Output1(0) <= '-';
			when "1100100" =>
				SD2Output1(0) <= '-';
			when "1100101" =>
				SD2Output1(0) <= '0';
			when "1100110" =>
				SD2Output1(0) <= '0';
			when "1100111" =>
				SD2Output1(0) <= '-';
			when "1101000" =>
				SD2Output1(0) <= '0';
			when "1101001" =>
				SD2Output1(0) <= '-';
			when "1101010" =>
				SD2Output1(0) <= '0';
			when "1101011" =>
				SD2Output1(0) <= '1';
			when "1101100" =>
				SD2Output1(0) <= '-';
			when "1101101" =>
				SD2Output1(0) <= '-';
			when "1101110" =>
				SD2Output1(0) <= '0';
			when "1101111" =>
				SD2Output1(0) <= '-';
			when "1110000" =>
				SD2Output1(0) <= '-';
			when "1110001" =>
				SD2Output1(0) <= '-';
			when "1110010" =>
				SD2Output1(0) <= '-';
			when "1110011" =>
				SD2Output1(0) <= '0';
			when "1110100" =>
				SD2Output1(0) <= '-';
			when "1110101" =>
				SD2Output1(0) <= '0';
			when "1110110" =>
				SD2Output1(0) <= '-';
			when "1110111" =>
				SD2Output1(0) <= '-';
			when "1111000" =>
				SD2Output1(0) <= '-';
			when "1111001" =>
				SD2Output1(0) <= '-';
			when "1111010" =>
				SD2Output1(0) <= '0';
			when "1111011" =>
				SD2Output1(0) <= '-';
			when "1111100" =>
				SD2Output1(0) <= '-';
			when "1111101" =>
				SD2Output1(0) <= '-';
			when "1111110" =>
				SD2Output1(0) <= '-';
			when "1111111" =>
				SD2Output1(0) <= '-';
			when others =>
				SD2Output1(0) <= '-';
		end case;
	end process;

	--------------
	SD2_CASE_a_1 : process (ErrorVec1) is
	begin
		case ErrorVec1 is
			when "0000000" =>
				SD2Output1(1) <= '0';
			when "0000001" =>
				SD2Output1(1) <= '0';
			when "0000010" =>
				SD2Output1(1) <= '1';
			when "0000011" =>
				SD2Output1(1) <= '1';
			when "0000100" =>
				SD2Output1(1) <= '0';
			when "0000101" =>
				SD2Output1(1) <= '0';
			when "0000110" =>
				SD2Output1(1) <= '1';
			when "0000111" =>
				SD2Output1(1) <= '0';
			when "0001000" =>
				SD2Output1(1) <= '0';
			when "0001001" =>
				SD2Output1(1) <= '0';
			when "0001010" =>
				SD2Output1(1) <= '1';
			when "0001011" =>
				SD2Output1(1) <= '0';
			when "0001100" =>
				SD2Output1(1) <= '0';
			when "0001101" =>
				SD2Output1(1) <= '1';
			when "0001110" =>
				SD2Output1(1) <= '0';
			when "0001111" =>
				SD2Output1(1) <= '0';
			when "0010000" =>
				SD2Output1(1) <= '0';
			when "0010001" =>
				SD2Output1(1) <= '0';
			when "0010010" =>
				SD2Output1(1) <= '1';
			when "0010011" =>
				SD2Output1(1) <= '0';
			when "0010100" =>
				SD2Output1(1) <= '0';
			when "0010101" =>
				SD2Output1(1) <= '0';
			when "0010110" =>
				SD2Output1(1) <= '-';
			when "0010111" =>
				SD2Output1(1) <= '-';
			when "0011000" =>
				SD2Output1(1) <= '0';
			when "0011001" =>
				SD2Output1(1) <= '-';
			when "0011010" =>
				SD2Output1(1) <= '-';
			when "0011011" =>
				SD2Output1(1) <= '-';
			when "0011100" =>
				SD2Output1(1) <= '-';
			when "0011101" =>
				SD2Output1(1) <= '-';
			when "0011110" =>
				SD2Output1(1) <= '-';
			when "0011111" =>
				SD2Output1(1) <= '0';
			when "0100000" =>
				SD2Output1(1) <= '0';
			when "0100001" =>
				SD2Output1(1) <= '0';
			when "0100010" =>
				SD2Output1(1) <= '1';
			when "0100011" =>
				SD2Output1(1) <= '0';
			when "0100100" =>
				SD2Output1(1) <= '0';
			when "0100101" =>
				SD2Output1(1) <= '-';
			when "0100110" =>
				SD2Output1(1) <= '-';
			when "0100111" =>
				SD2Output1(1) <= '-';
			when "0101000" =>
				SD2Output1(1) <= '0';
			when "0101001" =>
				SD2Output1(1) <= '-';
			when "0101010" =>
				SD2Output1(1) <= '0';
			when "0101011" =>
				SD2Output1(1) <= '-';
			when "0101100" =>
				SD2Output1(1) <= '-';
			when "0101101" =>
				SD2Output1(1) <= '-';
			when "0101110" =>
				SD2Output1(1) <= '-';
			when "0101111" =>
				SD2Output1(1) <= '0';
			when "0110000" =>
				SD2Output1(1) <= '0';
			when "0110001" =>
				SD2Output1(1) <= '1';
			when "0110010" =>
				SD2Output1(1) <= '0';
			when "0110011" =>
				SD2Output1(1) <= '0';
			when "0110100" =>
				SD2Output1(1) <= '-';
			when "0110101" =>
				SD2Output1(1) <= '-';
			when "0110110" =>
				SD2Output1(1) <= '-';
			when "0110111" =>
				SD2Output1(1) <= '0';
			when "0111000" =>
				SD2Output1(1) <= '-';
			when "0111001" =>
				SD2Output1(1) <= '-';
			when "0111010" =>
				SD2Output1(1) <= '-';
			when "0111011" =>
				SD2Output1(1) <= '0';
			when "0111100" =>
				SD2Output1(1) <= '0';
			when "0111101" =>
				SD2Output1(1) <= '-';
			when "0111110" =>
				SD2Output1(1) <= '-';
			when "0111111" =>
				SD2Output1(1) <= '0';
			when "1000000" =>
				SD2Output1(1) <= '0';
			when "1000001" =>
				SD2Output1(1) <= '0';
			when "1000010" =>
				SD2Output1(1) <= '1';
			when "1000011" =>
				SD2Output1(1) <= '-';
			when "1000100" =>
				SD2Output1(1) <= '0';
			when "1000101" =>
				SD2Output1(1) <= '0';
			when "1000110" =>
				SD2Output1(1) <= '-';
			when "1000111" =>
				SD2Output1(1) <= '-';
			when "1001000" =>
				SD2Output1(1) <= '0';
			when "1001001" =>
				SD2Output1(1) <= '-';
			when "1001010" =>
				SD2Output1(1) <= '0';
			when "1001011" =>
				SD2Output1(1) <= '-';
			when "1001100" =>
				SD2Output1(1) <= '-';
			when "1001101" =>
				SD2Output1(1) <= '-';
			when "1001110" =>
				SD2Output1(1) <= '-';
			when "1001111" =>
				SD2Output1(1) <= '0';
			when "1010000" =>
				SD2Output1(1) <= '0';
			when "1010001" =>
				SD2Output1(1) <= '0';
			when "1010010" =>
				SD2Output1(1) <= '-';
			when "1010011" =>
				SD2Output1(1) <= '-';
			when "1010100" =>
				SD2Output1(1) <= '0';
			when "1010101" =>
				SD2Output1(1) <= '0';
			when "1010110" =>
				SD2Output1(1) <= '-';
			when "1010111" =>
				SD2Output1(1) <= '1';
			when "1011000" =>
				SD2Output1(1) <= '-';
			when "1011001" =>
				SD2Output1(1) <= '0';
			when "1011010" =>
				SD2Output1(1) <= '0';
			when "1011011" =>
				SD2Output1(1) <= '-';
			when "1011100" =>
				SD2Output1(1) <= '-';
			when "1011101" =>
				SD2Output1(1) <= '0';
			when "1011110" =>
				SD2Output1(1) <= '-';
			when "1011111" =>
				SD2Output1(1) <= '-';
			when "1100000" =>
				SD2Output1(1) <= '0';
			when "1100001" =>
				SD2Output1(1) <= '-';
			when "1100010" =>
				SD2Output1(1) <= '0';
			when "1100011" =>
				SD2Output1(1) <= '-';
			when "1100100" =>
				SD2Output1(1) <= '-';
			when "1100101" =>
				SD2Output1(1) <= '0';
			when "1100110" =>
				SD2Output1(1) <= '0';
			when "1100111" =>
				SD2Output1(1) <= '-';
			when "1101000" =>
				SD2Output1(1) <= '1';
			when "1101001" =>
				SD2Output1(1) <= '-';
			when "1101010" =>
				SD2Output1(1) <= '0';
			when "1101011" =>
				SD2Output1(1) <= '0';
			when "1101100" =>
				SD2Output1(1) <= '-';
			when "1101101" =>
				SD2Output1(1) <= '-';
			when "1101110" =>
				SD2Output1(1) <= '0';
			when "1101111" =>
				SD2Output1(1) <= '-';
			when "1110000" =>
				SD2Output1(1) <= '-';
			when "1110001" =>
				SD2Output1(1) <= '-';
			when "1110010" =>
				SD2Output1(1) <= '-';
			when "1110011" =>
				SD2Output1(1) <= '0';
			when "1110100" =>
				SD2Output1(1) <= '-';
			when "1110101" =>
				SD2Output1(1) <= '0';
			when "1110110" =>
				SD2Output1(1) <= '-';
			when "1110111" =>
				SD2Output1(1) <= '-';
			when "1111000" =>
				SD2Output1(1) <= '-';
			when "1111001" =>
				SD2Output1(1) <= '-';
			when "1111010" =>
				SD2Output1(1) <= '0';
			when "1111011" =>
				SD2Output1(1) <= '-';
			when "1111100" =>
				SD2Output1(1) <= '-';
			when "1111101" =>
				SD2Output1(1) <= '-';
			when "1111110" =>
				SD2Output1(1) <= '-';
			when "1111111" =>
				SD2Output1(1) <= '-';
			when others =>
				SD2Output1(1) <= '-';
		end case;
	end process;

	--------------
	SD2_CASE_a_2 : process (ErrorVec1) is
	begin
		case ErrorVec1 is
			when "0000000" =>
				SD2Output1(2) <= '0';
			when "0000001" =>
				SD2Output1(2) <= '0';
			when "0000010" =>
				SD2Output1(2) <= '0';
			when "0000011" =>
				SD2Output1(2) <= '0';
			when "0000100" =>
				SD2Output1(2) <= '1';
			when "0000101" =>
				SD2Output1(2) <= '1';
			when "0000110" =>
				SD2Output1(2) <= '1';
			when "0000111" =>
				SD2Output1(2) <= '0';
			when "0001000" =>
				SD2Output1(2) <= '0';
			when "0001001" =>
				SD2Output1(2) <= '0';
			when "0001010" =>
				SD2Output1(2) <= '0';
			when "0001011" =>
				SD2Output1(2) <= '1';
			when "0001100" =>
				SD2Output1(2) <= '1';
			when "0001101" =>
				SD2Output1(2) <= '0';
			when "0001110" =>
				SD2Output1(2) <= '0';
			when "0001111" =>
				SD2Output1(2) <= '0';
			when "0010000" =>
				SD2Output1(2) <= '0';
			when "0010001" =>
				SD2Output1(2) <= '0';
			when "0010010" =>
				SD2Output1(2) <= '0';
			when "0010011" =>
				SD2Output1(2) <= '0';
			when "0010100" =>
				SD2Output1(2) <= '1';
			when "0010101" =>
				SD2Output1(2) <= '0';
			when "0010110" =>
				SD2Output1(2) <= '-';
			when "0010111" =>
				SD2Output1(2) <= '-';
			when "0011000" =>
				SD2Output1(2) <= '0';
			when "0011001" =>
				SD2Output1(2) <= '-';
			when "0011010" =>
				SD2Output1(2) <= '-';
			when "0011011" =>
				SD2Output1(2) <= '-';
			when "0011100" =>
				SD2Output1(2) <= '-';
			when "0011101" =>
				SD2Output1(2) <= '-';
			when "0011110" =>
				SD2Output1(2) <= '-';
			when "0011111" =>
				SD2Output1(2) <= '0';
			when "0100000" =>
				SD2Output1(2) <= '0';
			when "0100001" =>
				SD2Output1(2) <= '0';
			when "0100010" =>
				SD2Output1(2) <= '0';
			when "0100011" =>
				SD2Output1(2) <= '0';
			when "0100100" =>
				SD2Output1(2) <= '1';
			when "0100101" =>
				SD2Output1(2) <= '-';
			when "0100110" =>
				SD2Output1(2) <= '-';
			when "0100111" =>
				SD2Output1(2) <= '-';
			when "0101000" =>
				SD2Output1(2) <= '0';
			when "0101001" =>
				SD2Output1(2) <= '-';
			when "0101010" =>
				SD2Output1(2) <= '0';
			when "0101011" =>
				SD2Output1(2) <= '-';
			when "0101100" =>
				SD2Output1(2) <= '-';
			when "0101101" =>
				SD2Output1(2) <= '-';
			when "0101110" =>
				SD2Output1(2) <= '-';
			when "0101111" =>
				SD2Output1(2) <= '0';
			when "0110000" =>
				SD2Output1(2) <= '0';
			when "0110001" =>
				SD2Output1(2) <= '0';
			when "0110010" =>
				SD2Output1(2) <= '0';
			when "0110011" =>
				SD2Output1(2) <= '0';
			when "0110100" =>
				SD2Output1(2) <= '-';
			when "0110101" =>
				SD2Output1(2) <= '-';
			when "0110110" =>
				SD2Output1(2) <= '-';
			when "0110111" =>
				SD2Output1(2) <= '1';
			when "0111000" =>
				SD2Output1(2) <= '-';
			when "0111001" =>
				SD2Output1(2) <= '-';
			when "0111010" =>
				SD2Output1(2) <= '-';
			when "0111011" =>
				SD2Output1(2) <= '0';
			when "0111100" =>
				SD2Output1(2) <= '0';
			when "0111101" =>
				SD2Output1(2) <= '-';
			when "0111110" =>
				SD2Output1(2) <= '-';
			when "0111111" =>
				SD2Output1(2) <= '0';
			when "1000000" =>
				SD2Output1(2) <= '0';
			when "1000001" =>
				SD2Output1(2) <= '0';
			when "1000010" =>
				SD2Output1(2) <= '0';
			when "1000011" =>
				SD2Output1(2) <= '-';
			when "1000100" =>
				SD2Output1(2) <= '1';
			when "1000101" =>
				SD2Output1(2) <= '0';
			when "1000110" =>
				SD2Output1(2) <= '-';
			when "1000111" =>
				SD2Output1(2) <= '-';
			when "1001000" =>
				SD2Output1(2) <= '0';
			when "1001001" =>
				SD2Output1(2) <= '-';
			when "1001010" =>
				SD2Output1(2) <= '0';
			when "1001011" =>
				SD2Output1(2) <= '-';
			when "1001100" =>
				SD2Output1(2) <= '-';
			when "1001101" =>
				SD2Output1(2) <= '-';
			when "1001110" =>
				SD2Output1(2) <= '-';
			when "1001111" =>
				SD2Output1(2) <= '0';
			when "1010000" =>
				SD2Output1(2) <= '0';
			when "1010001" =>
				SD2Output1(2) <= '1';
			when "1010010" =>
				SD2Output1(2) <= '-';
			when "1010011" =>
				SD2Output1(2) <= '-';
			when "1010100" =>
				SD2Output1(2) <= '0';
			when "1010101" =>
				SD2Output1(2) <= '0';
			when "1010110" =>
				SD2Output1(2) <= '-';
			when "1010111" =>
				SD2Output1(2) <= '0';
			when "1011000" =>
				SD2Output1(2) <= '-';
			when "1011001" =>
				SD2Output1(2) <= '0';
			when "1011010" =>
				SD2Output1(2) <= '0';
			when "1011011" =>
				SD2Output1(2) <= '-';
			when "1011100" =>
				SD2Output1(2) <= '-';
			when "1011101" =>
				SD2Output1(2) <= '0';
			when "1011110" =>
				SD2Output1(2) <= '-';
			when "1011111" =>
				SD2Output1(2) <= '-';
			when "1100000" =>
				SD2Output1(2) <= '0';
			when "1100001" =>
				SD2Output1(2) <= '-';
			when "1100010" =>
				SD2Output1(2) <= '0';
			when "1100011" =>
				SD2Output1(2) <= '-';
			when "1100100" =>
				SD2Output1(2) <= '-';
			when "1100101" =>
				SD2Output1(2) <= '0';
			when "1100110" =>
				SD2Output1(2) <= '0';
			when "1100111" =>
				SD2Output1(2) <= '-';
			when "1101000" =>
				SD2Output1(2) <= '0';
			when "1101001" =>
				SD2Output1(2) <= '-';
			when "1101010" =>
				SD2Output1(2) <= '0';
			when "1101011" =>
				SD2Output1(2) <= '0';
			when "1101100" =>
				SD2Output1(2) <= '-';
			when "1101101" =>
				SD2Output1(2) <= '-';
			when "1101110" =>
				SD2Output1(2) <= '1';
			when "1101111" =>
				SD2Output1(2) <= '-';
			when "1110000" =>
				SD2Output1(2) <= '-';
			when "1110001" =>
				SD2Output1(2) <= '-';
			when "1110010" =>
				SD2Output1(2) <= '-';
			when "1110011" =>
				SD2Output1(2) <= '0';
			when "1110100" =>
				SD2Output1(2) <= '-';
			when "1110101" =>
				SD2Output1(2) <= '0';
			when "1110110" =>
				SD2Output1(2) <= '-';
			when "1110111" =>
				SD2Output1(2) <= '-';
			when "1111000" =>
				SD2Output1(2) <= '-';
			when "1111001" =>
				SD2Output1(2) <= '-';
			when "1111010" =>
				SD2Output1(2) <= '0';
			when "1111011" =>
				SD2Output1(2) <= '-';
			when "1111100" =>
				SD2Output1(2) <= '-';
			when "1111101" =>
				SD2Output1(2) <= '-';
			when "1111110" =>
				SD2Output1(2) <= '-';
			when "1111111" =>
				SD2Output1(2) <= '-';
			when others =>
				SD2Output1(2) <= '-';
		end case;
	end process;

	--------------
	SD2_CASE_a_5 : process (ErrorVec1) is
	begin
		case ErrorVec1 is
			when "0000000" =>
				SD2Output1(5) <= '0';
			when "0000001" =>
				SD2Output1(5) <= '0';
			when "0000010" =>
				SD2Output1(5) <= '0';
			when "0000011" =>
				SD2Output1(5) <= '0';
			when "0000100" =>
				SD2Output1(5) <= '0';
			when "0000101" =>
				SD2Output1(5) <= '0';
			when "0000110" =>
				SD2Output1(5) <= '0';
			when "0000111" =>
				SD2Output1(5) <= '0';
			when "0001000" =>
				SD2Output1(5) <= '0';
			when "0001001" =>
				SD2Output1(5) <= '0';
			when "0001010" =>
				SD2Output1(5) <= '0';
			when "0001011" =>
				SD2Output1(5) <= '0';
			when "0001100" =>
				SD2Output1(5) <= '0';
			when "0001101" =>
				SD2Output1(5) <= '0';
			when "0001110" =>
				SD2Output1(5) <= '0';
			when "0001111" =>
				SD2Output1(5) <= '0';
			when "0010000" =>
				SD2Output1(5) <= '0';
			when "0010001" =>
				SD2Output1(5) <= '0';
			when "0010010" =>
				SD2Output1(5) <= '0';
			when "0010011" =>
				SD2Output1(5) <= '1';
			when "0010100" =>
				SD2Output1(5) <= '0';
			when "0010101" =>
				SD2Output1(5) <= '0';
			when "0010110" =>
				SD2Output1(5) <= '-';
			when "0010111" =>
				SD2Output1(5) <= '-';
			when "0011000" =>
				SD2Output1(5) <= '0';
			when "0011001" =>
				SD2Output1(5) <= '-';
			when "0011010" =>
				SD2Output1(5) <= '-';
			when "0011011" =>
				SD2Output1(5) <= '-';
			when "0011100" =>
				SD2Output1(5) <= '-';
			when "0011101" =>
				SD2Output1(5) <= '-';
			when "0011110" =>
				SD2Output1(5) <= '-';
			when "0011111" =>
				SD2Output1(5) <= '0';
			when "0100000" =>
				SD2Output1(5) <= '1';
			when "0100001" =>
				SD2Output1(5) <= '1';
			when "0100010" =>
				SD2Output1(5) <= '1';
			when "0100011" =>
				SD2Output1(5) <= '0';
			when "0100100" =>
				SD2Output1(5) <= '1';
			when "0100101" =>
				SD2Output1(5) <= '-';
			when "0100110" =>
				SD2Output1(5) <= '-';
			when "0100111" =>
				SD2Output1(5) <= '-';
			when "0101000" =>
				SD2Output1(5) <= '1';
			when "0101001" =>
				SD2Output1(5) <= '-';
			when "0101010" =>
				SD2Output1(5) <= '0';
			when "0101011" =>
				SD2Output1(5) <= '-';
			when "0101100" =>
				SD2Output1(5) <= '-';
			when "0101101" =>
				SD2Output1(5) <= '-';
			when "0101110" =>
				SD2Output1(5) <= '-';
			when "0101111" =>
				SD2Output1(5) <= '1';
			when "0110000" =>
				SD2Output1(5) <= '1';
			when "0110001" =>
				SD2Output1(5) <= '0';
			when "0110010" =>
				SD2Output1(5) <= '0';
			when "0110011" =>
				SD2Output1(5) <= '0';
			when "0110100" =>
				SD2Output1(5) <= '-';
			when "0110101" =>
				SD2Output1(5) <= '-';
			when "0110110" =>
				SD2Output1(5) <= '-';
			when "0110111" =>
				SD2Output1(5) <= '0';
			when "0111000" =>
				SD2Output1(5) <= '-';
			when "0111001" =>
				SD2Output1(5) <= '-';
			when "0111010" =>
				SD2Output1(5) <= '-';
			when "0111011" =>
				SD2Output1(5) <= '0';
			when "0111100" =>
				SD2Output1(5) <= '0';
			when "0111101" =>
				SD2Output1(5) <= '-';
			when "0111110" =>
				SD2Output1(5) <= '-';
			when "0111111" =>
				SD2Output1(5) <= '0';
			when "1000000" =>
				SD2Output1(5) <= '0';
			when "1000001" =>
				SD2Output1(5) <= '0';
			when "1000010" =>
				SD2Output1(5) <= '0';
			when "1000011" =>
				SD2Output1(5) <= '-';
			when "1000100" =>
				SD2Output1(5) <= '0';
			when "1000101" =>
				SD2Output1(5) <= '0';
			when "1000110" =>
				SD2Output1(5) <= '-';
			when "1000111" =>
				SD2Output1(5) <= '-';
			when "1001000" =>
				SD2Output1(5) <= '0';
			when "1001001" =>
				SD2Output1(5) <= '-';
			when "1001010" =>
				SD2Output1(5) <= '1';
			when "1001011" =>
				SD2Output1(5) <= '-';
			when "1001100" =>
				SD2Output1(5) <= '-';
			when "1001101" =>
				SD2Output1(5) <= '-';
			when "1001110" =>
				SD2Output1(5) <= '-';
			when "1001111" =>
				SD2Output1(5) <= '0';
			when "1010000" =>
				SD2Output1(5) <= '0';
			when "1010001" =>
				SD2Output1(5) <= '0';
			when "1010010" =>
				SD2Output1(5) <= '-';
			when "1010011" =>
				SD2Output1(5) <= '-';
			when "1010100" =>
				SD2Output1(5) <= '0';
			when "1010101" =>
				SD2Output1(5) <= '0';
			when "1010110" =>
				SD2Output1(5) <= '-';
			when "1010111" =>
				SD2Output1(5) <= '0';
			when "1011000" =>
				SD2Output1(5) <= '-';
			when "1011001" =>
				SD2Output1(5) <= '0';
			when "1011010" =>
				SD2Output1(5) <= '0';
			when "1011011" =>
				SD2Output1(5) <= '-';
			when "1011100" =>
				SD2Output1(5) <= '-';
			when "1011101" =>
				SD2Output1(5) <= '0';
			when "1011110" =>
				SD2Output1(5) <= '-';
			when "1011111" =>
				SD2Output1(5) <= '-';
			when "1100000" =>
				SD2Output1(5) <= '1';
			when "1100001" =>
				SD2Output1(5) <= '-';
			when "1100010" =>
				SD2Output1(5) <= '0';
			when "1100011" =>
				SD2Output1(5) <= '-';
			when "1100100" =>
				SD2Output1(5) <= '-';
			when "1100101" =>
				SD2Output1(5) <= '0';
			when "1100110" =>
				SD2Output1(5) <= '0';
			when "1100111" =>
				SD2Output1(5) <= '-';
			when "1101000" =>
				SD2Output1(5) <= '0';
			when "1101001" =>
				SD2Output1(5) <= '-';
			when "1101010" =>
				SD2Output1(5) <= '0';
			when "1101011" =>
				SD2Output1(5) <= '0';
			when "1101100" =>
				SD2Output1(5) <= '-';
			when "1101101" =>
				SD2Output1(5) <= '-';
			when "1101110" =>
				SD2Output1(5) <= '0';
			when "1101111" =>
				SD2Output1(5) <= '-';
			when "1110000" =>
				SD2Output1(5) <= '-';
			when "1110001" =>
				SD2Output1(5) <= '-';
			when "1110010" =>
				SD2Output1(5) <= '-';
			when "1110011" =>
				SD2Output1(5) <= '0';
			when "1110100" =>
				SD2Output1(5) <= '-';
			when "1110101" =>
				SD2Output1(5) <= '1';
			when "1110110" =>
				SD2Output1(5) <= '-';
			when "1110111" =>
				SD2Output1(5) <= '-';
			when "1111000" =>
				SD2Output1(5) <= '-';
			when "1111001" =>
				SD2Output1(5) <= '-';
			when "1111010" =>
				SD2Output1(5) <= '0';
			when "1111011" =>
				SD2Output1(5) <= '-';
			when "1111100" =>
				SD2Output1(5) <= '-';
			when "1111101" =>
				SD2Output1(5) <= '-';
			when "1111110" =>
				SD2Output1(5) <= '-';
			when "1111111" =>
				SD2Output1(5) <= '-';
			when others =>
				SD2Output1(5) <= '-';
		end case;
	end process;
	------------------------------------
	Correcting_b: FOR i in 0 to 2 GENERATE
		Corrected_RedFSM0(i) <= redx(i) xor SD2Output0(i);
	END GENERATE;
	Corrected_RedFSM0(3) <= redx(Red_size-2) xor SD2Output0(Red_size-2);
	---
	Correcting_a: FOR i in Red_size to Red_size+2 GENERATE
		Corrected_RedFSM1(i-Red_size) <= redx(i) xor SD2Output1(i-Red_size);
	END GENERATE;
	Corrected_RedFSM1(3) <= redx(2*Red_size-2) xor SD2Output1(Red_size-2);
	------------------------------------
	LFTable_inv_Process0: Process (Corrected_RedFSM0)
		begin
			F_inv0(0) <= LFTable_inv0(15-to_integer(unsigned(Corrected_RedFSM0)));
		end process;	
	
	LFTable_inv_Process1: Process (Corrected_RedFSM0)
		begin
			F_inv0(1) <= LFTable_inv1(15-to_integer(unsigned(Corrected_RedFSM0)));
		end process;
	
	LFTable_inv_Process2: Process (Corrected_RedFSM0)
		begin
			F_inv0(2) <= LFTable_inv2(15-to_integer(unsigned(Corrected_RedFSM0)));
		end process;

	---
	LFTable_inv_Process_0: Process (Corrected_RedFSM1)
		begin
			F_inv1(0) <= LFTable_inv0(15-to_integer(unsigned(Corrected_RedFSM1)));
		end process;	
	
	LFTable_inv_Process_1: Process (Corrected_RedFSM1)
		begin
			F_inv1(1) <= LFTable_inv1(15-to_integer(unsigned(Corrected_RedFSM1)));
		end process;
	
	LFTable_inv_Process_2: Process (Corrected_RedFSM1)
		begin
			F_inv1(2) <= LFTable_inv2(15-to_integer(unsigned(Corrected_RedFSM1)));
		end process;
		
	LFTable_inv_Process_3: Process (Corrected_RedFSM1)
		begin
			F_inv1(3) <= LFTable_inv3(15-to_integer(unsigned(Corrected_RedFSM1)));
		end process;
	------------------------------------
	
	FSM <= F_inv1 & F_inv0(2 downto 0);
	---
	
	Gen0_to_3: IF BitNumber < Red_size GENERATE
		GenwithoutDec1: IF withDec = 0 GENERATE
				FSMdone 	<=	std_logic_vector(to_unsigned(LFSR4doneEnc,4)) & std_logic_vector(to_unsigned(LFSR3doneEnc,3));
		END GENERATE;

		GenwithDec1: IF withDec /= 0 GENERATE
			FSMdoneEnc 	<=	std_logic_vector(to_unsigned(LFSR4doneEnc,4)) & std_logic_vector(to_unsigned(LFSR3doneEnc,3));
			FSMdoneDec	<=  std_logic_vector(to_unsigned(LFSR4doneDec,4)) & std_logic_vector(to_unsigned(LFSR3doneDec,3));

			FSMdone		<= FSMdoneEnc WHEN EncDec = '0' ELSE FSMdoneDec;
		END GENERATE;
		done_internal(0)	<= '1' WHEN (FSM = FSMdone) ELSE '0';
		done_internal(Red_size-1 downto 1) <= (others => '0');
		
		
		GenwithoutDec: IF withDec = 0 GENERATE
			FSMUpdate(0) <= FSM(1);
			FSMUpdate(1) <= FSM(2);
			FSMUpdate(2) <= (FSM(0) XOR FSM(1));
			FSMUpdate(3) <= '0';		
		END GENERATE;	

		GenwithDec: IF withDec /= 0 GENERATE
			FSMUpdate(0) <= FSM(1) 					WHEN EncDec = '0' ELSE (FSM(0) XOR FSM(2));
			FSMUpdate(1) <= FSM(2) 					WHEN EncDec = '0' ELSE FSM(0);
			FSMUpdate(2) <= (FSM(0) XOR FSM(1)) 	WHEN EncDec = '0' ELSE FSM(1);
			FSMUpdate(3) <= '0';
		END GENERATE;	
		
		--------------------------
		
		GEN0: IF BitNumber=0 GENERATE
			LF_ProcessDone: Process (done_internal)
			begin
				done <= LFTable0(15-to_integer(unsigned(done_internal)));
			end process;
		
			Red_a_b <= Corrected_RedFSM0(0);
			
			LF_Process: Process (FSMUpdate)
			begin
				Red_FSMUpdateBit <= LFTable0(15-to_integer(unsigned(FSMUpdate(3 downto 0))));
			end process;	
		END GENERATE;

		GEN1: IF BitNumber=1 GENERATE
			LF_ProcessDone: Process (done_internal)
			begin
				done <= LFTable1(15-to_integer(unsigned(done_internal)));
			end process;
			Red_a_b <= Corrected_RedFSM0(1);
			LF_Process: Process (FSMUpdate)
			begin
				Red_FSMUpdateBit <= LFTable1(15-to_integer(unsigned(FSMUpdate(3 downto 0))));
			end process;	
		END GENERATE;

		GEN2: IF BitNumber=2 GENERATE
			LF_ProcessDone: Process (done_internal)
			begin
				done <= LFTable2(15-to_integer(unsigned(done_internal)));
			end process;
			Red_a_b <= Corrected_RedFSM0(2);
			LF_Process: Process (FSMUpdate)
			begin
				Red_FSMUpdateBit <= LFTable2(15-to_integer(unsigned(FSMUpdate(3 downto 0))));
			end process;	
		END GENERATE;	

		GEN3: IF BitNumber=3 GENERATE
			LF_ProcessDone: Process (done_internal)
			begin
				done <= LFTable3(15-to_integer(unsigned(done_internal)));
			end process;
			Red_a_b <= redx(BitNumber) xor SD2Output0(BitNumber);
			LF_Process: Process (FSMUpdate)
			begin
				Red_FSMUpdateBit <= LFTable3(15-to_integer(unsigned(FSMUpdate(3 downto 0))));
			end process;	
		END GENERATE;	
		
		GEN4: IF BitNumber=4 GENERATE
			LF_ProcessDone: Process (done_internal)
			begin
				done <= LFTable4(15-to_integer(unsigned(done_internal)));
			end process;
			Red_a_b <= redx(BitNumber) xor SD2Output0(BitNumber);
			LF_Process: Process (FSMUpdate)
			begin
				Red_FSMUpdateBit <= LFTable4(15-to_integer(unsigned(FSMUpdate(3 downto 0))));
			end process;	
		END GENERATE;	
		
		GEN5: IF BitNumber=5 GENERATE
			LF_ProcessDone: Process (done_internal)
			begin
				done <= LFTable5(15-to_integer(unsigned(done_internal)));
			end process;
			Red_a_b <= redx(BitNumber) xor SD2Output0(BitNumber);
			LF_Process: Process (FSMUpdate)
			begin
				Red_FSMUpdateBit <= LFTable5(15-to_integer(unsigned(FSMUpdate(3 downto 0))));
			end process;	
		END GENERATE;	
		
		GEN6: IF BitNumber=6 GENERATE
			LF_ProcessDone: Process (done_internal)
			begin
				done <= LFTable6(15-to_integer(unsigned(done_internal)));
			end process;
			Red_a_b <= redx(BitNumber) xor SD2Output0(BitNumber);
			LF_Process: Process (FSMUpdate)
			begin
				Red_FSMUpdateBit <= LFTable6(15-to_integer(unsigned(FSMUpdate(3 downto 0))));
			end process;	
		END GENERATE;	
		
	END GENERATE;	
	
	---
	
	Gen7_to_13: IF BitNumber >= Red_size GENERATE
		GenwithoutDec: IF withDec = 0 GENERATE
			FSMUpdate(3) <= FSM(4);
			FSMUpdate(4) <= FSM(5);
			FSMUpdate(5) <= FSM(6);
			FSMUpdate(6) <= (FSM(3) XOR FSM(4));
		END GENERATE;	

		GenwithDec: IF withDec /= 0 GENERATE
			FSMUpdate(3) <= FSM(4) 						WHEN EncDec = '0' ELSE (FSM(3) XOR FSM(6));
			FSMUpdate(4) <= FSM(5) 						WHEN EncDec = '0' ELSE FSM(3);
			FSMUpdate(5) <= FSM(6) 						WHEN EncDec = '0' ELSE FSM(4);
			FSMUpdate(6) <= (FSM(3) XOR FSM(4)) 	WHEN EncDec = '0' ELSE FSM(5);
		END GENERATE;	
		
		--------------------------
		
		GEN7: IF BitNumber-Red_size=0 GENERATE
			LF_Process: Process (FSMUpdate)
			begin
				Red_FSMUpdateBit <= LFTable0(15-to_integer(unsigned(FSMUpdate(6 downto 3))));
			end process;	
			Red_a_b <= redx(BitNumber) xor SD2Output1(BitNumber-Red_size);
		END GENERATE;

		GEN8: IF BitNumber-Red_size=1 GENERATE
			LF_Process: Process (FSMUpdate)
			begin
				Red_FSMUpdateBit <= LFTable1(15-to_integer(unsigned(FSMUpdate(6 downto 3))));
			end process;	
			Red_a_b <= redx(BitNumber) xor SD2Output1(BitNumber-Red_size);
		END GENERATE;

		GEN9: IF BitNumber-Red_size=2 GENERATE
			LF_Process: Process (FSMUpdate)
			begin
				Red_FSMUpdateBit <= LFTable2(15-to_integer(unsigned(FSMUpdate(6 downto 3))));
			end process;	
			Red_a_b <= redx(BitNumber) xor SD2Output1(BitNumber-Red_size);
		END GENERATE;		
		
		GEN10: IF BitNumber-Red_size=3 GENERATE
			LF_Process: Process (FSMUpdate)
			begin
				Red_FSMUpdateBit <= LFTable3(15-to_integer(unsigned(FSMUpdate(6 downto 3))));
			end process;	
			Red_a_b <= redx(BitNumber) xor SD2Output1(BitNumber-Red_size);
		END GENERATE;

		GEN11: IF BitNumber-Red_size=4 GENERATE
			LF_Process: Process (FSMUpdate)
			begin
				Red_FSMUpdateBit <= LFTable4(15-to_integer(unsigned(FSMUpdate(6 downto 3))));
			end process;	
			Red_a_b <= redx(BitNumber) xor SD2Output1(BitNumber-Red_size);
		END GENERATE;

		GEN12: IF BitNumber-Red_size=5 GENERATE
			LF_Process: Process (FSMUpdate)
			begin
				Red_FSMUpdateBit <= LFTable5(15-to_integer(unsigned(FSMUpdate(6 downto 3))));
			end process;	
			Red_a_b <= redx(BitNumber) xor SD2Output1(BitNumber-Red_size);
		END GENERATE;
		
		GEN13: IF BitNumber-Red_size=6 GENERATE
			LF_Process: Process (FSMUpdate)
			begin
				Red_FSMUpdateBit <= LFTable6(15-to_integer(unsigned(FSMUpdate(6 downto 3))));
			end process;	
			Red_a_b <= redx(BitNumber) xor SD2Output1(BitNumber-Red_size);
		END GENERATE;
	END GENERATE;
end Behavioral;

