//
//  AlbumTableViewCell.swift
//  Q
//
//  Created by Nicolai Garcia on 8/8/18.
//  Copyright © 2018 Nicolai Garcia. All rights reserved.
//

import UIKit

class AlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var AlbumArtworkImageView: UIImageView!
    
    @IBOutlet weak var AlbumNameLabel: UILabel!
    
    @IBOutlet weak var ArtistLabel: UILabel!
    
    var mediaItem: MediaItem? {
        didSet {
            AlbumNameLabel.text = mediaItem?.name ?? ""
            ArtistLabel.text = mediaItem?.artistName ?? ""
            DispatchQueue.main.async {
                let artworkUrl = self.mediaItem?.artwork.imageURL(size: CGSize(width: (self.mediaItem?.artwork.width)!, height: (self.mediaItem?.artwork.height)!))
                do {
                    let data = try Data(contentsOf: artworkUrl!)
                    self.AlbumArtworkImageView.image = UIImage(data: data)
                } catch {
                    print("ERROR FETCHING \(self.mediaItem!.name) ARTWORK")
                }
            }
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
