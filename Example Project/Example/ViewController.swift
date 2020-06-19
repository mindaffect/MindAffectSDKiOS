/* Copyright (c) 2016-2020 MindAffect.
Author: Jop van Heesch

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */


import UIKit
import NoiseTagging


class ViewController: UIViewController {
			
	var presentedNavigationController: UINavigationController!
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if self.presentedNavigationController == nil {
			
			// Change NoiseTagging's default settings:
			
			// Enable accessing the Developer screen:
			NoiseTagging.settings.set(boolValue: true, for: NoiseTagSettingTitles.twoFingerDoubleTapOpensDeveloperScreen)
			
			// In this app controls do not change within trials, so we can safely enable Metal for rendering, which should be more precise (see `useMetal` for a more elaborate explanation):
			NoiseTagging.settings.set(boolValue: true, for: NoiseTagSettingTitles.useMetal)
			
			// Disable NoiseTagging printing in the console:
//			NoiseTagging.settings.set(boolValue: false, for: NoiseTagSettingTitles.noiseTaggingPrintsToTheConsole)
			
			
			// Present a navigation controller with a ListOfExamplesTableViewController as its root. The ListOfExamplesTableViewController shows a list of examples. If the user selects an example, that example is pushed:
			
			// Create a ListOfExamplesTableViewController:
			let listOfExamplesTableViewController = ListOfExamplesTableViewController(nibName: "ListOfExamplesTableViewController", bundle: nil)
			
			// Create a UINavigationController, which we will present fullscreen:
			self.presentedNavigationController = UINavigationController(rootViewController: listOfExamplesTableViewController)
			self.presentedNavigationController.modalPresentationStyle = .fullScreen
			
			// Prepare the navigation controller's appearance:
			self.presentedNavigationController.overrideUserInterfaceStyle = .light
			self.presentedNavigationController.navigationBar.barTintColor = kColorMindAffectOrange
			self.presentedNavigationController.navigationBar.isTranslucent = false
			let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
			self.presentedNavigationController.navigationBar.titleTextAttributes = textAttributes
			self.presentedNavigationController.navigationBar.tintColor = UIColor.white
			self.presentedNavigationController.navigationBar.prefersLargeTitles = true
			let navigationBarAppearance = UINavigationBarAppearance()
			navigationBarAppearance.configureWithOpaqueBackground()
			navigationBarAppearance.titleTextAttributes = textAttributes
			navigationBarAppearance.largeTitleTextAttributes = textAttributes
			navigationBarAppearance.backgroundColor = kColorMindAffectOrange
			self.presentedNavigationController.navigationBar.standardAppearance = navigationBarAppearance
			self.presentedNavigationController.navigationBar.scrollEdgeAppearance = navigationBarAppearance
			self.presentedNavigationController.navigationBar.compactAppearance = navigationBarAppearance
			
			// Present the navigationController:
			self.present(self.presentedNavigationController, animated: true, completion: nil)
		}
	}
}

