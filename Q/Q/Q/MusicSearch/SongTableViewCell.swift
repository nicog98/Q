//
//  SongTableViewCell.swift
//  Q
//
//  Created by Nicolai Garcia on 8/8/18.
//  Copyright © 2018 Nicolai Garcia. All rights reserved.
//

import UIKit

class SongTableViewCell: MusicSearchTableViewCell {

    @IBOutlet weak var SongNameLabel: UILabel!
    
    @IBOutlet weak var ArtistLabel: UILabel!
    
    override var mediaItem: MediaItem? {
        didSet {
            SongNameLabel.text = mediaItem?.name ?? ""
            ArtistLabel.text = mediaItem?.artistName ?? ""
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
