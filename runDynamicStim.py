#!/usr/bin/env python
# -*- coding: utf-8 -*-

# --- Import packages ---
from psychopy import locale_setup
from psychopy import prefs
from psychopy import plugins
plugins.activatePlugins()
prefs.hardware['audioLib'] = 'ptb'
prefs.hardware['audioLatencyMode'] = '3'
from psychopy import sound, gui, visual, core, data, event, logging, clock, colors, layout
from psychopy.constants import (NOT_STARTED, STARTED, PLAYING, PAUSED,
                                STOPPED, FINISHED, PRESSED, RELEASED, FOREVER)

import numpy as np  # whole numpy lib is available, prepend 'np.'
from numpy import (sin, cos, tan, log, log10, pi, average,
                   sqrt, std, deg2rad, rad2deg, linspace, asarray)
from numpy.random import random, randint, normal, shuffle, choice as randchoice
import os  # handy system and path functions
import sys  # to get file system encoding
import cv2

import psychopy.iohub as io
from psychopy.hardware import keyboard

import pandas as pd

# Ensure that relative paths start from the same directory as this script
_thisDir = os.path.dirname(os.path.abspath(__file__))
os.chdir(_thisDir)

# ======================== get gui inputs ============================ 
# Store info about the experiment session
psychopyVersion = '2023.1.2'
expName = 'DynamicStimuli'  # from the Builder filename that created this script
expInfo = {
    'participant': f"P99",
    'run': '1',
}
# --- Show participant info dialog --
dlg = gui.DlgFromDict(dictionary=expInfo, sortKeys=False, title=expName)
if dlg.OK == False:
    core.quit()  # user pressed cancel
expInfo['date'] = data.getDateStr()  # add a simple timestamp
expInfo['expName'] = expName
expInfo['psychopyVersion'] = psychopyVersion

#save gui inputs 
participant = expInfo['participant']
run_num = int(expInfo['run']) - 1 #indexing starts at 0 so run #1 would be indexed as run 0


# ======================== experiment set-up ============================ 
num_task_repeats = 4

#import sequence info from participant folder
stim_names = pd.read_csv(_thisDir + '/data/' + str(participant) + '/' + str(participant) + '_sequence_orders/' + str(participant) + '_stim-names.csv', header=None, names=None)
stim_directories = pd.read_csv(_thisDir + '/data/' + str(participant) + '/' + str(participant) + '_sequence_orders/' + str(participant) + '_stim-directories.csv', header=None, names=None)
block_conds_all = pd.read_csv(_thisDir + '/data/' + str(participant) + '/' + str(participant) + '_sequence_orders/' + str(participant) + '_block-conds-all.csv', header=None, names=None)
condition_names = pd.read_csv(_thisDir + '/data/' + str(participant) + '/' + str(participant) + '_sequence_orders/' + str(participant) + '_condition-names.csv', header=None, names=None)
task_repeat_stim = pd.read_csv(_thisDir + '/data/' + str(participant) + '/' + str(participant) + '_sequence_orders/' + str(participant) + '_task-repeat-stimuli.csv', header=None, names=None)

#load all info for this run only
stim_names = stim_names[run_num]
stim_directories = stim_directories[run_num]
block_conds_all = block_conds_all[run_num]
condition_names = condition_names[run_num]
task_repeat_stim = task_repeat_stim[run_num]

# Data file name stem = absolute path + name; later add .psyexp, .csv, .log, etc
#filename = _thisDir + '/data/' + str(participant) + '/' % (expInfo['participant'], expName, expInfo['date'])
#filename = _thisDir + os.sep + u'data/%s_%s_%s' % (expInfo['participant'], run_string, expName, expInfo['date'])

experiment_info_header = str(expInfo['participant']) + '_run' + str(run_num+1) + '_' + expName + '_' + expInfo['date']
filename = _thisDir + '/data/' + str(participant) + '/' + str(experiment_info_header)

# An ExperimentHandler isn't essential but helps with data saving
thisExp = data.ExperimentHandler(name=expName, version='',
    extraInfo=expInfo, runtimeInfo=None,
    originPath='/Users/bethrispoli/Desktop/VPNL/fyp/DynamicStimuli_PsychoPy/runDynamicStim.py',
    savePickle=True, saveWideText=True,
    dataFileName=filename)
# save a log file for detail verbose info
logFile = logging.LogFile(filename+'.log', level=logging.EXP)
logging.console.setLevel(logging.WARNING)  # this outputs to the screen, not a file

#maybe this shouldnt be here
endExpNow = False  # flag for 'escape' or other condition => quit the exp
frameTolerance = 0.001  # how close to onset before 'same' frame

# ======================== screen/keyboard set-up ============================ 
# --- Setup the Window ---
win = visual.Window(
    size=(960, 540), fullscr=True, screen=1, #change screen stuff here; size=(960, 540), screen=0 is default--- trying to get the stimuli to play only on the scanner screen
    winType='pyglet', allowStencil=False, 
    monitor='testMonitor', color=[0, 0, 0], colorSpace='rgb',
    backgroundImage='/Users/beth/Desktop/DynaCat/dynacat_stimuli/controlled_backgrounds/background_color.png', backgroundFit='contain', 
    blendMode='avg', useFBO=True, 
    units='pix')
win.mouseVisible = True
# store frame rate of monitor if we can measure it
expInfo['frameRate'] = win.getActualFrameRate()
if expInfo['frameRate'] != None:
    frameDur = 1.0 / round(expInfo['frameRate'])
else:
    frameDur = 1.0 / 60.0  # could not measure, so guess
# --- Setup input devices ---
ioConfig = {}

# Setup iohub keyboard
ioConfig['Keyboard'] = dict(use_keymap='psychopy')

ioSession = '1'
if 'session' in expInfo:
    ioSession = str(expInfo['session'])
ioServer = io.launchHubServer(window=win, **ioConfig)

# create a default keyboard (e.g. to check for escape)
defaultKeyboard = keyboard.Keyboard(backend='iohub')

#initialize button box
button_box_resp = keyboard.Keyboard()

# ======================== load text screens  for run ============================
# --- Load instructions screen info ---
instructions_screen = visual.TextStim(win=win, name='instructions_screen',
    text='Press a button every time a video repeats.',
    font='Open Sans',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0.0, 
    color='white', colorSpace='rgb', opacity=None, 
    languageStyle='LTR',
    depth=0.0);
intructions_response = keyboard.Keyboard()

# --- Load "wait_for_trigger" screen info ---
waiting_for_trigger_text = visual.TextStim(win=win, name='waiting_for_trigger_text',
    text='Waiting for trigger (t)...',
    font='Open Sans',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0.0, 
    color='white', colorSpace='rgb', opacity=None, 
    languageStyle='LTR',
    depth=0.0);
trigger = keyboard.Keyboard()

# --- load countdown screen ---
countdown = visual.TextStim(win=win, name='countdown',
    text='',
    font='Open Sans',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0.0, 
    color='white', colorSpace='rgb', opacity=None, 
    languageStyle='LTR',
    depth=0.0);

# ======================== load video stimuli  ============================
#get video file paths from stim_directories only for non-baseline stimuli
video_paths = stim_directories

# create a list of loaded MovieStim3 objects
videos = [visual.MovieStim(win, path, flipVert=False, size=(1920, 1080)) for path in video_paths] #changed from MoveStim3


# ======================== run experiment! ============================
# --- Create some handy timers---
globalClock = core.Clock()  # to track the time since experiment started
routineTimer = core.Clock()  # to track time remaining of each (possibly non-slip) routine 

# --- Prepare to start Routine "instructions" ---
continueRoutine = True
# update component parameters for each repeat
intructions_response.keys = []
intructions_response.rt = []
_intructions_response_allKeys = []
# keep track of which components have finished
instructionsComponents = [instructions_screen, intructions_response]
for thisComponent in instructionsComponents:
    thisComponent.tStart = None
    thisComponent.tStop = None
    thisComponent.tStartRefresh = None
    thisComponent.tStopRefresh = None
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED
# reset timers
t = 0
_timeToFirstFrame = win.getFutureFlipTime(clock="now")
frameN = -1

# --- Run Routine "instructions" ---
routineForceEnded = not continueRoutine
while continueRoutine:
    # get current time
    t = routineTimer.getTime()
    tThisFlip = win.getFutureFlipTime(clock=routineTimer)
    tThisFlipGlobal = win.getFutureFlipTime(clock=None)
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *instructions_screen* updates
    
    # if instructions_screen is starting this frame...
    if instructions_screen.status == NOT_STARTED and tThisFlip >= 0-frameTolerance:
        # keep track of start time/frame for later
        instructions_screen.frameNStart = frameN  # exact frame index
        instructions_screen.tStart = t  # local t and not account for scr refresh
        instructions_screen.tStartRefresh = tThisFlipGlobal  # on global time
        win.timeOnFlip(instructions_screen, 'tStartRefresh')  # time at next scr refresh
        # add timestamp to datafile
        thisExp.timestampOnFlip(win, 'instructions_screen.started')
        # update status
        instructions_screen.status = STARTED
        instructions_screen.setAutoDraw(True)
    
    # if instructions_screen is active this frame...
    if instructions_screen.status == STARTED:
        # update params
        pass
    
    # *intructions_response* updates
    waitOnFlip = False
    
    # if intructions_response is starting this frame...
    if intructions_response.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
        # keep track of start time/frame for later
        intructions_response.frameNStart = frameN  # exact frame index
        intructions_response.tStart = t  # local t and not account for scr refresh
        intructions_response.tStartRefresh = tThisFlipGlobal  # on global time
        win.timeOnFlip(intructions_response, 'tStartRefresh')  # time at next scr refresh
        # add timestamp to datafile
        thisExp.timestampOnFlip(win, 'intructions_response.started')
        # update status
        intructions_response.status = STARTED
        # keyboard checking is just starting
        waitOnFlip = True
        win.callOnFlip(intructions_response.clock.reset)  # t=0 on next screen flip
        win.callOnFlip(intructions_response.clearEvents, eventType='keyboard')  # clear events on next screen flip
    if intructions_response.status == STARTED and not waitOnFlip:
        theseKeys = intructions_response.getKeys(keyList=['y','n','left','right','space'], waitRelease=False)
        _intructions_response_allKeys.extend(theseKeys)
        if len(_intructions_response_allKeys):
            intructions_response.keys = _intructions_response_allKeys[-1].name  # just the last key pressed
            intructions_response.rt = _intructions_response_allKeys[-1].rt
            # a response ends the routine
            continueRoutine = False
    
    # check for quit (typically the Esc key)
    if endExpNow or defaultKeyboard.getKeys(keyList=["escape"]):
        core.quit()
    
    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        routineForceEnded = True
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in instructionsComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# --- Ending Routine "instructions" ---
for thisComponent in instructionsComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# check responses
if intructions_response.keys in ['', [], None]:  # No response was made
    intructions_response.keys = None
thisExp.addData('intructions_response.keys',intructions_response.keys)
if intructions_response.keys != None:  # we had a response
    thisExp.addData('intructions_response.rt', intructions_response.rt)
thisExp.nextEntry()
# the Routine "instructions" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# --- Prepare to start Routine "wait_for_trigger" ---
continueRoutine = True
# update component parameters for each repeat
trigger.keys = []
trigger.rt = []
_trigger_allKeys = []
# keep track of which components have finished
wait_for_triggerComponents = [waiting_for_trigger_text, trigger]
for thisComponent in wait_for_triggerComponents:
    thisComponent.tStart = None
    thisComponent.tStop = None
    thisComponent.tStartRefresh = None
    thisComponent.tStopRefresh = None
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED
# reset timers
t = 0
_timeToFirstFrame = win.getFutureFlipTime(clock="now")
frameN = -1

# --- Run Routine "wait_for_trigger" ---
routineForceEnded = not continueRoutine
while continueRoutine:
    # get current time
    t = routineTimer.getTime()
    tThisFlip = win.getFutureFlipTime(clock=routineTimer)
    tThisFlipGlobal = win.getFutureFlipTime(clock=None)
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *waiting_for_trigger_text* updates
    
    # if waiting_for_trigger_text is starting this frame...
    if waiting_for_trigger_text.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
        # keep track of start time/frame for later
        waiting_for_trigger_text.frameNStart = frameN  # exact frame index
        waiting_for_trigger_text.tStart = t  # local t and not account for scr refresh
        waiting_for_trigger_text.tStartRefresh = tThisFlipGlobal  # on global time
        win.timeOnFlip(waiting_for_trigger_text, 'tStartRefresh')  # time at next scr refresh
        # add timestamp to datafile
        thisExp.timestampOnFlip(win, 'waiting_for_trigger_text.started')
        # update status
        waiting_for_trigger_text.status = STARTED
        waiting_for_trigger_text.setAutoDraw(True)
    
    # if waiting_for_trigger_text is active this frame...
    if waiting_for_trigger_text.status == STARTED:
        # update params
        pass
    
    # *trigger* updates
    waitOnFlip = False
    
    # if trigger is starting this frame...
    if trigger.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
        # keep track of start time/frame for later
        trigger.frameNStart = frameN  # exact frame index
        trigger.tStart = t  # local t and not account for scr refresh
        trigger.tStartRefresh = tThisFlipGlobal  # on global time
        win.timeOnFlip(trigger, 'tStartRefresh')  # time at next scr refresh
        # add timestamp to datafile
        thisExp.timestampOnFlip(win, 'trigger.started')
        # update status
        trigger.status = STARTED
        # keyboard checking is just starting
        waitOnFlip = True
        win.callOnFlip(trigger.clock.reset)  # t=0 on next screen flip
        win.callOnFlip(trigger.clearEvents, eventType='keyboard')  # clear events on next screen flip
    if trigger.status == STARTED and not waitOnFlip:
        theseKeys = trigger.getKeys(keyList=['g','t'], waitRelease=False)
        _trigger_allKeys.extend(theseKeys)
        if len(_trigger_allKeys):
            trigger.keys = _trigger_allKeys[-1].name  # just the last key pressed
            trigger.rt = _trigger_allKeys[-1].rt
            # a response ends the routine
            continueRoutine = False
    
    # check for quit (typically the Esc key)
    if endExpNow or defaultKeyboard.getKeys(keyList=["escape"]):
        core.quit()
    
    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        routineForceEnded = True
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in wait_for_triggerComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# --- Ending Routine "wait_for_trigger" ---
for thisComponent in wait_for_triggerComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# check responses
if trigger.keys in ['', [], None]:  # No response was made
    trigger.keys = None
thisExp.addData('trigger.keys',trigger.keys)
if trigger.keys != None:  # we had a response
    thisExp.addData('trigger.rt', trigger.rt)
thisExp.nextEntry()
# the Routine "wait_for_trigger" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

#==========================

# --- Prepare to start Routine "countdown n-extra TRs" ---
continueRoutine = True
# update component parameters for each repeat
thisExp.addData('countdown.started', globalClock.getTime())
# keep track of which components have finished
trialComponents = [countdown]
for thisComponent in trialComponents:
    thisComponent.tStart = None
    thisComponent.tStop = None
    thisComponent.tStartRefresh = None
    thisComponent.tStopRefresh = None
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED
# reset timers
t = 0
_timeToFirstFrame = win.getFutureFlipTime(clock="now")
frameN = -1

# --- Run Routine "countdown n-extra TRs" ---
routineForceEnded = not continueRoutine
while continueRoutine and routineTimer.getTime() < 8.0:
    # get current time
    t = routineTimer.getTime()
    tThisFlip = win.getFutureFlipTime(clock=routineTimer)
    tThisFlipGlobal = win.getFutureFlipTime(clock=None)
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *countdown* updates
    
    # if countdown is starting this frame...
    if countdown.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
        # keep track of start time/frame for later
        countdown.frameNStart = frameN  # exact frame index
        countdown.tStart = t  # local t and not account for scr refresh
        countdown.tStartRefresh = tThisFlipGlobal  # on global time
        win.timeOnFlip(countdown, 'tStartRefresh')  # time at next scr refresh
        # add timestamp to datafile
        thisExp.timestampOnFlip(win, 'countdown.started')
        # update status
        countdown.status = STARTED
        countdown.setAutoDraw(True)
    
    # if countdown is active this frame...
    if countdown.status == STARTED:
        # update params
        countdown.setText(int(round(8 - t, 3)), log=False)
    
    # if countdown is stopping this frame...
    if countdown.status == STARTED:
        # is it time to stop? (based on global clock, using actual start)
        if tThisFlipGlobal > countdown.tStartRefresh + 8-frameTolerance:
            # keep track of stop time/frame for later
            countdown.tStop = t  # not accounting for scr refresh
            countdown.frameNStop = frameN  # exact frame index
            # add timestamp to datafile
            thisExp.timestampOnFlip(win, 'countdown.stopped')
            # update status
            countdown.status = FINISHED
            countdown.setAutoDraw(False)
    
    # check for quit (typically the Esc key)
    if defaultKeyboard.getKeys(keyList=["escape"]):
        thisExp.status = FINISHED
    if thisExp.status == FINISHED or endExpNow:
        endExperiment(thisExp, inputs=inputs, win=win)
    
    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        routineForceEnded = True
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in trialComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# --- Ending Routine "trial" ---
for thisComponent in trialComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
thisExp.addData('trial.stopped', globalClock.getTime())
# using non-slip timing so subtract the expected duration of this Routine (unless ended on request)
if routineForceEnded:
    routineTimer.reset()
else:
    routineTimer.addTime(-8.000000)


#
## --- Prepare 8 TRs to be clipped ---
#number_blocks_to_be_clipped = 2 # 2 4-second blocks
#for i in range(number_blocks_to_be_clipped):
#    stimuli = videos[0] # use baseline as stimuli so that gray matches
#    continueRoutine = True
#    # update component parameters for each repeat
#    button_box_resp.keys = []
#    button_box_resp.rt = []
#    _button_box_resp_allKeys = []
#    # keep track of which components have finished
#    play_stimuliComponents = [stimuli, button_box_resp]
#    for thisComponent in play_stimuliComponents:
#        thisComponent.tStart = None
#        thisComponent.tStop = None
#        thisComponent.tStartRefresh = None
#        thisComponent.tStopRefresh = None
#        if hasattr(thisComponent, 'status'):
#            thisComponent.status = NOT_STARTED
#    
#    # reset timers
#    t = 0
#    _timeToFirstFrame = win.getFutureFlipTime(clock="now")
#    frameN = -1
#    
#    # --- Run Routine "8 TRs to be clipped" ---
#    routineForceEnded = not continueRoutine
#    while continueRoutine and routineTimer.getTime() < 4.0:
#        # get current time
#        t = routineTimer.getTime()
#        tThisFlip = win.getFutureFlipTime(clock=routineTimer)
#        tThisFlipGlobal = win.getFutureFlipTime(clock=None)
#        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
#        # update/draw components on each frame
#        
#        # *stimuli* updates
#        
#        # if stimuli is starting this frame...
#        if stimuli.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
#            # keep track of start time/frame for later
#            stimuli.frameNStart = frameN  # exact frame index
#            stimuli.tStart = t  # local t and not account for scr refresh
#            stimuli.tStartRefresh = tThisFlipGlobal  # on global time
#            win.timeOnFlip(stimuli, 'tStartRefresh')  # time at next scr refresh
#            # add timestamp to datafile
#            thisExp.timestampOnFlip(win, 'stimuli.started')
#            thisExp.addData('condition',block_conds_all[0])
#            thisExp.addData('stim_name',stim_names[0])
#            # update status
#            stimuli.status = STARTED
#            stimuli.setAutoDraw(True)
#            stimuli.play()
#        
#        # if stimuli is stopping this frame...
#        if stimuli.status == STARTED:
#            # is it time to stop? (based on global clock, using actual start)
#            if tThisFlipGlobal > stimuli.tStartRefresh + 4.0-frameTolerance:
#                # keep track of stop time/frame for later
#                stimuli.tStop = t  # not accounting for scr refresh
#                stimuli.frameNStop = frameN  # exact frame index
#                # add timestamp to datafile
#                thisExp.timestampOnFlip(win, 'stimuli.stopped')
#                # update status
#                stimuli.status = FINISHED
#                stimuli.setAutoDraw(False)
#                stimuli.stop()
#                #if stimuli.isFinished:  # force-end the routine; keep getting error moviestim3 has no attribute isFinished but i dont think im using moviestim3
#                #continueRoutine = False
#            
#            # *button_box_resp* updates
#            waitOnFlip = False
#            
#            # if button_box_resp is starting this frame...
#            if button_box_resp.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
#                # keep track of start time/frame for later
#                button_box_resp.frameNStart = frameN  # exact frame index
#                button_box_resp.tStart = t  # local t and not account for scr refresh
#                button_box_resp.tStartRefresh = tThisFlipGlobal  # on global time
#                win.timeOnFlip(button_box_resp, 'tStartRefresh')  # time at next scr refresh
#                # add timestamp to datafile
#                thisExp.timestampOnFlip(win, 'button_box_resp.started')
#                # update status
#                button_box_resp.status = STARTED
#                # keyboard checking is just starting
#                waitOnFlip = True
#                win.callOnFlip(button_box_resp.clock.reset)  # t=0 on next screen flip
#                win.callOnFlip(button_box_resp.clearEvents, eventType='keyboard')  # clear events on next screen flip
#            if button_box_resp.status == STARTED and not waitOnFlip:
#                theseKeys = button_box_resp.getKeys(keyList=['r', 'g', 'b', 'y', 'e'], waitRelease=False)
#                _button_box_resp_allKeys.extend(theseKeys)
#                if len(_button_box_resp_allKeys):
#                    button_box_resp.keys = _button_box_resp_allKeys[-1].name  # just the last key pressed
#                    button_box_resp.rt = _button_box_resp_allKeys[-1].rt
#        
#        # check for quit (typically the Esc key)
#        if endExpNow or defaultKeyboard.getKeys(keyList=["escape"]):
#            core.quit()
#        
#        # check if all components have finished
#        if not continueRoutine:  # a component has requested a forced-end of Routine
#            routineForceEnded = True
#            break
#        continueRoutine = False  # will revert to True if at least one component still running
#        for thisComponent in play_stimuliComponents:
#            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
#                continueRoutine = True
#                break  # at least one component has not yet finished
#                
#        # check button box responses
#        if button_box_resp.keys in ['', [], None]:  # No response was made
#            button_box_resp.keys = None
#        thisExp.addData('button_box_resp.keys',button_box_resp.keys)
#        if button_box_resp.keys != None:  # we had a response
#            print(button_box_resp.keys)
#            thisExp.addData('button_box_resp.rt', button_box_resp.rt)
#            
#        # refresh the screen
#        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
#            win.flip()
#    
#    # --- Ending Routine "play_stimuli" ---
#    for thisComponent in play_stimuliComponents:
#        if hasattr(thisComponent, "setAutoDraw"):
#            thisComponent.setAutoDraw(False)
#    stimuli.stop()
#    # using non-slip timing so subtract the expected duration of this Routine (unless ended on request)
#    if routineForceEnded:
#        routineTimer.reset()
#    else:
#        routineTimer.addTime(-4.000000)
#    thisExp.nextEntry() #i think this will make the stimuli save to a new line every iteration
#

#==========================
# --- Prepare to start Routine "play_stimuli" ---
stim_index = 0
num_correct_responses = 0
for block_cond in block_conds_all:
    button_responses = 0
    print(block_cond)
    print(stim_names[stim_index])
    stimuli = videos[stim_index]
    continueRoutine = True
    # update component parameters for each repeat
    button_box_resp.keys = []
    button_box_resp.rt = []
    _button_box_resp_allKeys = []
    # keep track of which components have finished
    play_stimuliComponents = [stimuli, button_box_resp]
    for thisComponent in play_stimuliComponents:
        thisComponent.tStart = None
        thisComponent.tStop = None
        thisComponent.tStartRefresh = None
        thisComponent.tStopRefresh = None
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    
    # reset timers
    t = 0
    _timeToFirstFrame = win.getFutureFlipTime(clock="now")
    frameN = -1
    
    # --- Run Routine "play_stimuli" ---
    routineForceEnded = not continueRoutine
    while continueRoutine and routineTimer.getTime() < 4.0:
        # get current time
        t = routineTimer.getTime()
        tThisFlip = win.getFutureFlipTime(clock=routineTimer)
        tThisFlipGlobal = win.getFutureFlipTime(clock=None)
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *stimuli* updates
        
        # if stimuli is starting this frame...
        if stimuli.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
            # keep track of start time/frame for later
            stimuli.frameNStart = frameN  # exact frame index
            stimuli.tStart = t  # local t and not account for scr refresh
            stimuli.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(stimuli, 'tStartRefresh')  # time at next scr refresh
            # add timestamp to datafile
            thisExp.timestampOnFlip(win, 'stimuli.started')
            thisExp.addData('condition',block_conds_all[stim_index])
            thisExp.addData('stim_name',stim_names[stim_index])
            # update status
            stimuli.status = STARTED
            stimuli.setAutoDraw(True)
            stimuli.play()
        
        # if stimuli is stopping this frame...
        if stimuli.status == STARTED:
            # is it time to stop? (based on global clock, using actual start)
            if tThisFlipGlobal > stimuli.tStartRefresh + 4.0-frameTolerance:
                # keep track of stop time/frame for later
                stimuli.tStop = t  # not accounting for scr refresh
                stimuli.frameNStop = frameN  # exact frame index
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'stimuli.stopped')
                # update status
                stimuli.status = FINISHED
                stimuli.setAutoDraw(False)
                stimuli.stop()
                #if stimuli.isFinished:  # force-end the routine; keep getting error moviestim3 has no attribute isFinished but i dont think im using moviestim3
                #continueRoutine = False
            
            # *button_box_resp* updates
            waitOnFlip = False
            
            # if button_box_resp is starting this frame...
            if button_box_resp.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                # keep track of start time/frame for later
                button_box_resp.frameNStart = frameN  # exact frame index
                button_box_resp.tStart = t  # local t and not account for scr refresh
                button_box_resp.tStartRefresh = tThisFlipGlobal  # on global time
                win.timeOnFlip(button_box_resp, 'tStartRefresh')  # time at next scr refresh
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'button_box_resp.started')
                # update status
                button_box_resp.status = STARTED
                # keyboard checking is just starting
                waitOnFlip = True
                win.callOnFlip(button_box_resp.clock.reset)  # t=0 on next screen flip
                win.callOnFlip(button_box_resp.clearEvents, eventType='keyboard')  # clear events on next screen flip
            if button_box_resp.status == STARTED and not waitOnFlip:
                theseKeys = button_box_resp.getKeys(keyList=['r', 'g', 'b', 'y', 'e'], waitRelease=False)
                _button_box_resp_allKeys.extend(theseKeys)
                if len(_button_box_resp_allKeys):
                    button_box_resp.keys = _button_box_resp_allKeys[-1].name  # just the last key pressed
                    button_box_resp.rt = _button_box_resp_allKeys[-1].rt
        
        # check for quit (typically the Esc key)
        if endExpNow or defaultKeyboard.getKeys(keyList=["escape"]):
            core.quit()
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            routineForceEnded = True
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in play_stimuliComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
                
        # check button box responses
        if button_box_resp.keys in ['', [], None]:  # No response was made
            button_box_resp.keys = None
        thisExp.addData('button_box_resp.keys',button_box_resp.keys)
        if button_box_resp.keys != None:  # we had a response
            print(button_box_resp.keys)
            thisExp.addData('button_box_resp.rt', button_box_resp.rt)
            if block_cond == 25:
                button_responses = button_responses + 1 #record if it was a correct repsonse for a task repeat, right now is recording every frame
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # --- Ending Routine "play_stimuli" ---
    for thisComponent in play_stimuliComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    stimuli.stop()
    if block_cond == 25 and button_responses > 0:
        num_correct_responses = num_correct_responses + 1 #record if a button press was a correct repsonse for a task repeat
    # using non-slip timing so subtract the expected duration of this Routine (unless ended on request)
    if routineForceEnded:
        routineTimer.reset()
    else:
        routineTimer.addTime(-4.000000)
    thisExp.nextEntry() #i think this will make the stimuli save to a new line every iteration
    stim_index = stim_index + 1

# --- load end screen info --- (loading down here so that we can display the accuracy score)
#record accuracy score
task_score = (num_correct_responses / num_task_repeats) * 100
thisExp.addData('num_correct_responses',num_correct_responses)
thisExp.addData('task_score',task_score)

run_finished_text = visual.TextStim(win=win, name='run_finished_text',
    text='Run finished! Accuracy Score: ' + str(task_score) + '%',
    font='Open Sans',
    pos=(0, 0), height=0.05, wrapWidth=None, ori=0.0, 
    color='white', colorSpace='rgb', opacity=None, 
    languageStyle='LTR',
    depth=0.0);
exit_key = keyboard.Keyboard()

# --- Prepare to start Routine "end_screen" ---
continueRoutine = True
# update component parameters for each repeat
exit_key.keys = []
exit_key.rt = []
_exit_key_allKeys = []
# keep track of which components have finished
end_screenComponents = [run_finished_text, exit_key]
for thisComponent in end_screenComponents:
    thisComponent.tStart = None
    thisComponent.tStop = None
    thisComponent.tStartRefresh = None
    thisComponent.tStopRefresh = None
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED
# reset timers
t = 0
_timeToFirstFrame = win.getFutureFlipTime(clock="now")
frameN = -1

# --- Run Routine "end_screen" ---
routineForceEnded = not continueRoutine
while continueRoutine:
    # get current time
    t = routineTimer.getTime()
    tThisFlip = win.getFutureFlipTime(clock=routineTimer)
    tThisFlipGlobal = win.getFutureFlipTime(clock=None)
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *run_finished_text* updates
    
    # if run_finished_text is starting this frame...
    if run_finished_text.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
        # keep track of start time/frame for later
        run_finished_text.frameNStart = frameN  # exact frame index
        run_finished_text.tStart = t  # local t and not account for scr refresh
        run_finished_text.tStartRefresh = tThisFlipGlobal  # on global time
        win.timeOnFlip(run_finished_text, 'tStartRefresh')  # time at next scr refresh
        # add timestamp to datafile
        thisExp.timestampOnFlip(win, 'run_finished_text.started')
        # update status
        run_finished_text.status = STARTED
        run_finished_text.setAutoDraw(True)
    
    # if run_finished_text is active this frame...
    if run_finished_text.status == STARTED:
        # update params
        pass
    
    # *exit_key* updates
    waitOnFlip = False
    
    # if exit_key is starting this frame...
    if exit_key.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
        # keep track of start time/frame for later
        exit_key.frameNStart = frameN  # exact frame index
        exit_key.tStart = t  # local t and not account for scr refresh
        exit_key.tStartRefresh = tThisFlipGlobal  # on global time
        win.timeOnFlip(exit_key, 'tStartRefresh')  # time at next scr refresh
        # add timestamp to datafile
        thisExp.timestampOnFlip(win, 'exit_key.started')
        # update status
        exit_key.status = STARTED
        # keyboard checking is just starting
        waitOnFlip = True
        win.callOnFlip(exit_key.clock.reset)  # t=0 on next screen flip
        win.callOnFlip(exit_key.clearEvents, eventType='keyboard')  # clear events on next screen flip
    if exit_key.status == STARTED and not waitOnFlip:
        theseKeys = exit_key.getKeys(keyList=['y','n','left','right','space'], waitRelease=False)
        _exit_key_allKeys.extend(theseKeys)
        if len(_exit_key_allKeys):
            exit_key.keys = _exit_key_allKeys[-1].name  # just the last key pressed
            exit_key.rt = _exit_key_allKeys[-1].rt
            # a response ends the routine
            continueRoutine = False
    
    # check for quit (typically the Esc key)
    if endExpNow or defaultKeyboard.getKeys(keyList=["escape"]):
        core.quit()
    
    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        routineForceEnded = True
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in end_screenComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
            
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()


# --- Ending Routine "end_screen" ---
for thisComponent in end_screenComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# check responses
if exit_key.keys in ['', [], None]:  # No response was made
    exit_key.keys = None
thisExp.addData('exit_key.keys',exit_key.keys)
if exit_key.keys != None:  # we had a response
    thisExp.addData('exit_key.rt', exit_key.rt)
thisExp.nextEntry()
# the Routine "end_screen" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# --- End experiment ---
# Flip one final time so any remaining win.callOnFlip() 
# and win.timeOnFlip() tasks get executed before quitting
win.flip()

# these shouldn't be strictly necessary (should auto-save)
thisExp.saveAsWideText(filename+'.csv', delim='auto')
thisExp.saveAsPickle(filename)
logging.flush()
# make sure everything is closed down
thisExp.abort()  # or data files will save again on exit


# --- Export par files ---
#set color codes
black = '1 1 1' #for task repeats
white = '0 0 0' #for baselines

faces_normal = '0.53725490196 0.09411764705 0.09411764705'
faces_linear = '0.73725490196 0.12549019607 0.16078431372'
faces_still = '0.92549019607 0.14117647058 0.14901960784'

hands_normal = '0.93725490196 0.29019607843 0.13725490196'
hands_linear = '0.95686274509 0.49803921568 0.32549019607'
hands_still = '0.9725490196 0.63137254902 0.48235294117'

bodies_normal = '0.86274509803 0.70196078431 0.15294117647'
bodies_linear = '0.99215686274 0.84705882352 0'
bodies_still = '1 0.90980392156 0.52549019607'

animals_normal = '0.77647058823 0.09411764705 0.52156862745'
animals_linear = '0.9294117647 0.15294117647 0.56470588235'
animals_still = '0.93725490196 0.41960784313 0.66274509803'

objects1_normal = '0.17647058823 0.17647058823 0.45098039215'
objects1_linear = '0.23137254902 0.32549019607 0.63921568627'
objects1_still = '0.41960784313 0.56862745098 0.79607843137'

objects2_normal = '0.36470588235 0.16862745098 0.50588235294'
objects2_linear = '0.49803921568 0.27843137254 0.61176470588'
objects2_still = '0.65490196078 0.50588235294 0.7294117647'

scenes1_normal = '0 0.50588235294 0.51764705882'
scenes1_linear = '0.07058823529 0.70196078431 0.65098039215'
scenes1_still = '0.71372549019 0.8862745098 0.90196078431'

scenes2_normal = '0.05882352941 0.39607843137 0.20392156862'
scenes2_linear = '0.14117647058 0.55294117647 0.26666666666'
scenes2_still = '0.4431372549 0.75686274509 0.42352941176'

condition_colors = pd.DataFrame({
    'condition_num': [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25],
    'color_code': [white, \
                   faces_normal, faces_linear, faces_still, \
                   hands_normal, hands_linear, hands_still, \
                   bodies_normal, bodies_linear, bodies_still, \
                   animals_normal, animals_linear, animals_still, \
                   objects1_normal, objects1_linear, objects1_still, \
                   objects2_normal, objects2_linear, objects2_still, \
                   scenes1_normal, scenes1_linear, scenes1_still, \
                   scenes2_normal, scenes2_linear, scenes2_still, \
                   black]})

#build dataframe for conditions par file
onset_nums = [4 * i for i in range(0, len(stim_directories))] 
column_names = ['onset_time', 'cond_num', 'cond_name', 'color_code']
par_file_df = pd.DataFrame({}, columns=column_names)

index = 0
for block_cond in block_conds_all:
    onset_time = onset_nums[index]
    color_code = condition_colors.iloc[block_cond][1]
    condition_name = condition_names[index]
    
    new_data = {'onset_time': onset_time, 'cond_num': block_cond, 'cond_name': condition_name, 'color_code': color_code} 
    new_data_df = pd.DataFrame([new_data])
    par_file_df = pd.concat([par_file_df, new_data_df])
    #par_file_df = par_file_df.append(new_data, ignore_index=True)
    
    index = index + 1
# export conditions par file
par_file_df.to_csv(_thisDir + os.sep + u'data/' + str(participant) + '/' + experiment_info_header + '_par_file.par', sep='\t', index=False, header=False, lineterminator='\n')
print("Par file exported successfully!")


#build dataframe for indiviual video indexing par file
column_names_individual_stim = ['onset_time', 'cond_num', 'stimuli_name', 'color_code'] #i think cond_num should actually be cond name
par_file_df_individual_stim = pd.DataFrame({}, columns=column_names_individual_stim)

index = 0
for block_cond in block_conds_all:
    onset_time = onset_nums[index]
    color_code = condition_colors.iloc[block_cond][1]
    stimuli_name = stim_names[index]
    
    new_data = {'onset_time': onset_time, 'cond_num': block_cond, 'stimuli_name': stimuli_name, 'color_code': color_code} 
    new_data_df = pd.DataFrame([new_data])
    par_file_df_individual_stim = pd.concat([par_file_df_individual_stim, new_data_df])
    
    #par_file_df_individual_stim = par_file_df_individual_stim.append(new_data, ignore_index=True)
    
    index = index + 1
# export individual stimuli par file
par_file_df_individual_stim.to_csv(_thisDir + os.sep + u'data/' + str(participant) + '/' + experiment_info_header + '_par_file_individual_stim.par', sep='\t', index=False, header=False, lineterminator='\n')
print("Par file exported successfully!")



# --- close everything ---
win.close()
core.quit()


