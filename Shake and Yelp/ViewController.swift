//
//  ViewController.swift
//  Shake and Yelp
//
//  Created by Sam Lee on 4/4/17.
//  Copyright © 2017 Sam Lee. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    var client: YLPClient?
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var chosenPlaceLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBAction func searchButton(_ sender: UIButton) {
        
        let latitude = locationManager.location?.coordinate.latitude
        let longitude = locationManager.location?.coordinate.longitude
        let coordinate = YLPCoordinate(latitude: latitude!, longitude: longitude!)
        let term = searchTextField.text!
        
        client?.search(with: coordinate,
                       term: term,
                       limit: 3,
                       offset: 0,
                       sort: .bestMatched,
                       completionHandler:
            { search, error in
                guard search != nil else {
                    print("Searched errored: \(error)")
                    return
                }
                guard let topBusiness = search?.businesses.first else {
                    print("No businesses found")
                    return
                }
                print("Top business: \(topBusiness.name), id: \(topBusiness.identifier)")
                
                DispatchQueue.main.async {
                    self.chosenPlaceLabel.text = "Top business: \(topBusiness.name)"
                }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestLocation()
        }
        
        let appId = "a14lrvvLkVsDbjUFI9wUQw"
        let secretKey = "i9tJBRBtylbMwFRf6Mig9TnFRpcwFrbhBHnoOXSqicwWY0YF6XSbczm3yFohqyBP"
        
        YLPClient.authorize(withAppId: appId, secret: secretKey) { (client, error) in
            self.client = client
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        searchTextField.resignFirstResponder()
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let latitude = locationManager.location?.coordinate.latitude
            let longitude = locationManager.location?.coordinate.longitude
            let coordinate = YLPCoordinate(latitude: latitude!, longitude: longitude!)
            let term = searchTextField.text!
            
            client?.search(with: coordinate,
                           term: term,
                           limit: 3,
                           offset: 0,
                           sort: .bestMatched,
                           completionHandler:
                { search, error in
                    guard search != nil else {
                        print("Searched errored: \(error)")
                        return
                    }
                    guard let topBusiness = search?.businesses.first else {
                        print("No businesses found")
                        return
                    }
                    print("Top business: \(topBusiness.name), id: \(topBusiness.identifier)")
                    
                    DispatchQueue.main.async {
                        self.chosenPlaceLabel.text = "Top business: \(topBusiness.name)"
                    }
            })
        }
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            let location = locations.last!
            print("Location: \(location)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
}
