// DiDiR2 robot
// Direct Drive Robot 2
// github.com/didir2
// Author: Mihai Oltean
// https://mihaioltean.github.io, mihai.oltean@gmail.com
// License: MIT
//-------------------------------------------------------------------
wheel_radius = 250;
wheel_internal_radius = 230;
wheel_thick = 30;

wheel_motor_radius = 125;
wheel_motor_thick = 60;
wheel_motor_shaft_length = 100;
wheel_motor_shaft_radius = 12;

distance_between_wheels = 580;
distance_to_balance_motor = 150; 
distance_to_arm_motor1 = distance_between_wheels / 2 - 50; 
distance_between_arm_motors = 100; 

arm_bone_thick = 20;
arm_bone_depth = 50;
arm_length = 400;

arm_angle_between_arms = 70;
arm_angle2 = 80;
balance_weight_angle = 130;

//-------------------------------------------------------------------
module motor_hub()
{
    color("black")
    cylinder(h = wheel_motor_thick, r = wheel_motor_radius, center = true);
    cylinder(h = wheel_motor_shaft_length, r = wheel_motor_shaft_radius, center = true);
}
//-------------------------------------------------------------------
module wheel()
{
    difference(){
        color("LightSteelBlue") cylinder(r = wheel_radius, h = wheel_thick, center = true);
        cylinder(r = wheel_internal_radius, h = wheel_thick + 2, center = true);
    }
}
//-------------------------------------------------------------------
module wheel_with_motor()
{
    wheel();
    motor_hub();
}
//-------------------------------------------------------------------
module balance_motor()
{
    motor_hub();
    balance_weight_arm_length = wheel_motor_radius + 50;
    
    // weighted arm
     rotate([0, 0, balance_weight_angle]){
        rotate([-90, 0, 0]){
                cylinder(h = balance_weight_arm_length, r = arm_bone_thick);
                translate ([0, 0, balance_weight_arm_length])
                cylinder (r = 50, h= 50);
        }
    }
}
//-------------------------------------------------------------------
module ddr_arm()
{
    // arm motor 1
    motor_hub();
            
    // arm motor 2   
    translate([0, 0, distance_between_arm_motors])
            motor_hub()
            ;
            
            // arm1
     translate([0, 0, wheel_motor_thick / 2]){
        rotate([-90, 0, 0])
            cylinder(h = arm_length, r = arm_bone_thick)
            ;
// 2nd segment
            translate([0, arm_length, 0])
            rotate([0, 0, arm_angle_between_arms])
        rotate([-90, 0, 0])
                cylinder(h = arm_length, r = arm_bone_thick)
                ;
       }
     
     // arm2
     translate([0, 0, distance_between_arm_motors - wheel_motor_thick / 2]){
        rotate([0, 0, arm_angle_between_arms]){
            rotate([-90, 0, 0])
                translate([0, 0, arm_bone_thick])
                    cylinder(h = arm_length, r = arm_bone_thick);
         }
// 2nd segment

          translate([-arm_length * sin(arm_angle_between_arms), arm_length * cos(arm_angle_between_arms), 0])
            rotate([-90, 0, 0])
                translate([0, 0, arm_bone_thick])
                  cylinder(h = arm_length, r = arm_bone_thick);
     }
     // connection in the front
     translate([0, arm_length, 0])
     translate([-arm_length * sin(arm_angle_between_arms), arm_length * cos(arm_angle_between_arms), 0])
     cylinder(h = 100, r = 40);
}
//-------------------------------------------------------------------
module DiDiR2()
{
// one wheel
    rotate([90, 0, 0]) 
        wheel_with_motor();
        // the other wheel
    translate([0, distance_between_wheels, 0])
        rotate([90, 0, 0])
            wheel_with_motor();
    // shaft
    rotate([-90, 0, 0]) 
        cylinder (h = distance_between_wheels, r= 8);
    
    // motor for balance
    translate([0, distance_to_balance_motor, 0])
        rotate([-90, 0, 0])
            balance_motor()
            ;
            
    translate([0, distance_to_arm_motor1, 0])
            rotate([-90, 0, 0])
            rotate([0, 0, arm_angle2])
                ddr_arm()
                ;
}
//----------------------------------------------------------------
DiDiR2();

//ddr_arm();
//balance_motor();