library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity MEM_RAM is
port ( clk : in std_logic;
MemWrite : in std_logic;
--we : in std_logic; -- op?ional
ALUResin : in std_logic_vector(31 downto 0);
ALUResout : out std_logic_vector(31 downto 0);
RD2 : in std_logic_vector(31 downto 0);
MemData : out std_logic_vector(31 downto 0);
MemData3 : out std_logic_vector(31 downto 0));
end MEM_RAM ;



architecture Behavioral of MEM_RAM is
type ram_type is array (0 to 63) of std_logic_vector(31 downto 0);
signal ram : ram_type := (
0 => X"00001100",
4 => X"00000005",
8 => X"000FFFFF",
12 => X"00000003",
16 => X"00000005",
20 => X"00000004",
24 => X"00000006",
28 => X"00000007",

others => X"00000000");

begin

  MemData <= ram(conv_integer(ALUResin(7 downto 2)));
  MemData3 <= RD2;
     
process(clk)
begin
    if rising_edge(clk) then
            if MemWrite = '1' then
                ram(conv_integer(ALUResin(7 downto 2))) <= RD2;
        end if;
      end if;
   
end process;

ALUResout <= ALUResin;

end Behavioral;