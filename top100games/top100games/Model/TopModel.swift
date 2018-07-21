//
//  TopModel.swift
//  top100games
//
//  Created by Carlos Alberto Mota Candreva on 21/07/2018.
//  Copyright © 2018 Carlos Alberto Mota Candreva. All rights reserved.
//

import Foundation

/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Top {
    public var channels : Int?
    public var viewers : Int?
    public var game : Game?
    
    /**
     Returns an array of models based on given dictionary.
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Top Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Top]
    {
        var models:[Top] = []
        for item in array
        {
            models.append(Top(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Top Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        channels = dictionary["channels"] as? Int
        viewers = dictionary["viewers"] as? Int
        if (dictionary["game"] != nil) { game = Game(dictionary: dictionary["game"] as! NSDictionary) }
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.channels, forKey: "channels")
        dictionary.setValue(self.viewers, forKey: "viewers")
        dictionary.setValue(self.game?.dictionaryRepresentation(), forKey: "game")
        
        return dictionary
    }
    
}
