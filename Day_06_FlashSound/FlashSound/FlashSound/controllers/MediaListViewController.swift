//
//  MediaListViewController.swift
//  FlashSound
//
//  Created by Ian on 5/16/16.
//  Copyright © 2016 ianchengtw_ios_30_apps_in_30_days. All rights reserved.
//

import UIKit
import MediaPlayer

class MediaListViewController: UICollectionViewController {
    
    private let reuseIdentifier = String(MediaViewCell)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let audioControlPanel = UIView()
        audioControlPanel.frame = CGRectMake(0, self.collectionView!.bounds.height - 120, self.collectionView!.bounds.width, 120)
        
        let stopButton = UIButton(frame: CGRectMake( audioControlPanel.bounds.width / 2 - 50, 10, 100, 100 ))
        stopButton.setImage(UIImage(named: "icon-stop"), forState: .Normal)
        stopButton.addTarget(self, action: Selector("StopMusic:"), forControlEvents: .TouchUpInside)
        
        audioControlPanel.addSubview(stopButton)
        self.view.addSubview(audioControlPanel)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        collectionView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func StopMusic(sender: UIButton) {
        
        MPMusicPlayerController.applicationMusicPlayer().stop()
        
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return storage.playlists.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        guard
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as? MediaViewCell,
            let item = storage.getItem(indexPath.row)
            else { return UICollectionViewCell() }
        
        cell.titleLabel.text = item.title
        cell.imageView.image = item.image
        cell.imageView.contentMode = UIViewContentMode.ScaleToFill
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        guard
            let item = storage.getItem(indexPath.row)
            else { return }
        
        let player = MPMusicPlayerController.applicationMusicPlayer()
        player.setQueueWithItemCollection(item.mediaItemCollection)
        player.play()
        
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
