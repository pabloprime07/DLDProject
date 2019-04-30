----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:40:38 04/30/2019 
-- Design Name: 
-- Module Name:    topLevel - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity topLevel is
    Port ( iDataAv : in  STD_LOGIC;
           iDataRd : out  STD_LOGIC;
           iData : in  STD_LOGIC_VECTOR (143 downto 0);
           oDataAv : out  STD_LOGIC;
           oDataRd : in  STD_LOGIC;
           oData : out  STD_LOGIC_VECTOR (143 downto 0);
           lkupData : out  STD_LOGIC_VECTOR (127 downto 0);
           lkupDataValid : out  STD_LOGIC;
           lkupMiss : in  STD_LOGIC;
           lkupFlowPrty : in  STD_LOGIC_VECTOR (2 downto 0);
           lkupFlowId : in  STD_LOGIC_VECTOR (7 downto 0);
           LkupFlowInfo : in  STD_LOGIC_VECTOR (255 downto 0);
           LkupFlowInfoValid : in  STD_LOGIC;
           flowId : in  STD_LOGIC_VECTOR (7 downto 0);
           burstSize : in  STD_LOGIC_VECTOR (15 downto 0);
           flowRate : in  STD_LOGIC_VECTOR (15 downto 0);
           configure : in  STD_LOGIC;
           iOffset : in  STD_LOGIC_VECTOR (15 downto 0);
           iLength : in  STD_LOGIC_VECTOR (2 downto 0);
           iInst : in  STD_LOGIC_VECTOR (7 downto 0);
           oOffset : out  STD_LOGIC_VECTOR (15 downto 0);
           oLength : out  STD_LOGIC_VECTOR (2 downto 0);
           oInst : out  STD_LOGIC_VECTOR (7 downto 0);
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC);
end topLevel;

architecture Behavioral of topLevel is

component lkupExtractor is
    Port ( iData : in  STD_LOGIC_VECTOR (143 downto 0);
           trigger : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (127 downto 0);
           outputValid : out  STD_LOGIC;
           clk : in  STD_LOGIC;
           fail : out  STD_LOGIC;
           offset : in  STD_LOGIC_VECTOR (3 downto 0);
           len : in  STD_LOGIC_VECTOR (2 downto 0));
end component;

type ipStates is (waiting, reading);
signal ipState : ipStates := waiting;

signal EOP : STD_LOGIC;
signal iDataStored : STD_LOGIC_VECTOR(144 downto 0);


-------------------------
--Temp Signals
signal lkupOP : STD_LOGIC_VECTOR (127 downto 0);
signal lkupOV, lkupFail, lkupExtractorTrigger : STD_LOGIC;
signal lkupOffset : STD_LOGIC_VECTOR (3 downto 0);
signal lkupLen : STD_LOGIC_VECTOR (2 downto 0);
------------------------


begin

LE : lkupExtractor port map
		(	iData => iData,
			trigger => lkupExtractorTrigger,
			output => lkupOP,
			outputValid => lkupOV,
			clk => clk,
			fail => lkupFail,
			offset => lkupOffset,
			len => lkupLen		
		);

EOP <= not(iData(143) and iData(134) and iData(125) and iData(116) and iData(107) and iData(98) and iData(89) and iData(80) and iData(71) and iData(62) and iData(53) and iData(44) and iData(35) and iData(26) and iData(17) and iData(8));
iDataStored <= EOP & iData;

input:process(clk)

variable offsetCounter : integer range 0 to 65535;
variable currPacketOffset : integer range 0 to 65535;
variable currPacketLength : integer range 0 to 7;

begin
if rising_edge(clk) then
	case ipState is
		when waiting =>
		--When iDataAv is = 1, we assume that iOffset, iLength, iInst are valid.
		--Thus, we store these values in the same clock cycle as 
			if iDataAv = '1' then --and lkup doesn't already have one packet in queue and FIFO is not full
				iDataRd <= '1';--rd_en for ip FIFOs
				offsetCounter := 0;
				ipState <= reading;
				currPacketOffset := to_integer(unsigned(iOffset));
				currPacketLength := to_integer(unsigned(iLength));
			end if;
		when reading =>
			if offsetCounter < currPacketOffset and offsetCounter + 16 > currPacketOffset then
				lkupExtractorTrigger <= '1';
				--curr vector has required bytes
			else
				lkupExtractorTrigger <= '0';
				offsetCounter := offsetCounter + 16;
			end if;
			if EOP = '1' then
				--current vector has some dv=0
				iDataRd <= '0';
				ipState <= waiting;
			end if;
	end case;
end if;
end process;


end Behavioral;

