//
//  PinDescriptionTableViewController.swift
//  MyAssistant
//
//  Created by user on 12/8/17.
//  Copyright © 2017 Vignesh. All rights reserved.
//
protocol PinDescriptionDelegate {
    func saveContext()
    func removePin(pin: PinAnnotation)
}


import UIKit
import CoreData
import MapKit
class PinDescriptionTableViewController: UITableViewController {
    
    @IBOutlet weak var rightButton: UIBarButtonItem!
    var pinInfo = [PinDataClass]()
    var pinDetails: PinDataClass?
    var delegate: PinDescriptionDelegate?
    let alertHelper = Alert()
    var theTitle: String?
    var notes: String?
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var notesField: UITextField!
    @IBOutlet weak var titleField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate = self
        notesField.delegate = self
        if let pin = pinDetails {
            titleField.text = pin.title
            notesField.text = pin.notes
        }
        //        if let pinIdentifier = pinId {
        //            let fetchRequest: NSFetchRequest<PinDataClass> = PinDataClass.fetchRequest()
        //            fetchRequest.predicate = NSPredicate(format: "id==\(pinIdentifier)")
        //
        //            do {
        //                pinInfo = try DatabaseController.persistentContainer.viewContext.fetch(fetchRequest)
        //                guard let pin = pinInfo.first else {
        //                    print("No relevant data found")
        //                    return
        //                }
        //                print(pin)
        //                titleField.text = pin.title
        //                notesField.text = pin.notes
        //
        //            } catch {
        //                print("Error: \(error)")
        //            }
        //
        //        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rightButtonTapped(_ sender: Any) {
        if rightButton.title == "Delete" {
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
                DatabaseController.persistentContainer.viewContext.delete(pinData)
                DatabaseController.saveContext()
                    dismiss(animated: true, completion: nil)
                }
            } catch {
                print("Fetch failed due to error \(error)")
            }
        } else if rightButton.title == "Save" {
            guard let title = titleField.text, let notes = notesField.text else {
                return
            }
            if title.isEmpty || notes.isEmpty {
                alertHelper.showAlert(title: "Empty Field(s)", message: "Please do not leave any field empty", vc: self)
            } else {
                let pinData: PinDataClass = NSEntityDescription.insertNewObject(forEntityName: "PinData", into: DatabaseController.persistentContainer.viewContext) as! PinDataClass
                pinData.title = titleField.text
                pinData.date = Date()
                pinData.notes = notesField.text
                delegate?.saveContext()
                dismiss(animated: true, completion: nil)
            }
        }
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
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if titleField.text != theTitle || notesField.text != theTitle {
            rightButton.title = "Save"
        }
    }
}
