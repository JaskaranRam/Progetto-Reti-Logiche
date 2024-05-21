----------------------------------------------------------------------------------
-- 
-- Engineer: Jaskaran Ram & Lorenzo Reitani
-- Create Date: 24.04.2023 11:35:24
-- Module Name: project_reti_logiche - Behavioral
-- Project Name: Progetto di Reti Logiche 
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity project_reti_logiche is
    port (
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_start : in std_logic;
        i_w : in std_logic;
        o_z0 : out std_logic_vector(7 downto 0);
        o_z1 : out std_logic_vector(7 downto 0);
        o_z2 : out std_logic_vector(7 downto 0);
        o_z3 : out std_logic_vector(7 downto 0);
        o_done : out std_logic;
        o_mem_addr : out std_logic_vector(15 downto 0);
        i_mem_data : in std_logic_vector(7 downto 0);
        o_mem_we : out std_logic;
        o_mem_en : out std_logic
    );
end project_reti_logiche;

library ieee;
use ieee.std_logic_1164.all;

entity registro is
    port(
        input : in std_logic_vector(7 downto 0);
        load : in std_logic;
        done : in std_logic;
        clock : in std_logic;
        reset : in std_logic;
        output : out std_logic_vector(7 downto 0)
    );
end entity registro;

architecture Behavioral of registro is
    signal memory : std_logic_vector(7 downto 0);
begin
    process(clock, reset)
    begin
        if (reset = '1') then
            memory <= (others => '0');
        elsif rising_edge(clock) then
            if (load = '1') then
                memory <= input;
            end if;
        end if;
    end process;

    output <= (others => '0') when (done = '0') else memory;
end architecture Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ShiftRegister is
    generic(
        N : integer -- numero di bit dell'output
    );
    port(
        clk : in std_logic;       -- segnale di clock
        rst : in std_logic;       -- segnale di reset
        in_data : in std_logic;   -- segnale di input
        load : in std_logic;      -- segnale di load
        out_data : out std_logic_vector(N-2 downto 0);   -- segnale di output
        refresh : in std_logic
    );
end entity ShiftRegister;

architecture Behavioral of ShiftRegister is
begin
    process(clk, rst )
        variable shift_reg : std_logic_vector(N-1 downto 0) := (others => '0');
    begin
        if rst = '1' or refresh = '1' then
            shift_reg := (others => '0');  -- reset
        elsif rising_edge(clk) then
            if load = '1' then  -- caricamento nel registro solo se il segnale di load è alto       
                for i in N-1 downto 1 loop  -- shift
                    shift_reg(i) := shift_reg(i-1);
                end loop;
                shift_reg(0) := in_data;  -- input nel primo bit
            end if;
        end if;
        out_data <= shift_reg(N-1 downto 1);  -- output
    end process;
end architecture Behavioral;

 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity r_z_selector is
  port (
    go : in std_logic;
    in_signal : in std_logic;
    input : in std_logic_vector(1 downto 0);
    r_z0_load, r_z1_load, r_z2_load, r_z3_load : out std_logic
  );
end entity r_z_selector;

architecture Behavioral of r_z_selector is
begin
  r_z0_load <= in_signal when input = "00" and go = '1' else '0';
  r_z1_load <= in_signal when input = "01" and go = '1' else '0';
  r_z2_load <= in_signal when input = "10" and go = '1' else '0';
  r_z3_load <= in_signal when input = "11" and go = '1' else '0';
end architecture Behavioral;


architecture Behavioral of project_reti_logiche is
    
    component r_z_selector is
        port (
             go : in std_logic;
             in_signal : in std_logic;
             input : in std_logic_vector(1 downto 0);
             r_z0_load, r_z1_load, r_z2_load, r_z3_load : out std_logic
        );
    end component;
    
    component ShiftRegister is
    generic(
        N : integer   -- numero di bit dell'output
    );
    port(
        clk : in std_logic;       -- segnale di clock
        rst : in std_logic;       -- segnale di reset
        in_data : in std_logic;   -- segnale di input
        load : in std_logic;      -- segnale di load
        out_data : out std_logic_vector(N-2 downto 0);   -- segnale di output
        refresh : in std_logic
    );
    end component ShiftRegister;
    
    component registro is
    port(
        input : in std_logic_vector(7 downto 0);
        load : in std_logic;
        done : in std_logic;
        clock : in std_logic;
        reset : in std_logic;
        output : out std_logic_vector(7 downto 0)
    );
    end component;
    
    signal r_selector_load : std_logic;
    signal r_indirizzo_load : std_logic;
    signal selector : std_logic_vector (1 downto 0);
    signal r_z0_load : std_logic;
    signal r_z1_load : std_logic;
    signal r_z2_load : std_logic;
    signal r_z3_load : std_logic;
    signal done: std_logic;
    signal go: std_logic;
    
    type S is (S0,S1,S2,S3,S4,S5,S6);
    signal cur_state, next_state : S;
    
begin
    r_intestazione : ShiftRegister
    generic map (N =>3)
    port map (clk => i_clk, rst =>i_rst, in_data => i_w, load => r_selector_load, out_data =>selector, refresh =>done);
    
    r_indirizzo : ShiftRegister
    generic map (N=>17)
    port map (clk => i_clk, rst =>i_rst, in_data => i_w, load => r_indirizzo_load, out_data =>o_mem_addr, refresh => done);
    
    r_z0 : registro 
    port map(input => i_mem_data, load => r_z0_load, done => done, clock => i_clk, reset => i_rst, output => o_z0);
    r_z1 : registro 
    port map(input => i_mem_data, load => r_z1_load, done => done, clock => i_clk, reset => i_rst, output => o_z1);
    r_z2 : registro 
    port map(input => i_mem_data, load => r_z2_load, done => done, clock => i_clk, reset => i_rst, output => o_z2);
    r_z3 : registro 
    port map(input => i_mem_data, load => r_z3_load, done => done, clock => i_clk, reset => i_rst, output => o_z3);
    
    demultiplexer : r_z_selector
    port map(go => go, in_signal => '1' ,input => selector, r_z0_load => r_z0_load, r_z1_load => r_z1_load, r_z2_load => r_z2_load, r_z3_load => r_z3_load);

    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            cur_state <= S0;
            
        elsif i_clk'event and i_clk = '1' then
            cur_state <= next_state;
        end if;
    end process;
    
    process(cur_state, i_start)
    begin
        next_state <= cur_state;
        case cur_state is 
            when S0 =>
                if i_start = '1' then
                    next_state <= S1;
                else 
                    next_state <= S0;
                end if;
            when S1 =>
                next_state <= S2;
            when S2 =>
                if i_start = '0' then
                    next_state <= S4;
                else 
                    next_state <= S3;
                end if;
            when S3 =>
                if i_start = '0' then
                    next_state <= S4;
                else
                    next_state <= S3;
                end if;
            when S4 =>
                next_state <= S5;
            when S5 =>
                next_state <= S6;
            when S6 =>
                next_state <= S0;
        end case;
    end process;
    
    o_done <= done;
    o_mem_we <= '0';
    o_mem_en <= '1';
    
    process(cur_state)
    begin
        
        case cur_state is
            when S0 => 
                r_selector_load <= '1';
                r_indirizzo_load <= '0';
                done <= '0';
                go <= '0';
            when S1 => 
                r_selector_load <= '1';
                r_indirizzo_load <= '0';
                done <= '0';
                go <= '0';
            when S2 =>
                r_selector_load <= '1';
                r_indirizzo_load <= '1';
                done <= '0';
                go <= '0';   
            when S3 =>
                r_selector_load <= '0';
                r_indirizzo_load <= '1';
                done <= '0';
                go <= '0';
            when S4 =>
                r_selector_load <= '0';
                r_indirizzo_load <= '0';
                done <= '0';
                go <= '1';
            when S5 =>
                r_selector_load <= '0';
                r_indirizzo_load <= '0';
                done <= '0';
                go <= '1';
            when S6 =>
                r_selector_load <= '0';
                r_indirizzo_load <= '0';
                done <= '1';
                go <= '0';
         end case;
     end process;
    
end Behavioral;