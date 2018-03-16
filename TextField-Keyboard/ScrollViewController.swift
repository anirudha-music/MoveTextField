//
//  ScrollViewController.swift
//  TextField-Keyboard
//
//  Created by Anirudha on 16/03/18.
//  Copyright © 2018 Anirudha Mahale. All rights reserved.
//

import UIKit

class ScrollViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContentView: UIView!
    var activeTextField: UIView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        scrollContentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(forceEndEditing)))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        forceEndEditing()
    }
    
    @objc private func forceEndEditing() {
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
        let padding: CGFloat = 60
        
        if self.view.frame.origin.y >= 0 {
            if editingTextFieldY > keyboardY - padding {
                let yOffset = self.view.frame.origin.y - (editingTextFieldY - (keyboardY - padding) - getVisibleRect().origin.y)
                print(yOffset)
                self.view.frame.origin.y = yOffset
            }
        }
    }
    
    func getVisibleRect() -> CGRect {
        var visibleRect = CGRect()
        visibleRect.origin = scrollView.contentOffset
        visibleRect.size = scrollView.bounds.size
        
        let theScale: CGFloat = 1.0 / 1.0
        visibleRect.origin.x *= theScale
        visibleRect.origin.y *= theScale
        visibleRect.size.width *= theScale
        visibleRect.size.height *= theScale
        
        return visibleRect
    }
}

extension ScrollViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
}
