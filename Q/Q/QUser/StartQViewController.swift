//
//  StartQ.swift
//  Q
//
//  Created by Nicolai Garcia on 1/3/19.
//  Copyright © 2019 Nicolai Garcia. All rights reserved.
//

import UIKit

class StartQViewController: UIViewController {
    
    @IBAction func StartQ(_ sender: Any) {
        performSegue(withIdentifier: "ShowQ", sender: sender)
    }
    
}
