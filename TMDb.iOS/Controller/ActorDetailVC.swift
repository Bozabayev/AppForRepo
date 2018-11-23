//
//  ActorDetailVC.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/21/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import UIKit
import Moya

class ActorDetailVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
  
    
    var movie : Movie?
    var actorInfo : Cast?
    var movies = [Movie]()
    var personId : Int?
    let provider = MoyaProvider<ActorDetailService>()
    let nib = UINib(nibName: "ActorDetailCell", bundle: nil)
    let nibMovies = UINib(nibName: "MovieDetailCollection", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(nib, forCellReuseIdentifier: "ActorDetailCell")
        tableView.register(nibMovies, forCellReuseIdentifier: "MovieDetailCollection")
        loadActorDetail()
        loadFilmography()
        navigationItem.title = "Актёр"
        LoadingIndicator().showActivityIndicator(uiView: self.view)
        
        
    }
    
    
    func loadActorDetail() {
        guard let person_id = personId else {return}
        provider.request(.actorDetail(person_id: person_id)) { [weak self](result) in
            guard let strongself = self else {return}
            switch result {
            case .success(let response):
                do {
                    let jsonData = try response.mapJSON() as! [String: Any]
                    strongself.actorInfo = (Cast(JSON: jsonData)!)
                    strongself.tableView.reloadData()
                } catch {
                    
                }
            case .failure(let error):
                print("Error : \(error)")
            }
        }
        
    }

    
    func loadFilmography() {
        guard let id = personId else {return}
        provider.request(.actorMovies(person_id: id)) { [weak self](result) in
            guard let strongSelf = self else {return}
            switch result {
            case .success( let response):
                do {
                    let jsonData = try response.mapJSON() as! [String: Any]
                    print(jsonData)
                    let array = jsonData["cast"] as! [[String: Any]]
                    strongSelf.movies = array.map({Movie(JSON: $0)!})
                    strongSelf.tableView.reloadData()
                    LoadingIndicator().hideActivityIndicator(uiView: strongSelf.view)
                    
                } catch {
                    print("Mapping error")
                }
            case .failure(let error):
                print("error: \(error)")
            }
        }
        
    }
    
  
  

}



extension ActorDetailVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let firstIndex = IndexPath(row: 0, section: 0)
        let secondIndex = IndexPath(row: 1, section: 0)
        
        if firstIndex == indexPath {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ActorDetailCell", for: firstIndex) as? ActorDetailCell {
            guard let cast = actorInfo else {return UITableViewCell()}
            cell.configureCell(cast: cast)
            cell.posterImg.layer.cornerRadius = 7
            return cell
            
        }
        return UITableViewCell()
        }
        else if secondIndex == indexPath {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MovieDetailCollection", for: secondIndex) as? MovieDetailCollection {
                cell.collectionView.tag = 3
                cell.collectionViewTitle.text = "Фильмография"
                cell.collectionView.delegate = self
                cell.collectionView.dataSource = self
                cell.collectionView.reloadData()
                return cell
            }
            }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return UITableView.automaticDimension
        case 1:
            return 220
        default:
            return UITableView.automaticDimension
        }
    }
    
    
}


extension ActorDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
        }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            if let thirdCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieDetailCollectionCell", for: indexPath) as? MovieDetailCollectionCell {
                let movie = movies[indexPath.row]
                thirdCell.configureCellForSimilarMovies(movie: movie)
                return thirdCell
            } else {
                return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MovieDetailVC") as! MovieDetailVC
            vc.movieDetail = movies[indexPath.row]
            self.navigationController!.pushViewController(vc, animated: true)
        
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


