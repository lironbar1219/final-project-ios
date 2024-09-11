
import UIKit

class MessageUi {
    static func showMessage(on viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    
    static func showMessageWithClickEvent(on viewController: UIViewController, title: String, message: String, buttonString:String, retryAction: @escaping () -> Void ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add the Retry button with the retry action
        let retryButton = UIAlertAction(title: buttonString, style: .default) { _ in
            retryAction()
        }
        alert.addAction(retryButton)
        
        // Add a Close button to dismiss the alert
//        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        
        viewController.present(alert, animated: true, completion: nil)
    }
  
}
