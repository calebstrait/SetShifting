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
+ 4010 - option correct feedback given
+ 4011 - option incorrect feedback given
+ 4012 - all options disappear

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
+ 4072 - looking at option two during choice period
+ 4073 - looking at option three during choice period
+ 4074 - looking away from previously looked at choice
+ 4075 - fixation acquired on an option

## Data saved to .mat files and sent to Plexon

+ trial number             
+ trial outcome (0 = incorrect, 1 = correct)
+ choice made (1 = top, 2 = left, 3 = right)
+ block percent correct (whole percentage)
+ total percent correct (whole percentage)
+ trial stimulus in top position:
	++ 11 = circle, cyan
	++ 12 = circle, magenta
	++ 13 = circle, yellow
	++ 21 = star, cyan
	++ 22 = star, magenta
	++ 23 = star, yellow
	++ 31 = triangle, cyan
	++ 32 = triangle, magenta
	++ 33 = triangle, yellow
+ trial stimulus in left position:
	++ same encoding as above
+ trial stimulus in right position:
	++ same encoding as above
+ position displayed first in staggered presentation
	++ 1 = top
	++ 2 = left
	++ 3 = right
+ position displayed second in staggered presentation
	++ 1 = top
	++ 2 = left
	++ 3 = right
+ position displayed third in staggered presentation
	++ 1 = top
	++ 2 = left
	++ 3 = right
+ rewarded or not
	++ 0 = not rewarded
	++ 1 = was rewarded)		
+ time allowed to fixate on fixation dot (sends over 15000 if this value is intmax; otherwise it sends the actual value, which is multiplied by 1000 if the value is less than 1)
+ minimum fixation time on fixation dot to initial trial (multiplied by 1000 if the value is less than 1)		
+ duration that feedback is displayed (multiplied by 1000 if the value is less than 1)		
+ ITI (multiplied by 1000 if the value is less than 1)
+ experiment type (1 = intra-dimensional, 2 = extra-dimensional, 3 = reversal)
+ session type (1 = unstaggered, 2 = staggered)
+ correct choices until shift occurs
+ total number of shifts that occurred during the session
+ which eye was tracked (1 = left, 2 = right)