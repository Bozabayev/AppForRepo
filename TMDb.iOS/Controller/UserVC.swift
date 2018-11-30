//
//  UserVC.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/22/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import UIKit
import  Moya

class UserVC: UIViewController, ChangeAvatarDelegate, FavoriteMoviesDelegate {
  
  
    @IBOutlet weak var tableView: UITableView!
    let nib = UINib(nibName: "UserCell", bundle: nil)
    let nibCollection = UINib(nibName: "UserCollectionView", bundle: nil)
    let providerAccount = MoyaProvider<AccountService>()
    private var accounts : Account?
    var movies = [Movie]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        loadAccountDetail()
        LoadingIndicator().showActivityIndicator(uiView: self.view)
    }
    
    
   
    
    
    func setUpView() {
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.title = "Пользователь"
        let backItem = UIBarButtonItem()
        backItem.title = "Назад"
        navigationItem.backBarButtonItem = backItem
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(nib, forCellReuseIdentifier: "UserCell")
        tableView.register(nibCollection, forCellReuseIdentifier: "UserCollectionView")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadAccountDetail()
    }
    
    
    func changeAvatarButton() {
     performSegue(withIdentifier: "AvatarPickerVC", sender: nil)
    }
    
    func favoriteMoviesBtn() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc  = storyboard.instantiateViewController(withIdentifier: "FavoriteMoviesVC") as! FavoriteMoviesVC
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    
    
    
    @IBAction func logOutBtnPressed(_ sender: Any) {
        keychain["username"] = nil
        keychain["password"] = nil
        keychain["accountId"] = nil
        UserDataService.instance.setSessionId(sessionId: "")
        let image = UIImage(named: "man")
        self.tabBarController?.tabBar.items![2].image = image
        self.tabBarController?.tabBar.items![2].selectedImage = image
        deleteSession()
        NotificationCenter.default.post(name: USER_LOGOUT, object: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AccountVC") as! AccountVC
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    func deleteSession() {
        providerAccount.request(.deleteSession) { (result) in
            switch result {
            case .success(let response):
                print("Section deleted: \(response)")
            case .failure(let error):
                print("Error in delete: \(error)")
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
                    strongSelf.tableView.reloadData()
                    guard let id = strongSelf.accounts?.id else {return}
                    UserDataService.instance.setAccountId(accountId: id)
                    keychain["accountId"] = "\(id)"
                    strongSelf.loadFavoriteMovies()
                    
                } catch {
                    print("Mapping eror")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    
    func loadFavoriteMovies() {
        providerAccount.request(.getFavoriteMovies(accountID: UserDataService.instance.accountID)) { [weak self](result) in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let response):
                do {
                    let jsonData = try response.mapJSON() as! [String: Any]
                    let array = jsonData["results"] as! [[String : Any]]
                    strongSelf.movies = array.map({Movie(JSON: $0)!})
                    strongSelf.tableView.reloadData()
                    LoadingIndicator().hideActivityIndicator(uiView: strongSelf.view)
                } catch {
                    print("Mapping error")
                    
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let firstIndex = IndexPath(row: 0, section: 0)
        let secondIndex = IndexPath(row: 1, section: 0)
        switch indexPath {
        case firstIndex:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: firstIndex) as? UserCell {
                cell.delegateButton = self
                cell.favoriteMoviesLbl.text = "\(movies.count)"
                if UserDataService.instance.avatarName == "" {
                    cell.avatarImg.image = #imageLiteral(resourceName: "man-2")
                } else {
                    let image = UIImage(named: "\(UserDataService.instance.avatarName)")!
                    cell.avatarImg.image = image
                    cell.avatarImg.layer.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                    cell.avatarImg.layer.cornerRadius = 10
                    cell.avatarImg.clipsToBounds = true
                    let size  = CGSize(width: 20, height: 20)
                    let scaledImage =  image.scaleImage(toSize: size)
                    self.tabBarController?.tabBar.items![2].image = scaledImage
                    self.tabBarController?.tabBar.items![2].selectedImage = scaledImage
                }
                guard let userName = self.accounts?.username else {return cell}
                cell.userNameLbl.text = "Username: \(String(describing: userName))"
               
                return cell
            }
        case secondIndex:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "UserCollectionView", for: secondIndex) as? UserCollectionView {
                cell.delegateBtn = self
                cell.collectionView.tag = 1
                cell.collectionView.delegate = self
                cell.collectionView.dataSource = self
                cell.collectionView.reloadData()
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
        case 1:
            return 220
        default:
            return 220
        }
    }
    
    
}



extension UserVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 1:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieDetailCollectionCell", for: indexPath) as? MovieDetailCollectionCell {
                let movie = movies[indexPath.row]
                cell.configureCellForSimilarMovies(movie: movie)
                return cell
            }
        default:
            return UICollectionViewCell()
        }
         return UICollectionViewCell()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MovieDetailVC") as! MovieDetailVC
        vc.movieDetail = movies[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    

    
    
}
