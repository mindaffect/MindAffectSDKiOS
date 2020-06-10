/* Copyright (c) 2016-2020 MindAffect.
Author: Jop van Heesch

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */


import UIKit
import NoiseTagging


/**
This example shows how to use `NoiseTagButtonView` to show brain-pressable buttons with either an icon or a title. 
*/
class SimpleButtonsViewController: ExampleViewController {
	
	// UI:
	@IBOutlet weak var button1: NoiseTagButtonView!
	@IBOutlet weak var button2: NoiseTagButtonView!
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		
		// Set our title and subTitle, which are shown in the list of examples. 
		self.title = "Simple buttons"
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// On button1 we set a title:
		self.button1.title = "Hello"
		
		// On button2 we set an image:
		self.button2.image = UIImage(named: "Speak")
    }
	

	// MARK: - NoiseTagDelegate

	func startNoiseTagControlOn(noiseTaggingView: UIView) {
		// If button1 is pressed, we change its title:
		self.button1.noiseTagging.addAction(timing: 0) {
			self.button1.title = self.button1.title == "Hello" ? "Bye" : "Hello"
		}
		
		// If button2 is pressed, we print the title of button1:
		self.button2.noiseTagging.addAction(timing: 0) {
			guard let title = self.button1.title else {
				print("The title of button1 is nil, how can that be?")
				return
			}
			
			Saying.say(text: title)
		}
	}
}
