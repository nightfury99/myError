//
//  AdminViewTableViewCell.swift
//  tRyInG98
//
//  Created by Macbook Pro on 25/05/2019.
//  Copyright © 2019 Usim. All rights reserved.
//

import UIKit

class AdminViewTableViewCell: UITableViewCell {

    @IBOutlet weak var viewImage: UIImageView!
    @IBOutlet weak var viewTitleLabel: UILabel!
    @IBOutlet weak var viewMatricIdLabel: UILabel!
    @IBOutlet weak var viewDateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
