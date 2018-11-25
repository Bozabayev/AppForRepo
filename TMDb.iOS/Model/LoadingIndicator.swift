//
//  LoadingIndicator.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/21/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import UIKit



class LoadingIndicator {
    
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
   
    func showActivityIndicator(uiView: UIView) {
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.3)
        container.tag = 100
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = #colorLiteral(red: 0.3586877584, green: 0.3565607071, blue: 0.3603261113, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.center = CGPoint(x : loadingView.frame.size.width / 2, y :  loadingView.frame.size.height / 2)
        
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        activityIndicator.startAnimating()
    }
    
    
  @objc  func hideActivityIndicator(uiView: UIView) {
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
        if let viewWithTag = uiView.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    
    
}
