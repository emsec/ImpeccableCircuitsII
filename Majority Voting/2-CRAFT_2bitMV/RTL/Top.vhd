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

entity Top is
	Generic ( 
		withTweak : integer := 0;
		withDec   : integer := 0);
    Port ( 
		clk 			: in  STD_LOGIC;
      rst 			: in  STD_LOGIC;
		EncDec		: in  STD_LOGIC := '0';  -- 0: encryption  1: decryption
      Input			: in  STD_LOGIC_VECTOR ( 63 downto 0);
      Key 			: in  STD_LOGIC_VECTOR (127 downto 0);
		Tweak       : in  STD_LOGIC_VECTOR ( 63 downto 0) := (others => '0');
      Output 		: out STD_LOGIC_VECTOR ( 63 downto 0);
      done 			: out STD_LOGIC);
end Top;

architecture Behavioral of Top is
	signal OutputA									: STD_LOGIC_VECTOR(63 downto 0);
	signal OutputB									: STD_LOGIC_VECTOR(63 downto 0);
	signal OutputC									: STD_LOGIC_VECTOR(63 downto 0);
	signal OutputD									: STD_LOGIC_VECTOR(63 downto 0);
	signal OutputE									: STD_LOGIC_VECTOR(63 downto 0);
	signal OutputRegIn							: STD_LOGIC_VECTOR(63 downto 0);
	signal MajorityVotingIn0					: STD_LOGIC_VECTOR(64 downto 0);
	signal MajorityVotingIn1					: STD_LOGIC_VECTOR(64 downto 0);
	signal MajorityVotingIn2					: STD_LOGIC_VECTOR(64 downto 0);
	signal MajorityVotingIn3					: STD_LOGIC_VECTOR(64 downto 0);
	signal MajorityVotingIn4					: STD_LOGIC_VECTOR(64 downto 0);
	signal MajorityVotingOut					: STD_LOGIC_VECTOR(64 downto 0);
	signal doneA									: STD_LOGIC;
	signal doneB									: STD_LOGIC; 
	signal doneC									: STD_LOGIC; 
	signal doneD									: STD_LOGIC; 
	signal doneE									: STD_LOGIC; 
	signal done_internal							: STD_LOGIC;
	signal done_reg								: STD_LOGIC; 	
begin

	CRAFT_A: ENTITY work.CipherA 
	GENERIC Map (withTweak => withTweak, withDec => withDec)
	PORT MAP(
		clk => clk,
		rst => rst,
		EncDec => EncDec,
		Input => Input,
		Key => Key,
		Tweak => Tweak,
		Output => OutputA,
		done => doneA
	);
	
	CRAFT_B: ENTITY work.CipherB 
	GENERIC Map (withTweak => withTweak, withDec => withDec)
	PORT MAP(
		clk => clk,
		rst => rst,
		EncDec => EncDec,
		Input => Input,
		Key => Key,
		Tweak => Tweak,
		Output => OutputB,
		done => doneB
	);
	
	CRAFT_C: ENTITY work.CipherC 
	GENERIC Map (withTweak => withTweak, withDec => withDec)
	PORT MAP(
		clk => clk,
		rst => rst,
		EncDec => EncDec,
		Input => Input,
		Key => Key,
		Tweak => Tweak,
		Output => OutputC,
		done => doneC
	);
	
	CRAFT_D: ENTITY work.CipherD 
	GENERIC Map (withTweak => withTweak, withDec => withDec)
	PORT MAP(
		clk => clk,
		rst => rst,
		EncDec => EncDec,
		Input => Input,
		Key => Key,
		Tweak => Tweak,
		Output => OutputD,
		done => doneD
	);
	
	CRAFT_E: ENTITY work.CipherE 
	GENERIC Map (withTweak => withTweak, withDec => withDec)
	PORT MAP(
		clk => clk,
		rst => rst,
		EncDec => EncDec,
		Input => Input,
		Key => Key,
		Tweak => Tweak,
		Output => OutputE,
		done => doneE
	);
	
	MajorityVotingIn0 <= doneA & OutputA;
	MajorityVotingIn1 <= doneB & OutputB;
	MajorityVotingIn2 <= doneC & OutputC;
	MajorityVotingIn3 <= doneD & OutputD;
	MajorityVotingIn4 <= doneE & OutputE;
	
	
	OutputMajorityVoting: ENTITY work.MajorityVoting
	GENERIC Map (size => 65)
	PORT MAP(
		a => MajorityVotingIn0,
		b => MajorityVotingIn1,
		c => MajorityVotingIn2,
		d => MajorityVotingIn3,
		e => MajorityVotingIn4,
		output => MajorityVotingOut);
		
		
	OutputRegIn 		<= MajorityVotingOut (63 downto 0);
	done_internal		<= MajorityVotingOut (64);
	
	reg_gen: PROCESS(clk, done_internal)
	BEGIN
		IF RISING_EDGE(clk) THEN
			done_reg <= done_internal;
		END IF;
	END PROCESS;	

	
	OutputReg: ENTITY work.regER
	GENERIC Map ( size => 64)
	PORT Map ( 
		clk	=> clk,
		rst	=> rst,
		EN		=> done_reg,
		D 		=> OutputRegIn,
		Q 		=> Output);

	done		<= done_reg;
	
end Behavioral;

