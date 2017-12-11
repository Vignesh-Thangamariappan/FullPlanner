//
//  DashboardCollectionViewController.swift
//  MyAssistant
//
//  Created by user on 12/8/17.
//  Copyright © 2017 Vignesh. All rights reserved.
//

import UIKit
import MapKit
import CoreData

private let reuseIdentifier = "pinCell"

class DashboardCollectionViewController: UICollectionViewController {
    var userPins = [PinDataClass]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPinData()
        self.clearsSelectionOnViewWillAppear = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tabBarController?.navigationItem.title = "Dashboard"
//        getPinData()
        print(userPins)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPins.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        let titleLabel = cell.viewWithTag(1) as! UILabel
        let notesLabel = cell.viewWithTag(2) as! UILabel
        titleLabel.text = userPins[indexPath.row].title
        notesLabel.text = userPins[indexPath.row].notes
        return cell
    }
    func getPinData() {
        let fetchRequest: NSFetchRequest<PinDataClass> = PinDataClass.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            userPins = try DatabaseController.persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print("Unable to generate Pins")
        }
    }
}
