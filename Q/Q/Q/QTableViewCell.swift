//
//  QTableViewCell.swift
//  Q
//
//  Created by Nicolai Garcia on 8/15/18.
//  Copyright © 2018 Nicolai Garcia. All rights reserved.
//

import UIKit
import SDWebImage

class QTableViewCell: UITableViewCell {
    
    @IBOutlet weak var SongLabel: UILabel!
    
    @IBOutlet weak var ArtistLabel: UILabel!
    
    @IBOutlet weak var AlbumArtworkImageView: UIImageView!
    
    var mediaItem: MediaItem? {
        didSet {
            self.SongLabel.text = mediaItem?.name
            self.ArtistLabel.text = mediaItem?.artistName
            guard let artworkUrl = self.mediaItem?.artwork.imageURL(size: CGSize(width: (self.mediaItem?.artwork.width)!, height: (self.mediaItem?.artwork.height)!)) else {
                return
            }
            AlbumArtworkImageView.sd_setImage(with: artworkUrl, placeholderImage: UIImage())
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
