# Quick Start

Follow these steps to create your first NoiseTagging app for iOS:

## Download the Framework

If you have not yet done already, download the ios_noise_tagging repo from BitBucket: https://bitbucket.org/mindaffect_bci/ios_noise_tagging/src/master/. 

## Build the Framework

1. Open NoiseTagging.xcodeproj. 
2. Build the framework for a real iOS device. Note that currently we do not create a *fat* or *universal* framework, so either you build the framework for use in the Simulator, or you build the framework for use on real devices. 
3. You find the framework – NoiseTagging.framework – in the project navigator in the *products* group.

## Add the Framework to your project

1. Create a new project, or use an existing project. **Important**: currently the NoiseTagging framework assumes that apps are running on a large iPad Pro.
2. Drag the framework that you just build into your own project. In the dialog that appears, tick "Copy items if needed" and untick "Add to targets". 
3. Select your project in the project navigator, select your app target in the project and target list, and add NoiseTagging.framework to the list of Embedded Binaries.

## Create your first Flickering Button

Follow these steps to add a button that can be 'brain pressed':

### Import the Framework

At the top of each file where you want to use NoiseTagging:

```Swift
import NoiseTagging
```

### Create a Button

The NoiseTagging framework provides a number of generic UI components that work well with noise tagging. The simplest of these is the *NoiseTagButtonView* class. Add one using Interface Builder or programatically. For example like this, in your view controller:

```Swift
let flickeringButton = NoiseTagButtonView(frame: CGRect(x: 20, y: 20, width: 300, height: 300))

override func viewDidLoad() {
	super.viewDidLoad()

	// Set properties on our button:
	flickeringButton.title = "Hello"

	// Add the button to the view hierarchy:
	view.addSubview(flickeringButton)
}
```

### Implement the `NoiseTagDelegate` Protocol

To make the button flicker, you need to implement the `NoiseTagDelegate` protocol. Later on I will discuss the role of this protocol in more detail. For now it suffices to say that NoiseTagging will call a function on the delegate (the `NoiseTagDelegate`) to set things up. Within this function you tell NoiseTagging what action should be performed on each button press. 

In this example we make our `ViewController` the delegate:

```
class ViewController: UIViewController, NoiseTagDelegate {
```

And we implement `NoiseTagDelegate`'s one required function:

```
func startNoiseTagControlOn(noiseTaggingView: UIView) {
	// Set noise tagging actions:
	flickeringButton.setNoiseTagAction {
		print("Hello")
	}
}
```

Note that we have set a *noise tag action* on our button, which is a closure. NoiseTagging runs this closure whenever the button is pressed, either by brain or by touch. 

### Push

Now add this line at the end of `viewDidLoad`:

```
NoiseTagging.push(view: view, forNoiseTaggingWithDelegate: self)
```

This is what will result in `startNoiseTagControlOn:noiseTaggingView` being called on the delegate. In ... I will discuss what this *push* exactly means, but for now: run your app! Remember that you have build the NoiseTagging framework for real devices only, so run your app on a real device. 

Your app should now show a button with "Hello" on it. Tap it and "Hello" should be printed in Xcode's Console. Swipe up or down and the button should begin to flicker. Double tap with two fingers to enter the *Developer Screen*. 

One thing is still missing: how can you connect a brain? 

### Provide Access to the Brain Control Layer

The NoiseTagging framework provides UI for letting users set everything up – connect with the MA Decoder, fit the headset, and calibrate. This UI is called *the Brain Control Layer*. It is your responsibility to provide access to the Brain Control Layer, for example like this:

```
...
// Add a button to enter the Brain Control Layer:
let brainControlButton = UIButton(frame: CGRect(x: 20, y: 350, width: 1, height: 1))
brainControlButton.setTitle("Enter Brain Control", for: .normal)
brainControlButton.sizeToFit()
brainControlButton.addTarget(self, action: #selector(enterBrainControlLayer), for: .touchUpInside)
view.addSubview(brainControlButton)
...

@objc func enterBrainControlLayer() {
	NoiseTagging.enterBrainControlLayerFrom(view: view)
}
```

Go ahead and try it out! If you have a complete MindAffect setup, you can now press your button with your brain!

### Full Code Example

The full code looks like this:

```
import UIKit
import NoiseTagging

class ViewController: UIViewController, NoiseTagDelegate {

	let flickeringButton = NoiseTagButtonView(frame: CGRect(x: 20, y: 20, width: 300, height: 300))
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Set properties on our button:
		flickeringButton.title = "Hello"
		
		// Add the button to the view hierarchy:
		view.addSubview(flickeringButton)
		
		// Push our view on the NoiseTagging stack:
		NoiseTagging.push(view: view, forNoiseTaggingWithDelegate: self)
		
		// Add a button to enter the Brain Control Layer:
		let brainControlButton = UIButton(frame: CGRect(x: 20, y: 350, width: 1, height: 1))
		brainControlButton.setTitle("Enter Brain Control", for: .normal)
		brainControlButton.sizeToFit()
		brainControlButton.addTarget(self, action: #selector(enterBrainControlLayer), for: .touchUpInside)
		view.addSubview(brainControlButton)
	}
	
	func startNoiseTagControlOn(noiseTaggingView: UIView) {
		// Set noise tagging actions:
		flickeringButton.setNoiseTagAction {
			print("Hello")
		}
	}
	
	@objc func enterBrainControlLayer() {
		NoiseTagging.enterBrainControlLayerFrom(view: view)
	}
}
```

## Further Reading

We recommend that next you read the *Main Programming Guide*. This guide provides an overview of everything you need to know to start developing your own amazing, brain-controllable iOS apps!


<!---

### The Noise Tagging Stack

For you to understand what is going on in the next steps, let us first discuss the *noise tagging stack*. 

The noise tagging stack is maintained by NoiseTagging and is a stack of *noise tagging units*. Each noise tagging unit consists of a `UIView` and a `NoiseTagDelegate`. Units can be pushed onto the stack and they can be popped. The unit at the top of the stack is the *active unit*. 

Your code and NoiseTagging work togethether in order to make the appropriate buttons flicker, based on the active unit. This works as follows:
1. You push a noise tagging unit by calling `NoiseTagging.push:view:forNoiseTaggingWithDelegate`, passing a view and a delegate. 
2. NoiseTagging calls `startNoiseTagControlOn:noiseTaggingView` on the delegate, passing the view.
3. The delegate assigns *noise tagging actions* to buttons. The view is passed so you can have one object which is the delegate for multiple units and use that view to know which buttons should get actions. 
4. NoiseTagging takes care of performing the set noise tagging actions whenever a button is pressed. 

### Implement the NoiseTagDelegate Protocol




Use the Framework
Simple Example
Related articles


--->
