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
    let providerAccount = MoyaProvider<AccountService>()
    let username = keychain["username"]
    let password = keychain["password"]
    let avatarName = keychain["avatarName"]
    let accountId = keychain["accountId"]
    var favoriteMovies = [Movie]()
    var accounts : Account?
    var request_token = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        
    }
  
    
    override func viewWillAppear(_ animated: Bool) {
        setUserData()
    }
    
    func setUserData() {
        
        if username == "Bozik" {
            UserDataService.instance.setAvatarName(avatarName: avatarName!)
        } 
        
        if username != nil && password != nil {
            requestToken()
        } else {
            return
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
        provider.request(.createSession(request_token: request_token)) { [weak self](result) in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let response):
                do {
                    let jsonData = try response.mapJSON() as! [String : Any]
                    let  sessionId = jsonData["session_id"] as? String
                    UserDataService.instance.setSessionId(sessionId: sessionId!)
                    strongSelf.loadAccountDetail()
                } catch {
                    print("Moya Error")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    
    
    func loadFavoriteMovies() {
        providerAccount.request(.getFavoriteMovies(accountID: UserDataService.instance.accountID)) { [weak self] (result) in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let response):
                do {
                    let jsonData = try response.mapJSON() as! [String: Any]
                    let array = jsonData["results"] as! [[String : Any]]
                   
                    strongSelf.favoriteMovies = array.map({Movie(JSON: $0)!})
                    
                    for movie in strongSelf.favoriteMovies{
                        guard let id = movie.id else {return}
                        UserDataService.instance.setFavoriteMoviesId(favoriteMoviesID: id)
                    }
                } catch {
                    print("Mapping error")
                    
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func loadAccountDetail() {
        providerAccount.request(.accountDetail(sessionID: UserDataService.instance.sessionID)) { [weak self](result) in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let response):
                do {
                    let jsonData = try response.mapJSON() as! [String: Any]
                    strongSelf.accounts = Account(JSON: jsonData)
                    guard let id = strongSelf.accounts?.id else {return}
                    UserDataService.instance.setAccountId(accountId: id)
                    strongSelf.loadFavoriteMovies()
                    
                } catch {
                    print("Mapping eror")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    

}
