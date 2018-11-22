//
//  Movie.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/7/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import Foundation
import ObjectMapper



private enum Keys: String, CodingKey{
    case id = "id"
    case title = "title"
    case overview = "overview"
    case poster_path = "poster_path"
    case vote_average = "vote_ average"
    case genre_ids = "genre_ids"
}


class Movie: Mappable, Codable {
    
    var title : String?
    var id : Int?
    var overview : String?
    var poster_path : String?
    var vote_average : Double?
    var genre_ids : Int?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        title  <- map[Keys.title.rawValue]
        id     <- map[Keys.id.rawValue]
        overview  <- map[Keys.overview.rawValue]
        poster_path <- map[Keys.poster_path.rawValue]
        vote_average <- map["vote_average"]
        genre_ids <- map[Keys.genre_ids.rawValue]
    }

    func encode(to encoder: Encoder)throws{
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(overview, forKey: .overview)
        try container.encode(poster_path, forKey: .poster_path)
        try container.encode(genre_ids, forKey: .genre_ids)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        overview = try container.decode(String.self, forKey: .overview)
        poster_path = try container.decode(String.self, forKey: .poster_path)
        genre_ids = try container.decode(Int.self, forKey: .genre_ids)
    }
    
}



