//
//  UserReservedTableViewCell.swift
//  tRyInG98
//
//  Created by Macbook Pro on 26/05/2019.
//  Copyright © 2019 Usim. All rights reserved.
//

import UIKit

class UserReservedTableViewCell: UITableViewCell {

    @IBOutlet weak var userViewImage: UIImageView!
    @IBOutlet weak var userViewTitleLabel: UILabel!
    @IBOutlet weak var userViewMatricIdLabel: UILabel!
    @IBOutlet weak var userViewDateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
