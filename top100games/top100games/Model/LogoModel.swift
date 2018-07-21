//
//  LogoModel.swift
//  top100games
//
//  Created by Carlos Alberto Mota Candreva on 20/07/2018.
//  Copyright © 2018 Carlos Alberto Mota Candreva. All rights reserved.
//

import Foundation

public class Logo {
    public var large : String?
    public var medium : String?
    public var small : String?
    public var template : String?
    
    /**
     Constructs the object based on the given dictionary.
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Logo Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        large = dictionary["large"] as? String
        medium = dictionary["medium"] as? String
        small = dictionary["small"] as? String
        template = dictionary["template"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.large, forKey: "large")
        dictionary.setValue(self.medium, forKey: "medium")
        dictionary.setValue(self.small, forKey: "small")
        dictionary.setValue(self.template, forKey: "template")
        
        return dictionary
    }
    
}
