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

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0)
         -- outt : out STD_LOGIC_VECTOR (31 downto 0)
           );
            
end test_env;

architecture Behavioral of test_env is
signal counter: std_logic_vector (4 downto 0):=(others=>'0');
signal en0: std_logic:='0';
signal en1: std_logic:='0';

signal jump_address: std_logic_vector(31 downto 0);
signal branch_address: std_logic_vector(31 downto 0);
signal pc: std_logic_vector(31 downto 0);
signal instruction: std_logic_vector(31 downto 0);

signal data: std_logic_vector(31 downto 0):=(others=>'0');
signal in1: std_logic_vector(31 downto 0):=(others=>'0');
signal in2: std_logic_vector(31 downto 0):=(others=>'0');
signal in3: std_logic_vector(31 downto 0):=(others=>'0');

signal ra1 :  std_logic_vector(4 downto 0);
signal ra2 :  std_logic_vector(4 downto 0);
signal wa :  std_logic_vector(4 downto 0);
signal wd :  std_logic_vector(31 downto 0);
signal regwr :  std_logic;
signal regdst :  std_logic;
signal extop: std_logic;
signal rd1 :  std_logic_vector(31 downto 0);
signal reg3 :  std_logic_vector(31 downto 0);
signal rd2 :  std_logic_vector(31 downto 0);
signal funct: std_logic_vector( 5 downto 0);
signal  sa :  STD_LOGIC_VECTOR (4 downto 0);
signal  ext_imm : STD_LOGIC_VECTOR (31 downto 0);

signal alusrc :  STD_LOGIC;
signal branch :  STD_LOGIC;
signal ALUOp :  STD_LOGIC_VECTOR(2 downto 0);
signal ALURes : STD_LOGIC_VECTOR(31 downto 0);
signal ALUResOut : STD_LOGIC_VECTOR(31 downto 0);
signal MemWrite :  STD_LOGIC;
signal MemToReg :  STD_LOGIC;
signal Jump: std_logic;
signal zero: std_logic;

signal reg_file_wa:std_logic_vector(4 downto 0);
signal reg_file_wd:std_logic_vector(31 downto 0);

signal memData : std_logic_vector(31 downto 0);
signal memData3 : std_logic_vector(31 downto 0);


signal PCSrc : STD_LOGIC;

type rom is array(0 to 31) of std_logic_vector(31 downto 0);
signal rom_file : rom:= (
0 => X"00000111",
1 => X"00001111",
2 => X"00011111",
others => X"11111111"
);

component ID is
port(
signal clk: in STD_LOGIC;
signal RegWr : in STD_LOGIC;
signal  Instr : in STD_LOGIC_VECTOR (25 downto 0);
signal  RegDst : in STD_LOGIC;
signal  ExtOp : in STD_LOGIC;
signal  RD1 : out STD_LOGIC_VECTOR (31 downto 0);
signal  RD2 : out STD_LOGIC_VECTOR (31 downto 0);
signal  WD : in STD_LOGIC_VECTOR (31 downto 0);
signal  Funct : out STD_LOGIC_VECTOR (5 downto 0);
signal  Sa : out STD_LOGIC_VECTOR (4 downto 0);
signal  Ext_Imm : out STD_LOGIC_VECTOR (31 downto 0);
signal reg3 : out STD_LOGIC_VECTOR (31 downto 0));
end component;


component UC is
port(
signal Instr : in STD_LOGIC_VECTOR (5 downto 0);
signal RegDst : out STD_LOGIC;
signal ExtOp : out STD_LOGIC;
signal AluSrc : out STD_LOGIC;
signal Branch : out STD_LOGIC;
signal Jump : out STD_LOGIC;
signal ALUOp : out STD_LOGIC_VECTOR(2 downto 0);
signal MemWrite : out STD_LOGIC;
signal MemToReg : out STD_LOGIC;
signal RegWrite : out STD_LOGIC);


end component;

component MPG is
port(
signal clk, btn: in STD_LOGIC;
signal en: out STD_LOGIC);
end component;

component SSD is
port(
signal clk: in std_logic;
signal data: in std_logic_vector(31 downto 0);
signal cat: out std_logic_vector(6 downto 0);
signal an: out std_logic_vector(7 downto 0));
end component;

component reg_file is
port(
signal clk : in std_logic; 
signal ra1 : in std_logic_vector(4 downto 0);
signal ra2 : in std_logic_vector(4 downto 0);
signal wa : in std_logic_vector(4 downto 0);
signal wd : in std_logic_vector(31 downto 0);
signal regwr : in std_logic;
signal rd1 : out std_logic_vector(31 downto 0);
signal rd2 : out std_logic_vector(31 downto 0));
end component;

component IFetch is
port(
signal clk: in std_logic;
signal jump: in std_logic;
signal jump_address: std_logic_vector(31 downto 0);
signal branch_address: std_logic_vector(31 downto 0);
signal PCSrc: in std_logic;
signal en_pc:in std_logic;
signal res_pc:in std_logic;
signal pc: out std_logic_vector(31 downto 0);
signal instruction: out std_logic_vector(31 downto 0)
);
end component;

component EX is
port(
signal rd1 : in STD_LOGIC_VECTOR (31 downto 0);
signal rd2 : in STD_LOGIC_VECTOR (31 downto 0);
signal funct : in STD_LOGIC_VECTOR (5 downto 0);
signal Sa : in STD_LOGIC_VECTOR (4 downto 0);
signal Ext_Imm : in STD_LOGIC_VECTOR (31 downto 0);
signal PC_plus_4: in STD_LOGIC_VECTOR (31 downto 0);
signal AluSrc : in STD_LOGIC;
signal AluOp: in STD_LOGIC_VECTOR(2 downto 0);
signal AluRes: out STD_LOGIC_VECTOR(31 downto 0);
signal zero: out STD_LOGIC;
signal BranchAddress: out STD_LOGIC_VECTOR(31 downto 0)
);
end component;

component MEM_RAM is
port(
signal clk : in std_logic;
signal MemWrite : in std_logic;
--signal we : in std_logic; -- op?ional
signal ALUResin : in std_logic_vector(31 downto 0);
signal ALUResout : out std_logic_vector(31 downto 0);
signal RD2 : in std_logic_vector(31 downto 0);
signal MemData : out std_logic_vector(31 downto 0);
signal MemData3 : out std_logic_vector(31 downto 0));
end component;

begin
test_env_MPG1: MPG port map(
clk=>clk,
btn=>btn(0),
en=>en0
);
--en0<=btn(0); --- 
--en1<=btn(1); --- 
test_env_MPG21: MPG port map(
clk=>clk,
btn=>btn(1),
en=>en1
);

test_env_SSD: SSD port map(
clk=>clk,
data=>data,
cat=>cat,
an=>an
);

test_env_IFetch: IFetch port map(
clk=>clk,
jump=>jump,
jump_address=>jump_address,
branch_address=>branch_address,
PCSrc=>PCSrc,
en_pc=>en0,
res_pc=>en1,
pc=>pc,
instruction=>instruction
);

test_env_ID: ID port map(

clk=>clk,
RegWr => regwr,
Instr => instruction(25 downto 0),
RegDst => regdst,
ExtOp => extop,
RD1 => rd1,
RD2 => rd2,
WD => wd,
Funct => funct,
Sa => sa,
Ext_IMM => ext_imm,
reg3 => reg3
);

test_env_UC: UC port map
(
Instr => instruction(31 downto 26),
RegDst => regdst,
ExtOp => extop,
AluSrc => alusrc,
Branch => branch,
Jump => Jump,
ALUOp => ALUOp,
MemWrite => MemWrite,
MemToReg => MemToReg,
RegWrite => regwr
);

test_env_EX: EX port map
(
 rd1 => rd1,
 rd2 => rd2,
 funct => instruction(5 downto 0),
 Sa => instruction(10 downto 6),
 Ext_Imm => instruction(31 downto 0),
 PC_plus_4 => pc,
 AluSrc => alusrc,
 AluOp => ALUOp,
 AluRes => ALURes,
 zero => zero,
 BranchAddress => branch_address
);

test_env_RAM: MEM_RAM port map
(
 clk => clk,
 MemWrite => memWrite,
 ALUResin => ALURes,
ALUResout => ALUResOut,
 RD2 => rd2,
 MemData => memData,
 MemData3 => memData3);
--);

--test_env_regfile: reg_file port map
--(
--clk=>clk,
--ra1=>ra1,
--ra2=>ra2,
--wa=>reg_file_wa,
--wd=>reg_file_wd,
--regwr => regwr,
--rd1 => rd1,
--rd2 => rd2
--);

PCSrc <= branch and zero;
jump_address <= pc(31 downto 28) & instruction(25 downto 0) & "00";



process(clk)
begin
if(rising_edge(clk)) then
    if(sw(7) = '0') then
    data<=instruction;
    else
    data<=reg3;
    end if;
    end if;
end process;



-- outt<=memData3;

wd <= ALUResOut when MemToReg = '0' else memData;

led(0) <= branch;--regdst;
--led(1) <= extop;
--led(2) <= alusrc;
--led(3) <= branch;
--led(4) <= jump;
--led(7 downto 5) <= ALUOp;
led(8) <= PCSrc;
--led(9) <= memToReg;
--led(10) <= regwr;
led(15 downto 1) <= "000000000000000";

--test_env_MPG2: MPG port map(
--clk=>clk,
--btn=>btn(1),
--en=>regwr
--);

--test_env_REG: reg_file port map(
--clk=>clk,
--ra1=>ra1,
--ra2=>ra2,
--wa=>wa,
--wd=>wd,
--regwr=>regwr,
--rd1=>rd1,
--rd2=>rd2
--);
--process (clk, btn)
--begin
--    if btn(2) = '1' then -- reset asincron
--        counter <= (others => '0');
--    elsif rising_edge(clk) then
--        if en = '1' then
--            counter <= counter + 1;
--        end if;
--    end if;
--end process;



--process(counter)
--begin
--data<=rom_file(conv_integer(counter));
--end process;


--process(counter)
--begin
--ra1<=counter;
--ra2<=counter;
--wa<=counter;

--if btn(0) = '1' then
--    regwr<=not(regwr);
--end if;
--data<=rd1+rd2;
--wd<=rd1+rd2;
--end process;

--process(sw)
--begin
--in1<=X"0000000" & sw(3 downto 0);
--in2<=X"0000000" & sw(7 downto 4);
--in3<=X"000000" & sw(7 downto 0);
--end process;
--process(counter)
--begin
--case counter is
--when "00" =>data<=in1+in2;
--when "01" =>data<=in1-in2;
--when "10" =>data<=in3(29 downto 0) & "00";
--when others =>data<="00" & in3(31 downto 2);
--end case;

--if (data=0) then
--    led(7)<='1';
--else
--    led(7)<='0';
--end if;
--end process;
--led<=sw;
--led<=counter(31 downto 16);
--an(7 downto 4)<="1111";
--an(3 downto 0)<=btn(3 downto 0);
--cat<=(others=>'0');

end Behavioral;