/* Copyright (c) 2016-2020 MindAffect.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */


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
			let listOfExamplesTableViewController = ListOfExamplesTableViewController(nibName: "ListOfExamplesTableViewController", bundle: nil)
			
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

