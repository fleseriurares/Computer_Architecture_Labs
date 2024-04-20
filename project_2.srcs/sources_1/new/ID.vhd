----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/04/2024 04:50:23 PM
-- Design Name: 
-- Module Name: ID - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ID is
    Port ( clk: in STD_LOGIC;
           RegWr : in STD_LOGIC;
           Instr : in STD_LOGIC_VECTOR (25 downto 0);
           RegDst : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (31 downto 0);
           RD2 : out STD_LOGIC_VECTOR (31 downto 0);
           WD : in STD_LOGIC_VECTOR (31 downto 0);
           Funct : out STD_LOGIC_VECTOR (5 downto 0);
           Sa : out STD_LOGIC_VECTOR (4 downto 0);
           Ext_Imm : out STD_LOGIC_VECTOR (31 downto 0);
           reg3 : out STD_LOGIC_VECTOR (31 downto 0));
end ID;

architecture Behavioral of ID is

signal m1: STD_LOGIC_VECTOR(4 DOWNTO 0);
type reg_array is array(0 to 31) of std_logic_vector(31 downto 0);
signal reg_file : reg_array:= (
0 => X"00000000",
2 => X"00000000",
3 => X"00000000",
10 => X"00000000",
11 => X"00000000",
12 => X"00000001",
13 => X"00000004",
others => X"00000000");

begin
    
    m1 <= Instr(20 downto 16) when RegDst = '0' else  Instr(15 downto 11);
    reg3 <= reg_file(3);
    process(clk)
     begin
       if rising_edge(clk) then
        if regwr = '1' then
        reg_file(conv_integer(m1)) <= WD;
        end if;
        end if;
    end process;
        
        RD1 <= reg_file(conv_integer(Instr(25 downto 21)));
        RD2 <= reg_file(conv_integer(Instr(20 downto 16)));
    
    Funct <= Instr(5 downto 0);
    Sa <= Instr(10 downto 6);
   
    process(Instr,ExtOp)
    begin
        if ExtOp = '0' then
            Ext_Imm <= x"0000" & Instr(15 downto 0);
        elsif(Instr(15) = '0') then
             Ext_Imm <= x"0000" & Instr(15 downto 0);
        else
            Ext_Imm <= x"FFFF" & Instr(15 downto 0);
        end if;
    end process;
    
end Behavioral;
