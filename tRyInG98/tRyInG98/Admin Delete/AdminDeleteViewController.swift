//
//  AdminDeleteViewController.swift
//  tRyInG98
//
//  Created by Macbook Pro on 25/05/2019.
//  Copyright © 2019 Usim. All rights reserved.
//

import UIKit
import Firebase

class AdminDeleteViewController: UIViewController {

    @IBOutlet weak var thesisTableView: UITableView!
    
    var ThesisS = [DeleteThesis]()
    var ref:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ReferenceToThesisData()
        
    }
    
    func ReferenceToThesisData(){
        ThesisS.removeAll()
        thesisTableView.reloadData()
        
        ref = Database.database().reference().child("Thesis")
        ref.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                for detail in snapshot.children.allObjects as! [DataSnapshot]{
                    //Fetch value
                    let ChatObject = detail.value as? [String: AnyObject]
                    let Id = detail.key
                    let Title = ChatObject?["Title"] as? String
                    let Author = ChatObject?["Author"] as? String
                    let Year = ChatObject?["Year"] as? String
                    let Course = ChatObject?["Course"] as? String
                    let ThesisURL = ChatObject?["ThesisURL"] as? String
                    
                    let List = DeleteThesis(Id: Id, Title: Title ?? "", Author: Author ?? "", Year: Year ?? "", Course: Course ?? "", ThesisURL: ThesisURL ?? "")
                    //print("Test URL: \(ThesisURL ?? "")")
                    self.ThesisS.append(List)
                }
                self.thesisTableView.reloadData()
            }
        }
    }
}

extension AdminDeleteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ThesisS.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let history: DeleteThesis
        history = ThesisS[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThesisDeleteIdentifier") as? AdminDeleteTableViewCell
        
        cell?.thesisTitleLabel.text = history.Title
        cell?.thesisAuthorLabel.text = history.Author
        cell?.thesisYearLabel.text = history.Year
        cell?.thesisCourseLabel.text = history.Course
        
        cell?.thesisImage!.sd_setImage(with: URL(string: "\(history.ThesisURL)" ), placeholderImage: UIImage(named: "placeholder.png"))
        return cell!
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let history: DeleteThesis
        history = ThesisS[indexPath.row]
        
        let alert = UIAlertController(title: "Admin", message: "Delete This Thesis?", preferredStyle: .alert)
        let post = UIAlertAction(title: "OK", style: .default) { _ in
            let detail: DeleteThesis
            detail = self.ThesisS[indexPath.row]
            let ref = Database.database().reference()
            let thesisRef = ref.child("Thesis").child("\(detail.Id)")
            thesisRef.removeValue()
            self.thesisTableView.reloadData()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(post)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
}
