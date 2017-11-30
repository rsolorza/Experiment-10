----------------------------------------------------------------------------------
-- Company: Ratner Engineering
-- Engineer: James Ratner
-- 
-- Create Date: 09/04/2017 02:30:45 PM
-- Design Name: 
-- Module Name: db_os - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: This is a combination of the debounce and one-shot models. 
--      See the individual models for more details. 
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


entity db_os is
    Port(        clk    : in std_logic;
                 sig_in : in std_logic;
          pos_pulse_out : out std_logic;
          neg_pulse_out : out std_logic);
end db_os;

architecture Behavioral of db_os is

    component DBounce 
        Port( clk    : in std_logic;
              sig_in : in std_logic;
              DB_out : out std_logic);
    end component;
    
    component one_shot_bdir 
        Port(        clk    : in std_logic;
                     sig_in : in std_logic;
              pos_pulse_out : out std_logic;
              neg_pulse_out : out std_logic);
    end component;

   signal s_db_out : std_logic := '0'; 
   
begin

   my_db: DBounce
   port map ( clk => clk, 
            sig_in => sig_in, 
            DB_out => s_db_out); 
            
   my_os: one_shot_bdir
   port map ( clk => clk, 
            sig_in => s_db_out, 
            pos_pulse_out => pos_pulse_out,
            neg_pulse_out => neg_pulse_out ); 

end Behavioral;





library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity DBounce is
    Port( clk    : in std_logic;
          sig_in : in std_logic;
          DB_out : out std_logic);
end DBounce;

architecture arch of DBounce is

    -- determines length of signal stabilization time
    constant N      : integer := 3;   -- 2^20 * 1/(33MHz) = 32ms
    
    signal q_reg    : unsigned(N-1 downto 0);
    signal r_dff1   : std_logic := '0';
    signal r_dff2   : std_logic := '0';
    signal s_reset  : std_logic := '0';
    signal s_cnt_en : std_logic := '0';
    signal s_db_out : std_logic := '0'; 
    
begin

    -- Counter Register
    process(clk, q_reg, s_reset)
    begin
       if (s_reset = '1') then 
          q_reg <= (others => '0');  
       elsif(rising_edge(clk)) then
          if (s_cnt_en = '1') then 
             q_reg <= q_reg + 1;
          end if;  
       end if;
    end process;

    -- Input Flip Flops 
    process(clk, sig_in)
    begin
        if (rising_edge(clk)) then
           r_dff1 <= sig_in;
           r_dff2 <= r_dff1;
        end if;
    end process;
    
    -- counter reset control (restarts count)
    s_reset <= r_dff1 xor r_dff2;  
    
    -- MSB of count used as FF load enable and counter enable
    s_cnt_en <= not(q_reg(N-1));     

    -- Output flip-flop definition
    process(clk, q_reg, s_DB_out)
    begin
        if(rising_edge(clk)) then
            if (q_reg(N-1) = '1') then
                s_db_out <= r_dff2;
            end if;
        end if;
    end process;
    
    DB_OUT <= s_db_out; 
    
end arch;





library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity one_shot_bdir is
    Port( clk    : in std_logic;
          sig_in : in std_logic;
          pos_pulse_out : out std_logic;
          neg_pulse_out : out std_logic);
end one_shot_bdir;

architecture arch of one_shot_bdir is

    -- flip flop declarations
    signal r_dff1   : std_logic := '0';
    signal r_dff2   : std_logic := '0';
    signal r_dff3   : std_logic := '0';
    signal r_dff4   : std_logic := '0';
    signal r_dff5   : std_logic := '0';
    signal r_dff6   : std_logic := '0';
    
    signal s_ret_in : std_logic := '0';
    signal s_fet_in : std_logic := '0';
    signal s_sig_change : std_logic := '0';
    
begin

    -- Input Flip Flops 
    process(clk, sig_in)
    begin
        if (rising_edge(clk)) then
           r_dff1 <= sig_in;
           r_dff2 <= r_dff1;
        end if;
    end process;

    -- positive pulse out  
    process(clk, s_ret_in)
    begin
        if (rising_edge(clk)) then
           r_dff3 <= s_ret_in;
           r_dff4 <= r_dff3;
        end if;
    end process;

    -- negative pulse out  
    process(clk, s_fet_in)
    begin
        if (rising_edge(clk)) then
           r_dff5 <= s_fet_in;
           r_dff6 <= r_dff5;
        end if;
    end process;

    -- signal change detector
    s_sig_change <= r_dff1 xor r_dff2; 

    s_ret_in <= r_dff1 and s_sig_change; 
    s_fet_in <= r_dff2 and s_sig_change; 
    
    pos_pulse_out <= r_dff3 or r_dff4; 
    neg_pulse_out <= r_dff5 nor r_dff6; 


end architecture arch;
