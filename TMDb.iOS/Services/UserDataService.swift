//
//  UserDataService.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/25/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import Foundation



class UserDataService {
    
    static let instance = UserDataService()
    
    private(set) public var avatarName = ""
    private(set) public var accountID = 0
    private(set) public var sessionID = ""
     private(set) public var movieID = 0
    private(set) public var favoriteMoviesID = [Int]()
    
    func setAvatarName(avatarName: String) {
        self.avatarName = avatarName
    }
    
    func setAccountId(accountId: Int){
        self.accountID = accountId
    }
    
    func setSessionId(sessionId: String){
        self.sessionID = sessionId
    }
    
    func setMovieId(movieId: Int) {
        self.movieID = movieId
    }
    
    
    func setFavoriteMoviesId(favoriteMoviesID: Int) {
        self.favoriteMoviesID.append(favoriteMoviesID)
    }
    
    
    func removeFavoriteMoviesId(favoriteMoviesId: Int) {
        
        self.favoriteMoviesID.removeAll(where: {$0 == favoriteMoviesId})
    }
    
    
    
   
    
    
}
