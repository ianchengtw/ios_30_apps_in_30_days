//
//  DataModel.swift
//  TWGeoCounty
//
//  Created by Ian on 5/10/16.
//  Copyright © 2016 ianchengtw_ios_30_apps_in_30_days. All rights reserved.
//

import Foundation
import CoreLocation

struct CountyGeo {
    var coordinates: [CLLocationCoordinate2D] = []
}

// Singleton plugin
extension DataModel {
    
    private static var _instance: DataModel? = nil
    
    class func getInstance() -> DataModel {
        
        if DataModel._instance == nil {
            DataModel._instance = DataModel()
        }
        
        return DataModel._instance!
        
    }
    
}

class DataModel {
    
    typealias County = String
    private var _twCounty: [County: CountyGeo] = [:]
    var twCounty: [County: CountyGeo] { return self._twCounty }
    
    init() {
        
        // read json
        let url = NSBundle.mainBundle().URLForResource("twCounty2010.geo", withExtension: "json")
        let data = NSData(contentsOfURL: url!)
        
        do {
            let object = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            if let dictionary = object as? [String: AnyObject] {
                parseJSONObjectToModel(dictionary)
            }
        } catch {
            // Handle Error
        }
        
    }
    
    func parseJSONObjectToModel(object: [String: AnyObject]) {
        
        guard
            let features = object["features"] as? [[String: AnyObject]]
            else { return }
        
        for feature in features {
            
            guard
                let properties = feature["properties"] as? [String: AnyObject],
                let CountyName = properties["COUNTYNAME"] as? String!,
                let geometry = feature["geometry"] as? [String: AnyObject],
                let coordinates = geometry["coordinates"] as? [ [ [ [ Double ] ] ] ]
                else { continue }
            
            self._twCounty[CountyName] = CountyGeo()
            
            for coordinate in coordinates[0][0] {
                
                self._twCounty[CountyName]?.coordinates.append(
                    CLLocationCoordinate2D(latitude: coordinate[1], longitude: coordinate[0])
                )
                
            }
            
        }
        
    }
    
}