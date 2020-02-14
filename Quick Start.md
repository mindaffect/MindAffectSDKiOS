# Quick Start

Follow these steps to create your first NoiseTagging app for iOS:


## Add the Framework to your project

1. Create a new project, or use an existing project. 
2. Select your project in Xcode's Project Navigator, select your target, and open the General tab. Add  **`NoiseTagging.xcframework`** underneath "Frameworks, Libraries, and Embedded Content".


## Create your first Flickering Button

Follow these steps to add a button that can be 'brain pressed':

### Import the Framework

At the top of each file where you want to use NoiseTagging:

```Swift
import NoiseTagging
```

### Create a Button

The NoiseTagging framework provides a number of generic UI components that work well with noise tagging. The simplest of these is the `NoiseTagButtonView` class. Add one using Interface Builder or programatically. For example like this, in your view controller:

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

To make the button flicker, you need to implement the `NoiseTagDelegate` protocol. In the **`Main Programming Guide`** the role of this protocol is discussed in more detail. For now it suffices to say that NoiseTagging will call a function on the delegate (the `NoiseTagDelegate`) to set things up. Within this function you tell NoiseTagging what action should be performed on each button press. 

In this example we make our `ViewController` the delegate:

```Swift
class ViewController: UIViewController, NoiseTagDelegate {
```

And we implement `NoiseTagDelegate`'s one required function:

```Swift
func startNoiseTagControlOn(noiseTaggingView: UIView) {
	// Add noise tagging actions:
	flickeringButton.noiseTagging.addAction(timing: 0) {
		print("Hello")
	}
}
```

Note that we have set a *noise tag action* on our button, which is a closure. NoiseTagging runs this closure whenever the button is pressed, either by brain or by touch. 


### Push

Now add this line at the end of `viewDidLoad`:

```Swift
NoiseTagging.push(view: view, forNoiseTaggingWithDelegate: self)
```

This is what will result in `startNoiseTagControlOn(noiseTaggingView:)` being called on the delegate. The **`Main Programming Guide`** explains what this *push* exactly means, but for now: run your app!


## Run your app

You can run in the Simulator or on a real device, but only on the latter the noise tags will be displayed correctly. 

Your app should show a button with "Hello" on it. Tap it and "Hello" should be printed in Xcode's Console. Swipe up or down and the button should begin to flicker. You can double tap with two fingers to enter the *Developer Screen*. 

One thing is still missing: how can you connect a brain? Double tap with one finger to open the UI for connecting a brain. If you have a MindAffect Decoder and a EEG headset, you should be able to calibrate and then press your button with your brain!


## Full Code Example

The full code looks like this:

```Swift
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
	}
	
	func startNoiseTagControlOn(noiseTaggingView: UIView) {
		// Add noise tagging actions:
		flickeringButton.noiseTagging.addAction(timing: 0) {
			print("Hello")
		}
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
