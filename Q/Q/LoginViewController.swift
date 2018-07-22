//
//  LoginViewController.swift
//  Q
//
//  Created by Nicolai Garcia on 7/10/18.
//  Copyright © 2018 Nicolai Garcia. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {
    
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
        PFUser.logInWithUsername(inBackground: UsernameTextField.text!, password: PasswordTextField.text!) { (user: PFUser?, error: Error?) in
            if let error = error {
                let errorString = error.localizedDescription
                print(errorString)
            } else {
                print("SUCCESSFULLY LOGGED IN \(user!.username!)")
            }
        }
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowSignUpPage", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        UsernameTextField.delegate = self
        PasswordTextField.delegate = self

        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    var screenMoved: Bool = false
    
    @objc func keyboardWillShow(notification: Notification) {
        if !screenMoved, let keyboardSize = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= keyboardSize.height
            screenMoved = true
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if screenMoved, let _ = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y = 0
            screenMoved = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

