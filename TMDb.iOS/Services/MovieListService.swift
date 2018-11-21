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
        
        case discoverGenreList(genre_id: Int, page: Int)
        
        case searchMovie(query: String)
        
        case similarMovies(movie_id: Int)
        
        case movieCast(movie_id: Int)
        


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
                
            case .movieCast(let movie_id):
                return "movie/\(movie_id)/credits"

            case .similarMovies(let movie_id):
                return "movie/\(movie_id)/similar"
            }
        }
        
        
        var method: Moya.Method {
            switch  self {
            case .popularList, .upcomingList, .genreList, .discoverGenreList, .searchMovie, .similarMovies, .movieCast :
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
        case .discoverGenreList(let genre_id, let page):
            return .requestParameters(parameters: ["api_key" : api_key, "with_genres" : genre_id, "page" : page], encoding: URLEncoding.default)
        case .searchMovie(let query):
            return .requestParameters(parameters: ["api_key" : api_key, "query" : query], encoding: URLEncoding.default)
        case .upcomingList(let page), .popularList(let page):
            return .requestParameters(parameters: ["api_key" : api_key,"page" : page ], encoding: URLEncoding.default)
        case .similarMovies(let movie_id):
            return .requestParameters(parameters: ["api_key" : api_key, "movie_id" : movie_id, "page" : pageNumberOfSimilarMovies as Any ], encoding: URLEncoding.default)
        case .movieCast(let movie_id):
            return .requestParameters(parameters: ["api_key" : api_key, "movie_id" : movie_id], encoding: URLEncoding.default)
        }
    }
    
        
        
   
    }


    
    
    


