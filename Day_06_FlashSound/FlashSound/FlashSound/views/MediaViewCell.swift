//
//  MediaViewCell.swift
//  FlashSound
//
//  Created by Ian on 5/16/16.
//  Copyright © 2016 ianchengtw_ios_30_apps_in_30_days. All rights reserved.
//

import UIKit

class MediaViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        self.layer.borderColor = UIColor.blueColor().CGColor
        self.layer.borderWidth = 1
    }
    
}
