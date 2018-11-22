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
    case id = "id"
    case biography = "biography"
}

class Cast : Mappable, Codable {
    
    required init?(map: Map) {
        
    }
    
    var name : String?
    var profile_path : String?
    var id : Int?
    var biography : String?
    
    func mapping(map: Map) {
        name <- map[Keys.name.rawValue]
        profile_path <- map[Keys.profile_path.rawValue]
        id <- map["id"]
        biography <- map["biography"]
    }
    
    
   
    
    
}
