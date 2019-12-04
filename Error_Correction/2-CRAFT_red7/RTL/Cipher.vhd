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
use work.functions.all;


entity Cipher is
	 Generic ( 
		Red_size  		: POSITIVE := 7;
		LFTable        : STD_LOGIC_VECTOR (127  DOWNTO 0) := x"000F333C555A66696A6559563F300C03"
		);
    Port ( clk 			: in  STD_LOGIC;
           rst 			: in  STD_LOGIC;
			  EncDec			: in  STD_LOGIC := '0';  -- 0: encryption  1: decryption
           Input 			: in  STD_LOGIC_VECTOR ( 63 downto 0);
           Key 			: in  STD_LOGIC_VECTOR (127 downto 0);
			  Tweak        : in  STD_LOGIC_VECTOR ( 63 downto 0) := (others => '0');
           Output 		: out STD_LOGIC_VECTOR ( 63 downto 0);
           done 			: out STD_LOGIC);
end Cipher;

architecture Behavioral of Cipher is
	constant withTweak 		: integer  := 0;
	constant withDec   		: integer  := 0;
	constant SboxTable 		: STD_LOGIC_VECTOR (63 DOWNTO 0) 	:= x"cad3ebf789150246";
	constant LFTable_inv		: STD_LOGIC_VECTOR (63 DOWNTO 0) 	:= x"0A5FE4B1D782396C";
	constant Red_SboxTable 	: STD_LOGIC_VECTOR (127 DOWNTO 0) 	:= x"3F0F5666550C5A5933696A303C650300";
	constant LFSRaTable 		: STD_LOGIC_VECTOR (63 DOWNTO 0) 	:= x"08912AB34CD56EF7";
	constant LFSRbTable 		: STD_LOGIC_VECTOR (63 DOWNTO 0) 	:= x"0451267304512673";
	constant Identity 		: STD_LOGIC_VECTOR (63 DOWNTO 0) 	:= x"0123456789ABCDEF";
	constant SD1Table 		: STD_LOGIC_VECTOR (511 DOWNTO 0) 	:= x"000000010001011100020400000000010002000000800001022200020002300C0000040000800001040044040A50040000800960808800800002040000800000";
	constant SD2Table 		: STD_LOGIC_VECTOR (1023 DOWNTO 0) 	:= x"000102030405060808090A040C02010010111220144000001800000000000010202122102400000028004000000000203002010000000004000000080000000040414200441000004800200000000040500400000100000200000000000800006000080000000000020000010000040000000040002000000000100000000000";
	
	constant LFSR4initEnc 	: integer := 1;
	constant LFSR3initEnc 	: integer := 1;

	constant LFSR4initDec 	: integer := 8;
	constant LFSR3initDec 	: integer := 5;

	--
	constant LFSR4EndEnc 	: integer := 4;
	constant LFSR3EndEnc 	: integer := 6;

	constant LFSR4EndDec 	: integer := 3;
	constant LFSR3EndDec 	: integer := 3;

	
	-------------------------------

	signal StateRegOutput						: STD_LOGIC_VECTOR(63 downto 0);
	
	signal RoundConstant							: STD_LOGIC_VECTOR(7  downto 0);
	signal AddRoundKeyOutput					: STD_LOGIC_VECTOR(63 downto 0);
	signal PermutationInput						: STD_LOGIC_VECTOR(63 downto 0);
	signal MCInput 								: STD_LOGIC_VECTOR(63 downto 0);
	signal MCOutput								: STD_LOGIC_VECTOR(63 downto 0);
	signal Feedback								: STD_LOGIC_VECTOR(63 downto 0);
	signal RoundKey								: STD_LOGIC_VECTOR(63 downto 0);
	signal K0										: STD_LOGIC_VECTOR(63 downto 0);
	signal K1										: STD_LOGIC_VECTOR(63 downto 0);
	signal SelectedKey							: STD_LOGIC_VECTOR(63 downto 0);
	signal SelectedTweak							: STD_LOGIC_VECTOR(63 downto 0);
	signal SelectedTweakKey						: STD_LOGIC_VECTOR(63 downto 0);
	signal SelectedTweakKeyMC					: STD_LOGIC_VECTOR(63 downto 0);
	signal Tweak_Q									: STD_LOGIC_VECTOR(63 downto 0);
	signal FaultyOutput							: STD_LOGIC_VECTOR(63 downto 0);
	signal FSMInitialEnc							: STD_LOGIC_VECTOR(6  downto 0);
	signal FSMInitialDec							: STD_LOGIC_VECTOR(6  downto 0);
	signal FSM										: STD_LOGIC_VECTOR(6  downto 0);
	signal FSMInitial								: STD_LOGIC_VECTOR(6  downto 0);
	signal FSMUpdate								: STD_LOGIC_VECTOR(6  downto 0);
	signal FSMReg									: STD_LOGIC_VECTOR(6  downto 0);

	-------
	signal TweakMux_D0_input					: STD_LOGIC_VECTOR(64+16*Red_size-1 downto 0);
	signal TweakMux_D1_input					: STD_LOGIC_VECTOR(64+16*Red_size-1 downto 0);
	signal TweakMux_Q								: STD_LOGIC_VECTOR(64+16*Red_size-1 downto 0);
	signal TweakMux_sel_input					: STD_LOGIC_VECTOR(4 downto 0);
	signal KeyMux_Q								: STD_LOGIC_VECTOR(64+16*Red_size-1 downto 0);
	signal KeyMux_D0_input						: STD_LOGIC_VECTOR(64+16*Red_size-1 downto 0);
	signal KeyMux_D1_input						: STD_LOGIC_VECTOR(64+16*Red_size-1 downto 0);
	signal KeyMux_sel_input						: STD_LOGIC_VECTOR(4 downto 0);
	signal Red_Input								: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_StateRegOutput					: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal CipherErrorVec						: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal StateRegOutputF						: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_RoundConstant					: STD_LOGIC_VECTOR( 2*Red_size-1 downto 0);
	signal Red_AddRoundKeyOutput				: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_PermutationInput				: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_MCInput							: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_MCOutput							: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_Feedback							: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_RoundKey							: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_K0									: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_K1									: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_SelectedKey						: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_SelectedTweak					: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_SelectedTweakKey				: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_SelectedTweakKeyMC				: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_Tweak								: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_Tweak_Q							: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);

	signal Red_FSMInitialEnc					: STD_LOGIC_VECTOR(2*Red_size-1 downto 0);
	signal Red_FSMInitialDec					: STD_LOGIC_VECTOR(2*Red_size-1 downto 0);
	signal Red_FSM									: STD_LOGIC_VECTOR(2*Red_size-1 downto 0);
	signal Red_FSMInitial						: STD_LOGIC_VECTOR(2*Red_size-1 downto 0);
	signal Red_FSMUpdate							: STD_LOGIC_VECTOR(2*Red_size-1 downto 0);
	signal Red_FSMReg								: STD_LOGIC_VECTOR(2*Red_size-1 downto 0);
	signal FSMF										: STD_LOGIC_VECTOR(2*Red_size-1 downto 0);
	signal FSMErrorVec							: STD_LOGIC_VECTOR(2*Red_size-1 downto 0);
	

	signal selects									: STD_LOGIC_VECTOR(1 downto 0);
	signal selectsReg								: STD_LOGIC_VECTOR(1 downto 0);
	signal selectsInitial						: STD_LOGIC_VECTOR(1 downto 0);
	signal selectsNext							: STD_LOGIC_VECTOR(1 downto 0);
	signal sel_Key									: STD_LOGIC;
	signal sel_Tweak								: STD_LOGIC;
	signal done_internal							: STD_LOGIC;
	
	signal Red_selects							: STD_LOGIC_VECTOR(Red_size*2-1 downto 0);
	signal Red_selectsReg						: STD_LOGIC_VECTOR(Red_size*2-1 downto 0);
	signal Red_selectsInitial					: STD_LOGIC_VECTOR(Red_size*2-1 downto 0);
	signal Red_selectsNext						: STD_LOGIC_VECTOR(Red_size*2-1 downto 0);
	signal Red_sel_Key							: STD_LOGIC_VECTOR(Red_size-1 downto 0);
	signal Red_sel_Tweak							: STD_LOGIC_VECTOR(Red_size-1 downto 0);
	signal Red_done								: STD_LOGIC_VECTOR(Red_size-1 downto 0);

	signal EnableSaveCiphertext				: STD_LOGIC;	
	signal OutputRegIn							: STD_LOGIC_VECTOR(63 downto 0);
	signal EncDec01								: STD_LOGIC_VECTOR( 1 downto 0);
	
begin

	--=================================================== Cipher 
	InputMUX: ENTITY work.MUX
	GENERIC Map ( size => 64)
	PORT Map ( 
		sel	=> rst,
		D0   	=> Feedback,
		D1 	=> Input,
		Q 		=> MCInput);

	MCInst: ENTITY work.MC
	GENERIC Map ( size => 4)
	PORT Map (
		state		=> MCInput,
		result	=> MCOutput);
	
	
	AddKeyXOR1: ENTITY work.XOR_2n
	GENERIC Map ( size => 4, count => 4)
	PORT Map ( MCOutput(63 downto 48), RoundKey(63 downto 48), AddRoundKeyOutput(63 downto 48));

	AddKeyConstXOR: ENTITY work.XOR_3n
	GENERIC Map ( size => 4, count => 2)
	PORT Map ( MCOutput(47 downto 40), RoundKey(47 downto 40), RoundConstant, AddRoundKeyOutput(47 downto 40));

	AddKeyXOR2: ENTITY work.XOR_2n
	GENERIC Map ( size => 4, count => 10)
	PORT Map ( MCOutput(39 downto 0), RoundKey(39 downto 0), AddRoundKeyOutput(39 downto 0));
	
	StateReg: ENTITY work.reg
	GENERIC Map ( size => 64)
	PORT Map ( 
		clk	=> clk,
		D 		=> AddRoundKeyOutput,
		Q 		=> StateRegOutput);
	
	F_StateRegOutput_Inst: ENTITY work.FMulti
	GENERIC Map ( count => 16, size	=> Red_size, Table => LFTable)
	PORT Map (
		input		=> StateRegOutput,
		output	=> StateRegOutputF);
		
	CipherErrorVecGen: ENTITY work.XOR_2n
	GENERIC Map ( size => Red_size, count => 16)
	PORT Map ( StateRegOutputF, Red_StateRegOutput, CipherErrorVec);
		
	SD1_SB_inst: ENTITY work.SD1_SB 
	Generic Map (StateSize => 4, Red_size => Red_size, SboxTable => SboxTable, SD1Table => SD1Table)
	PORT MAP(
		x 				=> StateRegOutput,
		ErrorVec		=> CipherErrorVec,
		CipherOut 	=> OutputRegIn,
		y 				=> PermutationInput);
	
	PermutationInst: ENTITY work.Permutation
	GENERIC Map ( size => 4)
	PORT Map (
		state		=> PermutationInput,
		result	=> Feedback);
	
	--=================================================== Cipher Redundancy

	Red_PlaintextInst: ENTITY work.FMulti
	GENERIC Map ( count => 16, size	=> Red_size, Table => LFTable)
	PORT Map (
		input		=> Input,
		output	=> Red_Input);
		
	Red_InputMUX: ENTITY work.MUX
	GENERIC Map ( size => 16*Red_size)
	PORT Map ( 
		sel	=> rst,
		D0		=> Red_Feedback,
		D1		=> Red_Input,
		Q		=> Red_MCInput);

	Red_MCInst: ENTITY work.MC
	GENERIC Map ( size => Red_size)
	PORT Map (
		state		=> Red_MCInput,
		result	=> Red_MCOutput);

	Red_AddKeyXOR1: ENTITY work.XOR_2n
	GENERIC Map ( size => Red_size, count => 4)
	PORT Map ( Red_MCOutput(16*Red_size-1 downto 12*Red_size), Red_RoundKey(16*Red_size-1 downto 12*Red_size), Red_AddRoundKeyOutput(16*Red_size-1 downto 12*Red_size));

	Red_AddKeyConstXOR: ENTITY work.XOR_3n
	GENERIC Map ( size => Red_size, count => 2)
	PORT Map ( Red_MCOutput(12*Red_size-1 downto 10*Red_size), Red_RoundKey(12*Red_size-1 downto 10*Red_size), Red_RoundConstant, Red_AddRoundKeyOutput(12*Red_size-1 downto 10*Red_size));

	Red_AddKeyXOR2: ENTITY work.XOR_2n
	GENERIC Map ( size => Red_size, count => 10)
	PORT Map ( Red_MCOutput(10*Red_size-1 downto 0), Red_RoundKey(10*Red_size-1 downto 0), Red_AddRoundKeyOutput(10*Red_size-1 downto 0));


	Red_StateReg: ENTITY work.reg
	GENERIC Map ( size => 16*Red_size)
	PORT Map ( 
		clk	=> clk,
		D 		=> Red_AddRoundKeyOutput,
		Q 		=> Red_StateRegOutput);
		
	F_SD2_RedSB_inst: ENTITY work.F_SD2_RedSB 
	Generic Map (StateSize => 4, Red_size => Red_size, LFTable => LFTable, Red_SboxTable => Red_SboxTable, SD2Table => SD2Table)
	PORT MAP(
		x => StateRegOutput,
		redx => Red_StateRegOutput,
		y => Red_PermutationInput );
		
	Red_PermutationInst: ENTITY work.Permutation
	GENERIC Map ( size => Red_size)
	PORT Map (
		state		=> Red_PermutationInput,
		result	=> Red_Feedback);

	--=================================================== Key Schedule

	K0 	<= Key (127 DOWNTO 64);
	K1 	<= Key (63  DOWNTO 0);

	KeyMux_sel_input 	<= sel_Key & Red_sel_Key(3 downto 0);
	KeyMux_D0_input 	<= K0 & Red_K0;
	KeyMux_D1_input 	<= K1 & Red_K1;
	SelectedKey 		<= KeyMux_Q(64+16*Red_size-1 downto 16*Red_size);
	Red_SelectedKey 	<= KeyMux_Q(16*Red_size-1 downto 0);
	
	K0K1_KeyMUX_And_Red_KeyMUX: ENTITY work.MUX2to1_Redn
	GENERIC Map ( 
		size1   => 5, 
		size2   => 64+16*Red_size,
		LFTable => LFTable)
	PORT Map (
		sel	=> KeyMux_sel_input,
		D0		=> KeyMux_D0_input,
		D1		=> KeyMux_D1_input,
		Q		=> KeyMux_Q);	
		
	GenwithoutTweak: IF withTweak = 0 GENERATE
		SelectedTweakKey <= SelectedKey;
	END GENERATE;	

	GenwithTweak: IF withTweak /= 0 GENERATE
		Tweak_QInst: ENTITY work.TweakPermutation 
		GENERIC Map (size => 4)
		PORT Map (Tweak, Tweak_Q);
		
		TweakMux_sel_input 		<= sel_Tweak & Red_sel_Tweak(3 downto 0);
		TweakMux_D0_input 		<= Tweak & Red_Tweak;
		TweakMux_D1_input 		<= Tweak_Q & Red_Tweak_Q;
		SelectedTweak 				<= TweakMux_Q(64+16*Red_size-1 downto 16*Red_size);
		Red_SelectedTweak 		<= TweakMux_Q(16*Red_size-1 downto 0);
		
		TweakMUX_And_Red_TweakMUX: ENTITY work.MUX2to1_Redn
		GENERIC Map ( 
			size1   => 5, 
			size2   => 64+16*Red_size,
			LFTable => LFTable)
		PORT Map (
			sel	=> TweakMux_sel_input,
			D0		=> TweakMux_D0_input,
			D1		=> TweakMux_D1_input,
			Q		=> TweakMux_Q);
			
		SelectedTweakKey <= SelectedKey XOR SelectedTweak;
	END GENERATE;
	
	-------

	GenwithoutDecKey: IF withDec = 0 GENERATE
		RoundKey		<= SelectedTweakKey;	
	END GENERATE;
	
	GenwithDecKey: IF withDec /= 0 GENERATE
		KeyMCInst: ENTITY work.MC
		GENERIC Map ( size => 4)
		PORT Map (
			state		=> SelectedTweakKey,
			result	=> SelectedTweakKeyMC);

		EncDecKeyMUX: ENTITY work.MUX
		GENERIC Map ( size => 32)
		PORT Map ( 
			sel	=> EncDec,
			D0   	=> SelectedTweakKey  (63 downto 32),
			D1 	=> SelectedTweakKeyMC(63 downto 32),
			Q 		=> RoundKey     (63 downto 32));	

		RoundKey(31 downto 0) <= SelectedTweakKey(31 downto 0);	
	END GENERATE;
		
	--=================================================== Key Schedule Redundancy

	Red_K0Inst: ENTITY work.FMulti
	GENERIC Map ( count => 16, size	=> Red_size, Table => LFTable)
	PORT Map (
		input		=> K0,
		output	=> Red_K0);
	
	Red_K1Inst: ENTITY work.FMulti
	GENERIC Map ( count => 16, size	=> Red_size, Table => LFTable)
	PORT Map (
		input		=> K1,
		output	=> Red_K1);
	

	GenRedwithoutTweak: IF withTweak = 0 GENERATE
		Red_SelectedTweakKey <= Red_SelectedKey;
	END GENERATE;

	GenRedwithTweak: IF withTweak /= 0 GENERATE
		Red_TweakInst: ENTITY work.FMulti
		GENERIC Map ( count => 16, size	=> Red_size, Table => LFTable)
		PORT Map (
			input		=> Tweak,
			output	=> Red_Tweak);

		Red_Tweak_QInst: ENTITY work.TweakPermutation 
		GENERIC Map (size => Red_size)
		PORT Map (Red_Tweak, Red_Tweak_Q);

		Red_AddTweak0: ENTITY work.XOR_2n
		GENERIC Map (size => Red_size, count => 16)
		PORT Map (Red_SelectedKey, Red_SelectedTweak, Red_SelectedTweakKey);
	END GENERATE;	
	
	--------
	
	GenRedwithoutDecKey: IF withDec = 0 GENERATE
		Red_RoundKey		<= Red_SelectedTweakKey;	
	END GENERATE;
	
	GenRedwithDecKey: IF withDec /= 0 GENERATE
		Red_KeyMCInst: ENTITY work.MC
		GENERIC Map ( size => Red_size)
		PORT Map (
			state		=> Red_SelectedTweakKey,
			result	=> Red_SelectedTweakKeyMC
			);
		
		Red_EncDecKeyMUX: ENTITY work.MUX
		GENERIC Map ( size => 8*Red_size)
		PORT Map ( 
			sel	=> EncDec,
			D0   	=> Red_SelectedTweakKey  (16*Red_size-1 downto 8*Red_size),
			D1 	=> Red_SelectedTweakKeyMC(16*Red_size-1 downto 8*Red_size),
			Q 		=> Red_RoundKey          (16*Red_size-1 downto 8*Red_size));	

		Red_RoundKey(8*Red_size-1 downto 0) <= Red_SelectedTweakKey(8*Red_size-1 downto 0);
	END GENERATE;

	--=================================================== LFSR

	FSMInitialEnc 	<= std_logic_vector(to_unsigned(LFSR4initEnc,4)) & std_logic_vector(to_unsigned(LFSR3initEnc,3));
	FSMInitialDec	<= std_logic_vector(to_unsigned(LFSR4initDec,4)) & std_logic_vector(to_unsigned(LFSR3initDec,3));
	
	GenwithoutDecFSM: IF withDec = 0 GENERATE
		FSMInitial 	<= FSMInitialEnc;
	END GENERATE;	

	GenwithDecFSM: IF withDec /= 0 GENERATE
		FSMInitialMUX: ENTITY work.MUX
		GENERIC Map ( size => 7)
		PORT Map ( 
			sel	=> EncDec,
			D0   	=> FSMInitialEnc,
			D1 	=> FSMInitialDec,
			Q 		=> FSMInitial);	
	END GENERATE;		
	
	FSMMUX: ENTITY work.MUX
	GENERIC Map ( size => 7)
	PORT Map ( 
		sel	=> rst,
		D0   	=> FSMReg,
		D1 	=> FSMInitial,
		Q 		=> FSM);

	F_FSM_Inst: ENTITY work.FMulti
	GENERIC Map ( count => 2, size => Red_size, Table => LFTable)
	PORT Map (
		input(2 downto 0) 	=> FSM(2 downto 0),
		input(7 downto 4) 	=> FSM(6 downto 3),
		input(3) 				=> '0',
		output					=> FSMF);
		
	FSMErrorVecGen: ENTITY work.XOR_2n
	GENERIC Map ( size => Red_size, count => 2)
	PORT Map (FSMF, Red_FSM, FSMErrorVec); 
	
	
	F_SD1_StateUpdate_Done_Inst: ENTITY work.F_SD1_StateUpdate_Done
	Generic Map (LFSR4doneEnc => LFSR4EndEnc, LFSR3doneEnc => LFSR3EndEnc, LFSR4doneDec => LFSR4EndDec, LFSR3doneDec => LFSR3EndDec, withDec => withDec, StateSize => 4, Red_size => Red_size, Count => 2, SD1Table => SD1Table)
	PORT MAP(
		x(2 downto 0) 	=> FSM(2 downto 0),
		x(7 downto 4) 	=> FSM(6 downto 3),
		x(3) 				=> '0',
		ErrorVec		 	=> FSMErrorVec,
		EncDec 			=> EncDec,
		done	 			=> done_internal,
		a_b 				=> RoundConstant,
		y 					=> FSMUpdate);
		
	
	FSMRegInst: ENTITY work.reg
	GENERIC Map ( size => 7)
	PORT Map ( 
		clk	=> clk,
		D 		=> FSMUpdate,
		Q 		=> FSMReg);
	

	--=================================================== Key Selects FSM

	sel_Key		<= selects(0);
	sel_Tweak	<= selects(1);
	
	GenwithoutDecselects: IF withDec = 0 GENERATE
		selectsInitial <= "00";
	END GENERATE;
	
	GenwithDecselects: IF withDec /= 0 GENERATE
		selectsInitial <= EncDec & EncDec;
	END GENERATE;
	
	selectsMUX: ENTITY work.MUX
	GENERIC Map ( size => 1)
	PORT Map ( 
		sel	=> rst,
		D0(0)   	=> selectsReg(0),
		D1(0) 	=> selectsInitial(0),
		Q(0)		=> selects(0));
		
	F_SD1_SelectsUpdate_Bit0_Inst: ENTITY work.F_SD1_SelectsUpdate_Bit
	GENERIC Map (0, withDec, 4, Red_size, LFTable, SD1Table)
	PORT MAP(
		selects(0) => selects(0),
		selects(1) => '0',
		redx => Red_selects,
		EncDec => EncDec,
		selectsNextBit => selectsNext(0));

	selectsRegInst: ENTITY work.reg
	GENERIC Map ( size => 1)
	PORT Map ( 
		clk	=> clk,
		D(0) 		=> selectsNext(0),
		Q(0) 		=> selectsReg(0));

	--=================================================== LFSR Redundancy
	
	Red_FSMInitialEnc 	<= LFTable(119+Red_size-LFSR4initEnc*8 downto 120-LFSR4initEnc*8) & LFTable(119+Red_size-LFSR3initEnc*8 downto 120-LFSR3initEnc*8);
	Red_FSMInitialDec		<= LFTable(119+Red_size-LFSR4initDec*8 downto 120-LFSR4initDec*8) & LFTable(119+Red_size-LFSR3initDec*8 downto 120-LFSR3initDec*8);
	
	GenRedwithoutDecFSM: IF withDec = 0 GENERATE
		Red_FSMInitial 	<= Red_FSMInitialEnc;
	END GENERATE;	

	GenRedwithDecFSM: IF withDec /= 0 GENERATE	
		Red_FSMInitialMUX: ENTITY work.MUX
		GENERIC Map ( size => 2*Red_size)
		PORT Map ( 
			sel	=> EncDec,
			D0   	=> Red_FSMInitialEnc,
			D1 	=> Red_FSMInitialDec,
			Q 		=> Red_FSMInitial);	
	END GENERATE;	
	
	Red_FSMMUX: ENTITY work.MUX
	GENERIC Map ( size => 2*Red_size)
	PORT Map ( 
		sel	=> rst,
		D0   	=> Red_FSMReg,
		D1 	=> Red_FSMInitial,
		Q 		=> Red_FSM);
		
	
	F_SD2_RedStateUpdate_Done_Inst: ENTITY work.F_SD2_RedStateUpdate_Done
	Generic Map (LFSR4EndEnc, LFSR3EndEnc, LFSR4EndDec, LFSR3EndDec, withDec, 4, Red_size, 2, LFTable, LFTable_inv, SD2Table)
	PORT MAP(
		x(2 downto 0) 		=> FSM(2 downto 0),
		x(7 downto 4) 		=> FSM(6 downto 3),
		x(3) 					=> '0',
		redx 					=> Red_FSM,
		EncDec 				=> EncDec,
		Red_done 			=> Red_done,
		Red_a_b 				=> Red_RoundConstant,
		y						=> Red_FSMUpdate);

	Red_FSMRegInst: ENTITY work.reg
	GENERIC Map ( size => 2*Red_size)
	PORT Map ( 
		clk	=> clk,
		D 		=> Red_FSMUpdate,
		Q 		=> Red_FSMReg);	
	
	--=================================================== Key FSM Redundancy

	Red_sel_Key		<= Red_selects(Red_size-1   downto 0);
	Red_sel_Tweak	<= Red_selects(Red_size*2-1 downto Red_size);

	Red_GenwithoutDecselects: IF withDec = 0 GENERATE
		Red_selectsInitial <= LFTable(120+Red_size-1 downto 120) & LFTable(120+Red_size-1 downto 120);
	END GENERATE;
	
	EncDec01 <= '0' & EncDec;
	
	Red_GenwithDecselects: IF withDec /= 0 GENERATE
		Gen: FOR i in 0 to Red_size-1 GENERATE
			selProcess: Process (EncDec01)
			begin
				Red_selectsInitial(i)  				<= LFTable(120-to_integer(unsigned(EncDec01))*8+i);
				Red_selectsInitial(Red_size+i) 	<= LFTable(120-to_integer(unsigned(EncDec01))*8+i);
			end process;	
		END GENERATE;	
	END GENERATE;
	
	Red_selectsMUX: ENTITY work.MUX
	GENERIC Map (size => Red_size)
	PORT Map ( 
		sel	=> rst,
		D0   	=> Red_selectsReg(Red_size-1 downto 0),
		D1 	=> Red_selectsInitial(Red_size-1 downto 0),
		Q 		=> Red_selects(Red_size-1 downto 0));
		
	
	F_SD2_Red_SelectsUpdate_Inst: ENTITY work.F_SD2_Red_SelectsUpdate
	GENERIC Map (withDec, 4, Red_size, 2, LFTable, LFTable_inv, SD2Table)
	PORT Map (selects, Red_selects, EncDec, Red_selectsNext);

	Red_selectsRegInst: ENTITY work.reg
	GENERIC Map ( size => Red_size)
	PORT Map ( 
		clk	=> clk,
		D 		=> Red_selectsNext(Red_size-1 downto 0),
		Q 		=> Red_selectsReg(Red_size-1 downto 0));

	--=================================================== Output Redundancy
	Output_MUX: ENTITY work.AND_4n
		GENERIC Map (size   => 64)
		PORT Map (
			a		=> Red_done(0),
			b		=> done_internal,
			c		=> Red_done(1),
			d		=> OutputRegIn,
			z		=> Output);
			
	done <= done_internal;
	
--Output 	<= OutputRegIn;

end Behavioral;

