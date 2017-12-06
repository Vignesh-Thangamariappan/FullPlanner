//
//  MainNavigation.swift
//  MyAssistant
//
//  Created by user on 12/4/17.
//  Copyright © 2017 Vignesh. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit

class MainNavigation: UINavigationController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginManager = LoginManager()
        loginManager.loginBehavior = .browser
        if let accessToken = FBSDKAccessToken.current() {
            let login = Login()
            login.getFBUserData()
        } else {
            let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "login")
            setViewControllers([login], animated: true)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
