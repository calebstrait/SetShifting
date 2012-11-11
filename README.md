# This is an experiment to test set-shifting.
This MATLAB script is currently capable of testing intra-dimensional and extra-dimensional set shifting. The ability to test reversal learning will be added in the near future.

# Saved data and data sent to Plexon (with codes)

## Session progress flags

+ 4000 - trial starts
+ 5000s - events
+ 6000 - sending trial data begins
+ 7000 - sending trial data ends
+ 8000 - trial ends

## Stimuli appearing and disappearing events sent to Plexon

+ 5001 - fixation dot appears	
+ 5002 - fixation dot disappears
+ 5003 - first option appears
+ 5004 - first option disappears
+ 5005 - second option appears
+ 5006 - second option disappears
+ 5007 - third option appears	
+ 5008 - third option disappears
+ 5009 - all options appear AND second fixation dot appears (NOTE: It never really disappeared)
+ 5010 - option correct feedback given
+ 5011 - option incorrect feedback given
+ 5012 - all options disappear
+ 5013 - reward given

## Eye movement events sent to Plexon

+ 5051 - look at fixation dot	
+ 5052 - look away from fixation dot	
+ 5053 - fixation acquired on fixation dot
+ 5061 - looking at option one during first presentation period
+ 5062 - looking away from option one during first presentation period
+ 5063 - looking at option two during first presentation period
+ 5064 - looking away from option two during first presentation period
+ 5065 - looking at option three during first presentation period
+ 5066 - looking away from option three during first presentation period	
+ 5071 - looking at option one during choice period
+ 5072 - looking at option two during choice period
+ 5073 - looking at option three during choice period
+ 5074 - looking away from previously looked at choice
+ 5075 - fixation acquired on an option

## Trial data sent to Plexon for all tasks but reversal learning

+ trial number        
+ current trial within the current block     
+ trial outcome
	+ 0 = incorrect
	+ 1 = correct
+ choice made
	+ 1 = top
	+ 2 = left
	+ 3 = right
+ location of the correct position
	+ 1 = top
	+ 2 = left
	+ 3 = right
+ block percent correct (whole percentage)
+ total percent correct (whole percentage)
+ trial stimulus in top position
	+ 11 = circle, cyan
	+ 12 = circle, magenta
	+ 13 = circle, yellow
	+ 21 = star, cyan
	+ 22 = star, magenta
	+ 23 = star, yellow
	+ 31 = triangle, cyan
	+ 32 = triangle, magenta
	+ 33 = triangle, yellow
+ trial stimulus in left position:
	+ same encoding as above
+ trial stimulus in right position:
	+ same encoding as above
+ position displayed first in staggered presentation
	+ 1 = top
	+ 2 = left
	+ 3 = right
+ position displayed second in staggered presentation
	+ 1 = top
	+ 2 = left
	+ 3 = right
+ position displayed third in staggered presentation
	+ 1 = top
	+ 2 = left
	+ 3 = right
+ rewarded or not
	+ 0 = not rewarded
	+ 1 = was rewarded				
+ experiment type
	+ 1 = intra-dimensional
	+ 2 = extra-dimensional
	+ 3 = reversal
+ current rule type		
	+ 1 = color	
	+ 2 = shape	
+ correct choices until shift occurs

## Trial data sent to Plexon during the reversal learning task

+ trial number        
+ current trial within the current block     
+ trial outcome
	+ 0 = incorrect
	+ 1 = correct
+ choice made
	+ 2 = left
	+ 3 = right
+ location of the correct position
	+ 2 = left
	+ 3 = right
+ block percent correct (whole percentage)
+ total percent correct (whole percentage)
+ trial stimulus in left position:
    + 11 = circle, cyan
	+ 12 = circle, magenta
	+ 13 = circle, yellow
	+ 21 = star, cyan
	+ 22 = star, magenta
	+ 23 = star, yellow
	+ 31 = triangle, cyan
	+ 32 = triangle, magenta
	+ 33 = triangle, yellow
+ trial stimulus in right position:
	+ same encoding as above
+ position displayed first in staggered presentation
	+ 2 = left
	+ 3 = right
+ position displayed second in staggered presentation
	+ 2 = left
	+ 3 = right
+ rewarded or not
	+ 0 = not rewarded
	+ 1 = was rewarded				
+ experiment type
	+ 1 = intra-dimensional
	+ 2 = extra-dimensional
	+ 3 = reversal
+ correct choices until shift occurs
+ percent chance a reward will be given when the correct option is chosen (whole percentage)