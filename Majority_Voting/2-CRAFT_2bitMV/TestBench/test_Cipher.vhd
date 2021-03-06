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

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 

ENTITY test_Cipher IS
END test_Cipher;
 
ARCHITECTURE behavior OF test_Cipher IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT TOP
	 Generic ( 
		withTweak : integer;
		withDec   : integer);
	 PORT(
         clk    : IN  std_logic;
         rst    : IN  std_logic;
         EncDec : IN  std_logic;
			Input  : IN  std_logic_vector(63 downto 0);
         Key    : IN  std_logic_vector(127 downto 0);
			Tweak  : IN  std_logic_vector( 63 downto 0);
         Output : OUT  std_logic_vector(63 downto 0);
         done   : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal EncDec : std_logic := '0';
	signal Input : std_logic_vector(63 downto 0) := (others => '0');
   signal Key : std_logic_vector(127 downto 0) := (others => '0');
	signal Tweak  : std_logic_vector( 63 downto 0) := (others => '0');

 	--Outputs
   signal Output11 : std_logic_vector(63 downto 0);
   signal done11 : std_logic;

   signal Output10 : std_logic_vector(63 downto 0);
   signal done10 : std_logic;

   signal Output01 : std_logic_vector(63 downto 0);
   signal done01 : std_logic;

   signal Output00 : std_logic_vector(63 downto 0);
   signal done00 : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut11: TOP 
	GENERIC MAP (withTweak => 1, withDec => 1)
	PORT MAP (
          clk => clk,
          rst => rst,
          EncDec => EncDec,
			 Input => Input,
          Key => Key,
			 Tweak => Tweak,
          Output => Output11,
          done => done11
        );

   uut10: TOP 
	GENERIC MAP (withTweak => 1, withDec => 0)
	PORT MAP (
          clk => clk,
          rst => rst,
          EncDec => EncDec,
			 Input => Input,
          Key => Key,
			 Tweak => Tweak,
          Output => Output10,
          done => done10
        );

   uut01: TOP 
	GENERIC MAP (withTweak => 0, withDec => 1)
	PORT MAP (
          clk => clk,
          rst => rst,
          EncDec => EncDec,
			 Input => Input,
          Key => Key,
			 Tweak => Tweak,
          Output => Output01,
          done => done01
        );

   uut00: TOP 
	GENERIC MAP (withTweak => 0, withDec => 0)
	PORT MAP (
          clk => clk,
          rst => rst,
          EncDec => EncDec,
			 Input => Input,
          Key => Key,
			 Tweak => Tweak,
          Output => Output00,
          done => done00
        );		  

	-------------------------------------------------

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
       wait for clk_period*1;

		Input   		<= (others => '0');
		Key 			<= (others => '0');
		Tweak			<= x"0123456789abcdef";
		EncDec		<= '0';
		
		rst			<= '1';

      wait for clk_period*1;		
		rst			<= '0';

		wait until done11='1'; 
		wait for clk_period*1.5;

		if (Output11 = x"42B05270E21B3FFF") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;

		if (Output10 = x"42B05270E21B3FFF") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;

		if (Output01 = x"F630538883063100") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;

		if (Output00 = x"F630538883063100") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;
		




      wait;
   end process;

END;

