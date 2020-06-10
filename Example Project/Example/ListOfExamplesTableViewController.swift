/* Copyright (c) 2016-2020 MindAffect.
Author: Jop van Heesch

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */


import UIKit
import NoiseTagging


/**
This VC shows a list of examples, which all are `ExampleViewController`s.

This VC's view is popped on the NoiseTagging stack (and therefore implements `NoiseTagDelegate`) so users can use the gestures provided by the NoiseTagging framework, such as double tapping with two fingers for opening the Developer screen.
*/
class ListOfExamplesTableViewController: UITableViewController, UINavigationControllerDelegate, NoiseTagDelegate {
	
	/**
	Reuse identifier for our table view's cells.
	*/
	private let kCellReuseIdentifier = "Example"
	
	/**
	An array of the VCs which manage the examples.
	*/
	var exampleViewControllers = [ExampleViewController]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Set our title, which is shown in the navigation bar:
		self.title = "Examples"
		
		// Prepare our array of 'example view controllers'. We will display these in a list. The user can go to an example by pressing it in the list:
		self.exampleViewControllers = [
			StartBrainSetupViewController(nibName: "StartBrainSetupViewController", bundle: nil),
			SimpleButtonsViewController(nibName: "SimpleButtonsViewController", bundle: nil),
			LabeledButtonsViewController(),
			PopupButtonViewController(),
			KeyboardViewController(nibName: "KeyboardViewController", bundle: nil),
			NavigationViewController(),
			CustomControlsViewController(nibName: "CustomControlsViewController", bundle: nil),
			]
		
		// Prepare our table view:
		self.tableView.reloadData()
		
		// Push ourselves on the noise tagging stack. We do not show any noise tagging controls, but this way the gestures provided by the NoiseTagging framework, such as opening the Developer Screen by double tapping with two fingers, work on our view as well. The only downside is that the NoiseTagging framework will change our view's background color, which is why we override `customBackgroundColorFor:noiseTaggingView`:
		NoiseTagging.push(view: self.view, forNoiseTaggingWithDelegate: self)
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		// While presenting an Example VC, we may hide our navigation bar. Make sure it is visible again:
		self.navigationController?.setNavigationBarHidden(false, animated: true)
	}
	
	/**
	See `NoiseTagDelegate`. Also see the comments in our `viewDidAppear:animated` implementation.
	*/
	func customBackgroundColorFor(noiseTaggingView: UIView) -> UIColor? {
		return UIColor.white
	}

	
    // MARK: - Table view data source and delegate

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.exampleViewControllers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .subtitle, reuseIdentifier: kCellReuseIdentifier)
		
        // Let the cell display the example VC's title and subTitle:
		cell.textLabel?.text = self.exampleViewControllers[indexPath.row].title
		cell.detailTextLabel?.numberOfLines = 0
		cell.accessoryType = .disclosureIndicator

        return cell
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// Push the selected example:
		let exampleViewController = self.exampleViewControllers[indexPath.row]
		if exampleViewController.wantsFullscreen {
			self.navigationController?.setNavigationBarHidden(true, animated: true)
		}
		self.navigationController?.pushViewController(exampleViewController, animated: true)
		
		// Also push a new unit onto the Noise Tagging stack:
		NoiseTagging.push(view: exampleViewController.view, forNoiseTaggingWithDelegate: exampleViewController)
	}
}
