//
//  RegisterViewController.swift
//  tRyInG98
//
//  Created by Macbook Pro on 19/05/2019.
//  Copyright © 2019 Usim. All rights reserved.
//

import UIKit
import TextFieldEffects
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var Status: UILabel!
    @IBOutlet weak var UsernameTextField: AkiraTextField!
    @IBOutlet weak var MatricNoTextField: AkiraTextField!
    @IBOutlet weak var EmailTextField: AkiraTextField!
    @IBOutlet weak var PasswordTextField: AkiraTextField!
    
    
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }
    
    
    @IBAction func RegisterButtonTapped(_ sender: UIButton) {
        guard let MatricID = MatricNoTextField.text else {return}
        guard let Username = UsernameTextField.text else {return}
        guard let Email = EmailTextField.text else {return}
        guard let Password = PasswordTextField.text else {return}
        
        let CurrentStatus = 0
        
        CreateUser(withEmail: Email, Password: Password, Username: Username, MatricID: MatricID, CurrentStatus: CurrentStatus)
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desVC = MainStoryboard.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
        self.navigationController?.pushViewController(desVC, animated: true)
        
    }
    
    
    
    func CreateUser(withEmail Email: String, Password: String, Username: String, MatricID: String, CurrentStatus: Int){
        Auth.auth().createUser(withEmail: Email, password: Password) { (result, error) in
            if let error = error{
                print("Failed to sign user up with error: ", error.localizedDescription)
                return
            }
            guard let uid = result?.user.uid else {return}
            let Values = ["Email": Email, "Username": Username, "Password": Password, "MatricID": MatricID, "CurrentStatus": CurrentStatus] as [String:Any]
            
            
            self.ref.child("Users").child(uid).updateChildValues(Values, withCompletionBlock: { (error, ref) in
                if let error = error{
                    print("Failed to update database with the error: ", error.localizedDescription)
                    return
                }
                self.dismiss(animated: true, completion: nil)
                print("Successfully signed up")
            })
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        
    }
    
    
    /*override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        EmailTextField.resignFirstResponder()
        PasswordTextField.resignFirstResponder()
    }*/
    

}
