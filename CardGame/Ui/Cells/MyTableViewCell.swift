//
//  MyTableViewCell.swift
//  CardGame
//
//  Created by Udi Levy on 26/08/2024.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblVictories: UILabel!
    @IBOutlet weak var lblLoses: UILabel!
    @IBOutlet weak var lblTotalWiningsAtWins: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
