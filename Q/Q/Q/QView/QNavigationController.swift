//
//  QNavigationController.swift
//  Q
//
//  Created by Nicolai Garcia on 11/9/18.
//  Copyright © 2018 Nicolai Garcia. All rights reserved.
//

import UIKit

class QNavigationController: UINavigationController {
    
    var appleMusicController: AppleMusicController!
    var appleMusicAuthorizationController: AppleMusicAuthorizationController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
