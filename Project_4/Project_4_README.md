For my project so far. To run it I first run each EPA file, then I run the init and P4 init file. Finally, I run the P4_new_matcode which combines the P4_runsim and the Project 2 run code. Note: Make sure to set the time to 3600 seconds on line 75 (out = sim("Project_4_Simulink_Update.slx", "StopTime", "3600")).
Right now it is set to 500 to make testing quicker.
When you run it at 3600 you will see that it runs and completes 7 laps. However, the SOC doesn't change and the break check fails.
I believe the issues are in the regenerative breaking in the acceleration controls section (Longitudinal model).
If that isn't the problem, it could also be that I may have connected my models wrong.
Any advice would be greatly appreciated. Thank you in advance!


# Project 4 Review Request

The first thing I want to mention is that the EPA cycles are not needed for this project! Instead, you should be using the track that was created back in Project 2 and you want 
to go around that track as fast as possible without going off the track for  60 minutes.

## Model Tips
1) I would suggest putting both of the driver models (p2 and p3) into a single subsystem and this will be the main driver model of your project.
- The desired velocity of the driver model should be coming from a modified speed scheduler, where you take in the vehicle's current position on track and depending if the vehicle is on the straightaway or curved section, adjusts the desired velocity of the vehicle.
- The actual velocity should just be the X component of the velocity (velocity from long model)

2) The next thing I would suggest is to put the P2 and P3 models into respective subsystems for lateral and longitudinal dynamic frames. This will help organize your model into the main 4 components
- Driver Model
- Lateral Dynamics Body Frame
- Longitudinal Dynamics Body Frame
- Car Kinematic Frame (Transformation/Rotation in your model)

3) Go back to the Acceleration Control block and review the logic used for the APP, BPP, and regen
- Remember in P3, how we took a small percentage from the BPP cmd and added it to APP, and the rest was passed as friction brake cmd. You are doing a similar thing in this P4 logic, however you need to make sure the regen percentage matches that of what's discussed in the project requirements/constraints

4) The next thing I would say it to go back and review the P3 and P2 feedback and make sure any changes suggested are implemented for this final model

You seem to be on the right track, but there are a few things missing from the driver logic. Address the changes I suggested and submit another request (or set up a zoom meeting with me) and I will go over your model once again.
