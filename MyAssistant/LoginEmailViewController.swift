//
//  LoginEmailViewController.swift
//  MyAssistant
//
//  Created by Vignesh on 08/07/18.
//  Copyright © 2018 Vignesh. All rights reserved.
//

import UIKit

class LoginEmailViewController: UIViewController {

    @IBOutlet weak var emailIDField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginWithEmail(sender: UIButton) {
        
        guard !(emailIDField.text?.isEmpty)!, !(passwordField.text?.isEmpty)! else {
            Alert().showAlert(title: "Empty Field(s)", message: "Please fill in all the fields", vc: self)
            return
        }
        
        guard emailIDField.text == "test@testing.co" else {
            Alert().showAlert(title: "Email not found (or) Invalid", message: "Please enter a valid email", vc: self)
            return
        }
        
        guard passwordField.text == "password" else {
            Alert().showAlert(title: "Invalid Password", message: "Please enter the correct password", vc: self)
            return
        }
        
        let tabBar = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBar")
        navigationController?.setViewControllers([tabBar], animated: true)

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
