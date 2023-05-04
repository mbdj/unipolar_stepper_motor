--
--  Mehdi
--
--  04/05/2023
--
--  moteur pas � pas (step motor)
--  moteur unipolaire 28BYJ-48 5V connect� sur un driver ULN2003
--  moteur pas � pas : voir https://zestedesavoir.com/tutoriels/686/arduino-premiers-pas-en-informatique-embarquee/747_le-mouvement-grace-aux-moteurs/3439_a-petits-pas-le-moteur-pas-a-pas/
--  voir aussi https://www.youtube.com/watch?v=QEoW3KhXKh4
--

-- pour fixer une priorit� haute � la task qui fait tourner le moteur
pragma Task_Dispatching_Policy (FIFO_Within_Priorities);

with Last_Chance_Handler;
pragma Unreferenced (Last_Chance_Handler);
--  The "last chance handler" is the user-defined routine that is called when
--  an exception is propagated. We need it in the executable, therefore it
--  must be somewhere in the closure of the context clauses.

with Ada.Real_Time; use Ada.Real_Time;
with STM32.Board;


with Stepper_Motor;
pragma Unreferenced (Stepper_Motor);

procedure Motor is
--  pour la boucle
   Period       : constant Ada.Real_Time.Time_Span := Ada.Real_Time.Milliseconds (200);
   Next_Release : Ada.Real_Time.Time := Ada.Real_Time.Clock;

begin
   --  initialiser les led utilisateur
   STM32.Board.Initialize_LEDs;

   loop
      -- clignote en violet (sur la board perso c'est une led RGB)
      STM32.Board.Toggle (STM32.Board.Red_LED);
      STM32.Board.Toggle (STM32.Board.Blue_LED);

      Next_Release := Next_Release + Period;
      delay until Next_Release;

   end loop;

end Motor;
