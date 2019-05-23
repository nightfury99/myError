//
//  ThesisListTableViewCell.swift
//  tRyInG98
//
//  Created by Macbook Pro on 22/05/2019.
//  Copyright © 2019 Usim. All rights reserved.
//

import UIKit

class ThesisListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thesisImage: UIImageView!
    
    @IBOutlet weak var ThesisTitleLabel: UILabel!
    @IBOutlet weak var ThesisAuthorLabel: UILabel!
    @IBOutlet weak var ThesisCourseLabel: UILabel!
    @IBOutlet weak var ThesisYearLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
