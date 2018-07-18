//
//  SignUpViewController.swift
//  Q
//
//  Created by Nicolai Garcia on 7/17/18.
//  Copyright © 2018 Nicolai Garcia. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var QLabel: UILabel!
    
    @IBOutlet weak var UsernameLabel: UILabel!
    
    @IBOutlet weak var PasswordLabel1: UILabel!
    
    @IBOutlet weak var PasswordLabel2: UILabel!
    
    @IBOutlet weak var UsernameField: UITextField!
    
    @IBOutlet weak var PasswordField1: UITextField!
    
    @IBOutlet weak var PasswordField2: UITextField!
    
    @IBOutlet weak var SignUpButton: UIButton! {
        didSet {
            SignUpButton.isEnabled = true
        }
    }
    
    @IBAction func passwordTwoEdited(_ sender: UITextField) {
        if sender.text == PasswordField1.text {
            SignUpButton.isEnabled = true
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SignUp(_ sender: UIButton) {
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
