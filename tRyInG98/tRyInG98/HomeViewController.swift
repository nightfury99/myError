//
//  HomeViewController.swift
//  tRyInG98
//
//  Created by Macbook Pro on 20/05/2019.
//  Copyright © 2019 Usim. All rights reserved.
//

import UIKit
import Firebase


class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var WelcomeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserData()

    }
    
    
    func loadUserData(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("Users").child(uid).observe(.value, with: {snapshot in
            if let Dict = snapshot.value as? [String: AnyObject]{
                let Username = Dict["Username"] as! String
                self.WelcomeLabel.text = "Welcome \(Username)!"
                print("My name \(Username)")
                
            }
        })
    }
    
    func SwitchToNavigationViewController(Navigation: String){
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let NaviVC = Storyboard.instantiateViewController(withIdentifier: Navigation) as! UINavigationController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = NaviVC
    }
    
    
    @IBAction func AdminButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Navigating to Admin Page", message: "Please enter Admin password", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "ID"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let post = UIAlertAction(title: "Go", style: .default) { _ in
            
            let logintext = alert.textFields![0]
            let passtext = alert.textFields![1]
            
            let login = logintext.text
            let text = passtext.text
            
            let log = login
            let pass = text
            
            if log == "nimda" && pass == "123321"{
                /*let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let desVC = mainStoryboard.instantiateViewController(withIdentifier: "HomeAdmin") as! HomeAdmin
                self.navigationController?.pushViewController(desVC, animated: true)*/
                self.performSegue(withIdentifier: "goToAdmin", sender: self)
                print("Hukay")
            } else {return}
        }
        alert.addAction(cancel)
        alert.addAction(post)
        present(alert, animated: true, completion: nil)
    }
    
    

}
