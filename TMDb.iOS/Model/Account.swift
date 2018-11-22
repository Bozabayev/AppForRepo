//
//  Account.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/22/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import ObjectMapper


private enum Keys: String, CodingKey {
    case username = "username"
    case password = "password"
    case request_token = "request_token"
}

class Account : Mappable, Codable {
    
    var username : String?
    var password : String?
    var request_token : String?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        username <- map[Keys.username.rawValue]
        password <- map[Keys.password.rawValue]
        request_token <- map[Keys.request_token.rawValue]
    }
    
    
    
    func encode(to encoder: Encoder)throws{
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(username, forKey: .username)
        try container.encode(password, forKey: .password)
        try container.encode(request_token, forKey: .request_token)
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        username = try container.decode(String.self, forKey: .username)
        password = try container.decode(String.self, forKey: .password)
        request_token = try container.decode(String.self, forKey: .request_token)
    }
    
    
}


