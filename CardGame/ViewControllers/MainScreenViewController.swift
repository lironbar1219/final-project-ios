
import UIKit
import CoreLocation

class MainScreenViewController: UIViewController {
    var playerWest: Gamer?
    var playerEast: Gamer?
    var cardsNames: [String]?
    let locationManager = CLLocationManager()
    var appGamer : Gamer!
    var currentLongitude: Double?
    var currentGameRound = 0
    var gameTimer: Timer?
    
    
    @IBOutlet weak var lblCurrentRound: UILabel!
    @IBOutlet weak var lblTimerCounter: UILabel!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var lblGamerName: UILabel!
    @IBOutlet weak var lblGamerWestName: UILabel!
    @IBOutlet weak var lblGamerEastName: UILabel!
    @IBOutlet weak var lblGamerWestScore: UILabel!
    @IBOutlet weak var lblGamerEastScore: UILabel!
    @IBOutlet weak var imgWestCard: UIImageView!
    @IBOutlet weak var imgEastCard: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setScreen();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setScreen(){
        setAudio()
        cardsNames = FilesHandler.getCardsFileNames();
        lblGamerName.text = "Hello \(appGamer!.fullName)";
        getLocation();
        
    }
    
    func setAudio(){
        // Load the audio file
        let audioLoaded = AudioPlayerHandler.shared.loadAudioFile(named: "flip", fileExtension: "mp3")
        
        if audioLoaded {
            // Optionally set loop count or volume
            AudioPlayerHandler.shared.setNumberOfLoops(0) // No loop
            AudioPlayerHandler.shared.setVolume(1.0)      // Full volume
        }
    }
    
    @IBAction func btnStartAction(_ sender: Any) {
        btnStart.isHidden = true;
        startGame()
    }
    @IBAction func btnLogOut(_ sender: Any) {
        LocalStorage.saveGamerName(nil);
        do {
            try FirebasePhoneAuthManager.shared.signOut();
            let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NavigationViewController") as! NavigationViewController
            
            // Replace the current stack with the new view controller
            if let navigationController = self.navigationController {
                navigationController.setViewControllers([newViewController], animated: true)
            }
        } catch {
            print("Failed to sign out: \(error.localizedDescription)")
            
        }
        
        
    }
    
    func setPlayerPlaces(){
        
        if(currentLongitude! < AppConstants.gameCenterLatitude){
            
            playerWest = Gamer(fullName: appGamer!.fullName)
            playerEast = Gamer(fullName: AppConstants.computer)
        }
        else{
            playerWest = Gamer(fullName: AppConstants.computer);
            playerEast = Gamer(fullName:appGamer!.fullName )
        }
        btnStart.isHidden = false
        lblGamerWestName.text = playerWest?.fullName;
        lblGamerEastName.text = playerEast?.fullName;
        
        updateScores();
        
    }
    
    func updateScores(){
        if let score1 = playerWest?.gameScore {
            lblGamerWestScore.text = "\(String(describing:score1))";
        }
        if let score2 = playerEast?.gameScore {
            lblGamerEastScore.text = "\(String(describing: score2))";
        }
    }
    
    
    func startGame() {
        currentGameRound = 0
        runRound()
    }
    
    func runRound() {
        AudioPlayerHandler.shared.play()
        currentGameRound += 1
        self.lblCurrentRound.text = "Round - \(currentGameRound)"
        // Show random cards
        showRandomCards()
        
        // Start the timer for the round
        lblTimerCounter.text = "\(AppConstants.gameRoundTimeSec)"
        var seconds = AppConstants.gameRoundTimeSec
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            seconds -= 1
            self.lblTimerCounter.text = "\(seconds)"
            if seconds == 0 {
                timer.invalidate()
                self.hideCards()
            }
        }
    }
    
    func hideCards() {
        AudioPlayerHandler.shared.play()
        
        if(currentGameRound==AppConstants.gameMaxRounds){
            setScreen();
            
            performSegue(withIdentifier: AppConstants.screens_segue_game_results_screen, sender: self)
            btnStart.isHidden=false;
            playerWest?.gameScore=0
            playerEast?.gameScore=0
            lblCurrentRound.text = "";
            endGame()
            
            
            return;
        }
        imgWestCard.image = UIImage(named: "west")
        imgEastCard.image = UIImage(named: "east")
        lblTimerCounter.text = "\(AppConstants.gameRoundHideCardsTimeSec)"
        var seconds = AppConstants.gameRoundHideCardsTimeSec
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            seconds -= 1
            self.lblTimerCounter.text = "\(seconds)"
            if seconds == 0 {
                timer.invalidate()
                self.runRound()
            }
        }
    }
    
    func showRandomCards() {
        guard let cardsNames = cardsNames else { return }
        
        
        let randomWestImage = cardsNames.randomElement() ?? ""
        let randomEastImage = cardsNames.randomElement() ?? ""
        
        var splitStringArray = randomWestImage.components(separatedBy: "_")
        let westValue = Int(splitStringArray.first!)
        
        splitStringArray = randomEastImage.components(separatedBy: "_")
        let eastValue = Int(splitStringArray.first!)
        if(eastValue != westValue){
            // score only if not equal
            if(westValue! > eastValue!){
                playerWest?.gameScore+=1;
            }
            else if(westValue! < eastValue!){
                playerEast?.gameScore+=1;
            }
        }
        
        updateScores();
        
        imgWestCard.image = UIImage(named: randomWestImage)
        imgEastCard.image = UIImage(named: randomEastImage)
    }
    
    func endGame() {
        imgWestCard.image = UIImage(named: "west")
        imgEastCard.image = UIImage(named: "east")
        
        lblGamerWestScore.text = "0";
        lblGamerEastScore.text = "0";
    }
    
    func getWinner()->Gamer{
        if(playerWest!.gameScore > playerEast!.gameScore){
       
            return playerWest!
        }
        else if(playerWest!.gameScore < playerEast!.gameScore){
            return playerEast!
        }
        else{
            //            return the computer as a winner
            if(playerWest?.fullName == AppConstants.computer){
                return playerWest!
            }
            else {
                return playerEast!
            }
        }
    }
    
    func     updateGamerWinings(playerSide:Gamer,didWin:Bool){
        
        if(appGamer.winnerStats == nil){
            appGamer.winnerStats = Winner(numberOfWins: 0,numberOfLoses: 0,sumOfWinPoints: 0);
        }
        
        if(didWin){
            appGamer.winnerStats!.numberOfWins+=1
            appGamer.winnerStats!.sumOfWinPoints+=playerSide.gameScore
        }
        else{
            appGamer.winnerStats?.numberOfLoses+=1;
        }
        
        let fieldsToUpdate: [String: Any] = [
            "winnerStats.numberOfWins": appGamer.winnerStats!.numberOfWins,
            "winnerStats.numberOfLoses": appGamer.winnerStats!.numberOfLoses,
            "winnerStats.sumOfWinPoints": appGamer.winnerStats!.sumOfWinPoints
        ]
        FirestoreManager.shared.updateFields(forDocumentId: (FirebasePhoneAuthManager.shared.getCurrentUser()?.phoneNumber)!, fieldsToUpdate:fieldsToUpdate
        );
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == AppConstants.screens_segue_game_results_screen {
            if let destinationVC = segue.destination as? GameResultsViewController {
                if(getWinner().fullName != AppConstants.computer){
                    updateGamerWinings(playerSide: getWinner(), didWin: true)
                }
                else{
                    updateGamerWinings(playerSide: getWinner(), didWin: false)
                }
                destinationVC.winner = getWinner();
            }
        }
    }
}





extension MainScreenViewController :CLLocationManagerDelegate {
    
    func handleStatus(authorizationStatus :CLAuthorizationStatus){
        switch authorizationStatus {
        case .notDetermined:
            // The user has not yet been asked to authorize location services.
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted:
            // The user cannot change this app’s status, possibly due to active restrictions such as parental controls.
            print()
            MessageUi.showMessage(on: self, title: "Location Error", message: "Location services are restricted. You cannot grant permission.")
        case .denied:
            // The user explicitly denied the use of location services for this app or they are globally disabled in Settings.
            
            MessageUi.showMessageWithClickEvent(on: self, title: "Location error", message: "Location services are denied. You need to enable it in Settings.", buttonString: "Retry") {
                let authorizationStatus = self.locationManager.authorizationStatus
                self.handleStatus(authorizationStatus: authorizationStatus);
            }
            
            
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        @unknown default:
            // Handle any future cases that might be added to CLAuthorizationStatus
            print("An unknown authorization status was encountered.")
        }
    }
    func getLocation(){
        locationManager.delegate = self
        let authorizationStatus = locationManager.authorizationStatus
        handleStatus(authorizationStatus: authorizationStatus);
        
    }
    
    // Handle the permission status
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleStatus(authorizationStatus: status)
        //        switch status {
        //        case .notDetermined:
        //            print("Location permission not determined")
        //            //              Alerts.showAlert(on: self, withTitle: "Location Permission not determined", message: "Please enable location services in settings.")
        //        case .restricted, .denied:
        //            print("Location permission denied/restricted")
        //            MessageUi.showMessage(on: self, title: "Location Permission Error", message: "Please enable location service.")
        //        case .authorizedWhenInUse, .authorizedAlways:
        //            print("Location permission granted")
        //            locationManager.startUpdatingLocation()
        //        @unknown default:
        //            fatalError()
        //        }
    }
    
    
    
    // Handle location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            print("User's location: (\(latitude), \(longitude))")
            currentLongitude=longitude;
            // Stop updating location to save battery
            
            locationManager.stopUpdatingLocation()
            if playerWest == nil {
                setPlayerPlaces()
            }
        }
    }
}
