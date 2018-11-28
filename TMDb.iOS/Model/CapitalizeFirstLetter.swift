//
//  CapitalizeFirstLetter.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/23/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import UIKit


extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
