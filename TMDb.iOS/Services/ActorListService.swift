//
//  ActorListService.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/21/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import Moya



enum ActorDetailService{
    case actorDetail(person_id: Int)
    case actorMovies(person_id: Int)
    case actorImages(person_id: Int)
}



extension ActorDetailService : TargetType {
    var baseURL: URL {
       return URL(string: "https://api.themoviedb.org/3/")!
    }
    
    var path: String {
        switch self {
        case .actorDetail(let person_id):
            return "person/\(person_id)"
        case .actorMovies(let person_id):
            return "person/\(person_id)/movie_credits"
        case .actorImages(let person_id):
            return "person/\(person_id)/images"

        }
    }
    
    var method: Method {
        switch self {
        case .actorDetail, .actorMovies, .actorImages:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .actorDetail(let person_id), .actorMovies(let person_id), .actorImages(let person_id):
            return .requestParameters(parameters: ["api_key" : api_key, "person_id" : person_id], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
