
import UIKit

class GameResultsViewController: UIViewController {
    @IBOutlet weak var lblWinnerName: UILabel!
    @IBOutlet weak var lblWinnerScore: UILabel!
    
    var winner: Gamer!;
    override func viewDidLoad() {
        super.viewDidLoad()
        setScreen();
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    func setScreen(){
        lblWinnerName.text = "Winner:\(winner.fullName)"
        lblWinnerScore.text = "Score:\(winner.gameScore)"
    }
    @IBAction func openWinnersList(_ sender: Any) {
        performSegue(withIdentifier: AppConstants.screens_segue_winners_screen, sender: self)
    }
    

}
