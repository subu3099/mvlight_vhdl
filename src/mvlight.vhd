-- Engineer: SUBARNA
-- Create Date: 06/16/2025 12:00:40 AM
-- Module Name: mwilight - Behavioral
-- Description: Moving light on LEDs, pattern load
-- and directions via push buttons:
--     btnd ='1' => Load pattern from switch
--     btnl ='1' => Rotate pattern left
--     btnr ='1' => Rotate pattern right
--     btnc ='1' => Stop rotation
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity mvlight is
    Port ( clk : in STD_LOGIC;
           btnd : in STD_LOGIC;
           btnl : in STD_LOGIC;
           btnc : in STD_LOGIC;
           btnr : in STD_LOGIC;
           swswitch : in STD_LOGIC_VECTOR (7 downto 0);
           zled : out STD_LOGIC_VECTOR (7 downto 0));
end mvlight;

ARCHITECTURE Behavioral OF mvlight IS
    SIGNAL rot_left : STD_LOGIC := '0';
    SIGNAL rot_right : STD_LOGIC := '0';
    SIGNAL led_reg : STD_LOGIC_VECTOR(7 DOWNTO 0) := x"03";

    -- for simulation
    CONSTANT MAX_COUNT : INTEGER := 2;

    -- for hardware
    -- CONSTANT MAX_COUNT : INTEGER := 16666666;
    SUBTYPE Counter_type IS INTEGER RANGE 0 TO MAX_COUNT;
    SIGNAL pulse_rot : STD_LOGIC;

BEGIN
     zled <= led_reg;

    timer_p: PROCESS(clk)
        VARIABLE cnt: Counter_type := MAX_COUNT;
    BEGIN
        IF RISING_EDGE(clk) THEN
            pulse_rot <= '0';
            IF cnt = 0 THEN
                pulse_rot <= '1';
                cnt := MAX_COUNT;
            ELSE
                cnt := cnt-1;
            END IF;
        END IF;
    END PROCESS timer_p;

    oplogic: PROCESS(clk)
    BEGIN
        IF RISING_EDGE(clk) THEN
            IF btnc = '1' THEN
                rot_left <= '0';
                rot_right <= '0';
            ELSIF btnl = '1' THEN
                rot_left <= '1';
                rot_right <= '0';
            ELSIF btnr = '1' THEN
                rot_left <= '0';
                rot_right <= '1';
            END IF;
        END IF;
    END PROCESS oplogic;

    rot_p: PROCESS(clk)
    BEGIN
        IF RISING_EDGE(clk) THEN
            IF btnd = '1' THEN
                led_reg <= swswitch;
            ELSIF pulse_rot = '1' THEN
                IF rot_left = '1' THEN
                    led_reg <= led_reg(6 DOWNTO 0) & led_reg(7);
                ELSIF rot_right = '1' THEN
                    led_reg <= led_reg(0) & led_reg(7 DOWNTO 1);
                END IF;
            END IF;
        END IF;
    END PROCESS rot_p;

END Behavioral;
