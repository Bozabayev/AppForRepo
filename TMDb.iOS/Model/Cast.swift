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
        id <- map[Keys.id.rawValue]
        biography <- map[Keys.biography.rawValue]
    }
    
    func encode(to encoder: Encoder)throws{
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(profile_path, forKey: .profile_path)
        try container.encode(biography, forKey: .biography)
       
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        biography = try container.decode(String.self, forKey: .biography)
        profile_path = try container.decode(String.self, forKey: .profile_path)
    }
   
    
    
}
