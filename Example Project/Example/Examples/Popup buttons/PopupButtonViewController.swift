/* Copyright (c) 2016-2020 MindAffect.
Author: Jop van Heesch

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */


import UIKit
import NoiseTagging


/**
This example shows how to use `NoiseTagPopupButtonView` to let users select one out of a number of options. 
*/
class PopupButtonViewController: ExampleViewController {

	var popupButton: NoiseTagPopupButtonView!
	
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		
		// Set our title and subTitle, which are shown in the list of examples. 
		self.title = "Popup buttons"
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Prepare popupButton:
		let margin: CGFloat = 20
		self.popupButton = NoiseTagPopupButtonView(frame: CGRect(x: margin, y: 100, width: min(600, self.view.frame.width - 2 * margin), height: Layout.Buttons.defaultHeight), locationLabel: .Right)
		
		// Set items on the popup button, from which the user can select one:
		self.popupButton.items = [
			NoiseTagPopupItem(title: "Option 1"),
			NoiseTagPopupItem(title: "Option 2"),
			NoiseTagPopupItem(title: "Option 3")
		]
		
		self.view.addSubview(self.popupButton)
    }


	// MARK: - NoiseTagDelegate

	func startNoiseTagControlOn(noiseTaggingView: UIView) {
		self.popupButton.noiseTagControlIsOn = true
	}

}
