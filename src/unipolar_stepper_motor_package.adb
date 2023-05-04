with STM32.Device;

with STM32.GPIO; use STM32.GPIO;

package body Unipolar_Stepper_Motor_Package is


   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (Motor              : in out Unipolar_Stepper_Motor;
                         IN1, IN2, IN3, IN4 : in STM32.GPIO.GPIO_Point) is

      All_Pin_Motor : constant STM32.GPIO.GPIO_Points := [IN1, IN2, IN3, IN4];

   begin
      Motor.IN1 := IN1;
      Motor.IN2 := IN2;
      Motor.IN3 := IN3;
      Motor.IN4 := IN4;

      STM32.Device.Enable_Clock (All_Pin_Motor);

      STM32.GPIO.Configure_IO
        (Points            => All_Pin_Motor,
         Config            => (Mode_Out,
                               Resistors   => Pull_Down,
                               Output_Type => Push_Pull,
                               Speed       => Speed_100MHz));

   end Initialize;


   ----------
   -- Step --
   ----------

   procedure Step (Motor            : in out Unipolar_Stepper_Motor;
                   Direction        : in Type_Direction := Clockwise;
                   Step_Type        : in Type_Step := Step;
                   Span_Delay       : Standard.Duration := 0.001) is

   begin

      --  moteur pas à pas unipolaire
      --  pour le faire tourner il suffit d'envoyer un signal à tour de rôle sur les pin IN1 à IN4

      case Motor.Coil_Position is

      --  step

      when 1 =>
         STM32.GPIO.Set (Motor.IN1);
         STM32.GPIO.Clear (Motor.IN2);
         STM32.GPIO.Clear (Motor.IN3);
         STM32.GPIO.Clear (Motor.IN4);
         Motor.Coil_Position := (if Direction = Clockwise then (if Step_Type = Step then 3 else 2)
                                 else (if Step_Type = Step then 7 else 8));
         delay (Span_Delay);

         --  half step
         when 2 =>
            STM32.GPIO.Set (Motor.IN1);
            STM32.GPIO.Set (Motor.IN2);
            STM32.GPIO.Clear (Motor.IN3);
            STM32.GPIO.Clear (Motor.IN4);
            Motor.Coil_Position := (if Direction = Clockwise then 3 else 1);
            delay (Span_Delay);

            --  step
         when 3 =>
            STM32.GPIO.Clear (Motor.IN1);
            STM32.GPIO.Set (Motor.IN2);
            STM32.GPIO.Clear (Motor.IN3);
            STM32.GPIO.Clear (Motor.IN4);
            Motor.Coil_Position := (if Direction = Clockwise then (if Step_Type = Step then 5 else 4)
                                    else (if Step_Type = Step then 1 else 2));
            delay (Span_Delay);

            --  half step
         when 4 =>
            STM32.GPIO.Clear (Motor.IN1);
            STM32.GPIO.Set (Motor.IN2);
            STM32.GPIO.Set (Motor.IN3);
            STM32.GPIO.Clear (Motor.IN4);
            Motor.Coil_Position := (if Direction = Clockwise then 5 else 3);
            delay (Span_Delay);

            --  step
         when 5 =>
            STM32.GPIO.Clear (Motor.IN1);
            STM32.GPIO.Clear (Motor.IN2);
            STM32.GPIO.Set (Motor.IN3);
            STM32.GPIO.Clear (Motor.IN4);
            Motor.Coil_Position := (if Direction = Clockwise then (if Step_Type = Step then 7 else 6)
                                    else (if Step_Type = Step then 3 else 4));
            delay (Span_Delay);

            --  half step
         when 6 =>
            STM32.GPIO.Clear (Motor.IN1);
            STM32.GPIO.Clear (Motor.IN2);
            STM32.GPIO.Set (Motor.IN3);
            STM32.GPIO.Set (Motor.IN4);
            Motor.Coil_Position := (if Direction = Clockwise then 7 else 5);
            delay (Span_Delay);

            --  step
         when 7 =>
            STM32.GPIO.Clear (Motor.IN1);
            STM32.GPIO.Clear (Motor.IN2);
            STM32.GPIO.Clear (Motor.IN3);
            STM32.GPIO.Set (Motor.IN4);
            Motor.Coil_Position := (if Direction = Clockwise then (if Step_Type = Step then 1 else 8)
                                    else (if Step_Type = Step then 5 else 6));
            delay (Span_Delay);

            --  half step
         when 8 =>
            STM32.GPIO.Set (Motor.IN1);
            STM32.GPIO.Clear (Motor.IN2);
            STM32.GPIO.Clear (Motor.IN3);
            STM32.GPIO.Set (Motor.IN4);
            Motor.Coil_Position := (if Direction = Clockwise then 1 else 7);
            delay (Span_Delay);

      end case;

   end Step;




   procedure Step (Motor                : in out Unipolar_Stepper_Motor;
                   Number_Of_Steps      : in Positive;
                   Direction            : in Type_Direction := Clockwise;
                   Step_Type            : in Type_Step := Step;
                   Span_Delay           : Standard.Duration := 0.001) is -- delay between each step to determine the speed

   begin
      for Index in 1 .. Number_Of_Steps loop
         Motor.Step (Direction, Step_Type, Span_Delay);
      end loop;
   end;

   procedure Step_Angle (Motor                : in out Unipolar_Stepper_Motor;
                         Angle                : in Degrees ;
                         Steps_Per_Revolution : in Positive := 2048 ;  --  for 28BYJ-48 in step (not in half step)
                         Direction            : in Type_Direction := Clockwise;
                         Step_Type            : in Type_Step := Step;
                         Span_Delay           : Standard.Duration := 0.001) is -- delay between each step to determine the speed

   begin

      Motor.Step (Number_Of_Steps => Positive ( Float (Steps_Per_Revolution * (if Step_Type = Step then 1 else 2)) * Float (Angle) / 360.0),
                  Direction      => Direction,
                  Step_Type      => Step_Type,
                  Span_Delay     => Span_Delay);
   end;

end Unipolar_Stepper_Motor_Package;
