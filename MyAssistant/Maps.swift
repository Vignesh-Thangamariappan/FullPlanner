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
    var userData = [PinAnnotation:String]()
    var newPin: PinAnnotation?
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsPointsOfInterest = true
        mapView.delegate = self
        mapView.showsBuildings = true
        getPinData()
        let locationChennai = CLLocationCoordinate2DMake(13.0827, 80.2707)
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(locationChennai, 1500, 1500), animated: true)
        getLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        print(savedPins)
        tabBarController?.navigationItem.title = "Maps"
        getPinData()
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
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)
        //        mapView.addAnnotation(pin)
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
                let address = formattedAddress.joined(separator: ", ")
                self.performSegue(withIdentifier: "toSavePin", sender: (address))
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
            destVC?.pinDetails = sender as? PinDataClass
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if let pinCoordinate = view.annotation?.coordinate {
        for pinData in fetchedPins {
            if pinData.locationX == Double(pinCoordinate.latitude) && pinData.locationY == Double(pinCoordinate.longitude) {
                print(pinData)
                print(pinCoordinate)
                let pinID = pinData
                performSegue(withIdentifier: "toViewPin", sender: pinID)
            }
        }
        }
    }
}

extension Maps:PinSaverDelegate {
    func setPin(notes: String,title: String?) {
        guard let pin = newPin, let newTitle = title else {
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
        savedPins.append(pin)
        userData[pin] = notes
        DatabaseController.saveContext()
        getPinData()
    }
}
extension Maps: PinDescriptionDelegate{
    func removePin(pin: PinAnnotation) {
        mapView.removeAnnotation(pin)
    }
    
    func saveContext() {
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
