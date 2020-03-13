//
//  CustomControlsViewController.swift
//  Example
//
//  Created by Jop van Heesch on 13/03/2020.
//  Copyright © 2020 MindAffect. All rights reserved.
//

import UIKit
import NoiseTagging


class CustomControlsViewController: UIViewController, NoiseTagDelegate {

	@IBOutlet weak var customButton: NoiseTagButtonUsingImages!
	
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		
		// Set our own title, which is shown in the navigation bar:
		self.title = "Custom Controls"
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		// If we are being popped from the navigation controller, we need to pop our own unit from the NoiseTagging stack as well:
		if self.isMovingFromParent {
			NoiseTagging.pop()
		}
	}
	
	
	// MARK: - NoiseTagDelegate
	
	func startNoiseTagControlOn(noiseTaggingView: UIView) {
		customButton.noiseTagging.addAction(timing: 0) {
			print("Button pressed")
		}
	}
}
