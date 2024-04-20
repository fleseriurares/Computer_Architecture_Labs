----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/28/2024 04:23:57 PM
-- Design Name: 
-- Module Name: IFetch - Behavioral
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

entity IFetch is
Port(
 clk: in std_logic;
 jump: in std_logic;
 jump_address: std_logic_vector(31 downto 0);
 branch_address: std_logic_vector(31 downto 0);
 PCSrc: in std_logic;
 en_pc:in std_logic;
 res_pc:in std_logic;
 pc: out std_logic_vector(31 downto 0);
 instruction: out std_logic_vector(31 downto 0));
end IFetch;

architecture Behavioral of IFetch is

signal pc_reg: std_logic_vector(31 downto 0) := (others => '0');
signal pc_int: std_logic_vector(31 downto 0) := (others => '0');

--signal m1: std_logic_vector(31 downto 0);
signal sum:std_logic_vector(31 downto 0) := (others => '0');
signal m2: std_logic_vector(31 downto 0) := (others => '0');

type rom is array(0 to 31) of std_logic_vector(31 downto 0);
signal rom_file : rom:= (

--0 => b"000000_00011_00010_00011_00000_000101",
--0 => b"000000_01011_00010_00011_00000_000001",
--1 => b"000000_01011_00010_00011_00000_000001",

0 => b"001001_00000_00001_0000000000000000", --lw $1,0
1 => b"001001_00000_00010_0000000000000100",  --lw $2,4
--2 => b"000000_00011_00011_00011_00000_000101", --xor &3,&3,&3
 2=> b"000000_01100_00000_00011_00000_000001", -- addi &3,&3,1
--4 => b"000000_00100_00100_00100_00000_000101", --xor &4,&4,&4
3 => b"001001_00000_00100_0000000000000000", --lw &4,(&1)
4 => b"001110_00010_00011_0000000000001110", -- beq -> 14
5 => b"001001_00100_00110_0000000000000000", --lw &6
6 => b"001001_00100_00111_0000000000000100", --lw &7
7 => b"000000_00110_00111_00101_00000_001000", --slt
8 => b"001110_00101_00000_0000000000001110", --beq -> 14
9 => b"000000_00100_00000_01011_00000_000001", -- lw &11,&4
10 => b"000000_01011_01101_00100_00000_000001", --addi &4, &11,4
11 => b"000000_00011_00000_01011_00000_000001", --addi &3, &3,1
12 => b"000000_01011_01100_00011_00000_000001", --addi &4, &&11,4

13 => b"001111_00000000000000000000000100", --j 4
14 => b"001010_00000_00101_0000000000001000",

--15 => b"001001_00000_00011_0000000000001000",

others => X"FFFFFFFF"
);

begin

pc<=pc_reg+4;
instruction<=rom_file(conv_integer(pc_reg(6 downto 2)));

process(clk,res_pc)--clk?
begin
    if res_pc = '1' then
        pc_reg<=(others => '0');
    elsif rising_edge(clk) then
     if en_pc = '1' then-- 
        pc_reg<=m2;
    end if;
    end if;
end process;

process(clk, jump, PCSrc, jump_address,branch_address,pc_reg)
begin
    if jump = '1' then
        m2<= jump_address;
    elsif PCSrc = '1' then
        m2<=branch_address;
    else
        m2<=pc_reg+4;
        end if;
 end process;






--pc<=pc_int;  
end Behavioral;
