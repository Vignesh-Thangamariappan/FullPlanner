//
//  Alert.swift
//  Random User Generator
//
//  Created by user on 11/24/17.
//  Copyright © 2017 Vignesh. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    
    let loaderAlert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    func showLoader(self viewController: UIViewController) {
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = .gray
        loadingIndicator.startAnimating();
        loaderAlert.view.addSubview(loadingIndicator)
        viewController.present(loaderAlert, animated: true, completion: nil)
        return
    }
    func dismissLoader() {
        loaderAlert.dismiss(animated: false, completion: nil)
        return
    }
    
    
    func showAlert(title: String, message: String, vc: UIViewController) {
        let customAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        customAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(customAlert, animated: true)
    }
    
    
    
}

