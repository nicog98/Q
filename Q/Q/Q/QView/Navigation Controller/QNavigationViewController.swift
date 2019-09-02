//
//  MusicSearchNavigationViewController.swift
//  Q
//
//  Created by Nicolai Garcia on 12/23/18.
//  Copyright © 2018 Nicolai Garcia. All rights reserved.
//

import UIKit

protocol QNavigationViewControllerDelegate {
    
    func didSelectMediaItem(mediaItem: MediaItem)
    
}

class QNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // Delegate to handle media item selected from music search
    var qNavigationViewControllerDelegate: QNavigationViewControllerDelegate?
    
    // Handle Apple Music configuration
    var appleMusicConfiguration: AppleMusicConfiguration?

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
