//
//  ViewController.swift
//  TWGeoCounty
//
//  Created by Ian on 5/10/16.
//  Copyright © 2016 ianchengtw_ios_30_apps_in_30_days. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {
    
    let dataModel = DataModel()
    var mapView: GMSMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.cameraWithLatitude(23.973875, longitude: 120.982024, zoom: 8)
        self.mapView = GMSMapView(frame: self.view.frame)
        self.mapView.camera = camera
        self.view.addSubview(self.mapView)
        
        drawCounty()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func drawCounty() {
        
        for (county, countyGeo) in dataModel.twCounty {
            
            
            // Create a rectangular path
            let path = GMSMutablePath()
            
            for geo in countyGeo.coordinates {
                path.addCoordinate(CLLocationCoordinate2D(latitude: geo.latitude, longitude: geo.longitude))

            }
            
            let polyline = GMSPolyline(path: path)
            polyline.strokeColor = UIColor.blackColor()
            polyline.strokeWidth = 2
            polyline.map = mapView
            
            
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: countyGeo.coordinates[0].latitude, longitude: countyGeo.coordinates[0].longitude))
            marker.title = county
            marker.map = self.mapView
            
        }
        
    }
    

}

