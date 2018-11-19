//
//  MovieListService.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/6/18.
//  Copyright © 2018 Rauan. All rights reserved.
//


import Moya

let api_key = "02da584cad2ae31b564d940582770598"
    
    enum MovieListService {
        
        case popularList
        
        case upcomingList
        
        case genreList
        
        case discoverGenreList(genre_id: Int)
        
//        case movieDetail(title: String, id: Int, overview: String, vote_average: String, poster_path: String)
//        case similarMovies(title: String, id: Int, poster_path: String)
    }
    
extension MovieListService: TargetType {
   
        
        var baseURL : URL { return URL(string: "https://api.themoviedb.org/3/")! }
        
        var path : String {
            switch self {
            case .popularList:
                return "movie/popular"
            
            case .upcomingList:
                return "movie/upcoming"
                
            case .genreList:
                return "genre/movie/list"
                
            case .discoverGenreList:
                return "discover/movie"
        
//            case .movieDetail:
//                return "movie/\(id)\(api_key)"
//
//            case .similarMovies:
//                return "movie/\(id)\(api_key)"
            }
        }
        
        
        var method: Moya.Method {
            switch  self {
            case .popularList, .upcomingList, .genreList, .discoverGenreList :
                return .get
            }
        }
    
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var task: Task {
        switch self {
        case .genreList, .upcomingList, .popularList:
            return .requestParameters(parameters: ["api_key" : api_key ], encoding: URLEncoding.default)
        case .discoverGenreList(let genre_id):
            return .requestParameters(parameters: ["api_key" : api_key, "with_genres" : genre_id], encoding: URLEncoding.default)
        }
    }
    
        
        
   
    }


    
    
    


