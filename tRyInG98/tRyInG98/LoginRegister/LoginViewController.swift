//
//  LoginViewController.swift
//  tRyInG98
//
//  Created by Macbook Pro on 19/05/2019.
//  Copyright © 2019 Usim. All rights reserved.
//

import UIKit
import TextFieldEffects
import Firebase


class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: AkiraTextField!
    @IBOutlet weak var passwordTextField: AkiraTextField!
    
    var ref:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }
    
    
    func switchToNavigationViewController(Navigation : String ) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let naviVC = storyboard.instantiateViewController(withIdentifier: Navigation) as! UINavigationController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = naviVC
        
    }
    
    /*
    if let Email = loginTextField.text, let Pass = passwordTextField.text{
        Auth.auth().signIn(withEmail: Email, password: Pass) { (user, error) in
            if user != nil{
                //self.switchToNavigationViewController(Navigation: "HomeViewController")
                self.performSegue(withIdentifier: "HomeVC", sender: self)
                return
            }
            else{
                //Create the action
                let AlertController = UIAlertController(title: "Invalid User", message: "Password or email wrong, Please try again!", preferredStyle: .alert)
                let OkAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default){
                    UIAlertAction in
                }
                //add the action
                AlertController.addAction(OkAction)
                //present the controller
                self.present(AlertController, animated: true, completion: nil)
                
            }
        }
    }*/
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        guard let email = loginTextField.text else{return}
        guard let password = passwordTextField.text else{return}
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            let userID = Auth.auth().currentUser?.uid
            if let error = error {
                print("Failed to sign user in with error: ", error.localizedDescription)
                
                let alertController = UIAlertController(title: "Invalid User", message: "Password or email wrong, Please try again!", preferredStyle: .alert)
                
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                }
                
                // Add the actions
                alertController.addAction(okAction)
                
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
                
                
                return
            } else {
                self.ref.child("Users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let value = snapshot.value as? NSDictionary
                    let status = value!["CurrentStatus"] as? Int
                    
                    if let error = error {
                        print("Failed to sign user in with error: ", error.localizedDescription)
                        return
                    }
                    else if status == 0{
                        try! Auth.auth().signOut()
                        
                        let alert = UIAlertController(title: "Account Status", message: "Pending!", preferredStyle: .alert)
                        let post = UIAlertAction(title: "OK", style: .default) { _ in
                            return
                        }
                        alert.addAction(post)
                        self.present(alert, animated: true, completion: nil)
                    }
                    else if status == 1{
                        self.performSegue(withIdentifier: "HomeVC", sender: self)
                        //                self.navigationController?.pushViewController(desVC, animated: true)
                        print("successfully signed in")
                    }
                    
                    
                })
            }
        }
    }
}


