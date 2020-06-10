/* Copyright (c) 2016-2020 MindAffect.
Author: Jop van Heesch

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */


import UIKit
import NoiseTagging


/**
This is an abstract superclass for all examples shown by `ListOfExamplesTableViewController`. 
*/
class ExampleViewController: UIViewController, NoiseTagDelegate {
	
	/**
	By default each example is presented inside `ListOfExamplesTableViewController`'s navigation controller. Subclasses of `ExampleViewController` can override this if they want to be presented fullscreen:
	*/
	var wantsFullscreen: Bool {
		return false
	}
		
	override var prefersStatusBarHidden: Bool {
		return self.wantsFullscreen
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		// If we are being popped from the navigation controller, we need to pop our own unit from the NoiseTagging stack as well:
		if self.isMovingFromParent {
			NoiseTagging.pop()
		}
	}
}

