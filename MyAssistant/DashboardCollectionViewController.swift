//
//  DashboardCollectionViewController.swift
//  MyAssistant
//
//  Created by user on 12/8/17.
//  Copyright © 2017 Vignesh. All rights reserved.
//

import UIKit
import MapKit

private let reuseIdentifier = "pinCell"

class DashboardCollectionViewController: UICollectionViewController {
    
    let data = ["Apple", "Samsung", "Redmi", "Lenovo"]
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        //        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tabBarController?.navigationItem.title = "Dashboard"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return data.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        // Configure the cell
  
        let label = cell.viewWithTag(2) as! UILabel
        label.text = data[indexPath.row]
        return cell
    }
    
}
