//
//  Settings.swift
//  MyAssistant
//
//  Created by user on 12/4/17.
//  Copyright © 2017 Vignesh. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit

class Settings: UITableViewController {
    
    
    let loginManager = LoginManager()
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = defaults.value(forKey: "userName") as? String, let mail = defaults.value(forKey: "userMail") as? String, let image = defaults.value(forKey: "userImage") as? String {
            if let url = URL(string:image) {
                do {
                    let img = UIImage(data: try Data(contentsOf: url))
                    profileImage.image = img
                    profileImage.layer.cornerRadius = (profileImage.frame.size.width)/2
                    profileImage.clipsToBounds = true
                } catch {
                    print("Unable to generate User Image")
                }
            }
            nameLabel.text = user
            emailLabel.text = mail
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func logoutTapped(_ sender: Any) {
        logoutAlert()
    }
    func logoutAlert() {
        let alert = UIAlertController(title: "Logging Out", message: "All your data will be removed. Are you sure?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .destructive, handler:{ (alert: UIAlertAction) in
            UserDefaults.standard.removeObject(forKey: "userName")
            UserDefaults.standard.removeObject(forKey: "userMail")
            UserDefaults.standard.removeObject(forKey: "userImage")
            self.loginManager.logOut()
            self.loginAgain()
        }  )
        let no = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(yes)
        alert.addAction(no)
        present(alert, animated: true, completion: nil)
    }
    func loginAgain() {
        
        let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "login")
        navigationController?.setViewControllers([login], animated: true)
    }
}
