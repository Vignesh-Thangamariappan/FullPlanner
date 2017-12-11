//
//  ViewController.swift
//  MyAssistant
//
//  Created by user on 12/4/17.
//  Copyright © 2017 Vignesh. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit

class LoginViewController: UIViewController{
    
    var dict : [String:Any] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
//        let loginButton = LoginButton(readPermissions: [.publicProfile,.email,.userHometown,.userFriends])
//        loginButton.center = view.center
//        loginButton.loginBehavior = .browser
//        loginButton.delegate = self
//        view.addSubview(loginButton)
    }
    
//    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
//        print("Logged In Successfully")
//        getFBUserData()
//    }
//    
//    func loginButtonDidLogOut(_ loginButton: LoginButton) {
//        print("LoggedOut Successfully")
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func fbLoginButtonTapped(_ sender: Any) {
        let alertHelper = Alert()
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile,.email], viewController: self){ loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
                alertHelper.showAlert(title: "Something went wrong", message: "Please Try Again", vc: self)
            case .cancelled:
                print("User cancelled login.")
                alertHelper.showAlert(title: "Login Cancelled by User", message: "Please Try Again", vc: self)
                
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.getFBUserData()
            }
        }
        
    }
    func getFBUserData(){
        if(FBSDKAccessToken.current()) != nil {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,name,picture.type(large),email"]).start(completionHandler: { (connection, result, error)-> Void in
                if let err = error {
                    print(err)
                } else {
                    self.dict = result as! [String:Any]
                    let data = self.dict["picture"] as? [String:Any]
                    let url = data!["data"] as? [String:Any]
                    let pic = url!["url"]
                    UserDefaults.standard.set(pic, forKey: "userImage")
                    UserDefaults.standard.set(self.dict["name"], forKey: "userName")
                    UserDefaults.standard.set(self.dict["email"],forKey:"userMail")
                    self.goToTabBar()
                }
            })
        }
        
    }
    private func goToTabBar() {
        let tabBar = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBar")
        navigationController?.setViewControllers([tabBar], animated: true)
    }
}



