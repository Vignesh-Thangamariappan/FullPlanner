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

class Maps: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var savedPins = [PinAnnotation]()
    var userData = [PinAnnotation:String]()
    var newPin: PinAnnotation?
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsPointsOfInterest = true
        mapView.delegate = self
        mapView.showsBuildings = true
        let locationChennai = CLLocationCoordinate2DMake(13.0827, 80.2707)
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(locationChennai, 1500, 1500), animated: true)
        getLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        print(savedPins)
        tabBarController?.navigationItem.title = "Maps"
        for pin in savedPins {
            mapView.addAnnotation(pin)
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
            let destVC = segue.destination as! PinSaverTableViewController
            destVC.location = (sender as! String)
            destVC.delegate = self
        }
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        let pinInfoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pinInfo")
        navigationController?.pushViewController(pinInfoVC, animated: true)
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
        savedPins.append(pin)
        userData[pin] = notes
        
    }
    
}
