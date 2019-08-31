//
//  AddCollectionViewCell.swift
//  Q
//
//  Created by Nicolai Garcia on 8/31/19.
//  Copyright © 2019 Nicolai Garcia. All rights reserved.
//

import UIKit

class AddCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var AddImageView: UIImageView! {
        didSet {
            AddImageView.layer.cornerRadius = 8.0
            AddImageView.clipsToBounds = true
        }
    }
    
}
