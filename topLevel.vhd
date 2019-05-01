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


-----------------------------------------------------
--INPUT
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

COMPONENT DataFIFO
  PORT (
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(144 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(144 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC
  );
END COMPONENT;

type ipStates is (waiting, reading);
signal ipState : ipStates := waiting;

signal EOP, ipFIFOfull, iDataRdinternal : STD_LOGIC;
signal iDataStored : STD_LOGIC_VECTOR(144 downto 0);

--INPUT ENDS
------------------------------------------------------

------------------------------------------------------
--LKUP

type lkupStates is (waiting, lkupSent, waitingToSend);
signal lkupState : lkupStates :=waiting;
signal LEOutput : STD_LOGIC_VECTOR (127 downto 0);
signal LEOutputValid, LEFail, LETrigger : STD_LOGIC;
signal lkupOffset : STD_LOGIC_VECTOR (3 downto 0);
signal lkupLen : STD_LOGIC_VECTOR (2 downto 0);
signal lkupMissInternal : STD_LOGIC;
signal lkupFlowPrtyInternal : STD_LOGIC_VECTOR (2 downto 0);
signal lkupFlowIdInternal : STD_LOGIC_VECTOR (7 downto 0);
signal LkupFlowInfoInternal : STD_LOGIC_VECTOR (255 downto 0);
--LKUP ENDS
------------------------------------------------------

------------------------------------------------------
--Processing

--Make different signals
--signal lkupMissInternal : STD_LOGIC;
--signal lkupFlowPrtyInternal : STD_LOGIC_VECTOR (2 downto 0);
--signal lkupFlowIdInternal : STD_LOGIC_VECTOR (7 downto 0);
--signal LkupFlowInfoInternal : STD_LOGIC_VECTOR (255 downto 0);
--Processing ends
------------------------------------------------------

-------------------------
--Temp Signals


signal dout : STD_LOGIC_VECTOR (144 downto 0);
signal rd_en, empty : STD_LOGIC;

signal offsetCounterSig : STD_LOGIC_VECTOR (15 downto 0);
signal currPacketOffsetSig : STD_LOGIC_VECTOR (15 downto 0);
signal currPacketOffsetLengthSig : STD_LOGIC_VECTOR (2 downto 0);
------------------------


begin

----------------------------------------
--Components
LE : lkupExtractor port map
		(	iData => iData,
			trigger => LETrigger,
			output => LEOutput,
			outputValid => LEOutputValid,
			clk => clk,
			fail => LEFail,--This hasn't been addressed yet
			offset => lkupOffset,
			len => lkupLen		
		);
iDataFIFO : DataFIFO
  PORT MAP (
    clk => clk,
    rst => rst,
    din => iDataStored,
    wr_en => iDataRdinternal,
    rd_en => rd_en,
    dout => dout,
    full => ipFIFOfull,
    empty => empty
  );

--------------------------------------------------
--OUTPUTS
iDataRd <= iDataRdinternal;
lkupData <= LEOutput;
--------------------------------------------------
--Signals
EOP <= iDataRdinternal and not(iData(143) and iData(134) and iData(125) and iData(116) and iData(107) and iData(98) and iData(89) and iData(80) and iData(71) and iData(62) and iData(53) and iData(44) and iData(35) and iData(26) and iData(17) and iData(8));
iDataStored <= EOP & iData;


input:process(clk)

variable offsetCounter : integer range 0 to 65535;
variable currPacketOffset : integer range 0 to 65535;
variable currPacketOffsetLength : integer range 0 to 7;

begin
if rising_edge(clk) then
	case ipState is
		when waiting =>
			LETrigger <= '0';
			iDataRdinternal <= '0';
			offsetCounter := 0;
		--When iDataAv is = 1, we assume that iOffset, iLength, iInst are valid.
		--Thus, we store these values in the same clock cycle as 
			if ((iDataAv = '1') and not(lkupState = waitingtosend) and ipFIFOfull='0') then 
				ipState <= reading;
				currPacketOffset := to_integer(unsigned(iOffset));
				currPacketOffsetLength := to_integer(unsigned(iLength));
				lkupOffset <= iOffset(3 downto 0);
				lkupLen <= iLength;
			end if;
		when reading =>
			iDataRdinternal <= '1';--rd_en for ip FIFOs
			if ((offsetCounter < currPacketOffset) and (offsetCounter + 16 > currPacketOffset)) then
				LETrigger <= '1';
				--curr vector has required bytes
			else
				LETrigger <= '0';	
			end if;
			offsetCounter := offsetCounter + 16;
			if EOP = '1' then
				--current vector has some dv=0
				ipState <= waiting;
			end if;
	end case;
	
	offsetCounterSig <= STD_LOGIC_VECTOR(to_unsigned(offsetCounter,offsetCounterSig'length));
	currPacketOffsetSig <= STD_LOGIC_VECTOR(to_unsigned(currPacketOffset,currPacketOffsetSig'length));
	currPacketOffsetLengthSig <= STD_LOGIC_VECTOR(to_unsigned(currPacketOffsetLength,currPacketOffsetLengthSig'length));
end if;
end process;

lkup:process(clk)
begin
if rising_edge(clk) then
	case lkupState is
		when waiting =>
			if LEOutputValid='1' then
				lkupDataValid <= '1';
				lkupState <= lkupSent;
			end if;
		when lkupsent =>
			lkupDataValid <= '0';
			if LEOutputValid='1' and lkupFlowInfoValid='0' then
				lkupState <= waitingToSend;
			elsif LEOutputValid='0' and lkupFlowInfoValid='1' then
				lkupState <= waiting;
				lkupMissInternal <= lkupMiss;
				lkupFlowPrtyInternal <= lkupFlowPrty;
				lkupFlowIdInternal <= lkupFlowId;
				LkupFlowInfoInternal <= LkupFlowInfo;
			elsif LEOutputValid='1' and lkupFlowInfoValid='1' then
				lkupMissInternal <= lkupMiss;
				lkupFlowPrtyInternal <= lkupFlowPrty;
				lkupFlowIdInternal <= lkupFlowId;
				LkupFlowInfoInternal <= LkupFlowInfo;
				lkupDataValid <= '1';
			end if;
		when waitingToSend =>
			if lkupFlowInfoValid='1' then
				lkupMissInternal <= lkupMiss;
				lkupFlowPrtyInternal <= lkupFlowPrty;
				lkupFlowIdInternal <= lkupFlowId;
				LkupFlowInfoInternal <= LkupFlowInfo;
				lkupDataValid <= '1';
				lkupState <= lkupSent;
			end if;
	end case;
end if;
end process;


end Behavioral;

-----------------------------------------------------------
--NOTES
--One lkup data register
--If it is not empty, that means we are waiting for previous lkup and next packet lkup is stored. 
--can't accept anymore packets