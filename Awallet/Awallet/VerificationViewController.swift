import UIKit

//for substring
extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        let end = index(start, offsetBy: min(self.count - range.lowerBound,
                                             range.upperBound - range.lowerBound))
        return String(self[start..<end])
    }

    subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
         return String(self[start...])
    }
}

class VerificationViewController: UIViewController, // can only extend one class
                                PinTexFieldDelegate // implement multiple protocols
{
    @IBOutlet var label: UILabel?
    @IBOutlet var fields: [UITextField]?
    
    var phoneNumString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.label?.text = "Enter the code sent to "+self.phoneNumString
        
        //if let element = fields?[0]
        //{element.becomeFirstResponder()}
        //or
        //let element = fields?[0]
        //element?.becomeFirstResponder()
        fields?[0].becomeFirstResponder()
    }
    
    //check if backspace is pressed
    func didPressBackspace(textField : PinTextField) {
        //if the current textfield isn't empty, keep cursor at current textfield and empty the textfield
        if let text = textField.text {
            if text != "" {
                textField.text = ""
                return
            }
        }
        
        //if the current textfield is empty, move to the previous
        if let index = fields?.firstIndex(of: textField) {
            if index == 0 {
            } else {
                fields?[index-1].text = ""
                fields?[index-1].becomeFirstResponder()
            }
        }
        
    }
    
    @IBAction func fieldChanged(sender: UITextField) {
        
        //void input 2 characters into 1 textfield
        if let text = sender.text {
            if text.count > 1 {
                let character: Character = "e"
                //replace text if already filled
                sender.text = String(text.last ?? character)
            }
        }
        
        //if text length = 6 then auto paste and start verification
        if let text = sender.text {
            if text.count == 6 {
                var index = 0
                for char in text {
                    fields?[index].text = String(char)
                    index+=1
                }
                startVerifcation()
                return
            }
        }
        
        //input 1 by 1 until index 5
        if let index = fields?.firstIndex(of: sender) {
            if index == 5 {
                startVerifcation()
            } else {
                fields?[index+1].becomeFirstResponder()
            }
        }
    }
    func startVerifcation() {
        var codeString = ""
        if let fields = fields {
            for field in fields {
                // A ?? B means if A is not optional, then return A. otherwise return B
                codeString += field.text ?? ""
            }
        }

        Api.verifyCode(phoneNumber: phoneNumString, code: codeString) { response, error in
            if let err = error {
                let alert = UIAlertController(title: "Error", message: err.message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "re-enter", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                if let fields = self.fields {
                    for field in fields{
                        field.text = ""
                    }
                }
                self.fields?[0].becomeFirstResponder()
            } else {
                //update stored token from response
                Storage.authToken = response?["auth_token"] as? String
                if let newVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "HomeViewController") as? HomeViewController {
                    
                    //store the phoneNumString into our storage without +1 in the front
                    Storage.phoneNumberInE164 = self.phoneNumString[2...]
                    UIApplication.shared.windows.first?.rootViewController = newVC
                }
            }
        }
    }
    
    @IBAction func resendClick(sender: UIButton){
        Api.sendVerificationCode(phoneNumber: self.phoneNumString) { response, error in
        }
    }
    
}
