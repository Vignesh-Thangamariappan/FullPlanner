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

class SettingsTableViewController: UITableViewController {
    
    let loginManager = LoginManager()
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let userName = defaults.value(forKey: "userName") as? String, let mail = defaults.value(forKey: "userMail") as? String, let image = defaults.value(forKey: "userImage") as? String else {
            print("Something Went Wrong")
            return
        }
        if let url = URL(string:image) {
            do {
                let userImage = UIImage(data: try Data(contentsOf: url))
                profileImage.image = userImage
                profileImage.layer.cornerRadius = (profileImage.frame.size.width)/2
                profileImage.clipsToBounds = true
            } catch {
                print("Unable to generate User Image")
            }
        }
        nameLabel.text = userName
        emailLabel.text = mail
    }
    @IBAction func logoutTapped(_ sender: Any) {
        logoutAlert()
    }
    private func logoutAlert() {
        let logoutWarningAlert = UIAlertController(title: "Logging Out", message: "All your data will be removed. Are you sure?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .destructive) { (alert: UIAlertAction) in
            UserDefaults.standard.removeObject(forKey: "userName")
            UserDefaults.standard.removeObject(forKey: "userMail")
            UserDefaults.standard.removeObject(forKey: "userImage")
            self.loginManager.logOut()
            self.loginAgain()
        }
        let no = UIAlertAction(title: "No", style: .cancel, handler: nil)
        logoutWarningAlert.addAction(yes)
        logoutWarningAlert.addAction(no)
        present(logoutWarningAlert, animated: true, completion: nil)
    }
    private func loginAgain() {
        let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "login")
        navigationController?.setViewControllers([login], animated: true)
    }
}
