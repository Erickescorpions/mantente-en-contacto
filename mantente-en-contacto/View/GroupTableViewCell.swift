//
//  GroupTableViewCell.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 24/08/25.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    @IBOutlet weak var memberImage: UIImageView!
    
    @IBOutlet weak var memberUsername: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
