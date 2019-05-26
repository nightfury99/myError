//
//  ThesisListScreenViewController.swift
//  tRyInG98
//
//  Created by Macbook Pro on 22/05/2019.
//  Copyright © 2019 Usim. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class ThesisListScreenViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var ThesisTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var searchActive : Bool = false
    var filtered = [ThesisImage]()
    var ThesisS = [ThesisImage]()
    var newSearchString = ""
    
    
    var ref:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ReferenceToThesisData()
        ThesisTableView.delegate = self
        ThesisTableView.dataSource = self
    }
    
    
    
    
    func ReferenceToThesisData(){
        ThesisS.removeAll()
        ThesisTableView.reloadData()
        
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
                    
                    let List = ThesisImage(Id: Id, Title: Title ?? "", Author: Author ?? "", Year: Year ?? "", Course: Course ?? "", ThesisURL: ThesisURL ?? "")
                    print("Test URL: \(ThesisURL ?? "")")
                    self.ThesisS.append(List)
                }
                self.ThesisTableView.reloadData()
            }
        }
    }
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        self.searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = ThesisS.filter {
            $0.Title.localizedCaseInsensitiveContains(searchText)
                || ($0.Author.localizedCaseInsensitiveContains(searchText))
                || ($0.Course.localizedCaseInsensitiveContains(searchText))
                || ($0.Year.localizedCaseInsensitiveContains(searchText))
            
        }
        if(searchBar.text!.count == 0 && filtered.count == 0 ){
            searchActive = false;
        } else {
            searchActive = true;
        }
        let searchString = searchBar.text
        newSearchString = searchString!
        
        ThesisTableView.reloadData()
    }
}




extension ThesisListScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        } else {
            return ThesisS.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThesisIdentifier") as? ThesisListTableViewCell
        
        if(searchActive){
            let filter: ThesisImage
            filter = filtered[indexPath.row]
            
            cell?.ThesisTitleLabel.text = filter.Title
            cell?.ThesisAuthorLabel.text = filter.Author
            cell?.ThesisYearLabel.text = filter.Year
            cell?.ThesisCourseLabel.text = filter.Course
            
            cell?.thesisImage!.sd_setImage(with: URL(string: "\(filter.ThesisURL)" ), placeholderImage: UIImage(named: "placeholder.png"))
        } else {
            let history: ThesisImage
            history = ThesisS[indexPath.row]
            
            cell?.ThesisTitleLabel.text = history.Title
            cell?.ThesisAuthorLabel.text = history.Author
            cell?.ThesisYearLabel.text = history.Year
            cell?.ThesisCourseLabel.text = history.Course
            
            cell?.thesisImage!.sd_setImage(with: URL(string: "\(history.ThesisURL)" ), placeholderImage: UIImage(named: "placeholder.png"))
        }
        
        
        return cell!
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let Detail: ThesisImage
        Detail = self.ThesisS[indexPath.row]
        ref.child("Thesis").child("\(Detail.Id)")
        let firstVCDATA = Detail.Id
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desVC = mainStoryboard.instantiateViewController(withIdentifier: "ThesisInfo") as! ThesisInfoViewController
        desVC.ThesisId = firstVCDATA
        self.navigationController?.pushViewController(desVC, animated: true)
    }
}
