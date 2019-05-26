//
//  ThesisInfoViewController.swift
//  tRyInG98
//
//  Created by Macbook Pro on 22/05/2019.
//  Copyright © 2019 Usim. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class ThesisInfoViewController: UIViewController {

    @IBOutlet weak var thesisImage: UIImageView!
    @IBOutlet weak var TitleLabel: UITextView!
    @IBOutlet weak var ThesisID: UILabel!
    @IBOutlet weak var AuthorLabel: UILabel!
    @IBOutlet weak var CourseLabel: UILabel!
    @IBOutlet weak var YearLabel: UILabel!
    @IBOutlet weak var DescriptionLabel: UITextView!
    
    
    //var ThesisS = [ThesisImage]()
    var ref: DatabaseReference!
    var ThesisId = ""
    var MatricNum = ""
    var ThesisUrl = ""
    var ThesisTitle = ""
    var ThesisNum = 0
    let uid = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("My uid is \(uid!)")
        print("my thesis Id is \(ThesisId)")
        ReferenceToThesisInfo()
        LoadUserData()
    }
    
    
    func ReferenceToThesisInfo(){
        ref = Database.database().reference().child("Thesis").child("\(ThesisId)")
        print("-------------(Testing The Code)-------------")
        print("\(ThesisId)")
        ref.observe(DataEventType.value) { (snapshot) in
            if let Dict = snapshot.value as? [String: AnyObject]{
                let title = Dict["Title"] as! String
                let author = Dict["Author"] as! String
                let course = Dict["Course"] as! String
                let year = Dict["Year"] as! String
                let description = Dict["Description"] as! String
                let thesisID = Dict["ThesisID"] as! String
                let thesisURL = Dict["ThesisURL"] as! String
                let thesisNum = Dict["ThesisNum"] as! Int
                
                self.ThesisTitle = title
                self.ThesisNum = thesisNum
                self.ThesisUrl = thesisURL
                
                self.TitleLabel.text = title
                self.ThesisID.text = thesisID
                self.AuthorLabel.text = author
                self.CourseLabel.text = course
                self.YearLabel.text = year
                self.DescriptionLabel.text = description
                
                self.thesisImage.sd_setImage(with: URL(string: thesisURL), placeholderImage: UIImage(named: "placeholder.png"))
            }
        }
    }
    
    
    func LoadUserData(){
        Database.database().reference().child("Users").child("\(uid!)").observe(.value) { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject]{
                let MatricNo = dict["MatricID"] as! String
                print("My matric Number is: \(MatricNo)")
                self.MatricNum = MatricNo
            }
        }
    }
    
    
    func AddUserToThesisDatabase(ThesisTitle:String, MatricID:String, ThesisID:String, ThesisURL: String){
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMMM-yyyy"
        let BorrowedDate = formatter.string(from: date)
        
        let calendar = Calendar.current
        let rightNow = Date()
        let sevenDaysAfter = calendar.date(byAdding: .day, value: 7, to: rightNow)
        print(sevenDaysAfter!)
        let returnDate = formatter.string(from: sevenDaysAfter!)
        
        let values = ["BookID": ThesisID, "BookTitle": ThesisTitle, "DateBorrowed": BorrowedDate, "DateReturn": returnDate, "MatricID": MatricID, "UID": uid!] as [String : Any]
        Database.database().reference().child("Thesis_Borrowed").childByAutoId().updateChildValues(values, withCompletionBlock: { (error, ref) in
            
            //self.dismiss(animated: true, completion: nil)
            let alertController = UIAlertController(title: "Borrow Thesis", message: "your have successfully borrowed a Thesis!", preferredStyle: .alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
            }

            // Add the actions
            alertController.addAction(okAction)
            
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
        })
        
        let userBookBorrowValues = ["UID": uid!,"ThesisID": ThesisID, "ThesisTitle": ThesisTitle, "DateBorrowed": BorrowedDate, "DateReturn": returnDate, "ThesisURL": ThesisURL] as [String : Any]
        Database.database().reference().child("UserThesis").childByAutoId().child(uid!).setValue(userBookBorrowValues)
    }
    
    
    
    @IBAction func borrowButtonTapped(_ sender: UIButton) {
        if ThesisNum <= 0{
            let AlertController = UIAlertController(title: "No Thesis Currently Available", message: "You Can Reserve Thesis", preferredStyle: .alert)
            let Cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) { (UIAlertAction) in
                
            }
            let ReserveAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (UIAlertAction) in
                
            }
            AlertController.addAction(Cancel)
            AlertController.addAction(ReserveAction)
            self.present(AlertController, animated: true, completion: nil)
        }
        else{
            BorrowThesis()
        }
    }
    
    
    @IBAction func reservedButtonTaped(_ sender: UIButton) {
        let Alert = UIAlertController(title: "Reserved This Thesis?", message: "Please Enter the Date for Reservation", preferredStyle: .alert)
        Alert.addTextField { (textField) in
            textField.placeholder = "Date"
        }
        let Cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let Reserve = UIAlertAction(title: "Reserve", style: .default){ _ in
            guard let DateReserved = Alert.textFields?.first?.text else {return}
            let UserThesisBorrowValues = ["DateReserved": DateReserved, "ThesisTitle": self.ThesisTitle, "MatricID": self.MatricNum, "ThesisURL": self.ThesisUrl]
            Database.database().reference().child("ReservedThesis").childByAutoId().setValue(UserThesisBorrowValues)
            
            let alertController = UIAlertController(title: "Reserved Thesis", message: "your have successfully reserved a Thesis!", preferredStyle: .alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
            }
            
            // Add the actions
            alertController.addAction(okAction)
            
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
        }
        Alert.addAction(Cancel)
        Alert.addAction(Reserve)
        present(Alert, animated: true, completion: nil)
    }
    
    
    
    
    func BorrowThesis(){
        let dataref = Database.database().reference().child("Thesis").child("\(ThesisId)")
        dataref.observeSingleEvent(of: .value) {
            (snapshot) in
            print (snapshot)
            if let dict = snapshot.value as? [String: AnyObject]
            {
                
                if  let numOfThesis = dict["ThesisNum"] as? Int {
                    print ("num of book :\(numOfThesis)")
                    let numofBooksAfterClicked = (numOfThesis - 1)
                    dataref.updateChildValues(["ThesisNum": numofBooksAfterClicked])
                    
                    self.AddUserToThesisDatabase(ThesisTitle: self.TitleLabel.text!, MatricID: "\(self.MatricNum)", ThesisID: self.ThesisId, ThesisURL: self.ThesisUrl)
                }
            }
        }
    }
}
