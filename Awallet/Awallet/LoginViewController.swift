//
//  ViewController.swift
//  Awallet
//
//  Created by Stephy Gao on 1/18/21.
//
import PhoneNumberKit
import UIKit

class LoginViewController: UIViewController {
    
    //load PhoneNumberTextField package
    @IBOutlet var textField: PhoneNumberTextField?
    override func viewDidLoad() {
        super.viewDidLoad()
        //prefix for country area code
        self.textField?.withPrefix = true
        //for display country flag
        self.textField?.withFlag = true
        
        //fill textfiled with stored phone number
        textField?.text = Storage.phoneNumberInE164
        
    }
    
    //a tap gesture recognizer
    @IBAction func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            //resign first responder will end the current text field
            self.textField?.resignFirstResponder()
        }
    }
    
//    IOS BIND BUTTON TO VIE CONTROLLER METHOD
    @IBAction func clickNextPage(sender: UIButton) {
        self.textField?.resignFirstResponder()
        
        if let phoneNum = self.textField?.text {
            let clearedPhoneNum = phoneNum.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "")
            
            //Jump to home screen if the stored phone number = the phoneNumber in our textfield
            if let phoneNumber = Storage.phoneNumberInE164 {
                if clearedPhoneNum == phoneNumber {
                    if let newVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "HomeViewController") as? HomeViewController {
                        UIApplication.shared.windows.first?.rootViewController = newVC
                    }
                    return
                }
            }
            
            
            for char in clearedPhoneNum {
                if !char.isNumber {
                    let alert = UIAlertController(title: "Error", message: "Please enter digits only", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "re-enter", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
            if clearedPhoneNum.count != 10{
                let alert = UIAlertController(title: "Error", message: "Phone number is not 10 digit", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "re-enter", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            let fixedPhoneNum = "+1"+clearedPhoneNum
            
            //reset a view controler
            //UIStoryboard(name: "the storyboard's name", bundle: nil).instantiateViewController(identifier: "its view controler's name")(good for transitioning the display but we are still working in out current ViewController)
            
            //now we are working in our current ViewController
            //but we want to get access the next view controller(DisplayNumberViewController in this case)
            if let newVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "displayPhoneNumber") as? VerificationViewController {
                newVC.phoneNumString = fixedPhoneNum
                Api.sendVerificationCode(phoneNumber: fixedPhoneNum) { response, error in
                }
                
                //present from the current view controller to the new view controller
                self.navigationController?.pushViewController(newVC, animated: true)
            }
        }
        
    }
}

