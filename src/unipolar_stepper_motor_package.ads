--
--  Mehdi
--  03/05/2023
--
--  Driver for an unipolar stepper motor with 4 phases (ex : 28BYJ-48 connected through an ULN2003)
--

with STM32.GPIO;

package Unipolar_Stepper_Motor_Package is

   type Unipolar_Stepper_Motor is tagged limited private;
   type Type_Direction is (Clockwise, Anti_Clockwise);
   type Type_Step is (Step, Half_Step);  -- half step = more torque but half the speed

   procedure Initialize (Motor              : in out Unipolar_Stepper_Motor;
                         --  IN1 .. IN4 : connection to the driver (ULN2003)
                         IN1, IN2, IN3, IN4 : in STM32.GPIO.GPIO_Point;
                         Span_Delay      : Standard.Duration := 0.001);  --  nb : Span_Delay : delay of signal application
                                                                         --  elsewhere the motor can't rotate

   ----------
   -- Step --
   ----------
   --  rotation of one step
   procedure Step (Motor           : in out Unipolar_Stepper_Motor;
                   Direction       : in Type_Direction := Clockwise;
                   Step_Type       : in Type_Step := Step);

   --  rotation of multiple steps
   procedure Step (Motor            : in out Unipolar_Stepper_Motor;
                   Number_Of_Steps  : in Positive;
                   Direction        : in Type_Direction := Clockwise;
                   Step_Type        : in Type_Step := Step);

   --  rotation of an angle in degree
   type Degrees is digits 5 range 0.0 .. 360.0;
   procedure Step_Angle (Motor                             : in out Unipolar_Stepper_Motor;
                         Angle                             : in Degrees ;
                         Steps_Per_Revolution              : in Positive := 2048 ;  --  for 28BYJ-48 in step (not in half step)
                         Direction                         : in Type_Direction := Clockwise;
                         Step_Type                         : in Type_Step := Step);


private
   --  motor with 4 phases : 4 steps (odd numbers 1,3,5,7) or 8 half steps (1 to 8)
   type Coil_Position_Type is new Integer range 1 .. 8;

   type Unipolar_Stepper_Motor is tagged limited
      record
         Coil_Position      : Coil_Position_Type := 1;
         IN1, IN2, IN3, IN4 : STM32.GPIO.GPIO_Point;
         Span_Delay         : Standard.Duration := 0.001;
      end record;

end Unipolar_Stepper_Motor_Package;
