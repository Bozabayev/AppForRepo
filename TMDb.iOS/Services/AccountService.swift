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
    case getFavoriteMovies(accountID: Int, sessionID: String)
    case markFavoriteMovie(accountID: Int, sessionID: String, id: Int)
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
            
        }
    }
    
    var method: Method {
        switch  self {
        case .requestToken, .accountDetail, .getFavoriteMovies:
            return .get
        case .createSession, .requestLoginToken, .markFavoriteMovie :
            return .post
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
        case .getFavoriteMovies(let sessionId):
            return .requestParameters(parameters: ["api_key" : api_key, "session_id" : sessionId], encoding: URLEncoding.default)
        case .markFavoriteMovie(let sessionId , let id, let accountID):
            return .requestCompositeParameters(bodyParameters: ["media_type" : "movie", "media_id" : id, "favorite" : true], bodyEncoding: JSONEncoding.default, urlParameters: ["api_key" : api_key, "session_id" : sessionId])
            
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .markFavoriteMovie:
            return ["application/json" : "charset=utf-8"]
        case .accountDetail, .createSession, .getFavoriteMovies, .requestLoginToken, .requestToken:
            return nil
        }
    }
    
    
}
