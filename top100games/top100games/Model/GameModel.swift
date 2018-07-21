//
//  GameModel.swift
//  top100games
//
//  Created by Carlos Alberto Mota Candreva on 20/07/2018.
//  Copyright © 2018 Carlos Alberto Mota Candreva. All rights reserved.
//

import Foundation

public class Game {
    public var _id : Int?
    public var box : Box?
    public var giantbomb_id : Int?
    public var logo : Logo?
    public var name : String?
    public var popularity : Int?
    
    /**
     Returns an array of models based on given dictionary.
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Game Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Game]
    {
        var models:[Game] = []
        for item in array
        {
            models.append(Game(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Game Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        _id = dictionary["_id"] as? Int
        if (dictionary["box"] != nil) { box = Box(dictionary: dictionary["box"] as! NSDictionary) }
        giantbomb_id = dictionary["giantbomb_id"] as? Int
        if (dictionary["logo"] != nil) { logo = Logo(dictionary: dictionary["logo"] as! NSDictionary) }
        name = dictionary["name"] as? String
        popularity = dictionary["popularity"] as? Int
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.box?.dictionaryRepresentation(), forKey: "box")
        dictionary.setValue(self.giantbomb_id, forKey: "giantbomb_id")
        dictionary.setValue(self.logo?.dictionaryRepresentation(), forKey: "logo")
        dictionary.setValue(self.name, forKey: "name")
        dictionary.setValue(self.popularity, forKey: "popularity")
        
        return dictionary
    }
    
}
