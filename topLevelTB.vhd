--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:51:44 04/30/2019
-- Design Name:   
-- Module Name:   /home/onkar/DLDProject/topLevelTB.vhd
-- Project Name:  DLDProject
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: topLevel
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY topLevelTB IS
END topLevelTB;
 
ARCHITECTURE behavior OF topLevelTB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT topLevel
    PORT(
         iDataAv : IN  std_logic;
         iDataRd : OUT  std_logic;
         iData : IN  std_logic_vector(143 downto 0);
         oDataAv : OUT  std_logic;
         oDataRd : IN  std_logic;
         oData : OUT  std_logic_vector(143 downto 0);
         lkupData : OUT  std_logic_vector(127 downto 0);
         lkupDataValid : OUT  std_logic;
         lkupMiss : IN  std_logic;
         lkupFlowPrty : IN  std_logic_vector(2 downto 0);
         lkupFlowId : IN  std_logic_vector(7 downto 0);
         LkupFlowInfo : IN  std_logic_vector(255 downto 0);
         LkupFlowInfoValid : IN  std_logic;
         flowId : IN  std_logic_vector(7 downto 0);
         burstSize : IN  std_logic_vector(15 downto 0);
         flowRate : IN  std_logic_vector(15 downto 0);
         configure : IN  std_logic;
         iOffset : IN  std_logic_vector(15 downto 0);
         iLength : IN  std_logic_vector(2 downto 0);
         iInst : IN  std_logic_vector(7 downto 0);
         oOffset : OUT  std_logic_vector(15 downto 0);
         oLength : OUT  std_logic_vector(2 downto 0);
         oInst : OUT  std_logic_vector(7 downto 0);
         clk : IN  std_logic;
         rst : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal iDataAv : std_logic := '0';
   signal iData : std_logic_vector(143 downto 0) := (others => '0');
   signal oDataRd : std_logic := '0';
   signal lkupMiss : std_logic := '0';
   signal lkupFlowPrty : std_logic_vector(2 downto 0) := (others => '0');
   signal lkupFlowId : std_logic_vector(7 downto 0) := (others => '0');
   signal LkupFlowInfo : std_logic_vector(255 downto 0) := (others => '0');
   signal LkupFlowInfoValid : std_logic := '0';
   signal flowId : std_logic_vector(7 downto 0) := (others => '0');
   signal burstSize : std_logic_vector(15 downto 0) := (others => '0');
   signal flowRate : std_logic_vector(15 downto 0) := (others => '0');
   signal configure : std_logic := '0';
   signal iOffset : std_logic_vector(15 downto 0) := (others => '0');
   signal iLength : std_logic_vector(2 downto 0) := (others => '0');
   signal iInst : std_logic_vector(7 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
   signal iDataRd : std_logic;
   signal oDataAv : std_logic;
   signal oData : std_logic_vector(143 downto 0);
   signal lkupData : std_logic_vector(127 downto 0);
   signal lkupDataValid : std_logic;
   signal oOffset : std_logic_vector(15 downto 0);
   signal oLength : std_logic_vector(2 downto 0);
   signal oInst : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: topLevel PORT MAP (
          iDataAv => iDataAv,
          iDataRd => iDataRd,
          iData => iData,
          oDataAv => oDataAv,
          oDataRd => oDataRd,
          oData => oData,
          lkupData => lkupData,
          lkupDataValid => lkupDataValid,
          lkupMiss => lkupMiss,
          lkupFlowPrty => lkupFlowPrty,
          lkupFlowId => lkupFlowId,
          LkupFlowInfo => LkupFlowInfo,
          LkupFlowInfoValid => LkupFlowInfoValid,
          flowId => flowId,
          burstSize => burstSize,
          flowRate => flowRate,
          configure => configure,
          iOffset => iOffset,
          iLength => iLength,
          iInst => iInst,
          oOffset => oOffset,
          oLength => oLength,
          oInst => oInst,
          clk => clk,
          rst => rst
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*0.5;

      -- insert stimulus here 
		iDataAv <='1';

      wait;
   end process;

END;
