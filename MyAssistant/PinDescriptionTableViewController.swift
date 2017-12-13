//
//  PinDescriptionTableViewController.swift
//  MyAssistant
//
//  Created by user on 12/8/17.
//  Copyright © 2017 Vignesh. All rights reserved.
//

import UIKit
import CoreData
import MapKit
class PinDescriptionTableViewController: UITableViewController {
    
    @IBOutlet weak var rightButton: UIBarButtonItem!
    var pinInfo = [PinDataClass]()
    var pinDetails: PinDataClass?
    var receivedData:(PinDataClass,PinAnnotation)?
    var pinAnnotation:PinAnnotation?
    let alertHelper = Alert()
    var theTitle: String?
    var notes: String?
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var notesField: UITextField!
    @IBOutlet weak var titleField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let detail = receivedData?.0, let annotation = receivedData?.1 {
            pinDetails = detail
            pinAnnotation = annotation
        }
        titleField.delegate = self
        notesField.delegate = self
        if let pin = pinDetails {
            titleField.text = pin.title
            notesField.text = pin.notes
            locationLabel.text = pin.address
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rightButtonTapped(_ sender: Any) {
        guard let id = pinDetails?.id else {
            alertHelper.showAlert(title: "Oops! Something went wrong", message: "Please try again", vc: self)
            return
        }
        let fetchRequest: NSFetchRequest<PinDataClass> = PinDataClass.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == '\(id)'")
        do {
            let object = try DatabaseController.persistentContainer.viewContext.fetch(fetchRequest)
            print(object)
            if let pinData = object.first {
                if rightButton.title == "Delete" {
                    showDeleteAlert(forPin: pinData)
                } else if rightButton.title == "Save" {
                    guard let title = titleField.text, let notes = notesField.text else {
                        return
                    }
                    if title.isEmpty || notes.isEmpty {
                        alertHelper.showAlert(title: "Empty Field(s)", message: "Please do not leave any field empty", vc: self)
                    } else {
                        pinData.title = title
                        pinData.notes = notes
                        DatabaseController.saveContext()
                        dismiss(animated: true, completion: nil)
                    }
                }
            }
        } catch {
            print("Fetch failed due to error \(error)")
        }
    }
    func showDeleteAlert(forPin pinData: PinDataClass) {
        let deleteAlert = UIAlertController(title: "Are you sure?", message: "All the Data will be deleted", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .destructive) { (alert) in
            DatabaseController.persistentContainer.viewContext.delete(pinData)
            DatabaseController.saveContext()
            self.dismiss(animated: true, completion: nil)
        }
        let no = UIAlertAction(title: "No", style: .default, handler: nil)
        deleteAlert.addAction(yes)
        deleteAlert.addAction(no)
        present(deleteAlert, animated: true, completion: nil)
    }
}

extension PinDescriptionTableViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            theTitle = textField.text
        } else if textField.tag == 1 {
            notes = notesField.text
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            notesField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if titleField.text != theTitle || notesField.text != theTitle {
            rightButton.title = "Save"
        }
    }
}
