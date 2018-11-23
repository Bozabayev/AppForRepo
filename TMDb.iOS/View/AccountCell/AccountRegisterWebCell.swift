//
//  AccountRegisterWebCell.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/23/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import UIKit
import WebKit

class AccountRegisterWebCell: UITableViewCell, WKNavigationDelegate {
    

    @IBOutlet weak var cellView: UIView!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.contentView.frame.size.width, height: self.contentView.frame.size.height))
        self.contentView.addSubview(webView)
        
        let url = URL(string: "https://www.themoviedb.org/account/signup")!
        webView.load(URLRequest(url: url))
    }

   
    
  
    
}
