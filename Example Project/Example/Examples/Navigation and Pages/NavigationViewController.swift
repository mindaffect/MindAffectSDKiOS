/* Copyright (c) 2016-2020 MindAffect.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */


import UIKit
import NoiseTagging


/**
This example shows how to use `NavigatorTreeOfPages` to create the brain-controllable equivalent of a `UINavigationController`. 
*/
class NavigationViewController: ExampleViewController {

	/**
	We use `navigator` to show our own UI (as a `Page`) and to present our *Sub Pages*.
	*/
	private var navigator: NavigatorTreeOfPages!
		
	/**
	Used for our example View page:
	*/
	private let viewPageViewController = ViewPageViewController(nibName: "ViewPageViewController", bundle: nil)
	
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		
		// Set our title and subTitle, which are shown in the list of examples.
		self.title = "Navigation and Pages"
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override var wantsFullscreen: Bool {
		return true
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		// To prepare our page hierarchy, first we create three pages (one View page, one Settings page, one List page) and then we combine them in another List page, our 'root page':
		
		// 1. Define a View page:
		let viewPage = Page(title: "A View Page", view: self.viewPageViewController.view, viewContainsFakeNavigationBar: true, delegate: self.viewPageViewController)
		viewPage.subTitle = "The contents of a View page is defined as a UIView."
		
		// 2. Define a Settings page. In this example we combine some NoiseTagging settings with a couple of our own settings:
		let settingsNoiseTagging = NoiseTagging.settings.settingsWith(titles: [
			NoiseTagSettingTitles.timeInBetweenTrials, // example of a Double setting
			NoiseTagSettingTitles.contrastMode // example of an Enum setting
			])
		let settings = settingsNoiseTagging + [
			BoolSetting(title: "A Bool Setting", value: true),
			TextSetting(title: "A Text Setting", value: "Some text"),
			IntSetting(title: "An Int Setting", value: 10)
		]
		let frameSettingsPages = CGRect(x: 0, y: 0, width: 1024 * ScalingUI.scaleWRTRegularIPadScreen, height: 640 * ScalingUI.scaleWRTRegularIPadScreen) // todo: calculate or use constants
		let settingsPage = Page(title: "A Settings Page", settings: settings, frame: frameSettingsPages, delegate: self)
		settingsPage.subTitle = "Each Settings page lets the user edit a maximum of six settings."
			
		// 3. Define a List page, containing two (very minimal) sub-pages:
		let subpage1 = Page(title: "Sub-page 1", view: UIView())
		let subpage2 = Page(title: "Sub-page 2", view: UIView())
		let listPage = Page(title: "A List Page", subPages: [subpage1, subpage2])
		listPage.subTitle = "List pages let you build a hierarchy of pages."
				
		// Combine the three pages into our Root page:
		let rootPage = Page(title: "Root Page", subPages: [viewPage, settingsPage, listPage])
		
		// We show our page hierarchy using NavigatorTreeOfPages:
		self.navigator = NavigatorTreeOfPages(presentingView: self.view, initialPage: rootPage)
		
		// If the navigator's closureToPerformOnClose is set, it shows the back button in its root page as well and performs that closure if the button is pressed:
		self.navigator.closureToPerformOnClose = {
			self.navigationController?.popViewController(animated: true)
		}
		
		// Let the navigator present its UI:
		self.navigator.present()
	}
	
	override var shouldPopNoiseTaggingWhenMovingFromParent: Bool {
		return true
	}

	
	// MARK: - NoiseTagDelegate
	
	/**
	See the `NoiseTagDelegate` protocol.
	*/
    func startNoiseTagControlOn(noiseTaggingView: UIView) {
		// Let our navigationHelper take care of adding noise tagging actions:
		self.navigator?.startNoiseTagControl()
	}

}
