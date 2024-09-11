
import UIKit
import FirebaseAuth
class LoginViewController: UIViewController, UITextFieldDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtCode: UITextField!
    @IBOutlet weak var btnSendCode: UIButton!
    @IBOutlet weak var btnSendPhone: UIButton!
    @IBOutlet weak var statusLabel: UILabel!

    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var viewPhone: UIView!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - IBActions
    @IBAction func requestCodeButtonTapped(_ sender: UIButton) {
        guard var phoneNumber = txtPhone.text, !phoneNumber.isEmpty else {
            updateStatusLabel(with: "Please enter a valid phone number.")
            return
        }
        phoneNumber = "+972"+phoneNumber;

        FirebasePhoneAuthManager.shared.requestVerificationCode(phoneNumber: phoneNumber) { [weak self] error in
            if let error = error {
                self?.updateStatusLabel(with: "Failed to request verification code: \(error.localizedDescription)")
            } else {
                self?.updateStatusLabel(with: "Verification code sent successfully.\nEnter password!")
                self?.showPassword();
            }
        }
    }

    @IBAction func signInButtonTapped(_ sender: UIButton) {
        guard let verificationCode = txtCode.text, !verificationCode.isEmpty else {
            updateStatusLabel(with: "Please enter the verification code.")
   
            return
        }

        FirebasePhoneAuthManager.shared.signInWithVerificationCode(verificationCode: verificationCode) { [weak self] user, error in
            if let error = error {
                self?.updateStatusLabel(with: "Failed to sign in: \(error.localizedDescription)")
            } else if let user = user {
                self?.updateStatusLabel(with: "User signed in successfully: \(user.phoneNumber ?? "Unknown Phone Number")")
             self?.goToNavigation()
            }
        }
    }

    
    func goToNavigation(){
        let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NavigationViewController") as! NavigationViewController
              
              // Replace the current stack with the new view controller
              if let navigationController = self.navigationController {
                  navigationController.setViewControllers([newViewController], animated: true)
              }
        
    }
    // MARK: - Helper Methods
    private func updateStatusLabel(with message: String) {
        statusLabel.text = message
    }

    private func setupUI() {
        viewPhone.layer.borderWidth = 1
        viewPhone.layer.borderColor = UIColor.blue.cgColor
        viewPhone.layer.cornerRadius = CGFloat(20)
        viewPhone.backgroundColor=UIColor.white
        viewPassword.layer.borderWidth = 1
        viewPassword.layer.borderColor = UIColor.systemPink.cgColor
        viewPassword.layer.cornerRadius = CGFloat(20)
        viewPassword.backgroundColor=UIColor.white
        
        txtPhone.delegate = self
        txtCode.delegate = self
        
        showPhoneNumber()
        
        statusLabel.text = ""
        
        btnSendCode.setTitle("Request Code", for: .normal)
        btnSendPhone.setTitle("Sign In", for: .normal)
    }
    
    @IBAction func actBackPassword(_ sender: Any) {
        showPhoneNumber();
    }
    
    func showPhoneNumber(){
        viewPassword.isHidden = true;
        viewPhone.isHidden = false;
    }
    
    func showPassword(){
        viewPassword.isHidden = false;
        viewPhone.isHidden = true;
    }
    
}

extension LoginViewController : UITextViewDelegate {
    // This method is called when the return button is pressed
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" { // Detect the newline character
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
