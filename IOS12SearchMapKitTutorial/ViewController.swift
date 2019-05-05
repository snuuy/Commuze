//
//  ViewController.swift
//  IOS12SearchMapKitTutorial
//
//  Created by Arthur Knopper on 06/09/2018.
//  Copyright © 2018 Arthur Knopper. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AVFoundation

class ViewController: UIViewController, UISearchBarDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var radius:Int = 0
    var destination = MKMapItem()
    
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var commuzeButton: UIButton!
    @IBAction func slider(_ sender: UISlider) {
        radius = Int(sender.value)
        label.text = "Wake Distance: " + String(radius) +  " km"
    }
    
    
    @IBAction func sleepTime(_ sender: UIButton) {
        let geofenceRegionCenter = destination.placemark.location!.coordinate
        let geofenceRegion = CLCircularRegion(
            center: geofenceRegionCenter,
            radius: Double(self.radius * 1000),
            identifier: "DestinationCircle"
        )
        geofenceRegion.notifyOnEntry = true
        //geofenceRegion.notifyOnExit = true
        
        self.locationManager.startMonitoring(for: geofenceRegion)
        
        search.isHidden =  true
        commuzeButton.setTitle("Cancel", for: .normal)
    }
    
    var locationManager = CLLocationManager()
    let searchRadius: CLLocationDistance = 2000
    
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func searchOnValueChanged(_ sender: Any) {
            mapView.removeAnnotations(mapView.annotations)
            
            searchInMap()
    }
    
    func getCurrentLocation() -> (CLLocationDegrees,CLLocationDegrees) {
        guard let locValue: CLLocationCoordinate2D = locationManager.location?.coordinate else { return (CLLocationDegrees(0),CLLocationDegrees(0)) }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    
        
        return (locValue.latitude, locValue.longitude)
    }
    
/*
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) -> (Double, Double) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        return (locValue.latitude, locValue.longitude)
    }
 
 */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        mapView.delegate = self
        search.delegate = self
        mapView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 250, right: 10)
        mapView.showAnnotations(self.mapView.annotations, animated: true)
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    
        var (lat,long) = (CLLocationDegrees(0),CLLocationDegrees(0))
        while lat == CLLocationDegrees(0) && long == CLLocationDegrees(0) {
            (lat,long) = getCurrentLocation()
        }
        let currentLocation = CLLocation(latitude: lat, longitude: long)
        
        let coordinateRegion = MKCoordinateRegion.init(center: currentLocation.coordinate, latitudinalMeters: searchRadius * 2.0, longitudinalMeters: searchRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchInMap()
        
    }
    
    func searchInMap() {
        let (lat,long) = getCurrentLocation()
        let currentLocation = CLLocation(latitude: lat, longitude: long)
        // 1
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = search.text
        // 2
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        request.region = MKCoordinateRegion(center: currentLocation.coordinate, span: span)
        // 3
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: {(response, error) in
            if response != nil {
                let item =  response!.mapItems[0]
                self.addPinToMapView(title: item.name, latitude: item.placemark.location!.coordinate.latitude, longitude: item.placemark.location!.coordinate.longitude)
                
               self.destination = item
            }
        })
        

        
    }
    
    func addPinToMapView(title: String?, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        if let title = title {
            mapView.removeAnnotations(mapView.annotations)
            
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let annotation = MKPointAnnotation()
        
            annotation.coordinate = location
            annotation.title = title
            
            mapView.addAnnotation(annotation)
        }
        mapView.showAnnotations(self.mapView.annotations, animated: true)

    }
    
}

extension UIViewController
{
    func hideKeyboard()
{
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(
    target: self,
    action: #selector(UIViewController.dismissKeyboard))
    
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}






