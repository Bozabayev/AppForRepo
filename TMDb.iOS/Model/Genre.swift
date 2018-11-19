//
//  Genre.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/7/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import ObjectMapper


private enum Keys: String, CodingKey{
    case id = "id"
    case name = "name"
}

class Genre: Mappable, Codable {
    
    required init?(map: Map) {
    }
    
 
    
    func mapping(map: Map) {
        id <- map[Keys.id.rawValue]
        name <- map[Keys.name.rawValue]
    }
    
    var id : Int?
    var name = ""
    
    func encode(to encoder: Encoder)throws{
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
    }
}
