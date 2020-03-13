//
//  NoiseTagButtonUsingImages.swift
//  Example
//
//  Created by Jop van Heesch on 13/03/2020.
//  Copyright © 2020 MindAffect. All rights reserved.
//

import UIKit
import NoiseTagging


class NoiseTagButtonUsingImages: UIImageView {

	let image0 = UIImage(named: "Image0")
	let image1 = UIImage(named: "Image1")
	
	// By overriding show(appearance:withDefaultColor:) we can use images instead of the default colors used for flickering:
	override func show(appearance: NoiseTagControlAppearance, withDefaultColor defaultColor: UIColor) {
		switch appearance {
		case .Flicker0:
			self.image = self.image0
		case .Flicker1:
			self.image = self.image1
		default:
			self.image = nil
			self.backgroundColor = defaultColor
		}
		
		self.layer.cornerRadius = 10
	}
}
