//
//  FlickrPhotosViewController.swift
//  FlickrSearch
//
//  Created by Ian on 5/15/16.
//  Copyright © 2016 ianchengtw_ios_30_apps_in_30_days. All rights reserved.
//

import UIKit

class FlickrPhotosViewController: UICollectionViewController {
    
    private let reuseIdentifier = "FlickrCell"
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    private var searches = [FlickrSearchResults]()
    private let flickr = Flickr()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return searches.count
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searches[section].searchResults.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as? FlickrPhotoCell else { return UICollectionViewCell() }
        
        guard let image = photoForIndexPath(indexPath).thumbnail else { return UICollectionViewCell() }
        
        cell.imageView.image = image
        cell.backgroundColor = UIColor.blackColor()
    
        return cell
    }

    func photoForIndexPath(indexPath: NSIndexPath) -> FlickrPhoto {
        return searches[indexPath.section].searchResults[indexPath.row]
    }

}

extension FlickrPhotosViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        textField.addSubview(activityIndicator)
        
        guard let searchingText = textField.text else { return false }
        
        flickr.searchFlickrForTerm(searchingText) { results, error in
            
            activityIndicator.removeFromSuperview()
            
            if error != nil {
                print("Error searching: \(error)")
            }
            
            if let results = results {
                
                print("Found \(results.searchResults.count) matching \(results.searchTerm)")
                
                self.searches.insert(results, atIndex: 0)
                
                self.collectionView?.reloadData()
                
            }
            
            textField.text = nil
            textField.resignFirstResponder()
            
        }
        
        return true
    }
    
}

extension FlickrPhotosViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let flickrPhoto = photoForIndexPath(indexPath)
        
        if var size = flickrPhoto.thumbnail?.size {
            size.width += 10
            size.height += 10
            return size
        }
        
        return CGSize(width: 100, height: 100)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
}
