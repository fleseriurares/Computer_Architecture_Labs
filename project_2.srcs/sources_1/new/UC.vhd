----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/04/2024 05:38:38 PM
-- Design Name: 
-- Module Name: UC - Behavioral
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

entity UC is
    Port ( Instr : in STD_LOGIC_VECTOR (5 downto 0);
           RegDst : out STD_LOGIC;
           ExtOp : out STD_LOGIC;
           AluSrc : out STD_LOGIC;
           Branch : out STD_LOGIC;
           Jump : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR(2 downto 0);
           MemWrite : out STD_LOGIC;
           MemToReg : out STD_LOGIC;
           RegWrite : out STD_LOGIC);
end UC;

architecture Behavioral of UC is

begin
   
    process(Instr)
    begin
        RegDst <= '0';
       ExtOp <= '0';
       AluSrc <= '0';
       Branch <= '0';
       Jump <= '0';
       ALUOp <= "000";
       MemWrite <= '0';
       MemToReg <= '0';
       RegWrite <= '0';
    case Instr is
         when "000000" => RegDst <='1'; RegWrite<='1'; AluOP<="000";
         when "001001" => RegWrite<='1'; AluSrc <= '1'; ExtOp<= '1'; MemtoReg<='1';AluOP<="001";
         when "001010" => AluSrc <= '1'; ExtOp<= '1'; MemWrite<='1'; AluOP<="010";
         when "001011" => RegWrite<='1'; AluSrc <= '1'; ExtOp<= '1'; AluOP<="011";
         when "001100" => RegWrite<='1'; AluSrc <= '1';AluOP<="100";
         when "001101" => RegWrite<='1'; AluSrc <= '1';AluOP<="101";
         when "001110" => ExtOp<='1'; Branch <= '1';AluOP<="110";
         when others => Jump <= '1'; AluOP<="111";
    end case;
    end process;

end Behavioral;
