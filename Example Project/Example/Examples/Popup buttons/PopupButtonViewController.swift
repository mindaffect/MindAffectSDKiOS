//
//  PopupButtonViewController.swift
//  Example
//
//  Created by Jop van Heesch on 02/03/2020.
//  Copyright © 2020 MindAffect. All rights reserved.
//

import UIKit
import NoiseTagging


class PopupButtonViewController: UIViewController, NoiseTagDelegate {

	var popupButton: NoiseTagPopupButtonView!
	
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		
		// Set our own title:
		self.title = "Popup buttons"
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Prepare popupButton:
		let margin: CGFloat = 20
		self.popupButton = NoiseTagPopupButtonView(frame: CGRect(x: margin, y: 100, width: min(600, self.view.frame.width - 2 * margin), height: kDefaultHeightNoiseTagButton), locationLabel: .Right)
		
		// Set items on the popup button, from which the user can select one:
		self.popupButton.items = [
			NoiseTagPopupItem(title: "Option 1"),
			NoiseTagPopupItem(title: "Option 2"),
			NoiseTagPopupItem(title: "Option 3")
		]
		
		self.view.addSubview(self.popupButton)
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
		self.popupButton.noiseTagControlIsOn = true
	}

}
