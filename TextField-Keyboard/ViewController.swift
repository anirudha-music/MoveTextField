//
//  ViewController.swift
//  TextField-Keyboard
//
//  Created by Anirudha on 11/10/17.
//  Copyright © 2017 Anirudha Mahale. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var activeTextField: UIView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if let navHeight = self.navigationController?.navigationBar.frame.height {
            self.view.frame.origin.y = 0 + navHeight + UIApplication.shared.statusBarFrame.height
        } else {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func keyboardDidShow(notification: Notification) {
        let info: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        print(keyboardSize)
        let keyboardY = self.view.frame.height - keyboardSize.height
        let editingTextFieldY = self.activeTextField.frame.origin.y
        //MARK:- This is the paddin between the keyboard and the textView or textField
        let padding: CGFloat = self.activeTextField.frame.height+8
        
        if self.view.frame.origin.y >= 0 {
            if editingTextFieldY > keyboardY - padding {
                let yOffset = self.view.frame.origin.y - (editingTextFieldY - (keyboardY - padding))
                self.view.frame.origin.y = yOffset
            }
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
}
