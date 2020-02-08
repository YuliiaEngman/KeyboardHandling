//
//  ViewController.swift
//  KeyboardHandling
//
//  Created by Yuliia Engman on 2/3/20.
//  Copyright © 2020 Yuliia Engman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var pursuitLogo: UIImageView!
    @IBOutlet weak var usernametextFiield: UITextField!
    
    @IBOutlet weak var passwordtexField: UITextField!
    @IBOutlet weak var pursuitLogoCenterYConstraint: NSLayoutConstraint!
    
    private var originalYconstraint: NSLayoutConstraint!
    
    private var keyboardIsVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyNotification()
        
        usernametextFiield.delegate = self
        passwordtexField.delegate = self
        
        pulsateLogo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unregisterForKeyboardNotifications()
    }
    
    private func registerForKeyNotification () {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    private func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    private func keyboardWillShow (_ notification: NSNotification) {
        // print("keyboardWillShow")
        //  print(notification.userInfo)
        
        // "UIKeyboardFrameBeginUserInfoKey"
        
        guard let keyboardFrame =
            // on this line of code we get height of the screen
            notification.userInfo?["UIKeyboardFrameBeginUserInfoKey"] as? CGRect else {
            return
        }
        //print("keyboard freme is \(keyboardFrame)")
        //        pursuitLogoCenterYConstraint.constant -= keyboardFrame.size.height
        moveKeyboardUp(keyboardFrame.size.height)
    }
    
    @objc
    private func keyboardWillHide (_ notification: NSNotification) {
        // print("keyboardWillHide")
        // print(notification.userInfo)
        
        //TODO: complete:
        resetUI()
    }
    
    private func moveKeyboardUp(_ height: CGFloat) {
        if keyboardIsVisible { return }
        //print("originalYConstraint: \(originalYconstraint.constant)")
        
        originalYconstraint = pursuitLogoCenterYConstraint // save original value
        
        pursuitLogoCenterYConstraint.constant -= (height * 0.80)
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        keyboardIsVisible = true
    }
    
    private func resetUI() {
        keyboardIsVisible = false
        // -314 = 0, +314
        pursuitLogoCenterYConstraint.constant -=
            originalYconstraint.constant
        
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
            
        }
    }
    private func pulsateLogo() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.repeat, .autoreverse], animations: {
            self.pursuitLogo.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: nil)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

