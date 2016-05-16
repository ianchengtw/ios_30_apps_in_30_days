//
//  Storage.swift
//  FlashSound
//
//  Created by Ian on 5/16/16.
//  Copyright © 2016 ianchengtw_ios_30_apps_in_30_days. All rights reserved.
//

import Foundation
import MediaPlayer

struct MusicRecord {
    let id: Int
    var title: String
    var mediaItemCollection: MPMediaItemCollection
    var image: UIImage
}

// Singleton plugin
extension Storage {
    
    private static var _instance: Storage? = nil
    
    class func sharedStorage() -> Storage {
        
        if self._instance == nil {
            
            self._instance = Storage()
            
        }
        
        return self._instance!
        
    }
    
}

class Storage {
    
    typealias Playlist = [Int: MusicRecord]
    private var _playlistCount: Int = 0
    private var _playlists = Playlist()
    var playlists: Playlist { return _playlists }
    
    init() {
        
        loadData()
        
    }
    
    private func loadData() {
        
        let data = NSUserDefaults.standardUserDefaults()
        
        guard
            let playlistCount = data.objectForKey("playlistCount") as? Int,
            let playlist = data.objectForKey("playlist") as? NSMutableDictionary
            else { return }
        
        _playlistCount = playlistCount
        _playlists = toggleStoredType(playlist)
        
    }
    
    private func saveData() {
        
        let data = NSUserDefaults.standardUserDefaults()
        
        data.removeObjectForKey("playlistCount")
        data.removeObjectForKey("playlist")
        
        data.setObject(_playlistCount, forKey: "playlistCount")
        data.setObject(toggleStoredType(playlists), forKey: "playlist")
        
        data.synchronize()
        
    }
    
    private func toggleStoredType(playlist: Playlist) -> NSMutableDictionary {
        
        let list = NSMutableDictionary()
        
        for (id, item) in playlist {
            
            guard
                let persistentId = item.mediaItemCollection.representativeItem?.valueForProperty(MPMediaItemPropertyPersistentID)
                else { continue }
            
            let mutableArray = NSMutableArray()
            mutableArray.addObject(persistentId)
            mutableArray.addObject(item.image)
            let encodedObjects = NSKeyedArchiver.archivedDataWithRootObject(mutableArray)
            
            let data = NSMutableDictionary()
            data.setValue(String(item.id), forKey: "id")
            data.setValue(item.title, forKey: "title")
            data.setValue(encodedObjects, forKey: "encodedObjects")
            
            list[String(id)] = data
            
        }
        
        return list
        
    }
    
    private func toggleStoredType(playlist: NSMutableDictionary) -> Playlist {
        
        var list = Playlist()
        
        for (_id, _item) in playlist {
            
            guard
                let id = (_id as? NSString)?.integerValue,
                let data = _item as? NSMutableDictionary,
                let item_id = (data["id"] as? NSString)?.integerValue,
                let title = data["title"] as? String,
                let encodedObjects = data["encodedObjects"] as? NSData,
                let unarchiveList = NSKeyedUnarchiver.unarchiveObjectWithData(encodedObjects) as? NSMutableArray,
                let image = unarchiveList[1] as? UIImage
                else { continue }
            
            let songQuery = MPMediaQuery()
            songQuery.addFilterPredicate(MPMediaPropertyPredicate(value: unarchiveList[0], forProperty: MPMediaItemPropertyPersistentID))
            let mediaItemCollection = MPMediaItemCollection(items: songQuery.items!)
            
            list[id] = MusicRecord(id: item_id, title: title, mediaItemCollection: mediaItemCollection, image: image)
            
        }
        
        return list
        
    }
    
    func addItem(title title: String, mediaItemCollection: MPMediaItemCollection, image: UIImage) {
        
        _playlistCount += 1
        let id = _playlistCount
        _playlists[id] = MusicRecord(id: id, title: title, mediaItemCollection: mediaItemCollection, image: image)
        
        saveData()
        
    }
    
    func getItem(index: Int) -> MusicRecord? {
        
        let list = _playlists
            .filter { _,_ in true }
            .sort { $0.1.id < $1.1.id }
        
        if index >= 0 && index < list.count {
            
            return list[index].1
            
        }
        
        return nil
        
    }
    
}
