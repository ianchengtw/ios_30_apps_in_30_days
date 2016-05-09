//
//  ViewController.swift
//  MapSearch
//
//  Created by Ian on 5/9/16.
//  Copyright © 2016 ianchengtw_ios_30_apps_in_30_days. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController, UISearchBarDelegate, LocateOnTheMap
{

    @IBOutlet weak var mapViewContainer: UIView!
    
    var mapView: GMSMapView!
    var searchResultController = SearchResultController()
    var resultsArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.mapView = GMSMapView(frame: self.mapViewContainer.frame)
        self.view.addSubview(self.mapView)
        
        self.searchResultController.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func searchWithAddress(sender: UIBarButtonItem) {
        
        let searchController = UISearchController(searchResultsController: self.searchResultController)
        searchController.searchBar.delegate = self
        self.presentViewController(searchController, animated: true, completion: nil)
        
    }
    
    func locateWithLongitude(location: CLLocationCoordinate2D, bounds: GMSCoordinateBounds, title: String) {
        
        dispatch_async(dispatch_get_main_queue()) {
            
            guard let camera = self.mapView.cameraForBounds(bounds, insets: UIEdgeInsetsZero) else { return }
            self.mapView.clear()
            self.mapView.camera = camera
            
            let marker = GMSMarker(position: location)
            marker.title = title
            marker.map = self.mapView
            
        }
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        let placeClient = GMSPlacesClient()
        placeClient.autocompleteQuery(searchText, bounds: nil, filter: nil) { (results, error: NSError?) -> Void in
            
            self.resultsArray.removeAll()
            guard let results = results else { return }
            
            for result in results {
                self.resultsArray.append(result.attributedFullText.string)
            }
            
            self.searchResultController.reloadDataWithArray(self.resultsArray)
            
        }
        
    }

}

