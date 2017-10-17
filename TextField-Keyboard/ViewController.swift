//
//  ViewController.swift
//  TextField-Keyboard
//
//  Created by Anirudha on 11/10/17.
//  Copyright © 2017 Anirudha Mahale. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var activeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetViewFrame()
        view.endEditing(true)
    }
    
    func resetViewFrame() {
        self.view.frame.origin.y = 0
    }
    
    @objc func keyboardDidShow(notification: Notification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration: TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve: UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            var yOffset: CGFloat = 0
            if endFrame?.origin.y ?? 0 >= UIScreen.main.bounds.size.height {
                yOffset = 0.0
            } else {
                yOffset = endFrame?.size.height ?? 0
            }
            
            UIView.animate(withDuration: duration, delay: 0, options: animationCurve, animations: {
                self.view.frame.origin.y = yOffset
            }, completion: nil)
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        resetViewFrame()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
}
