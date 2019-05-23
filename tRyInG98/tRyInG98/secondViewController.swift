//
//  secondViewController.swift
//  tRyInG98
//
//  Created by Macbook Pro on 19/05/2019.
//  Copyright © 2019 Usim. All rights reserved.
//

import UIKit

class secondViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goHome", sender: self)
    }
    
}
