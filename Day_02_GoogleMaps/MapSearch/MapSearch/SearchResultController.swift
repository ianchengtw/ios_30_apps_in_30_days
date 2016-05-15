//
//  SearchResultController.swift
//  MapSearch
//
//  Created by Ian on 5/9/16.
//  Copyright © 2016 ianchengtw_ios_30_apps_in_30_days. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

protocol LocateOnTheMap{
    func locateWithLongitude(location: CLLocationCoordinate2D, bounds: GMSCoordinateBounds, title: String)
}

class SearchResultController: UITableViewController {
    
    var searchResults = [String]()
    var delegate: LocateOnTheMap?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellIdentifier", forIndexPath: indexPath)
        
        cell.textLabel?.text = self.searchResults[indexPath.row]
        
        return cell
    }
    
    
    
    override func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath){
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
            guard
                let URIEncodingAddress = self.searchResults[indexPath.row].stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.symbolCharacterSet()),
                let url = NSURL(string: "https://maps.googleapis.com/maps/api/geocode/json?address=\(URIEncodingAddress)&sensor=false")
                else { return }
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (oData, res, error) -> Void in
                
                guard let data = oData else { print(error); return }
                
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves) as! NSDictionary
                    
                    guard
                        let locationLat = json["results"]?.valueForKey("geometry")?.valueForKey("location")?.valueForKey("lat")?.objectAtIndex(0) as? Double,
                        let locationLng = json["results"]?.valueForKey("geometry")?.valueForKey("location")?.valueForKey("lng")?.objectAtIndex(0) as? Double,
                        let northeastLat = json["results"]?.valueForKey("geometry")?.valueForKey("bounds")?.valueForKey("northeast")?.valueForKey("lat")?.objectAtIndex(0) as? Double,
                        let northeastLng = json["results"]?.valueForKey("geometry")?.valueForKey("bounds")?.valueForKey("northeast")?.valueForKey("lng")?.objectAtIndex(0) as? Double,
                        let southwestLat = json["results"]?.valueForKey("geometry")?.valueForKey("bounds")?.valueForKey("southwest")?.valueForKey("lat")?.objectAtIndex(0) as? Double,
                        let southwestLng = json["results"]?.valueForKey("geometry")?.valueForKey("bounds")?.valueForKey("southwest")?.valueForKey("lng")?.objectAtIndex(0) as? Double
                        else { return }
                    
                    self.delegate?.locateWithLongitude(
                        CLLocationCoordinate2D(latitude: locationLat, longitude: locationLng),
                        bounds: GMSCoordinateBounds(
                            coordinate: CLLocationCoordinate2D(latitude: northeastLat, longitude: northeastLng),
                            coordinate: CLLocationCoordinate2D(latitude: southwestLat, longitude: southwestLng)
                        ),
                        title: self.searchResults[indexPath.row]
                    )
                    
                }catch {
                    print("Error")
                }
            }
            
            task.resume()
    }
    
    
    func reloadDataWithArray(array:[String]){
        
        self.searchResults = array
        self.tableView.reloadData()
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
