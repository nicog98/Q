//
//  QUserViewController.swift
//  Q
//
//  Created by Nicolai Garcia on 7/22/18.
//  Copyright © 2018 Nicolai Garcia. All rights reserved.
//

import UIKit
import Parse

class QUserViewController: UIViewController, SignUpViewControllerDelegate, LoginViewControllerDelegate {
    
    var user: QUser?
    
    func setUser(user: PFUser) {
        self.user = QUser(user: user)
        UsernameField.text = self.user?.username
    }
    
    @IBOutlet weak var UsernameField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.UsernameField.text = self.user?.username
        // UsernameField.text = self.user?.username
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
