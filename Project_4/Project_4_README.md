# Updated Statement: Read Me
I made the changes you suggested, to run my code, simply run "P4init" and then "P4_runsim". You will see that it completes 11 laps and does not violate the braking or SOC requirements. Thank you for all of your help!


# **UPDATED** Project 4 Review Request

## Battery Model
1) I see why you are experiencing problems with the SOC, so remember that one of the requirements for this project is that the SOC
must start at 80%. In order to do this, you need to think of the SOC equation:
- SOC = 1 - (integral Icell/C)
So if we want our vehicle to start at 80% we need to change the 1 to a 0.8

2) Also, another thing I just want to mention is that the OCV ToWorkspace block should be connected to the output of the lookup table
as this will save the OCV of the battery for each simulation time.

## Driver Model
1) The main issue with the SOC problem is that you are not recharging at all when your vehicle brakes meaning that the throttle and brake cmd logic might have issues

2) Looking at the logic that calculates APP and BPP I think I found the main issues. While you are calculating the regen percentage, you are not utilizing it in your logic. 
- Looking at specifically the calculateAPPandBpp() fcn there is no need to check if the brakeCmd is > 0 because it never will be since you used a saturation block to limit
brakeCmd between 0 and -1. 
- Instead you should just have the following logic in that function: 
-- APP = accelCmd + brakeCmd*regen
-- BPP = brakeCmd * (1 - regen)
- Doing so allows the regen portion of the brakes to be added to the throttle command and the rest is passed as friction brakes in the brake command.

After making changes I still noticed that the vehicle was not producing any regen, so I decided to take a look at the APP and BPP signals and noticed that BPP was 0 for the entire simulation, meaning that the vehicle is not braking so it is never changing speed which made me take a look at the desirvd velocity

## Velocity Control Block
I put a scope on the desired velocity and noticed that the desired velocity was not changing from the straightaway to the curved sections this is why the vehicle is never braking while it goes around the track and why you have no regen in the SOC chart
I'm assuming that there are issues with the way you are deciding where the vehicle is on the track so make sure to go back to look at this logic


FYI you can go faster on the straightaways than the curved sections so don't be afraid to play around with the speeds of the vehicle so that you can go around the track as fast as possible in an hour under the contraints given

## Regarding your last question
While I can't give you a definite answer on what your grade would be if you just submitted what you have now, I can say that you would get points take off for:
1) Not meeting the SOC requirements
2) The wrong logic used in the regen calculations

So obviously it wouldn't be many points since your vehicle is still able to simulate properly and you are able to stay within the track but I hope you're able to finish this last project off strong!
So hopefully with the help I provide you are able to make the changes and get your vehicle to go around the track as fast as it can!

