//
//  AddThesisViewController.swift
//  tRyInG98
//
//  Created by Macbook Pro on 20/05/2019.
//  Copyright © 2019 Usim. All rights reserved.
//

import UIKit
import TextFieldEffects
import Firebase

class AddThesisViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var TitleTextField: AkiraTextField!
    @IBOutlet weak var AuthorTextField: AkiraTextField!
    @IBOutlet weak var CourseTextField: AkiraTextField!
    @IBOutlet weak var YearTextField: AkiraTextField!
    @IBOutlet weak var DescriptionTextField: AkiraTextField!
    @IBOutlet weak var ThesisIDTextField: AkiraTextField!
    @IBOutlet weak var imageViewAddBook: UIImageView!
    var ref:DatabaseReference!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }
    
    
    
    @IBAction func AddThesis(_ sender: UIButton) {
        guard let Title = TitleTextField.text else {return}
        guard let Author = AuthorTextField.text else {return}
        guard let Course = CourseTextField.text else {return}
        guard let Year = YearTextField.text else {return}
        guard let Description = DescriptionTextField.text else {return}
        guard let ThesisID = ThesisIDTextField.text else {return}
        
        //let ThesisIDConvert = Int(ThesisID)
        let ThesisNum = 2
        let FilePath = "\(String(describing: Auth.auth().currentUser))/\(Date.timeIntervalSinceReferenceDate)"
        let StorageRef = Storage.storage().reference().child(FilePath)
        let UploadData = imageViewAddBook.image?.pngData()
        let MetaData = StorageMetadata()
        MetaData.contentType = "image/png"
        
        StorageRef.putData(UploadData!, metadata: MetaData) { (metadata, error) in
            if error != nil{
                print("My error is: \(error.debugDescription)")
                //print(error?.localizedDescription)
                
                return
            }
            StorageRef.downloadURL(completion: { (url, error) in
                guard let DownloadURL = url?.absoluteString else{
                    return
                }
                print(DownloadURL)
                self.AddThesisToFirebase(Title: Title, Author: Author, Course: Course, Year: Year, Description: Description, ThesisID: ThesisID, LocalURL: DownloadURL, ThesisNum: ThesisNum)
            })
            
        }
        let Alert = UIAlertController(title: "You Have Updated This Thesis", message: "Good Thesis", preferredStyle: .alert)
        let Reserve = UIAlertAction(title: "OK", style: .default) { _ in
            
        }
        Alert.addAction(Reserve)
        present(Alert, animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func UploadPic(_ sender: UIButton) {
        let ImagePicker = UIImagePickerController()
        ImagePicker.delegate = self
        let ActionSheet = UIAlertController(title: "Photo Source", message: "Source", preferredStyle: .actionSheet)
        
        ActionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action:UIAlertAction) in ImagePicker.sourceType = .camera
            self.present(ImagePicker, animated: true, completion: nil)
        }))
        
        ActionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action:UIAlertAction) in ImagePicker.sourceType = .photoLibrary
            self.present(ImagePicker, animated: true, completion: nil)
        }))
        
        ActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(ActionSheet, animated: true, completion: nil)
    }
    
    
    
    func AddThesisToFirebase(Title: String, Author: String, Course: String, Year: String, Description: String, ThesisID: String, LocalURL: String, ThesisNum: Int){
        
        let Values = ["Title": Title, "Author": Author, "Year": Year, "Description": Description, "Course": Course, "ThesisID": ThesisID, "ThesisURL": LocalURL, "ThesisNum": ThesisNum] as [String : Any]
        self.ref.child("Thesis").childByAutoId().updateChildValues(Values) { (error, ref) in
            if let error = error{
                print("Failed to update database values with error: ", error.localizedDescription)
                return
            }
            self.dismiss(animated: true, completion: nil)
            print("Succesfully Add Thesis")
        }
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let Image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageViewAddBook.image = Image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
