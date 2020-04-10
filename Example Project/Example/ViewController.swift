//
//  ViewController.swift
//  Example
//
//  Created by Jop van Heesch on 02/03/2020.
//  Copyright © 2020 MindAffect. All rights reserved.
//

import UIKit
import NoiseTagging


class ViewController: UIViewController {
		
	var viewDidAppearHasBeenCalled = false
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if !viewDidAppearHasBeenCalled {
			
			viewDidAppearHasBeenCalled = true
			
			// Change NoiseTagging's default settings:
			
			// Enable accessing the Developer screen:
			NoiseTagging.settings.set(value: true, for: NoiseTagSettingTitles.twoFingerDoubleTapOpensDeveloperScreen)
			
			
			// Present a navigation controller with a ListOfExamplesTableViewController as its root. The ListOfExamplesTableViewController shows a list of examples. If the user selects an example, that example is pushed:
			
			// Create a ListOfExamplesTableViewController:
			let listOfExamplesTableViewController = ListOfExamplesTableViewController()
			
			// Create a UINavigationController, which we will present fullscreen:
			let navigationController = UINavigationController(rootViewController: listOfExamplesTableViewController)
			navigationController.modalPresentationStyle = .fullScreen
			
			// Prepare the navigation controller's appearance:
			navigationController.overrideUserInterfaceStyle = .light
			navigationController.navigationBar.barTintColor = kColorMindAffectOrange
			navigationController.navigationBar.isTranslucent = false
			let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
			navigationController.navigationBar.titleTextAttributes = textAttributes
			navigationController.navigationBar.tintColor = UIColor.white
			navigationController.navigationBar.prefersLargeTitles = true
			let navigationBarAppearance = UINavigationBarAppearance()
			navigationBarAppearance.configureWithOpaqueBackground()
			navigationBarAppearance.titleTextAttributes = textAttributes
			navigationBarAppearance.largeTitleTextAttributes = textAttributes
			navigationBarAppearance.backgroundColor = kColorMindAffectOrange
			navigationController.navigationBar.standardAppearance = navigationBarAppearance
			navigationController.navigationBar.scrollEdgeAppearance = navigationBarAppearance
			navigationController.navigationBar.compactAppearance = navigationBarAppearance
			
			// Present the navigationController:
			self.present(navigationController, animated: true, completion: nil)
		}
	}


}

