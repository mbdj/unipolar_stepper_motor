--  with Ada.Real_Time; use Ada.Real_Time;
with STM32.GPIO; use STM32.GPIO;
with STM32.Device; use STM32.Device;

with Unipolar_Stepper_Motor_Package; use Unipolar_Stepper_Motor_Package;

package body Stepper_Motor is

   Moteur : Unipolar_Stepper_Motor;

   task body Motor_Task is

   begin

      Moteur.Initialize (IN1 => STM32.Device.PA0,
                         IN2 => STM32.Device.PA1,
                         IN3 => STM32.Device.PA2,
                         IN4 => STM32.Device.PA3);

      loop
         Moteur.Step (Number_Of_Steps => 2048,
                      Direction      => Clockwise);

         Moteur.Step (Number_Of_Steps => 2048,
                      Direction      => Anti_Clockwise);

         Moteur.Step_Angle (Angle => 90.0);
         Moteur.Step_Angle (Angle => 180.0, Direction => Anti_Clockwise);

         Moteur.Step_Angle (Angle => 360.0, Step_Type => Half_Step);
         Moteur.Step_Angle (Angle => 180.0,  Step_Type => Half_Step, Direction => Anti_Clockwise);

      end loop;
   end Motor_Task;

end Stepper_Motor;
