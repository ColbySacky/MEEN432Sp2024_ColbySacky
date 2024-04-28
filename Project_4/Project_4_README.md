# Updated Statement: Read Me
I made the changes you suggested excluding organization. While I understand it looks better, combining everything and reconnecting everything is something I will save for the end once my code fully works. Right now to run my code, simply run "P4init" and then "P4_runsim". You will see that it completes 11 laps and does not violate the braking criteria. The main problem is the SOC conditions. While this could be from my regenerative breaking or velocity controller module, I believe that it may have to do with how my battery currently works. Any advice on how to keep the SOC within 10-95% would be greatly appreciated. Thank you for your help! (P.S. Out of curiosity, what would my grade be if I can't fix this problem?)

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
