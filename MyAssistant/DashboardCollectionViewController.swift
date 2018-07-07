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

class DashboardCollectionViewController: UICollectionViewController, NSFetchedResultsControllerDelegate {
    var fetchedResultsController: NSFetchedResultsController<PinDataClass>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fetchRequest: NSFetchRequest<PinDataClass> = PinDataClass.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DatabaseController.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
             try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
        self.clearsSelectionOnViewWillAppear = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tabBarController?.navigationItem.title = "Dashboard"
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView?.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        let titleLabel = cell.viewWithTag(1) as! UILabel
        let notesLabel = cell.viewWithTag(2) as! UILabel
        if let object = fetchedResultsController.fetchedObjects?[indexPath.row] {
        
        titleLabel.text = object.title
        notesLabel.text = object.notes
        }
        return cell
    }
}
