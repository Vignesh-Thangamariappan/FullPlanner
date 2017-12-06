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

class Login: UIViewController, LoginButtonDelegate{
    
    var dict : [String:Any] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let loginButton = LoginButton(readPermissions: [.publicProfile,.email,.userHometown,.userFriends])
        loginButton.center = view.center
        loginButton.loginBehavior = .browser
        loginButton.delegate = self
        view.addSubview(loginButton)
        
    }
    
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        print("Logged In Successfully")
        getFBUserData()
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("LoggedOut Successfully")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func getFBUserData(){
        if(FBSDKAccessToken.current()) != nil {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,name,picture.type(large),email"]).start(completionHandler:{ (connection, result, error)-> Void in
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
            }
            )}
    }
    func goToTabBar() {
        let tabBar = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBar")
        navigationController?.setViewControllers([tabBar], animated: true)
    }
}


