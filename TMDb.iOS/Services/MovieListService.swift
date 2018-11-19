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
        
        case popularList(page: Int)
        
        case upcomingList(page: Int)
        
        case genreList
        
        case discoverGenreList(genre_id: Int)
        
        case searchMovie(query: String)

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
                
            case .searchMovie:
                return "search/movie"

            }
        }
        
        
        var method: Moya.Method {
            switch  self {
            case .popularList, .upcomingList, .genreList, .discoverGenreList, .searchMovie :
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
        case .genreList:
            return .requestParameters(parameters: ["api_key" : api_key ], encoding: URLEncoding.default)
        case .discoverGenreList(let genre_id):
            return .requestParameters(parameters: ["api_key" : api_key, "with_genres" : genre_id], encoding: URLEncoding.default)
        case .searchMovie(let query):
            return .requestParameters(parameters: ["api_key" : api_key, "query" : query], encoding: URLEncoding.default)
        case .upcomingList(let page), .popularList(let page):
            return .requestParameters(parameters: ["api_key" : api_key,"page" : page ], encoding: URLEncoding.default)
        }
    }
    
        
        
   
    }


    
    
    


