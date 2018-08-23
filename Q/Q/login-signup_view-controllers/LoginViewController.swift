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
    
    // The 'UserDefaults' key for storing and retrieving user login information so user can be auto-logged in to their account
    static let usernameUserDefaultsKey = "UsernameUserDefaultsKey"
    
    static let passwordUserDefaultsKey = "PasswordUserDefaultsKey"
    
    @IBOutlet weak var QLabel: UILabel!
    
    @IBOutlet weak var UsernameLabel: UILabel!

    @IBOutlet weak var PasswordLabel: UILabel!
    
    @IBOutlet weak var UsernameTextField: UITextField!
    
    @IBOutlet weak var PasswordTextField: UITextField!
    
    @IBOutlet weak var SignInActivityIndicator: UIActivityIndicatorView! {
        didSet {
            self.SignInActivityIndicator.isHidden = true
        }
    }
    
    private var usernameEdited: Bool = false
    
    private var passwordEdited: Bool = false
    
    public var user: PFUser?
    
    func loginUser(username: String, password: String, firstTime: Bool) {
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                let errorString = error.localizedDescription
                print(errorString)
            } else {
                print("SUCCESSFULLY LOGGED IN \(user!.username!)")
                self.user = user
                self.SignInActivityIndicator.stopAnimating()
                self.SignInActivityIndicator.isHidden = true
                
                // store login information in user defaults
                if firstTime {
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(self.UsernameTextField.text, forKey: LoginViewController.usernameUserDefaultsKey)
                    userDefaults.set(self.PasswordTextField.text, forKey: LoginViewController.passwordUserDefaultsKey)
                }
                
                self.performSegue(withIdentifier: "ShowQUserViewFromSignIn", sender: nil)
            }
        }
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        self.SignInActivityIndicator.isHidden = false
        self.SignInActivityIndicator.startAnimating()
        loginUser(username: self.UsernameTextField.text!, password: self.PasswordTextField.text!, firstTime: true)
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
    
    override func viewWillAppear(_ animated: Bool) {
        // attempt to retrieve user login information if stored in user defaults
        let userDefaults = UserDefaults.standard
        if let username = userDefaults.string(forKey: LoginViewController.usernameUserDefaultsKey), let password = userDefaults.string(forKey: LoginViewController.passwordUserDefaultsKey) {
            loginUser(username: username, password: password, firstTime: false)
        }
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowQUserViewFromSignIn") {
            if let qUser = segue.destination as? QUserViewController {
                qUser.user = QUser(user: self.user!)
            }
        }
    }

}

