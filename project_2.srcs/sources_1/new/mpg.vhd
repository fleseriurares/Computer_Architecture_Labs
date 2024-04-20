----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/29/2024 05:38:27 PM
-- Design Name: 
-- Module Name: mpg - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity mpg is
Port(
signal clk: in std_logic;
signal btn: in std_logic;
signal en: out std_logic);
end mpg;

architecture Behavioral of mpg is

signal cnt: std_logic_vector(15 downto 0) := (others=>'0');
signal Q1: std_logic;
signal Q2: std_logic;
signal Q3: std_logic;

begin


en <= not(Q3) and Q2;
process(clk)
begin

 if rising_edge(clk) then
        cnt<=cnt+1;
if cnt="1111111111111111" then
Q1<=btn;
  end if;
  Q2<=Q1;
  Q3<=Q2;
 end if;

end process;

end Behavioral;
