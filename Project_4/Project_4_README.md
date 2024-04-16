For my project so far. To run it I first run each EPA file, then I run the init and P4 init file. Finally, I run the P4_new_matcode which combines the P4_runsim and the Project 2 run code. Note: Make sure to set the time to 3600 seconds on line 75 (out = sim("Project_4_Simulink_Update.slx", "StopTime", "3600")).
Right now it is set to 500 to make testing quicker.
When you run it at 3600 you will see that it runs and completes 7 laps. However, the SOC doesn't change and the break check fails.
I believe the issues are in the regenerative breaking in the acceleration controls section (Longitudinal model).
If that isn't the problem, it could also be that I may have connected my models wrong.
Any advice would be greatly appreciated. Thank you in advance!


