----------------------------------------------------------------------------------
-- Module Name: mvlight_tb - Behavioral

----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mvlight_tb is
--  Port ( );
end mvlight_tb;

ARCHITECTURE Behavioral OF mvlight_tb IS
    COMPONENT mvlight
        PORT ( clk     : IN  STD_LOGIC;
               btnd    : IN  STD_LOGIC;
               btnl    : IN  STD_LOGIC;
               btnc    : IN  STD_LOGIC;
               btnr    : IN  STD_LOGIC;
               swswitch: IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
               zled    : OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
    END COMPONENT;

    SIGNAL clk     : STD_LOGIC := '0';
    SIGNAL btnd    : STD_LOGIC := '0';
    SIGNAL btnl    : STD_LOGIC := '0';
    SIGNAL btnc    : STD_LOGIC := '0';
    SIGNAL btnr    : STD_LOGIC := '0';
    SIGNAL swswitch: STD_LOGIC_VECTOR (7 DOWNTO 0) := x"d7";
    SIGNAL zled    : STD_LOGIC_VECTOR (7 DOWNTO 0) := x"00";

    CONSTANT clk_period : TIME := 10ns;

BEGIN
    uut: mvlight
        PORT MAP ( clk      => clk,
                   btnd     => btnd,
                   btnl     => btnl,
                   btnc     => btnc,
                   btnr     => btnr,
                   swswitch => swswitch,
                   zled     => zled );

    clk_p : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period / 2;
        clk <= '1';
        WAIT FOR clk_period / 2;
    END PROCESS clk_p;

    stim_p : PROCESS
    BEGIN
        WAIT FOR clk_period;
        btnl <= '1';
        WAIT FOR clk_period;
        btnl <= '0';

        WAIT FOR clk_period * 30;
        btnr <= '1';
        WAIT FOR clk_period;
        btnr <= '0';

        WAIT FOR clk_period * 30;
        btnc <= '1';
        WAIT FOR clk_period;
        btnc <= '0';

        WAIT FOR clk_period * 10;
        btnd <= '1';
        WAIT FOR clk_period;
        btnd <= '0';

        WAIT;
    END PROCESS stim_p;

END Behavioral;