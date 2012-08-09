# This is an experiment to test set-shifting.
This MATLAB script is currently capable of testing intra-dimensional and extra-dimensional set shifting. The ability to test reversal learning will be added in the near future.

# Saved data and data sent to Plexon (with codes)

## Stimuli appearing and disappearing events sent to Plexon

+ 4001 - fixation dot appears	
+ 4002 - fixation dot disappears
+ 4003 - first option appears
+ 4004 - first option disappears
+ 4005 - second option appears
+ 4006 - second option disappears
+ 4007 - third option appears	
+ 4008 - third option disappears
+ 4009 - all options appear
+ 4010 - looking at an option
+ 4011 - looking away from the option just looked at
+ 4012 - an option is selected
+ 4013 - option correct feedback given
+ 4014 - option incorrect feedback given
+ 4015 - all options disappear

## Eye movement events sent to Plexon

+ 4051 - look at fixation dot	
+ 4052 - look away from fixation dot	
+ 4053 - fixation acquired on fixation dot
+ 4061 - looking at option one during first presentation period
+ 4062 - looking away from option one during first presentation period
+ 4063 - looking at option two during first presentation period
+ 4064 - looking away from option two during first presentation period
+ 4065 - looking at option three during first presentation period
+ 4066 - looking away from option three during first presentation period
+ 4071 - looking at option one during choice period
+ 4072 - looking away from option one during choice period
+ 4073 - looking at option two during choice period
+ 4074 - looking away from option two during choice period
+ 4075 - looking at option three during choice period
+ 4076 - looking away from option three during choice period
+ 4081 - fixation acquired on an option

## Data saved to .mat files and sent to Plexon

+ trial number             
+ trial outcome
+ choice made
+ block percent correct
+ total percent correct
+ trial stimuli
+ rewarded or not
+ time allowed to fixate (same for fixation dot and choices)
+ minimum fixation time on fixation dot to initial trial
+ duration fixation must be held on staggered options (recording) or hold dot (behavior)
+ duration that feedback is displayed
+ ITI
+ experiment type (intra-dimensional, extra-dimensional, etc.)
+ session type (staggered or unstaggered stimuli presentation)
+ correct choices until shift occurs
+ total number of shifts that occurred during the session
+ which eye was tracked
+ what colors were used
+ what shapes were used