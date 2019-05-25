//
//  AdminDeleteTableViewCell.swift
//  tRyInG98
//
//  Created by Macbook Pro on 25/05/2019.
//  Copyright © 2019 Usim. All rights reserved.
//

import UIKit

class AdminDeleteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thesisImage: UIImageView!
    @IBOutlet weak var thesisTitleLabel: UILabel!
    @IBOutlet weak var thesisAuthorLabel: UILabel!
    @IBOutlet weak var thesisCourseLabel: UILabel!
    @IBOutlet weak var thesisYearLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
