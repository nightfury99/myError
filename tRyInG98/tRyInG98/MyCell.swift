//
//  MyCell.swift
//  tRyInG98
//
//  Created by Macbook Pro on 26/05/2019.
//  Copyright © 2019 Usim. All rights reserved.
//

import Foundation
import Gemini
import UIKit

class MyCell: GeminiCell{
    @IBOutlet weak var mainImageView: UIImageView!
    
    func setCell(imageName: String){
        mainImageView.image = UIImage(named: imageName)
    }
}
