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
        title  <- map["title"]
        id     <- map["id"]
        overview  <- map["overview"]
        poster_path <- map["poster_path"]
        vote_average <- map["vote_average"]
        genre_ids <- map["genre_ids"]
    }

    
    
}



