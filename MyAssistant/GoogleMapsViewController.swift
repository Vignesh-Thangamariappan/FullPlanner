//
//  GoogleMapsViewController.swift
//  MyAssistant
//
//  Created by user on 12/13/17.
//  Copyright © 2017 Vignesh. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import CoreData
import GooglePlaces

class GoogleMapsViewController: UIViewController, GMSMapViewDelegate {
    
    var locationManager = CLLocationManager()
    var fetchedPins = [PinDataClass]()
    var fetchedResultsController: NSFetchedResultsController<PinDataClass>!
    var address: String?
    var newMarker: GMSMarker?
    
    @IBOutlet weak var mapView: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: 48.857165, longitude: 2.354613, zoom: 8.0)
        mapView.camera = camera
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.isBuildingsEnabled = true
        getPinDetails()
        getLocation()
    }
    
    func getPinDetails() {
        let fetchRequest: NSFetchRequest<PinDataClass> = PinDataClass.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DatabaseController.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
            guard let fetchedObjects = fetchedResultsController.fetchedObjects else {
                return }
            fetchedPins = fetchedObjects
            for pinData in fetchedPins {
                if let title = pinData.title {
                   let marker = GMSMarker(position: CLLocationCoordinate2DMake(pinData.locationX, pinData.locationY))
                    marker.title = title
                    marker.map = mapView
                }
            }
        } catch {
            print("Error generating fetch results \(error)")
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSavePin" {
            let destVC = segue.destination as? PinSaverTableViewController
            destVC?.location = (sender as! String)
            destVC?.delegate = self
        } else if segue.identifier == "toViewPin" {
            let destVC = segue.destination as? PinDescriptionTableViewController
            destVC?.receivedData = sender as? (PinDataClass,GMSMarker)
        }
    }
    
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        
        
        let geoCoder = GMSGeocoder()
        newMarker = GMSMarker(position: coordinate)
        geoCoder.reverseGeocodeCoordinate(coordinate){ (locations,error) in
            guard let location = locations?.firstResult() else {
                return
            }
            print(location)
            self.address = location.lines?[0]
            self.newMarker?.title = location.lines?[0]
            self.newMarker?.icon = GMSMarker.markerImage(with: .blue)
            self.performSegue(withIdentifier: "toSavePin", sender: self.address)
        }

        
//        let geoCoder = CLGeocoder()
//        let marker = GMSMarker(position: coordinate)
//
//        geoCoder.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { (locations,error) in
//            guard let addressDict = locations?[0] else {
//                print("Unable to generate the address")
//                return
//            }
//            if let locationName = addressDict.name {
//                self.newMarker = GMSMarker(position: coordinate)
//                marker.title = locationName
//            }
//            if let formattedAddress = addressDict.addressDictionary!["FormattedAddressLines"] as? [String] {
//                self.address = formattedAddress.joined(separator: ", ")
//                print(self.address)
//            }
//
//
//        }
        
        
        
        
        newMarker?.map = mapView
        newMarker?.appearAnimation = .pop
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        newMarker = marker
        let pinCoordinate = marker.position
        for pinData in fetchedPins {
            if pinData.locationX == pinCoordinate.latitude && pinData.locationY == pinCoordinate.longitude {
                let pinID = pinData
//                performSegue(withIdentifier: "toViewPin", sender: (pinID, marker))
                print("Successfully Tapped")
            }
        }
        return false
    }
}

extension GoogleMapsViewController: CLLocationManagerDelegate {
    
    func getLocation() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .denied || status != .restricted || status != .notDetermined {
            manager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 8, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error =\(error)")
    }
}

extension GoogleMapsViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        mapView.clear()
        guard let fetchedObjects = fetchedResultsController.fetchedObjects else {
            print("Error fetching the pins")
            return
        }
        fetchedPins = fetchedObjects
        for pinData in fetchedPins {
            if let title = pinData.title, let address = pinData.address {
                let marker = GMSMarker(position: CLLocationCoordinate2DMake(pinData.locationX, pinData.locationY))
                marker.title = title
                marker.snippet = address
                marker.map = mapView
            }
        }
    }
}

extension GoogleMapsViewController:PinSaverDelegate {
    func cancel() {
        newMarker?.map = nil
    }
    
    func setPin(notes: String,title: String?) {
        guard let pin = newMarker, let newTitle = title, let address = address else{
            print("No PIN:")
            return
        }
        if !newTitle.isEmpty {
            pin.title = newTitle
        }
        let uniqueId = String.random()
        print(uniqueId)
        let pinData: PinDataClass = NSEntityDescription.insertNewObject(forEntityName: "PinData", into: DatabaseController.persistentContainer.viewContext) as! PinDataClass
        pinData.date = Date()
        pinData.id = uniqueId
        pinData.locationX = Double(pin.position.latitude)
        pinData.locationY = Double(pin.position.longitude)
        pinData.title = pin.title
        pinData.subtitle = pin.snippet
        pinData.notes = notes
        pinData.address = address
        
        DatabaseController.saveContext()
       
    }
}

extension String {
    
    static func random(length: Int = 32) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
}


