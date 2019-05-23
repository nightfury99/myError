//
//  ViewController.swift
//  tRyInG98
//
//  Created by Macbook Pro on 02/04/2019.
//  Copyright © 2019 Usim. All rights reserved.
//

import UIKit
import Firebase
import TextFieldEffects

class ViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //let ref = Database.database().reference()
        
        //command to change data
        //ref.child("someId/Name").setValue("thanos_Z")
        //command to update data
        //ref.child("someId/Name").setValue("John")
        /*let updatezz = ["someId/Name":"Another Name", "huhu/Name":"newName", "huhu/Age":"223"]*/
        //ref.updateChildValues(updatezz)
        //command to delete data or id
        //ref.child("huhu").removeValue() or ref.child("huhu/Name").removeValue()
        
        //--------------------(SIGN OUT USER)-----------------------
        /*
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "Anything", sender: self)
        }catch{
            print("Couldnt logout")
        }*/
    }
    
    
    
}

