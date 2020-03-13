//
//  KeyboardViewController.swift
//  Example
//
//  Created by Jop van Heesch on 10/03/2020.
//  Copyright © 2020 MindAffect. All rights reserved.
//

import UIKit
import NoiseTagging


class KeyboardViewController: UIViewController {

	@IBOutlet weak var textField: UITextField!
	
	// Create a NoiseTagKeyboardViewController, which provides the actual keyboard:
	let keyboardVC = NoiseTagKeyboardViewController()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		
		// Set our own title, which is shown in the navigation bar:
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
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		// If we are being popped from the navigation controller, we need to pop our own unit from the NoiseTagging stack as well:
		if self.isMovingFromParent {
			NoiseTagging.pop()
		}
	}
	
	
	// MARK - Actions
	
	@IBAction func editTextPressed(_ sender: Any) {
		// This is hacky, but currently we need to make sure keyboardVC's view is loaded before we present keyboardVC, because some of its setup in viewDidLoad is required:
		_ = self.keyboardVC.view
		
		// We use keyboardVC to let the user change the text that is displayed in our text field:
		self.keyboardVC.typedText = self.textField.text ?? ""
		
		// Set keyboardVC's title, because it will be displayed in our navigation controller:
		self.keyboardVC.title = "Typing"
		
		// Push keyboardVC on our navigation controller:
		self.navigationController?.pushViewController(self.keyboardVC, animated: true)
		
		// Push keyboardVC on the NoiseTagging stack:
		NoiseTagging.push(view: self.keyboardVC.view, forNoiseTaggingWithDelegate: self.keyboardVC)
	}
	
	
	// MARK: - NoiseTagDelegate
	
	func startNoiseTagControlOn(noiseTaggingView: UIView) {
		// NOTE: We do not need to do anything here, because we have pushed keyboardVC on the NoiseTagging stack.
	}
}
