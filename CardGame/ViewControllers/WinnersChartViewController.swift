//
//  WinnersChartViewController.swift
//  CardGame
//
//  Created by Udi Levy on 25/08/2024.
//

import UIKit

class WinnersChartViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // Array to hold users data
    var users: [Gamer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.register(WinnersCell.self, forCellReuseIdentifier: "WinnersCell")
        // Register the NIB
          let nib = UINib(nibName: "MyTableViewCell", bundle: nil)
          tableView.register(nib, forCellReuseIdentifier: "my_cell")
        
        getUsers();
        
    }
    
    
    func getUsers(){
        FirestoreManager.shared.getAllUsers { gamers, error in
            if let error = error {
                print("Error fetching users: \(error.localizedDescription)")
            } else if let usersResponse = gamers {
                
                DispatchQueue.main.async {
                    self.users = usersResponse.sorted {
                        // Sort by numberOfWins in descending order
                        if $0.winnerStats?.numberOfWins != $1.winnerStats?.numberOfWins {
                            return ($0.winnerStats?.numberOfWins ?? 0) > ($1.winnerStats?.numberOfWins ?? 0)
                        }
                        
                        // If numberOfWins is equal, sort by numberOfLoses in ascending order
                        if $0.winnerStats?.numberOfLoses != $1.winnerStats?.numberOfLoses {
                            return ($0.winnerStats?.numberOfLoses ?? 0) < ($1.winnerStats?.numberOfLoses ?? 0)
                        }
                        
                        // If both numberOfWins and numberOfLoses are equal, sort by sumOfWinPoints in descending order
                        return ($0.winnerStats?.sumOfWinPoints ?? 0) > ($1.winnerStats?.sumOfWinPoints ?? 0)
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension WinnersChartViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Number of rows in the table view (number of users)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    // Configure the cell to display user data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "my_cell", for: indexPath) as? MyTableViewCell else {
              fatalError("The dequeued cell is not an instance of MyCell.")
          }
 
        let user = users[indexPath.row]
        cell.lblName.text = user.fullName
        cell.lblLoses.text =  "\(user.winnerStats?.numberOfLoses ?? 0)"
        cell.lblVictories.text = "\(user.winnerStats?.numberOfWins ?? 0)"
        cell.lblTotalWiningsAtWins.text = "\(user.winnerStats?.sumOfWinPoints ?? 0 )"
        
        // Configure any other properties or outlets
        
        return cell
    }
    
    // Handle cell selection (if needed)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Handle the cell tap event if needed
    }
}
