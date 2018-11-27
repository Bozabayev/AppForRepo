//
//  AccountService.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/22/18.
//  Copyright © 2018 Rauan. All rights reserved.
//


import Moya






enum AccountService {
    case requestToken
    case requestLoginToken(username: String, password: String, request_token: String)
    case createSession(request_token : String)
    case accountDetail(sessionID: String)
    case getFavoriteMovies(accountID: Int)
    case markFavoriteMovie(accountID: Int)
    case deleteSession
    case removeFavoriteMovie(accountID: Int)
}


extension AccountService : TargetType {
    var baseURL: URL { return URL(string: "https://api.themoviedb.org/3/")! }
    
    var path: String {
        switch self {
        case .requestToken:
            return "authentication/token/new"
        case .requestLoginToken:
            return "authentication/token/validate_with_login"
        case .createSession:
            return "authentication/session/new"
        case .accountDetail:
            return "account"
        case .getFavoriteMovies(let accountID):
            return "account/\(accountID)/favorite/movies"
        case .markFavoriteMovie(let accountID):
            return "account/\(accountID)/favorite"
        case .deleteSession:
            return "authentication/session"
        case .removeFavoriteMovie(let accountID):
            return "account/\(accountID)/favorite"
            
        }
    }
    
    var method: Method {
        switch  self {
        case .requestToken, .accountDetail, .getFavoriteMovies:
            return .get
        case .createSession, .requestLoginToken, .markFavoriteMovie, .removeFavoriteMovie :
            return .post
        case .deleteSession:
            return .delete
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .requestToken:
            return .requestParameters(parameters: ["api_key" : api_key], encoding: URLEncoding.default)
        case  .requestLoginToken(let username, let password, let request_token):
            return .requestCompositeParameters(bodyParameters: ["username" : username, "password" : password, "request_token" : request_token], bodyEncoding: JSONEncoding.default, urlParameters: ["api_key" : api_key])
        case .createSession(let request_token):
            return .requestCompositeParameters(bodyParameters: ["request_token" : request_token], bodyEncoding: JSONEncoding.default, urlParameters: ["api_key" : api_key])
        case .accountDetail(let sessionID):
            return .requestParameters(parameters: ["api_key" : api_key, "session_id" : sessionID], encoding: URLEncoding.default)
        case .getFavoriteMovies:
            return .requestParameters(parameters: ["api_key" : api_key, "session_id" : UserDataService.instance.sessionID], encoding: URLEncoding.default)
        case .markFavoriteMovie:
            return .requestCompositeParameters(bodyParameters: ["media_type" : "movie", "media_id" : UserDataService.instance.movieID, "favorite" : true], bodyEncoding: JSONEncoding.default, urlParameters: ["api_key" : api_key, "session_id" : UserDataService.instance.sessionID])
        case .deleteSession:
            return .requestCompositeParameters(bodyParameters: ["session_id" : "\(UserDataService.instance.sessionID)"], bodyEncoding: JSONEncoding.default, urlParameters: ["api_key" : api_key])
        case .removeFavoriteMovie:
            return .requestCompositeParameters(bodyParameters: ["media_type" : "movie", "media_id" : UserDataService.instance.movieID, "favorite" : false], bodyEncoding: JSONEncoding.default, urlParameters: ["api_key" : api_key, "session_id" : UserDataService.instance.sessionID])
            
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .markFavoriteMovie, .removeFavoriteMovie:
            return ["Content-Type": "application/json; charset=utf-8"]
        case .accountDetail, .createSession, .getFavoriteMovies, .requestLoginToken, .requestToken, .deleteSession:
            return nil
        }
    }
    
    
}
