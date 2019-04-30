----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:22:45 04/30/2019 
-- Design Name: 
-- Module Name:    lkupExtractor - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity lkupExtractor is
    Port ( iData : in  STD_LOGIC_VECTOR (143 downto 0);
           trigger : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (127 downto 0);
           outputValid : out  STD_LOGIC;
           clk : in  STD_LOGIC;
           fail : out  STD_LOGIC;
           offset : in  STD_LOGIC_VECTOR (3 downto 0);
           len : in  STD_LOGIC_VECTOR (2 downto 0));
end lkupExtractor;

architecture Behavioral of lkupExtractor is
----------------------------------------------------
--iData is in the format as given
--realData is iData(142 downto 135) & iData(133 downto 126) & iData(124 downto 117) & iData(115 downto 108) & iData(106 downto 99) & iData(97 downto 90) & iData(88 downto 81) & iData(79 downto 72) & iData(70 downto 63) & iData(61 downto 54) & iData(52 downto 45) & iData(43 downto 36) & iData(34 downto 27) & iData(25 downto 18) & iData(16 downto 9) & iData(7 downto 0)
--we want realData((len+offset)*8 downto offset*8)
--if (len+offset)*8 > 127 then take the excess bytes from the next clock cycle
--eg. offset = 15, len = 3
--we want realData_nextclock(15 downto 0) & realData_thisclock(127 downto 120)
--Trigger is '1' for exactly one clock cycle. That very clock cycle should be considered for processing.
--Let the extracted bits be extractedBits(len*8-1 downto 0). Then output should be "111...111" & extractedBits
--In case extractedBits are all zero, or dv='0' corresponding some extractedBits, then put fail<='1' for one clock cycle.
-- In case output is correct, then outputValid <= '1' for exactly 1 clock cycle
----------------------------------------------------
begin


end Behavioral;

