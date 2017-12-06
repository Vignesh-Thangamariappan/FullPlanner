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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let locationChennai = CLLocationCoordinate2DMake(13.0827, 80.2707)
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(locationChennai, 1500, 1500), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//        getLocation()
//    }
    
    
    func getLocation() {
        
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
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
        
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error =\(error)")
    }
    @IBAction func didLongPress(_ sender: UILongPressGestureRecognizer) {
        let touchPoint = sender.location(in: mapView)
        let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
//        print("\(touchCoordinate.latitude) + \(touchCoordinate.longitude)")
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: touchCoordinate.latitude, longitude: touchCoordinate.longitude)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
            guard let addressDict = placemarks?[0].addressDictionary  else {
                return
            }
            print(addressDict)
            // Print each key-value pair in a new row
            addressDict.forEach { print($0) }
            print(addressDict)
            // Print fully formatted address
            if let formattedAddress = addressDict["FormattedAddressLines"] as? [String] {
//                print(formattedAddress.joined(separator: ", "))
            }
            
            // Access each element manually
            if let locationName = addressDict["Name"] as? String, let city = addressDict["City"] as? String {
//                print(locationName)
                let pin = PinAnnotation(title: locationName, subtitle: city, location: touchCoordinate)
                self.mapView.addAnnotation(pin)
                
            }
            
            
            
            
        })
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let pinViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pinInfo")
        navigationController?.pushViewController(pinViewController, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let pinViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pinInfo")
        navigationController?.pushViewController(pinViewController, animated: true)
    }
    
}
