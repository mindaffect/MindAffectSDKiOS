/* Copyright (c) 2016-2020 MindAffect.
Author: Jop van Heesch

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */


import UIKit
import NoiseTagging


/**
This example shows how to present UI for letting the user setup brain control.

In this example the Brain Control Setup UI is pushed on the existing navigation controller.

Note that if NoiseTagging's `doubleTapOpensBrainSetup` setting is `true`, users can also enter the Brain Control Setup UI by double tapping on the view of the current noisetagging unit. 
*/
class StartBrainSetupViewController: ExampleViewController {
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

		// Set our title and subTitle, which are shown in the list of examples.
		self.title = "Brain Control Setup"
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@IBAction func setupBrainControl(_ sender: Any) {
		// The NoiseTagging framework provides UI for letting setup brain control. By default the user can enter this UI by double tapping on the view of the current noise tagging unit. But you can also present this UI yourselves, optionally in an existing navigation controller, like we do here:
		NoiseTagging.startBrainSetup(pushedFromNavigationController: self.navigationController) {
			// Once brain setup has finished, we pop the Brain Setup UI of the navigation stack. Note that the Brain Setup UI does not pop itself, because you could also want to push the next VC on the navigation stack.
			self.navigationController?.popViewController(animated: true)
			
			// We also pop ourselves, so we get back in the list of examples:
			self.navigationController?.popViewController(animated: true)
		}
	}
	
	/**
	See `NoiseTagDelegate`.
	*/
	func customBackgroundColorFor(noiseTaggingView: UIView) -> UIColor? {
		return UIColor.white
	}
	
}
