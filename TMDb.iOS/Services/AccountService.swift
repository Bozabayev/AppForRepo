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
            return "/authentication/session/new"
            
        }
    }
    
    var method: Method {
        switch  self {
        case .requestToken:
            return .get
        case .createSession, .requestLoginToken :
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
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
