library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity divisor_3 is
    port(
        clk         : in  std_logic;
        ena         : in  std_logic;  -- reset asíncrono (activo en '0')
        f_div_2_5   : out std_logic;  -- salida de 2.5MHz (100MHz/40)
        f_div_1_25  : out std_logic;  -- salida de 1.25MHz (100MHz/80)
        f_div_500   : out std_logic   -- salida de 500KHz (100MHz/200)
    );
end entity divisor_3;

architecture Behavioral of divisor_3 is
     -- Contador de módulo 4
     signal count40 : unsigned(5 downto 0) := (others => '0');
     -- Contador de módulo 2 (para dividir la señal de 2.5MHz a 1.25MHz)
     signal count2 : unsigned(0 downto 0) := (others => '0');
     -- Contador de módulo 5 (para dividir la señal de 2.5MHz a 500KHz)
     signal count5 : unsigned(2 downto 0) := (others => '0');

     signal pulse_div4 : std_logic := '0';  -- pulso de 1 ciclo a 100MHz, cada vez que el contador de módulo 4 se resetea
     signal pulse_div2 : std_logic := '0';
     signal pulse_div5 : std_logic := '0';
begin
     -- Proceso del contador de módulo 4
     process(clk, ena)
     begin
        if ena = '0' then
            -- Genera un pulso (de 1 ciclo del reloj de 100MHz) cuando count40 = 0
            -- pulse_div4 <= 
            count40 <= (others => '0');
            pulse_div4 <= '1';
             elsif rising_edge(clk) then 
             count40 <= count40 + 1;
             if count40 = "100111" then
                 count40 <= (others => '0');
                 pulse_div4 <= '1';
             else
                 pulse_div4 <= '0';
             end if;
         end if;
     end process;
     
     process(clk, ena)
     begin
        if ena = '0' then
            -- Genera un pulso (de 1 ciclo del reloj de 100MHz) cuando count40 = 0
            -- pulse_div4 <= 
            count5 <= (others => '0');
            pulse_div5 <= '1';
             elsif rising_edge(clk) then 
             count5 <= count5 + 1;
             if count5 = "100" then
                 count5 <= (others => '0');
                 pulse_div5 <= '1';
             else
                 pulse_div5 <= '0';
             end if;
         end if;
     end process;

     -- Procesos para actualizar los contadores secundarios (mod 2 y mod 5)
     process(clk, ena)
     begin
        if ena = '0' then
            count2 <= (others => '0');
            pulse_div2 <= '1';
            
        elsif rising_edge(clk) then 
             count2 <= count2 + 1;
             if count2 = "1" then
                 count2 <= (others => '0');
                 pulse_div2 <= '1';
                 
                 end if;
             else
                pulse_div2 <= '0';
             end if;
     end process;

     -- Asignaciones de salida: cada señal es un pulso de 1 ciclo de reloj
     f_div_2_5  <= pulse_div4;
     f_div_1_25 <= pulse_div2;
     f_div_500  <= pulse_div5;
end Behavioral;