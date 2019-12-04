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


entity MajorityVoting is
	 GENERIC ( size: POSITIVE);
    Port ( A : in  STD_LOGIC_VECTOR (size-1 downto 0);
           B : in  STD_LOGIC_VECTOR (size-1 downto 0);
           C : in  STD_LOGIC_VECTOR (size-1 downto 0);
           D : in  STD_LOGIC_VECTOR (size-1 downto 0);
           E : in  STD_LOGIC_VECTOR (size-1 downto 0);
           output : out  STD_LOGIC_VECTOR (size-1 downto 0));
end MajorityVoting;

architecture Behavioral of MajorityVoting is
	signal ABC_check_signal : STD_LOGIC;
	signal ABD_check_signal : STD_LOGIC;
	signal ABE_check_signal : STD_LOGIC;
	signal ACD_check_signal : STD_LOGIC;
	signal ACE_check_signal : STD_LOGIC;
	signal ADE_check_signal : STD_LOGIC;
	signal BCD_check_signal : STD_LOGIC;
	signal BCE_check_signal : STD_LOGIC;
	signal BDE_check_signal : STD_LOGIC;
	signal CDE_check_signal : STD_LOGIC;
begin
	
	ABC_check_inst: ENTITY work.CheckEquality 
	GENERIC Map (size => 65)
	PORT MAP(
		A => A,
		B => B,
		C => C,
		Output => ABC_check_signal);
		
	ABD_check_inst: ENTITY work.CheckEquality 
	GENERIC Map (size => 65)
	PORT MAP(
		A => A,
		B => B,
		C => D,
		Output => ABD_check_signal);
	
	ABE_check_inst: ENTITY work.CheckEquality 
	GENERIC Map (size => 65)
	PORT MAP(
		A => A,
		B => B,
		C => E,
		Output => ABE_check_signal);
		
	ACD_check_inst: ENTITY work.CheckEquality 
	GENERIC Map (size => 65)
	PORT MAP(
		A => A,
		B => C,
		C => D,
		Output => ACD_check_signal);
		
	ACE_check_inst: ENTITY work.CheckEquality 
	GENERIC Map (size => 65)
	PORT MAP(
		A => A,
		B => C,
		C => E,
		Output => ACE_check_signal); 
		
	ADE_check_inst: ENTITY work.CheckEquality 
	GENERIC Map (size => 65)
	PORT MAP(
		A => A,
		B => D,
		C => E,
		Output => ADE_check_signal);
		
	BCD_check_inst: ENTITY work.CheckEquality 
	GENERIC Map (size => 65)
	PORT MAP(
		A => B,
		B => C,
		C => D,
		Output => BCD_check_signal); 
		
	BCE_check_inst: ENTITY work.CheckEquality 
	GENERIC Map (size => 65)
	PORT MAP(
		A => B,
		B => C,
		C => E,
		Output => BCE_check_signal); 
		
	BDE_check_inst: ENTITY work.CheckEquality 
	GENERIC Map (size => 65)
	PORT MAP(
		A => B,
		B => D,
		C => E,
		Output => BDE_check_signal); 
		
	CDE_check_inst: ENTITY work.CheckEquality 
	GENERIC Map (size => 65)
	PORT MAP(
		A => C,
		B => D,
		C => E,
		Output => CDE_check_signal);
	
	output <=      A when (ABC_check_signal = '1') ELSE B when (ABD_check_signal = '1') ELSE B when (ABE_check_signal = '1') 
				 ELSE C when (ACD_check_signal = '1') ELSE E when (ACE_check_signal = '1') ELSE D when (ADE_check_signal = '1')
				 ELSE C when (BCD_check_signal = '1') ELSE E when (BCE_check_signal = '1') ELSE D when (BDE_check_signal = '1')
				 ELSE E when (CDE_check_signal = '1') ELSE (others => '0');

	

end Behavioral;

