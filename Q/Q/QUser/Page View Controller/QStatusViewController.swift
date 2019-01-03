//
//  QStatusViewController.swift
//  Q
//
//  Created by Nicolai Garcia on 1/3/19.
//  Copyright © 2019 Nicolai Garcia. All rights reserved.
//

import UIKit

protocol QStatusViewControllerDelegate {
    func didSelectStartQ()
}

class QStatusViewController: UIViewController {
    
    var delegate: QStatusViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var StartQButton: UIButton!
    
    @IBAction func startQ(_ sender: Any) {
        delegate?.didSelectStartQ()
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
