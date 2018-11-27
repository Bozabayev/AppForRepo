//
//  MainTabBarViewController.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/7/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import UIKit
import Moya

class MainTabBarViewController: UITabBarController {

    
    let provider = MoyaProvider<AccountService>()
    let username = keychain["username"]
    let password = keychain["password"]
    let avatarName = keychain["avatarName"]
    let accountId = keychain["accountId"]
    var accounts : Account?
    var request_token = ""
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        setUserData()
    }
    
    func setUserData() {
        if username != nil && password != nil {
            requestToken()
        } else {
            return
        }
        
        if username == "Bozik" {
            UserDataService.instance.setAvatarName(avatarName: avatarName!)
        }
        
        if accountId != nil {
            guard let id = accountId else {return}
            UserDataService.instance.setAccountId(accountId: Int(id)!)
        }
        
    }
    
    func requestToken() {
        provider.request(.requestToken) { (result) in
            switch result {
            case .success(let response):
                do {
                    let jsonData = try response.mapJSON() as! [String : Any]
                    self.request_token = (jsonData["request_token"]) as! String
                    self.requestLoginToken()
                } catch {
                    print("Moya Error")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func requestLoginToken() {
        provider.request(.requestLoginToken(username: username!, password: password!, request_token: request_token)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let jsonData = try response.mapJSON() as! [String : Any]
                    self.request_token = (jsonData["request_token"] as! String)
                    self.requestSessionId()
                    
                } catch {
                    print("Moya error")
                    
                }
            case .failure(let error):
                print("Error: \(error)")
                
            }
        }
    }
    
    
    
    func requestSessionId() {
        provider.request(.createSession(request_token: request_token)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let jsonData = try response.mapJSON() as! [String : Any]
                    let  sessionId = jsonData["session_id"] as? String
                    UserDataService.instance.setSessionId(sessionId: sessionId!)
                } catch {
                    print("Moya Error")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    

}
