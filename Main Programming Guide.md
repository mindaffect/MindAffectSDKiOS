# Main Programming Guide

This guide describes the most important concepts and functionalities of the NoiseTagging framework for iOS. By reading this document, you make sure you can use the framework effectively. 

Table of Contents:
- [Overview](#overview)
- [Blocking](#blocking)
- [Trials](#trials)
- [Settings](#settings)
- [Using Noise Tag Controls](#using-noise-tag-controls)
- [Custom Noise Tag Controls](#custom-noise-tag-controls)
- [Logging](#logging)


## Overview

This Section gives an overview of the most important pieces. Subsequent Sections discuss a number of tasks in more detail. 


### Controls

A *control* is an object that conforms to the `NoiseTagControl` protocol. Being a control means being a brain-pressable button. (In the future non-button control types might become availalable as well.) The most important tasks of these buttons are: 1) to show noise tags, and 2) to perform actions when they are being pressed, be it by brain or finger. 

You can easily define your own `NoiseTagControl`-conformant classes, but you can also simply use the standard control classes, such as `NoiseTagButtonView`. 


### NoiseTagging

The read-only variable `NoiseTagging` gives you easy access to a singleton `NoiseTagController`. This singleton – from now on referred to as `NoiseTagging` – is the conductor of most of what the NoiseTagging framework does, such as starting and stopping trials, making controls flicker, and communicating with the MindAffect Decoder.

`NoiseTagging` is also *your* main gateway to using the framework. You use it to define which controls should flicker, to provide  the user with UI to setup brain control, to customize noise tagging settings, etcetera. 


### Settings

`NoiseTagging.settings` lets you customize all kinds of things, such as trial timing and the default colors used for flickering. Please note that many of these settings have been developed for internal usage, so not all of them will be relevant for you.

For an explanation of `NoiseTagging` settings, check out `NoiseTagSettingTitles`. 


### Modes

One of `NoiseTagging`'s settings is its *mode*. This mode determines whether the system currently is used for calibration, normal usage, or one of the other modes. Currently we recommend you do **not** change this setting yourself. Using the framework's standard UI for letting the user hook up her brain, the system will correctly transition between modes. 

In the future we might use these modes for new features such as zero-train, or the option to integrate calibration in your own UI. If this is something you are interested in, please let us know!


### Trials and Updates

`NoiseTagging` takes care of starting and stopping trials, dependent on the current *mode* and a number of other settings. You control whether trials should be running or not using `NoiseTagging.trialsAreRunning`. 

After a user exits the standard UI for hooking up her brain, the system will set `NoiseTagging.trialsAreRunning` to `true` automatically. Also, by default the user can toggle `trialsAreRunning` by swiping up or down with one finger. 

`NoiseTagging` makes sure that the set of controls that flicker *never changes during a trial*. The same holds for the actions assigned to those controls. In order to enforce this – as well as for efficiency reasons –, you can only assign actions to controls as part of *an update block*. 

You can perform an update block explicitly using `NoiseTagging.updateControls(updateCode:)`, but normally you will not use this function directly. Instead you use the functions `push(view:forNoiseTaggingWithDelegate:)`, `pop()`, and `update(view:forNoiseTaggingWithDelegate:)`. These functions call `updateControls(updateCode:)` on your behalf and they are explained in the next Section.

Sometimes a new trial should not start untill something else has finished. For example certain animations need to finish before the flickering should start again. In such scenarios you must **not** set `NoiseTagging.trialsAreRunning` to false. Instead you should use *blocking*, which is explained in one of the later Sections. 


### Units and the Unit Stack

The set of controls that can be brain-controlled depends on the current *NoiseTagging unit*. A NoiseTagging unit, or simply *unit*, consists of two objects: a *view* (`UIView`) and a *delegate* (`NoiseTagDelegate`):

- The view generally is the view in which the brain-controllable controls reside. `NoiseTagging` may add gesture recognizers on this view, e.g. to let the user toggle the flickering on or off. 
- The delegate is responsible for preparing for brain control when the unit becomes the current unit. Primarily this means assigning actions to controls. The `NoiseTagDelegate` protocol also lets you make customizations, or respond to certain events, such as a trial ending. 

`NoiseTagging` keeps a stack of units, called the *unit stack*. If you want to make a certain set of controls brain-controllable, you push your own unit onto the stack: `NoiseTagging.push(view:forNoiseTaggingWithDelegate:)`. Once your unit becomes the current unit, your delegate will be asked to make preparations (see next Section).

You can pop the current unit using `NoiseTagging.pop()`. This removes the current unit from the stack and makes the now-top-most unit the current unit again. 

The fact that we use this stack has a number of advantages. E.g. the framework might display a warning message in a brain-controllable popover; when this message is dismissed, the framework simply pops and the previously current unit will become current again. The same happens when presenting a popover using a `NoiseTagPopupButtonView`. Last, the stack makes it easy to implement navigation logic, such as in a navigation controller. 

If you want to update the current unit, you can do so using `NoiseTagging.update(view:forNoiseTaggingWithDelegate:)`. This update will only take place if the passed view equals the current unit's view. 


### NoiseTagDelegate

As explained above, the main responsibility of a `NoiseTagDelegate` is to prepare a unit for brain control by assigning actions to controls. When a unit becomes the current unit – because it has been pushed, or because another unit was popped –, or if  `NoiseTagging.update(view:forNoiseTaggingWithDelegate:)` is called, `NoiseTagging` calls `startNoiseTagControlOn(noiseTaggingView:)` on the delegate. The implementation of this function typically looks something like this:

```Swift
import UIKit
import NoiseTagging

class ViewController: UIViewController, NoiseTagDelegate {

	...
	
	// MARK: - NoiseTagDelegate
	
	func startNoiseTagControlOn(noiseTaggingView: UIView) {
		// Add noise tagging actions:
		
		// For some types of controls you add actions directly:
		someNoiseTagButtonView.noiseTagging.addAction(timing: 0) {
			// This code is executed when the button is pressed:
			print("Hello")
		}
		
		// For some types of controls you add actions indirectly. E.g. a NoiseTagPopupButtonView's action always is the same and you only need to enable brain control on it:
		someNoiseTagPopupButtonView.noiseTagControlIsOn = true
	}
}
```

Please note that a unit does *not* need to have a fixed set of controls: each time `startNoiseTagControlOn(noiseTaggingView:)` is called your delegate can choose how it assigns actions to controls, depending on some current state. 

The `noiseTaggingView` argument makes it possible to use one delegate for multiple units.  

`NoiseTagDelegate` has a number of optional functions as well, e.g. to use an alternative background color (`customBackgroundColorFor(view:)`), or to respond to a trial ending without any of the buttons being pressed (`respondToNoClick()`).


## Blocking

Sometimes a new trial should not start untill some (asynchronous) task has finished. For example, if a button press results in an animated transition from one screen to another, the flickering should not start untill the transition is finished. Since `NoiseTagging` has no way of knowing whether such an animation is underway, *you* need to tell it. You do this using *blocking*. 

By calling `blockTrials(forDuration:)`, you let `NoiseTagging` know that it should not start a new trial untill a matching *unblock* occurs. This call also stops any current trial. The `forDuration` argument is optional. If you pass `nil`, you need to call `unblockTrials()` explicitly to unblock. Alternatively you can pass a time interval after which `NoiseTagging` will unblock on your behalf. 

Note that *each* block needs to be unblocked before a new trial may start. This means that if, for example, one block starts at time 1 and has a duration of 3, and another block starts at time 2 and has a duration of 4, for the whole duration of time 1 till time 6 no new trial will be started. 


### Examples

If you have a blocking animation, you can use a completion closure to unblock:

```Swift
// Block trials till our animations are finished:
NoiseTagging.blockTrials()

// Perform animations as part of a transaction, so we can set a completion block:
CATransaction.begin()
CATransaction.setCompletionBlock {
	// Unblock trials again:
	NoiseTagging.unblockTrials()
}

// Perform animations:
...

CATransaction.commit()
```

In some situations you may want to apply blocking, but you cannot use a completion closure to unblock. In these cases pass the time that is needed to complete the tasks:

```Swift
// Block trials till our asynchronous task is finished:
NoiseTagging.blockTrials(forDuration: someDuration)

// Perform some asynchronous task that takes someDuration:
...
```


### Blocking by `NoiseTagging`

The framework itself also applies blocking, for example for:

- Inducing breaks in between trials;
- Not running trials during an update;
- Not running trials during the execution of actions of some of the framework's standard controls.

Note that this implies that if your code no longer imposes any active blocks, the next trial may still need to wait for an *internal* unblock to take place. 


## Trials

This Section explains in more detail what a noise tagging trial consists of, its possible endings, and how each new trial follows up the previous one. 


### Trial Phases

In normal prediction mode, a trial consists of just one phase: the *flicker phase*. In other modes, such as *Generic train*, each trial consists of the following phases:

1. Highlight the target;
2. Pause;
3. Flicker.


### Trial Endings

Each trial ends in one of three possible ways:

1. A button is pressed, either by touch or brain.
2. There is a maximum trial duration, which has passed.
3. The trial is stopped mid-way, for example because `trialsAreRunning` becomes `false`, or an update takes place. 

Beneath these are discussed in more detail. 


#### 1. Button Presses

If a button is pressed, the framework gives visual feedback. The type of visual feedback depends on the `clickFeedbackMode` setting, as well as whether the press was by brain or by touch. For example, the pressed button temporarily becomes smaller, as if it is pressed downwards physically. Or the pressed button temporarily becomes white, while all other buttons become gray. During this visual feedback, trials are blocked. If the `clickSoundOnPress` is `true`, the framework  provides auditory feedback as well. 

Each of the pressed button's actions is performed. Each action has a `timing`, which you pass when adding an action to a button. This timing determines when the action is performed *with respect to* the visual feedback. If `timing` is 0, the action is executed immediately. If it is 1, the action is executed once the visual feedback has finished. If it has a value in between, the action is executed during the visual feedback. 


#### 2. Maximum Trial Durations

Depending on the settings `maxTestTrialDuration` and `disableMaxTestTrialDuration`, trials may have a maximum duration. If this is the case and time runs out, the trial ends. If the `disableNoClicks` setting is `true`, the *most likely* button will be pressed, just like in the case of a 'normal' button press. If  `disableNoClicks` is `false`, the framework gives visual feedback, indicating that no button is being pressed, and no button actions are performed. 


#### 3. Trials Stopped Mid-Way

If `trialsAreRunning` is set to `false` while a trial is running – be it by your own code or because the user swipes up or down with one finger –, the current trial ends as well. In this case there is no visual feedback, except that the flickering stops. 

The same happens if trials are being blocked. For example because you push a noise tagging unit (which results in an update), or because you call `blockTrials(forDuration:)` directly. 


### Inter-Trial Time

The minimum time in between trials is defined by the `timeInBetweenTrials` setting. Note that this is the *minimum* time, because the actual time in between trials may be larger due to blocking.

The framework applies blocking in between trials in order to provide visual feedback before the next trial starts. Furthermore any actions performed as a result of a button being pressed may perform blocking as well. 


## Settings

You can use `NoiseTagging`'s `settings` property to customise how the framework operates. 


### The Settings Screen

If the `twoFingerDoubleTapOpensDeveloperScreen` setting is `true`, the user can double tap with two fingers on the current unit's view in order to bring up the *Developer Screen*. From this screen the user can navigate to the *Settings Screen*, where all of `NoiseTagging`'s settings can be changed directly. 


### Changing Settings Programatically

You access settings by their titles, which are defined in the struct `NoiseTagSettingTitles`. For example:

```swift
let setting_framesPerBit = NoiseTagging.settings.settingWith(title: NoiseTagSettingTitles.framesPerBit)
```

Alternatively you can use some convenience methods of `setOfSettings` to get or set settings more directly:

```swift
// Get an Int setting:
_ = NoiseTagging.settings.intFor(NoiseTagSettingTitles.framesPerBit)

// Set a setting:
NoiseTagging.settings.set(value: 2, for: NoiseTagSettingTitles.framesPerBit)
```


### Important Settings

You can go through all settings to check which ones are relevant for you, but we want to highlight these two:

- **`timeInBetweenTrials`**: By default this is set to 1 second. Once a user is used to the system, you probably want to decrease this value, increasing overall speed. 
- **`certaintyRequiredForClick`**: The MindAffect Decoder sends predictions to iOS about where the user is looking. Each prediction contains a probability. A button is pressed once this probability passes a certain threshold, which is defined by this setting. If a user has a difficulty brain-pressing any buttons, you may want to lower this threshold. This does mean the chance of the wrong button being pressed increases as well.


## Using Noise Tag Controls

As discussed, the NoiseTagging framework for iOS provides a number of control classes you can use straight out of the box. However, if these do not provide what you want, you can easily define your own brain-pressable buttons. For this, see the next Section (*Custom Noise Tag Controls*). 


### `NoiseTagControlProperties`

Each `NoiseTagControl` has a `noiseTagging` property of type `NoiseTagControlProperties`. The purpose of this `noiseTagging` property is to store a number of things that are needed to make noise tagging work. It is also your main point of access to define how each control behaves as a brain-pressable button. 

The most important public part of `NoiseTagControlProperties` is the function `addAction(timing:closure:)`. As we have seen before, this lets you attach a noise tagging action to a control as follows:

```swift
control.noiseTagging.addAction(timing: 0) {
	print("Hello")
}
```

Furthermore, `NoiseTagControlProperties` provides these public variables: `identifier`, `customUtopiaObjectID`, `participatesInFlickering`, `enabled`, and `playClickSoundOnPress`. 

If you want to implement `NoiseTagControl` yourselves, please note that the `noiseTagging` property is provided by the framework automatically, so you do **not** need to implement it yourself.


### Actions and Updates

Please note that although actions are stored inside controls, they are **not** persistent over updates. At the start of each update – for example because a noise tagging unit is pushed or popped –, *all* control actions are deleted. The advantage of this approach is that there is just one single place where the actions of the current set of controls are being defined, namely in the function  `startNoiseTagControlOn(noiseTaggingView:)` of the current unit's delegate. Within that function you simply add actions to controls dependent on your own current state. 


## Custom Noise Tag Controls

Besides using the standard control classes provided by the framework, you can easily define your own brain-pressable buttons. You do this by conforming to the `NoiseTagControl` protocol. 


### `UIView` as `NoiseTagControl`

The easiest way to conform to `NoiseTagControl` is to simply subclass `UIView`. The NoiseTagging framework defines an extension on `UIView` which makes `UIView` conform to `NoiseTagControl` automatically. This extension provides default implementations of all of `NoiseTagControl`'s obligatory methods and properties. You can override these as you see fit. In the next Section we discuss the methods and properties that `NoiseTagControl` defines, as well as the default implementations for `UIView`. 


### `NoiseTagControl` Methods and Properties

#### `func setFlickerColor(color: UIColor)`
This function is called to show a noise tag on the control. The passed color is the current *flicker color*, which is a function of the current bit of the control's noise tag. By default `UIView` sets this color as its layer's background color. 

#### `func setFeedbackColor(color: UIColor?)`
This function is called to show *feedback* colors on the control, for example for *highlighting* – indicating that the user should look at the control during calibration –, or for providing visual feedback when there is a button press. By default `UIView` calls `setFlickerColor(color:)`, passing this color, or if the color is `nil`, it calls `self.updateUIDependingOnNoiseTagging()`. 

#### `func layerToHandleNoiseTagTaps() -> CALayer?`
In order to allow the user to press buttons using touch, the framework performs a simple kind of hit test. A tap is considered to be on a control if it is in the bounds of the layer returned by this function. By default `UIView` simply returns its `layer`.

#### `func layerToAnimateForfeedbackOnTouchPress() -> CALayer`
The framework applies a number of animations to controls. For example it might make a control 'wiggle' to indicate that the user should look at, or it might animate a control's size when it is pressed by touch. These animations are applied to the layer returned by this function. By default `UIView` simply returns its `layer`.

#### `func layerFlickeringPart() -> CALayer`
The framework may use Metal for drawing the parts of the UI that actually flicker. If Metal is used, for each control the contents of the layer returned by this function is what is drawn using Metal, in a view on top of everything else. By default `UIView` simply returns its `layer`.

#### `var isHiddenOrIsInHiddenView: Bool {get}`
The hit test we explained above, in the context of `layerToHandleNoiseTagTaps`, always fails if this function returns `true`. Also, brain presses are only possible on controls for which this returns `false`. This prevents that controls that are in the view hierarchy, invisible but enabled, be it by accident or on purpose, can still be pressed. By default `UIView` returns `false` only if its `isHidden` property is `false` and the same holds for all of its super views. 

#### `func updateUIDependingOnNoiseTagging()`
This allows controls to respond when the state of `NoiseTagging` changes in some way that might be relevant for their appearance. Currently this only is called when the flickering starts or stops. `UIView`'s default implementation is as follows:

```swift
// By default we use setFlickerColor to show the default color for enabled/disabled controls:
self.setFlickerColor(color: self.noiseTagging.enabled ? self.defaultColorWhenEnabled : self.defaultColorWhenDisabled)
```


## Logging

The NoiseTagging framework logs data that might be useful for your own development or research as well. You can access this data in two ways:


### Access Log Files

1. If the `twoFingerDoubleTapOpensDeveloperScreen` setting is `true`, within your app you can double tap with two fingers on the current unit's view in order to bring up the *Developer Screen*. From this screen you can navigate to the *Recordings Screen*, where you can find all log files stored by the framework. 
2. If you enable iTunes file sharing for your app, you can connect your iOS device to a computer and download the files. 


### Recordings

The NoiseTagging framework groups log files in *recordings*. Each recording contains the information that is logged in some meaningful bracket of time, plus optionally some feedback. 

The NoiseTagging framework creates multiple log files. E.g. one log file is about the communication with the Recogniser, another one is about rendering the flicker patterns, and yet another one is about the buttons that have been pressed. 


#### Time Brackets

Each recording has a beginning and – at some point in time – an end. This way all logged information is grouped in meaningful brackets of time. There always is a *current recording*. Whatever is being logged is added to the current recording. Whenever a new recording is started, if there was already a recording running, that recording is stopped. These are the situations in which a new recording is started:

- App is launched.
- App has been in the background for at least 1 hour. 
- We pass 00:00h and the recording has been running for over 23 hours. This way recordings never become ridiculously long. 
- The Developer Screen is opened. Note that this means that you can deliberately end the current recording and start a new one. 
- Whenever re-calibrating. 

The situations above are handled by the NoiseTagging framework, but clients of the framework – that is: specific apps – may also decide when to start a new recording. For example in a game it makes sense to start a new recording each time a new game starts, even if the user does not re-calibrate.

Normally a recording only ends when another recording starts, but if the app crashes the current recording ends as well. In that case it is still safely stored to disk. 


#### Recording Names

Each Recording has a name which helps you find things back easier. For example:

2019-09-23 09/44/45 +0000/ App started – 2.34h in background /2019-09-23 12/05/10 +0000

The part left of the “–” is about the recording’s start: when it started and why it started. The part right of the “–” is about the recording’s end: why it ended and when. Since a recording ends whenever a new recording starts, the right part always matches the left part of the name of the next recording. If a recording ends because the app crashes, the right part of the name will be missing. 


#### Note on the Current Recording

The Recordings Screen only displays finished recordings, which means the current recording is not being displayed. Since we start a new recording whenever entering the Developer Screen and you enter the Recordings Screen via the Developer Screen, normally this does not matter. But if you want to look at information that was logged while you were in the Developer Screen, you first need to end that recording by exiting and reopening the Developer Screen. 
