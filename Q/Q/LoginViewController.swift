//
//  LoginViewController.swift
//  Q
//
//  Created by Nicolai Garcia on 7/10/18.
//  Copyright © 2018 Nicolai Garcia. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var QLabel: UILabel!
    
    @IBOutlet weak var UsernameLabel: UILabel!

    @IBOutlet weak var PasswordLabel: UILabel!
    
    @IBOutlet weak var UsernameTextField: UITextField!
    
    @IBOutlet weak var PasswordTextField: UITextField!
    
    private var usernameEdited: Bool = false
    
    private var passwordEdited: Bool = false
    
    @IBAction func userNameFieldEdited(_ sender: UITextField) {
        usernameEdited = true
        if (passwordEdited) {
            // login
        }
    }
    
    @IBAction func passwordFieldEdited(_ sender: UITextField) {
        passwordEdited = true
        if (usernameEdited) {
            // login
        }
    }
    
    @IBAction func signIn(_ sender: UIButton) {
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowSignUpPage", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

