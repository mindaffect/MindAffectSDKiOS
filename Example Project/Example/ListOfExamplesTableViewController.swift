//
//  ListOfExamplesTableViewController.swift
//  Example
//
//  Created by Jop van Heesch on 02/03/2020.
//  Copyright © 2020 MindAffect. All rights reserved.
//

import UIKit
import NoiseTagging


class ListOfExamplesTableViewController: UITableViewController, UINavigationControllerDelegate {
	
	private let kCellReuseIdentifier = "Example"
	var exampleViewControllers = [UIViewController]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Set our own title:
		self.title = "Examples"
		
		// Prepare our array of 'example view controllers'. We will display these in a list. The user can go to an example by pressing it in the list:
		self.exampleViewControllers = [
			StartBrainSetupViewController(nibName: "StartBrainSetupViewController", bundle: nil),
			SimpleButtonsViewController(nibName: "SimpleButtonsViewController", bundle: nil),
			LabeledButtonsViewController(),
			PopupButtonViewController(),
			KeyboardViewController(nibName: "KeyboardViewController", bundle: nil),
			CustomControlsViewController(nibName: "CustomControlsViewController", bundle: nil),
			]
		
		// Prepare our table view:
		self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: kCellReuseIdentifier)
		self.tableView.reloadData()
    }
	
	
    // MARK: - Table view data source and delegate

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.exampleViewControllers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellReuseIdentifier, for: indexPath)
		
        // Let the cell display the example VC's title:
		cell.textLabel?.text = self.exampleViewControllers[indexPath.row].title
		
		cell.accessoryType = .disclosureIndicator

        return cell
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// Push the selected example:
		let exampleViewController = self.exampleViewControllers[indexPath.row]
		self.navigationController?.pushViewController(exampleViewController, animated: true)
		
		// If the example VC is a NoiseTagDelegate, also push a new unit onto the Noise Tagging stack:
		if let noiseTagDelegate = exampleViewController as? NoiseTagDelegate {
			NoiseTagging.push(view: exampleViewController.view, forNoiseTaggingWithDelegate: noiseTagDelegate)
		}
	}



}
