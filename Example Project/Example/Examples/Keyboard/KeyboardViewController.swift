/* Copyright (c) 2016-2020 MindAffect.
Author: Jop van Heesch

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */


import UIKit
import NoiseTagging


/**
This example shows how to use `NoiseTagKeyboardViewController` to present a brain-controllable keyboard and use it to edit text.
*/
class KeyboardViewController: ExampleViewController {

	// We show a text field whose text can be edited using `NoiseTagKeyboardViewController`:
	@IBOutlet weak var textField: UITextField!
	
	// Create a NoiseTagKeyboardViewController, which provides the actual keyboard:
	let keyboardVC = NoiseTagKeyboardViewController()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		
		// Set our title and subTitle, which are shown in the list of examples. 
		self.title = "Keyboard"
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		// When we appear because keyboardVC is dismissed, we need to pop it from the noise tagging stack (it does not do that automatically):
		if self.keyboardVC.viewIsInCurrentNoiseTaggingUnit {
			NoiseTagging.pop()
			
			// Show the text that has been typed in our text field:
			self.textField.text = self.keyboardVC.typedText
		}
	}
	
	
	// MARK - Actions
	
	@IBAction func editTextPressed(_ sender: Any) {
		// This is hacky, but currently we need to make sure keyboardVC's view is loaded before we present keyboardVC, because some of its setup in viewDidLoad is required:
		_ = self.keyboardVC.view
		
		// We use keyboardVC to let the user change the text that is displayed in our text field:
		self.keyboardVC.typedText = self.textField.text ?? ""
		
		// Set keyboardVC's title, because it will be displayed in our navigation controller:
		self.keyboardVC.title = "Editing Text"
		
		// Push keyboardVC on our navigation controller:
		self.navigationController?.pushViewController(self.keyboardVC, animated: true)
		
		// Push keyboardVC on the NoiseTagging stack:
		NoiseTagging.push(view: self.keyboardVC.view, forNoiseTaggingWithDelegate: self.keyboardVC)
	}
}
