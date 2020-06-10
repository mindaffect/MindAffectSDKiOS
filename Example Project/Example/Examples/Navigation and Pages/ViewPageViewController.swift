/* Copyright (c) 2016-2020 MindAffect.
Author: Jop van Heesch

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */


import UIKit
import NoiseTagging


/**
This view controller is used for an example View page by `NavigationViewController. See the xib file for more information.
*/
class ViewPageViewController: UIViewController, NoiseTagDelegate {

	@IBOutlet weak var button: NoiseTagButtonView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		// Our view will be displayed by a `NavigatorTreeOfPages`. Instead of using auto-layout, our view has been designed to fit a 12.9-inch iPad and we use `ScalingUI` to make the view fit any screen:
		ScalingUI.From12inch9.scale(view: self.view)
		
		self.button.title = "x"
    }


    // MARK: - NoiseTagDelegate

	func startNoiseTagControlOn(noiseTaggingView: UIView) {
		self.button.noiseTagging.addAction(timing: 0) {
			Saying.say(text: "X pressed")
		}
	}
}
