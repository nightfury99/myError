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
import Gemini

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

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBOutlet weak var collectionView: GeminiCollectionView!
    
    
    let photos = ["003", "004", "005", "006","007", "008" , "009" , "010" , "011" ,"012" , "013" ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.gemini
            .cubeAnimation()
            .cubeDegree(90)
    }
    
    // Call animation function
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gemCell", for: indexPath) as! MyCell
        cell.setCell(imageName: photos[indexPath.row])
        // Animate
        self.collectionView.animateCell(cell)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Animate
        self.collectionView.animateVisibleCells()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Animate
        if let cell = cell as? MyCell {
            self.collectionView.animateCell(cell)
        }
        
    }
    
    func switchToNavigationViewController(Navigation : String ) {
        let storyboard = UIStoryboard(name: "admin", bundle: nil)
        let naviVC = storyboard.instantiateViewController(withIdentifier: Navigation) as! UINavigationController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = naviVC
        
    }
    
    @IBAction func adminButtonTaped(_ sender: UIButton) {
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
    
    @IBAction func signOutButtonTapped(_ sender: UIButton) {
        handleSignOut()
    }
    
    @objc func handleSignOut() {
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in
            self.signOut()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func signOut() {
        try! Auth.auth().signOut()
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desVC = mainStoryboard.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
        self.navigationController?.pushViewController(desVC, animated: true)
    }
}
