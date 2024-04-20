----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2024 05:17:29 PM
-- Design Name: 
-- Module Name: EX - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.numeric_std.ALL;

entity EX is
Port(
      rd1 : in STD_LOGIC_VECTOR (31 downto 0);
      rd2 : in STD_LOGIC_VECTOR (31 downto 0);
      funct : in STD_LOGIC_VECTOR (5 downto 0);
      Sa : in STD_LOGIC_VECTOR (4 downto 0);
      Ext_Imm : in STD_LOGIC_VECTOR (31 downto 0);
      PC_plus_4: in STD_LOGIC_VECTOR (31 downto 0);
      AluSrc : in STD_LOGIC;
      AluOp: in STD_LOGIC_VECTOR(2 downto 0);
      AluRes: out STD_LOGIC_VECTOR(31 downto 0);
      zero: out STD_LOGIC;
      BranchAddress: out STD_LOGIC_VECTOR(31 downto 0)
);

end EX;

architecture Behavioral of EX is

signal b: std_logic_vector(31 downto 0);
signal AluCtrl : std_logic_vector(5 downto 0);
--signal AluResAux : std_logic_vector(31 downto 0);
begin

BranchAddress <= Ext_Imm(29 downto 0) & "00" + PC_plus_4;

process(ALUSrc,rd2,Ext_Imm)
begin
    case ALUSrc is
        when '0' => b<=rd2;
        when others => b<=Ext_Imm;
    end case;
end process;

process(AluOp,AluCtrl, funct, rd1,b,sa, Ext_Imm, PC_plus_4)
   variable AluResAux: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
begin

case AluOP is
    when "000" => case funct is
        when "000001" =>AluResAux := rd1 + b;
        when "000010" => AluResAux := rd1 - b;
        when "000011" => AluResAux := rd1 and b;
        when "000100" => AluResAux := rd1 or b;
        when "000101" => AluResAux := rd1 xor b;
        when "000110" =>  AluResAux := to_stdlogicvector(to_bitvector(rd1) sll conv_integer(sa));
        when "000111" =>  AluResAux := to_stdlogicvector(to_bitvector(rd1) srl conv_integer(sa));
        when others => if signed(rd1)>signed(b) then  AluResAux := X"00000000";
                         else  AluResAux := X"FFFFFFFF";
                         end if;
                    end case;    
   when "001" =>   AluResAux := rd1 + b; --lw
   when "010" =>   AluResAux :=rd1 + b; --sw
   when "011" =>  AluResAux := rd1 + b; --addi
   when "100" =>AluResAux :=  rd1 and b;
   when "101" =>  AluResAux := rd1 or b;
   when "110" =>AluResAux := Ext_Imm(29 downto 0) & "00" + PC_plus_4;
   when others => AluResAux := Ext_Imm(29 downto 0) & "00" + PC_plus_4;
    end case;
 
        if signed(rd1) = signed(b) then 
        zero <= '1';
        else
        zero <= '0';
        end if;
           AluRes <= AluResAux;
end process;

end Behavioral;
