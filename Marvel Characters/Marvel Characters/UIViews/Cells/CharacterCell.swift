//
//  CharacterCell.swift
//  Marvel Characters
//
//  Created by Hugo Alonso on 5/26/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import UIKit

class CharacterCell: UITableViewCell {
   
    @IBOutlet weak var bannerImage : UIImageView!
    @IBOutlet weak var nameLabel : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let nameLabel = nameLabel as? UIButton {
            nameLabel.titleLabel?.adjustsFontSizeToFitWidth = false
            nameLabel.titleLabel?.autoresizesSubviews = true
            nameLabel.autoresizingMask = [UIViewAutoresizing.flexibleRightMargin , UIViewAutoresizing.flexibleTopMargin]
        }
  }
}
