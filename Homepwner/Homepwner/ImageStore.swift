//
//  File.swift
//  Homepwner
//
//  Created by Dehelean Andrei on 7/16/16.
//  Copyright © 2016 Dehelean Andrei. All rights reserved.
//

import UIKit

class ImageStore {
    
    let cache = NSCache()
    
    func imageURLByKey(key: String) -> NSURL{
        let documentsDirectories = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.URLByAppendingPathComponent(key)
    }
    
    func setImageForKey(image: UIImage,forKey key: String){
        cache.setObject(image, forKey: key)
        
        let imageUrl = imageURLByKey(key)
        if let data = UIImageJPEGRepresentation(image, 0.5) {
            data.writeToURL(imageUrl, atomically: true)
        }
    }
    
    func imageForKey(key: String) -> UIImage? {
        if let image = cache.objectForKey(key) as? UIImage {
            return image
        }
        
        let imageURL = imageURLByKey(key)
        guard let imageFromDisk = UIImage(contentsOfFile: imageURL.path!) else {
            return nil
        }
        
        cache.setObject(imageFromDisk, forKey: key)
        return imageFromDisk
    }
    
    func deleteImageForKey(key: String) {
        cache.removeObjectForKey(key)
        
        let imageURL = imageURLByKey(key)
        do {
            try NSFileManager.defaultManager().removeItemAtURL(imageURL)
        } catch {
            print(error)
        }
    }
        
}
