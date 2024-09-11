
import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtGamerName: UITextField!
    @IBOutlet weak var btnStart: UIButton!
    var userGamer:Gamer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtGamerName.delegate = self
        txtGamerName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    @IBAction func btnStartClick(_ sender: Any) {
        LocalStorage.saveGamerName(txtGamerName.text!)
        userGamer = Gamer(fullName: self.txtGamerName.text!,phoneNumber: (FirebasePhoneAuthManager.shared.getCurrentUser()?.phoneNumber)!)
        
        FirestoreManager.shared.createUser(appUser: userGamer!) { error in
            if let error = error {
                // Handle the error (e.g., show an alert or log the error)
                print("Failed to create user: \(error.localizedDescription)")
            } else {
                // No error, perform the segue
                self.performSegue(withIdentifier: AppConstants.screens_segue_main_screen, sender: self)
            }
        }
    }
    
    
    // Example: Limit the number of characters
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        print("Text changed: \(textField.text ?? "")")
        
        if let text = textField.text, text.count > 2 {
            showStartGameButton(show: true);
        }
        else{
            showStartGameButton(show: false);
        }
    }
    public func showStartGameButton(show:Bool){
        btnStart.isHidden = !show;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == AppConstants.screens_segue_main_screen {
                    if let destinationVC = segue.destination as? MainScreenViewController {
                        destinationVC.appGamer = userGamer;
                    }
                }
    }
    
}

extension RegisterViewController : UITextViewDelegate {
    // This method is called when the return button is pressed
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" { // Detect the newline character
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
