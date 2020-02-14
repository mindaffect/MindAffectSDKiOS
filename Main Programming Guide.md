# Main Programming Guide

This guide describes the most important concepts and functionalities of the NoiseTagging framework for iOS. By reading this document, you make sure you can use the framework effectively. 


## Overview

This Section gives an overview of the most important pieces. Subsequent Sections discuss a number of tasks in more detail. 


### Controls

A _control_ is an object that conforms to the `NoiseTagControl` protocol. Being a control means being a brain-pressable button. (In the future non-button control types might become availalable as well.) The most important tasks of these buttons are: 1) to show noise tags, and 2) to perform actions when they are being pressed, be it by brain or finger. 

You can easily define your own `NoiseTagControl`-conformant classes, but you can also simply use the standard control classes, such as `NoiseTagButtonView`. 


### NoiseTagging

`NoiseTagging` gives you easy access to a singleton `NoiseTagController`. This singleton – from now on referred to as `NoiseTagging` – is the conductor of most of what the NoiseTagging framework does, such as starting and stopping trials, making controls flicker, and communicating with the MindAffect Decoder.

`NoiseTagging` is also your main gateway to using the framework. You use it to define which controls should flicker, to provide  the user with UI to setup brain control, to customize noise tagging settings, etcetera. 


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

- The view merely acts as an identifier, but generally it is the view in which the brain-controllable controls reside. 
- The delegate is responsible for preparing for brain control when the unit becomes the current unit. Primarily this means assigning actions to controls. The `NoiseTagDelegate` protocol also lets you make customizations, or respond to certain events, such as a trial ending. 

`NoiseTagging` keeps a stack of units, called the *unit stack*. If you want to make a certain set of your own controls brain-controllable, you push your own unit onto the stack: `NoiseTagging.push(view:forNoiseTaggingWithDelegate:)`. Once your unit becomes the current unit, your delegate will be asked to make preparations (see next Section).

You can pop the current unit using `NoiseTagging.pop()`. This removes the current unit from the stack and makes the now-top-most unit the current unit again. 

The fact that we use this stack has a number of advantages. E.g. the framework might display a warning message in a brain-controllable popover; when this message is dismissed, the framework simply pops and the previously current unit will become current again. The same happens when presenting a popover using a `NoiseTagPopupButtonView`. Last, the stack makes it easy to implement navigation logic, such as in a navigation controller. 


### NoiseTagDelegate

As explained above, the main responsibility of a `NoiseTagDelegate` is to prepare a unit for brain control by assigning actions to controls. When a unit becomes the current unit – because it has been pushed, or because another unit was popped –, `NoiseTagging` calls `startNoiseTagControlOn(noiseTaggingView:)` on the delegate. This typically looks something like this:

```
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

`NoiseTagDelegate` has a number of optional functions as well, e.g. to use an alternative background color (`customBackgroundColorFor(view:)`), or to respond to a trial ending without any of the buttons being pressed (`respondToNoClick()`).
