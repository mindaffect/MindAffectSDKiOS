//
//  StartBrainSetupViewController.swift
//  Example
//
//  Created by Jop van Heesch on 03/03/2020.
//  Copyright © 2020 MindAffect. All rights reserved.
//

import UIKit
import NoiseTagging


class StartBrainSetupViewController: UIViewController {
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		
		// Set our own title:
		self.title = "Setup brain control"
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@IBAction func setupBrainControl(_ sender: Any) {
		// The NoiseTagging framework provides UI for letting setup brain control. By default the user can enter this UI by double tapping on the view of the current noise tagging unit. But you can also present this UI yourselves, optionally in an existing navigation controller, like we do here:
		NoiseTagging.startBrainSetup(pushedFromNavigationController: self.navigationController) {
			// Once brain setup has finished, we pop ourselves of the navigation stack:
//			self.navigationController?.popViewController(animated: true)
		}
	}
	
}
