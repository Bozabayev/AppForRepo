//
//  Cast.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/20/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import ObjectMapper

private enum Keys : String, CodingKey {
    case name = "name"
    case profile_path = "profile_path"
}

class Cast : Mappable, Codable {
    
    required init?(map: Map) {
        
    }
    
    var name : String?
    var profile_path : String?
    
    func mapping(map: Map) {
        name <- map["name"]
        profile_path <- map["profile_path"]
    }
    
    
   
    
    
}
