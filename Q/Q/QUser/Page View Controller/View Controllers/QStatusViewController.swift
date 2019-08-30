//
//  QStatusViewController.swift
//  Q
//
//  Created by Nicolai Garcia on 1/3/19.
//  Copyright © 2019 Nicolai Garcia. All rights reserved.
//

import UIKit

class QStatusViewController: UIViewController {
    
    /// Notification that is posted when "START Q" is selected
    static let startQSelected = Notification.Name("startQSelected")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var StartQButton: UIButton!
    
    @IBAction func startQ(_ sender: Any) {
        NotificationCenter.default.post(name: QStatusViewController.startQSelected, object: self) // Post to notification center
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
