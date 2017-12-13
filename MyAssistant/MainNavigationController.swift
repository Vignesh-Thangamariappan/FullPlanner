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

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let loginManager = LoginManager()
        loginManager.loginBehavior = .browser
        if let accessToken = FBSDKAccessToken.current() {
            let loginVC = LoginViewController()
            loginVC.getFBUserData()
        } else {
            let loginController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "login")
            setViewControllers([loginController], animated: true)
        }
    }
}
