//
//  UserReservedViewController.swift
//  tRyInG98
//
//  Created by Macbook Pro on 26/05/2019.
//  Copyright © 2019 Usim. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class UserReservedViewController: UIViewController {

    @IBOutlet weak var userReservedTableView: UITableView!
    
    var reserve = [UserReserved]()
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewReserve()
    }
    
    func viewReserve(){
        
        reserve.removeAll()
        userReservedTableView.reloadData()
        
        ref = Database.database().reference().child("ReservedThesis")
        ref.observe(DataEventType.value, with: { (snapshot) in
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //iterating through all the values
                for detail in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let chatObject = detail.value as? [String: AnyObject]
                    
                    let title  = chatObject?["ThesisTitle"] as? String
                    let matricId  = chatObject?["MatricID"] as? String
                    let dateReserve = chatObject?["DateReserved"] as? String
                    let url = chatObject?["ThesisURL"] as? String
                    
                    
                    let list = UserReserved(title: title ?? "", matricID: matricId ?? "", dateReserve: dateReserve ?? "", url: url ?? "")
                    //appending it to list
                    self.reserve.append(list)
                    print(list)
                }
                //reloading the tableview
                self.userReservedTableView.reloadData()
            }
        })
    }
}

extension UserReservedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reserve.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let history: UserReserved
        history = reserve[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserReservedIdentifier") as? UserReservedTableViewCell
        
        cell?.userViewTitleLabel.text = history.title
        cell?.userViewMatricIdLabel.text = history.matricID
        cell?.userViewDateLabel.text = history.dateReserve
        
        
        cell?.userViewImage!.sd_setImage(with: URL(string: "\(history.url)" ), placeholderImage: UIImage(named: "placeholder.png"))
        return cell!
    }
}
