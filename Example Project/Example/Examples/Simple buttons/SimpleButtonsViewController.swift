//
//  SimpleButtonsViewController.swift
//  Example
//
//  Created by Jop van Heesch on 02/03/2020.
//  Copyright © 2020 MindAffect. All rights reserved.
//

import UIKit
import NoiseTagging


class SimpleButtonsViewController: UIViewController, NoiseTagDelegate {
	
	// UI:
	@IBOutlet weak var button1: NoiseTagButtonView!
	@IBOutlet weak var button2: NoiseTagButtonView!
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		
		// Set our own title:
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
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		// If we are being popped from the navigation controller, we need to pop our unit from the NoiseTagging stack as well:
		if self.isMovingFromParent {
			NoiseTagging.pop()
		}
	}


	// MARK: - NoiseTagDelegate

	func startNoiseTagControlOn(noiseTaggingView: UIView) {
		// If button1 is pressed, we change its title:
		self.button1.noiseTagging.addAction(timing: 0) {
			self.button1.title = self.button1.title == "Hello" ? "Bye" : "Hello"
		}
		
		// If button2 is pressed, we print the title of button1:
		self.button2.noiseTagging.addAction(timing: 0) {
			print("\(self.button1.title ?? "The title of button1 is nil, how can that be?")")
		}
	}
}
