//
//  UserVC.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/22/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import UIKit
import  Moya

class UserVC: UIViewController, ChangeAvatarDelegate {
  
    
   
    
   

    @IBOutlet weak var tableView: UITableView!
    let nib = UINib(nibName: "UserCell", bundle: nil)
    let providerAccount = MoyaProvider<AccountService>()
    var accountName : String?
    var accounts : Account?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(nib, forCellReuseIdentifier: "UserCell")
        loadAccountDetail()
       navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.title = "Пользователь"
        let backItem = UIBarButtonItem()
        backItem.title = "Назад"
        navigationItem.backBarButtonItem = backItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    func changeAvatarButton() {
     performSegue(withIdentifier: "AvatarPickerVC", sender: nil)
    }
    
    
    
    func loadAccountDetail() {
        providerAccount.request(.accountDetail(sessionID: UserDataService.instance.sessionID)) { [weak self](result) in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let response):
                do {
                    let jsonData = try response.mapJSON() as! [String: Any]
                    strongSelf.accounts = Account(JSON: jsonData)
                    print(strongSelf.accounts?.username)
                    strongSelf.tableView.reloadData()
                    guard let id = strongSelf.accounts?.id else {return}
                    UserDataService.instance.setAccountId(accountId: id)
                    
                } catch {
                    print("Mapping eror")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    
   
    


}




extension UserVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let firstIndex = IndexPath(row: 0, section: 0)
        switch indexPath {
        case firstIndex:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: firstIndex) as? UserCell {
                cell.delegateButton = self
                guard let userName = self.accounts?.username else {return UITableViewCell()}
                print(userName)
                cell.userNameLbl.text = "Username: \(String(describing: accountName))"
                if UserDataService.instance.avatarName == "" {
                    cell.avatarImg.image = #imageLiteral(resourceName: "man-2")
                } else {
                cell.avatarImg.image = UIImage(named: "\(UserDataService.instance.avatarName)")
                }
               
                return cell
            }
        default:
            return UITableViewCell()
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 220
        default:
            return 220
        }
    }
    
    
}
