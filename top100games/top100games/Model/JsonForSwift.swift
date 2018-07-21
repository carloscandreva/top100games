//
//  JsonForSwift.swift
//  top100games
//
//  Created by Carlos Alberto Mota Candreva on 21/07/2018.
//  Copyright © 2018 Carlos Alberto Mota Candreva. All rights reserved.
//

import Foundation

import Foundation

public class JsonForSwift {
    public var _total : Int?
    public var top : Array<Top>?
    
    /**
     Returns an array of models based on given dictionary.
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of JsonForSwift Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [JsonForSwift]
    {
        var models:[JsonForSwift] = []
        for item in array
        {
            models.append(JsonForSwift(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
    
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: JsonForSwift Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        _total = dictionary["_total"] as? Int
        if (dictionary["top"] != nil) { top = Top.modelsFromDictionaryArray(array: dictionary["top"] as! NSArray) }
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self._total, forKey: "_total")
        
        return dictionary
    }
    
}
