

import UIKit

class NavigationViewController: UIViewController {
    var userGamer:Gamer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigate();
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    func navigate(){
        if(FirebasePhoneAuthManager.shared.getCurrentUser() != nil ){
            // check registration
//            performSegue(withIdentifier: AppConstants.screens_segue_main_screen, sender: self)
            FirestoreManager.shared.getUserByPhoneNumber(phoneNumber: (FirebasePhoneAuthManager.shared.getCurrentUser()?.phoneNumber)!) { user, error in
                if let error = error {
                    print("Failed to get user: \(error.localizedDescription)")
                } else if let user = user {
                    print("User found: \(user.fullName), \(String(describing: user.phoneNumber))")
                    self.userGamer = user;
                    
                    self.performSegue(withIdentifier: AppConstants.screens_segue_main_screen, sender: self)
                    return;
                } else {
                    print("User not found.")
                }
                self.performSegue(withIdentifier: AppConstants.screens_segue_register_screen, sender: self)
            }
          
        }
        else{
            performSegue(withIdentifier: AppConstants.screens_segue_login_screen, sender: self)
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == AppConstants.screens_segue_main_screen {
                    if let destinationVC = segue.destination as? MainScreenViewController {
                        destinationVC.appGamer = userGamer;
                    }
                }
    }
    
}
