//
//  Maps.swift
//  MyAssistant
//
//  Created by user on 12/5/17.
//  Copyright © 2017 Vignesh. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData


class Maps: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var savedPins = [PinAnnotation]()
    var fetchedPins = [PinDataClass]()
    var newPin: PinAnnotation?
    var address: String?
    var locationManager = CLLocationManager()
    var fetchedResultsController: NSFetchedResultsController<PinDataClass>!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsPointsOfInterest = true
        mapView.delegate = self
        mapView.showsBuildings = true
        getPinDetails()
//        getPinData()
        let locationChennai = CLLocationCoordinate2DMake(13.0827, 80.2707)
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(locationChennai, 1500, 1500), animated: true)
        getLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print(savedPins)
        tabBarController?.navigationItem.title = "Maps"
//        mapView.removeAnnotations(mapView.annotations)
//        getPinData()
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
                if let title = pinData.title, let subtitle = pinData.subtitle {
                    let pin = PinAnnotation(title: title, subtitle: subtitle, location: CLLocationCoordinate2DMake(pinData.locationX, pinData.locationY))
                    mapView.addAnnotation(pin)
                }
            }
        } catch {
            print("Error generating fetch results \(error)")
        }
    }
    func getPinData() {
        let fetchRequest: NSFetchRequest<PinDataClass> = PinDataClass.fetchRequest()
        do {
            fetchedPins = try DatabaseController.persistentContainer.viewContext.fetch(fetchRequest)
            for pinData in fetchedPins {
                if let title = pinData.title, let subtitle = pinData.subtitle {
                    let pin = PinAnnotation(title: title, subtitle: subtitle, location: CLLocationCoordinate2DMake(pinData.locationX, pinData.locationY))
                    mapView.addAnnotation(pin)
                }
            }
        } catch {
            print(" Unable to fetch data due to Error = \(error)")
        }
    }
    
    
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
        let userLocation:CLLocation = locations[0] as CLLocation
        manager.stopUpdatingLocation()
        let center = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)
        
        let region = MKCoordinateRegionMakeWithDistance(center, 1500, 1500)
        mapView.userTrackingMode = .followWithHeading
        mapView.showsTraffic = true
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func locationTapped(_ sender: Any) {
        getLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error =\(error)")
    }
    
    @IBAction func didLongPress(_ sender: UITapGestureRecognizer) {
        
        
        let touchPoint = sender.location(in: mapView)
        let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: touchCoordinate.latitude, longitude: touchCoordinate.longitude)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
            guard let addressDict = placemarks?[0].addressDictionary  else {
                return
            }
            if let locationName = addressDict["Name"] as? String, let city = addressDict["City"] as? String {
                self.newPin = PinAnnotation(title: locationName, subtitle: city, location: touchCoordinate)
            }
            if let formattedAddress = addressDict["FormattedAddressLines"] as? [String] {
                self.address = formattedAddress.joined(separator: ", ")
                self.performSegue(withIdentifier: "toSavePin", sender: (self.address))
                return
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSavePin" {
            let destVC = segue.destination as? PinSaverTableViewController
            destVC?.location = (sender as! String)
            destVC?.delegate = self
        } else if segue.identifier == "toViewPin" {
            let destVC = segue.destination as? PinDescriptionTableViewController
//            destVC?.receivedData = sender as? (PinDataClass,GMSMarker)
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if let pinCoordinate = view.annotation?.coordinate {
            for pinData in fetchedPins {
                if pinData.locationX == pinCoordinate.latitude && pinData.locationY == pinCoordinate.longitude {
//                if pinData.locationX == Double(pinCoordinate.latitude) && pinData.locationY == Double(pinCoordinate.longitude) {
                    print(pinData)
                    print(pinCoordinate)
                    let pinID = pinData
                    performSegue(withIdentifier: "toViewPin", sender: (pinID,view.annotation as? PinAnnotation))
                }
            }
        }
    }
}

extension Maps:PinSaverDelegate {
    func cancel() {
        print("cancelled")
    }
    
    func setPin(notes: String,title: String?) {
        guard let pin = newPin, let newTitle = title, let address = address else{
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
        pinData.locationX = Double(pin.coordinate.latitude)
        pinData.locationY = Double(pin.coordinate.longitude)
        pinData.title = pin.title
        pinData.subtitle = pin.subtitle
        pinData.notes = notes
        pinData.address = address
        savedPins.append(pin)
        DatabaseController.saveContext()
        getPinData()
    }
}

extension Maps: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        mapView.removeAnnotations(mapView.annotations)
        guard let fetchedObjects = fetchedResultsController.fetchedObjects else {
            print("Error fetching the pins")
            return
        }
        fetchedPins = fetchedObjects
        for pinData in fetchedPins {
            if let title = pinData.title, let subtitle = pinData.subtitle {
                let pin = PinAnnotation(title: title, subtitle: subtitle, location: CLLocationCoordinate2DMake(pinData.locationX, pinData.locationY))
                mapView.addAnnotation(pin)
            }
        }
    }
}

