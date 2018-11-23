//
//  AccountVC.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/22/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import UIKit
import Moya

fileprivate enum SegmentType {
        case authorization
        case registration
}

var sessionId : String? = ""


class AccountVC: UIViewController, CreateAccTextDelegate , LoginButtonTapDelegate, CreateAccButtonTapDelegate, LoginTextDelegate {
    
    
   
    
   
   
    

    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
   fileprivate let authorizationNib = UINib(nibName: "AccountAuthorizationCell", bundle: nil)
   fileprivate let registrationNib = UINib(nibName: "AccountRegisterCell", bundle: nil)
    fileprivate let webNib = UINib(nibName: "AccountRegisterWebCell", bundle: nil)
   fileprivate let provider = MoyaProvider<AccountService>()
    fileprivate var accounts : Account?
    fileprivate var segmentType = SegmentType.authorization {
        didSet {
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.setHidesBackButton(true, animated: false)
       self.tableView.register(authorizationNib, forCellReuseIdentifier: "AccountAuthorizationCell")
        self.tableView.register(registrationNib, forCellReuseIdentifier: "AccountRegisterCell")
        self.tableView.register(webNib, forCellReuseIdentifier: "AccountRegisterWebCell")
    }
    
    @IBAction func segmentSwitched(_ sender: Any) {
        switch segmentedController.selectedSegmentIndex {
        case 0:
            segmentType = .authorization
        case 1:
            segmentType = .registration
        default:
            segmentType = .authorization
        }
        
    }
    
    
    func createAccTextDelegate(username: String, password: String) {
        accounts = Account(JSON: ["username" : username, "password" : password])
    }
    
    
    func loginTextDelegate(username: String, password: String) {
        accounts = Account(JSON: ["username" : username, "password" : password])
    }
    
    
    
    func loginTapButton() {
        tableView.reloadData()
        requestToken()
        
        
    }
    
    func createTapButton() {
        tableView.reloadData()
        requestToken()

//        requestLoginToken()
//        requestSessionId()
//        print(sessionId)
        
    }
    
    
    
    func requestToken() {
        provider.request(.requestToken) { [weak self](result) in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let response):
                do {
                    let jsonData = try response.mapJSON() as! [String : Any]
                    strongSelf.accounts?.request_token = (jsonData["request_token"] as! String)
                    strongSelf.requestLoginToken()
                } catch {
                    print("Moya Error")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func requestLoginToken() {
        guard let account = accounts else {return}
        provider.request(.requestLoginToken(username: account.username!, password: account.password!, request_token: account.request_token!)) { [weak self](result) in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let response):
                do {
                    let jsonData = try response.mapJSON() as! [String : Any]
                    print(jsonData)
                    strongSelf.accounts?.request_token = (jsonData["request_token"] as? String)
                    print(strongSelf.accounts?.request_token)
                    strongSelf.requestSessionId()
                } catch {
                    print("Moya error")
                
                }
            case .failure(let error):
                print("Error: \(error)")
                
            }
        }
    }
    
    
    
    func requestSessionId() {
        guard let account = accounts else {return}
        provider.request(.createSession(request_token: account.request_token!)) { [weak self](result) in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let response):
                do {
                    let jsonData = try response.mapJSON() as! [String : Any]
                    sessionId = jsonData["session_id"] as? String
                    print(sessionId)
                } catch {
                    print("Moya Error")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    
    
    
    
    
    
  

}



extension AccountVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch segmentType {
        case .authorization:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "AccountAuthorizationCell", for: indexPath) as? AccountAuthorizationCell {
                cell.delegate = self
                cell.delegateText = self
                return cell
                
            }
            
        case .registration:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "AccountRegisterWebCell", for: indexPath) as? AccountRegisterWebCell {
                cell.layer.frame.size.width = self.view.frame.size.width
                cell.contentView.frame.size.width = self.view.frame.size.width
                return cell
                
            }
            
        }
        return UITableViewCell()
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch segmentType {
        case .authorization:
            return 400
        case .registration:
            return 400
        }
    }
    
  
}



