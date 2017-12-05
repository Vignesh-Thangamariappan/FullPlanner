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
    
    let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    func showLoader(self viewController: UIViewController) {
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        viewController.present(alert, animated: true, completion: nil)
        return
    }
    func dismissLoader() {
        alert.dismiss(animated: false, completion: nil)
        return
    }
    
    
    func showAlert(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
    
    
    
}
