//
//  PinSaverTableViewController.swift
//  MyAssistant
//
//  Created by user on 12/7/17.
//  Copyright © 2017 Vignesh. All rights reserved.
//
protocol PinSaverDelegate {
    func setPin(notes: String)
}
import UIKit
import MapKit
class PinSaverTableViewController: UITableViewController {
    
    @IBOutlet weak var notesField: UITextField!
    var delegate : PinSaverDelegate?
    @IBOutlet weak var locationLabel: UILabel!
    var location:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        locationLabel.text = location
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveTapped(_ sender:Any) {
        
        if (notesField.text?.isEmpty)! {
            //        guard let theNote = notesField.text else {
            Alert().showAlert(title: "Missing Notes", message: "Please enter notes before saving", vc: self)
            return
        }
        else {
//                        delegate?.setPin(notes: theNote)
            delegate?.setPin(notes: notesField.text!)
            dismiss(animated: true, completion: nil)
        }
    }
    
    
}

