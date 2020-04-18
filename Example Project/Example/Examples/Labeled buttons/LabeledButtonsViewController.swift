/* Copyright (c) 2016-2020 MindAffect.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */


import UIKit
import NoiseTagging


/**
This example shows how to use `NoiseTagLabeledButtonView` to show brain-pressable buttons with both an icon and a title. 
*/
class LabeledButtonsViewController: ExampleViewController {

	private var button1: NoiseTagLabeledButtonView!
	private var button2: NoiseTagLabeledButtonView!
	
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		
		// Set our title and subTitle, which are shown in the list of examples. 
		self.title = "Labeled buttons"
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Prepare the first labeled button:
		let margin: CGFloat = 20
		self.button1 = NoiseTagLabeledButtonView(frame: CGRect(x: margin, y: 100, width: min(600, self.view.frame.width - 2 * margin), height: Layout.Buttons.defaultHeight))
		self.button1.title = "One"
		self.button1.image = UIImage(named: "Speak")
		self.view.addSubview(self.button1)
		
		// Set images and titles on the second labeled button:
		self.button2 = NoiseTagLabeledButtonView(frame: CGRect(x: margin, y: self.button1.frame.origin.y + self.button1.frame.height + margin, width: self.button1.frame.width, height: Layout.Buttons.defaultHeight))
		self.button2.title = "Two"
		self.button2.image = UIImage(named: "Speak")
		self.view.addSubview(self.button2)
    }
	
	override var shouldPopNoiseTaggingWhenMovingFromParent: Bool {
		return true
	}


	// MARK: - NoiseTagDelegate

	func startNoiseTagControlOn(noiseTaggingView: UIView) {
		// If a button is pressed, we print something:
		
		self.button1.noiseTagging.addAction(timing: 0) {
			Saying.say(text: self.button1.title!)
		}
		
		self.button2.noiseTagging.addAction(timing: 0) {
			Saying.say(text: self.button2.title!)
		}
	}
}
