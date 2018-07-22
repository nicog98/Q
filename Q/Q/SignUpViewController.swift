//
//  SignUpViewController.swift
//  Q
//
//  Created by Nicolai Garcia on 7/17/18.
//  Copyright © 2018 Nicolai Garcia. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        UsernameField.delegate = self
        PasswordField1.delegate = self
        PasswordField2.delegate = self
        
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
    
    @IBAction func SignUp(_ sender: UIButton) {
        let user = PFUser()
        user.username = UsernameField.text
        user.password = PasswordField2.text
        
        user.signUpInBackground { (success, error) in
            if let error = error {
                let errorString = error.localizedDescription
                print(errorString)
                // Show the errorString somewhere and let the user try again.
            } else {
                // Hooray! Let them use the app now.
                print("SUCCESSFULLY SIGNED UP \(user.username!) FOR Q")
            }
        }
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
