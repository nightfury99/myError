//
//  AdminApprovalViewController.swift
//  tRyInG98
//
//  Created by Macbook Pro on 25/05/2019.
//  Copyright © 2019 Usim. All rights reserved.
//

import UIKit
import Firebase

class AdminApprovalViewController: UIViewController {

    @IBOutlet weak var requestedUserView: UITableView!
    
    
    var rUser = [RequestedUser]()
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        referenceToData()
    }
    
    func referenceToData(){
        ref = Database.database().reference().child("Users")
        ref.observe(DataEventType.value, with: { (snapshot) in
            //if the reference have some values
            
            if snapshot.childrenCount > 0 {
                //iterating through all the values
                for detail in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    //getting values
                    let chatObject = detail.value as? [String: AnyObject]
                    let id = detail.key
                    let email  = chatObject?["Email"] as? String
                    let matricId  = chatObject?["MatricID"] as? String
                    let password = chatObject?["Password"] as? String
                    let status = chatObject?["CurrentStatus"] as? Int
                    let username = chatObject?["Username"] as? String
                    
                    let list = RequestedUser(id: id, email: email ?? "", matricID: matricId ?? "", password: password ?? "", status: status ?? 0, username: username ?? "")
                    
                    
                    //appending it to list
                    self.rUser.append(list)
                    print(id)
                }
                //reloading the tableview
                self.requestedUserView.reloadData()
            }
        })
    }
}


extension AdminApprovalViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rUser.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let history: RequestedUser
        history = rUser[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseIdentier") as? RequestedUserTableViewCell
        
        cell?.emailLabel.text = history.email
        cell?.matricIDLabel.text = history.matricID
        cell?.passwordLabel.text = history.password
        cell?.usernameLabel.text = history.username
        
        if history.status == 1 {
            cell?.statusLabel.text = "active"
        } else if history.status == 0 {
            cell?.statusLabel.text = "pending"
        }
        return cell!
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let history: RequestedUser
        history = rUser[indexPath.row]
        
        
        if history.status == 0{
            let alert = UIAlertController(title: "Admin", message: "Approve this user?", preferredStyle: .alert)
            let post = UIAlertAction(title: "OK", style: .default) { _ in
                
                let detail: RequestedUser
                detail = self.rUser[indexPath.row]
                let ref = Database.database().reference()
                
                let userRef = ref.child("Users").child("\(detail.id)")
                userRef.updateChildValues(["CurrentStatus": 1])
                
                self.requestedUserView.reloadData()
                print("triggered")
                print("\(detail.id)")
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(post)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
        else if history.status == 1{
            let alert = UIAlertController(title: "Admin", message: "Suspend this user?", preferredStyle: .alert)
            let post = UIAlertAction(title: "OK", style: .default) { _ in
                
                let detail: RequestedUser
                detail = self.rUser[indexPath.row]
                let ref = Database.database().reference()
                
                let userRef = ref.child("Users").child("\(detail.id)")
                userRef.updateChildValues(["CurrentStatus": 0])
                
                self.requestedUserView.reloadData()
                print("triggered")
                print("\(detail.id)")
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(post)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
