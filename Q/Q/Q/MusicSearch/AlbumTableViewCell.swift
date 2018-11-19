//
//  AlbumTableViewCell.swift
//  Q
//
//  Created by Nicolai Garcia on 8/8/18.
//  Copyright © 2018 Nicolai Garcia. All rights reserved.
//

import UIKit
import SDWebImage

class AlbumTableViewCell: MusicSearchTableViewCell {
    
    @IBOutlet weak var AlbumArtworkImageView: UIImageView!
    
    @IBOutlet weak var AlbumNameLabel: UILabel!
    
    @IBOutlet weak var ArtistLabel: UILabel!
    
    var expanded: Bool = false
    
    override var mediaItem: MediaItem? {
        didSet {
            AlbumNameLabel.text = mediaItem?.name ?? ""
            ArtistLabel.text = mediaItem?.artistName ?? ""
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
    }

}
