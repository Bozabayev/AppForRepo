//
//  GenreCell.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/8/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import UIKit

class GenreCell: UITableViewCell {

    
    
    @IBOutlet weak var genresTitle: UILabel!
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    func configureCell(genre: Genre){
        
        let genreName = genre.name
        genresTitle.text = genreName.capitalizingFirstLetter()
       
    }

    
    
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
