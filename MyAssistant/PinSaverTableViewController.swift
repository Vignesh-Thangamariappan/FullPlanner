//
//  PinSaverTableViewController.swift
//  MyAssistant
//
//  Created by user on 12/7/17.
//  Copyright © 2017 Vignesh. All rights reserved.
//
protocol PinSaverDelegate {
    func setPin(notes: String, title:String?)
}
import UIKit
import MapKit
class PinSaverTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var notesField: UITextField!
    
    @IBOutlet weak var titleField: UITextField!
    var delegate : PinSaverDelegate?
    @IBOutlet weak var locationLabel: UILabel!
    var location:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate = self
        titleField.tag = 0
        notesField.delegate = self
        notesField.tag = 1
        
        locationLabel.text = location
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            notesField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }


@IBAction func cancelTapped(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
}


@IBAction func saveTapped(_ sender:Any) {
    
    guard let theNote = notesField.text, let title = titleField.text else {
        print("No Field Exists")
        return }
    if theNote.isEmpty {
        Alert().showAlert(title: "Missing Notes", message: "Please enter notes before saving", vc: self)
        return
    }
    else {
        delegate?.setPin(notes: theNote,title: title)
        dismiss(animated: true, completion: nil)
    }
}

}

