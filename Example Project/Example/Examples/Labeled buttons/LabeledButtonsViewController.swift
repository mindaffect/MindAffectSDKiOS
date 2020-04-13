//
//  LabeledButtonsViewController.swift
//  Example
//
//  Created by Jop van Heesch on 02/03/2020.
//  Copyright © 2020 MindAffect. All rights reserved.
//

import UIKit
import NoiseTagging


class LabeledButtonsViewController: UIViewController, NoiseTagDelegate {

	private var button1: NoiseTagLabeledButtonView!
	private var button2: NoiseTagLabeledButtonView!
	
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		
		// Set our own title:
		self.title = "Labeled buttons"
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Prepare the first labeled button:
		let margin: CGFloat = 20
		self.button1 = NoiseTagLabeledButtonView(frame: CGRect(x: margin, y: 100, width: min(600, self.view.frame.width - 2 * margin), height: kDefaultHeightNoiseTagButton), locationLabel: .Right)
		self.button1.title = "One"
		self.button1.image = UIImage(named: "Speak")
		self.view.addSubview(self.button1)
		
		// Set images and titles on the second labeled button:
		self.button2 = NoiseTagLabeledButtonView(frame: CGRect(x: margin, y: self.button1.frame.origin.y + self.button1.frame.height + margin, width: self.button1.frame.width, height: kDefaultHeightNoiseTagButton), locationLabel: .Right)
		self.button2.title = "Two"
		self.button2.image = UIImage(named: "Speak")
		self.view.addSubview(self.button2)
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
		// If a button is pressed, we print something:
		
		self.button1.noiseTagging.addAction(timing: 0) {
			print("button1 pressed")
		}
		
		self.button2.noiseTagging.addAction(timing: 0) {
			print("button2 pressed")
		}
	}
}
