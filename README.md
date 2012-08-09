# This is an experiment to test set-shifting.

# Saved data and data sent to Plexon (with codes)

## Stimuli appearing and disappearing events sent to Plexon

4001 - fixation dot appears
4002 - options appear (with the fixation dot still on)
4003 - go signal (dot disappearing)
4004 - chosen option shrinking (IS THIS OK?)
4005 - chosen option fully shrunk/gone
4006 - non-chosen option disappears
4007 - entered error state from never initiating trial
4008 - entered error state from breaking hold
4009 - entered error state from never selecting an option
4010 - reward given (EVEN WHEN SPACEBAR IS HIT?)

## Eye movements events sent to Plexon

4051 - look at fixation dot
4052 - look away from fixation dot
4053 - fixation on fixation dot acquired

4061 - look away from hold fixation dot

4071 - look at stay option
4072 - look away from stay option
4073 - fixation on stay option acquired

4081 - look at leave option
4082 - look away from leave option
4083 - fixation on leave option acquired

## Data saved to .mat files and sent to Plexon

### Data that changes trial to trial
trial number
trial type (stay option on left or right)
time to shrink leave bar (foraging time)
outcome (leave or stay)
received reward (yes or no)
reward size given
number of errors (if any)
type of errors (if any)

### Data that does not change trial to trial

time allowed for initial fixation
fixation time required to start trial
time required to hold fixation
time allowed to saccade
ITI time
error state waiting time
all possible foraging times
shrink rate
time to shrink stay bar
all possible reward sizes