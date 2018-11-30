//
//  FilmsVC.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/6/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import UIKit
import Moya



class FilmsVC: UIViewController{
    
    
    
    fileprivate enum MovieType{
        case popular
        case upcoming
        case searching
    }
    

    @IBOutlet weak var customSegmentController: CustomSegmentedControl!
    
   
    @IBOutlet weak var tableView: UITableView!
    //MARK: Private variables
    fileprivate var pageNumberOfPopular : Int? = 1
    fileprivate var pageNumberOfUpcoming : Int? = 1
    fileprivate var popularMovies = [Movie]()
    fileprivate var upcomingMovies = [Movie]()
    fileprivate var searchingMovies = [Movie]()
    fileprivate var selectedMovie: Movie?
    fileprivate let searchBar = UISearchBar()
    fileprivate var timer = Timer()
    fileprivate var searchBtn : UIBarButtonItem?
    fileprivate let provider = MoyaProvider<MovieListService>()
    fileprivate var movie : Movie?
    fileprivate var movieType = MovieType.popular{
        didSet{
            tableView.reloadData()
        }
    }
    var imageView : UIImageView?
    let tap = UITapGestureRecognizer(target: self, action: #selector(FilmsVC.handleTap))
    let nib = UINib(nibName: "MovieCell", bundle: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        loadPopularMovies()
        loadUpcomingMovies()
        self.tableView.register(nib, forCellReuseIdentifier: "movieCell")
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        setUserData()
        setCustomSegmentController()
    }
    
    
    
    
    
    func setCustomSegmentController() {
        customSegmentController.borderWidth = 1
        customSegmentController.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        customSegmentController.commaSeparatedButtonTitles = "Популярное, Скоро на экранах"
        customSegmentController.selectorColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        customSegmentController.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        customSegmentController.selectorTextColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    func setUserData() {
        
        if UserDataService.instance.avatarName == "" {
            let image = UIImage(named: "man")
            self.tabBarController?.tabBar.items![2].image = image
            self.tabBarController?.tabBar.items![2].selectedImage = image
        } else {
            let image = UIImage(named: "\(UserDataService.instance.avatarName)")
        let size  = CGSize(width: 20, height: 20)
        let scaledImage =  image?.scaleImage(toSize: size)
        self.tabBarController?.tabBar.items![2].image = scaledImage
        self.tabBarController?.tabBar.items![2].selectedImage = scaledImage
        }
    }
    
    
    
    @IBAction func customSegmentedControllerSwitched(_ sender: CustomSegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            movieType = .popular
        case 1:
            movieType = .upcoming
        default:
            movieType = .popular
        }
    }
    
    
    

    @IBAction func searchBtnPressed(_ sender: Any) {
        setSearchBar()
       
    }
    
    
   
    
    @objc func handleTap( recognizer: UITapGestureRecognizer) {
        navigationItem.titleView = nil
        navigationItem.rightBarButtonItem = searchBtn
          let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar!.endEditing(true)
    }
    
    
  @objc private func searchMovies() {
    movieType = .searching
    provider.request(.searchMovie(query: timer.userInfo as! String)) { [weak self](result) in
        guard let strongSelf = self else {return}
        switch result {
        case .success(let response):
            do {
                let jsonData = try response.mapJSON() as! [String: Any]
                let array = jsonData["results"] as! [[String: Any]]
                strongSelf.searchingMovies = array.map({Movie(JSON: $0)!})
                strongSelf.tableView.reloadData()
            } catch {
                print("Mapping error")
            }
        case .failure(let error):
            print("error : \(error)")
        }
    }
    }
    
   @objc private func loadPopularMovies() {
        guard let page = pageNumberOfPopular else {return}
        provider.request(.popularList(page: page)) { [weak self](result) in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let response):
                do {
                    let jsonData = try response.mapJSON() as! [String: Any]
                    let array = jsonData["results"] as! [[String: Any]]
                    strongSelf.popularMovies += array.map({Movie(JSON: $0)!})
                    strongSelf.tableView.reloadData()
                } catch {
                    print("Mapping Error")
                }
            case . failure(let error):
                print("Server error: \(error)")
            }
        }
    }
    
  @objc  private func loadUpcomingMovies() {
        guard let page = pageNumberOfUpcoming else {return}
        provider.request(.upcomingList(page: page)) { [weak self](result) in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let response):
                do {
                    let jsonData = try response.mapJSON() as! [String:Any]
                    let array = jsonData["results"] as! [[String: Any]]
                    strongSelf.upcomingMovies += array.map({Movie(JSON: $0)!})
                    strongSelf.tableView.reloadData()
                } catch {
                    print("Mapping Error")
                }
            case . failure(let error):
                print("server error: \(error)")
            }
        }
    }
    
    
}

extension FilmsVC: UITableViewDataSource, UITableViewDelegate {

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if movieType == .popular {
            return popularMovies.count
        }
        if movieType == .upcoming {
            return upcomingMovies.count
        }
        if movieType == .searching {
            return searchingMovies.count
        }
        return popularMovies.count
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if movieType == .popular && popularMovies.count ==  indexPath.row + 1   {
            pageNumberOfPopular! += 1
            loadPopularMovies()
        }
        if movieType == .upcoming && upcomingMovies.count ==  indexPath.row + 1   {
            pageNumberOfUpcoming! += 1
            loadUpcomingMovies()
        }
        
        
        if  let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell") as? MovieCell {
            if movieType == .popular {
                movie = popularMovies[indexPath.row]
            }
            if movieType == .upcoming {
                movie = upcomingMovies[indexPath.row]
            }
            if movieType == .searching {
                movie = searchingMovies[indexPath.row]
            }
            guard let unwMovie = movie else {return UITableViewCell()}
            cell.configureCell(movie: unwMovie)
            return cell
        } else {
            return UITableViewCell()
        }
        
       
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if movieType == .popular{
            movie = self.popularMovies[indexPath.row]
        }
        if movieType == .upcoming {
            movie = self.upcomingMovies[indexPath.row]
        }
        if movieType == .searching {
            movie = self.searchingMovies[indexPath.row]
        }
        guard let unwMovie = movie else {return}
        selectedMovie = unwMovie
        let index = IndexPath(row: indexPath.row, section: 0)
        tableView.reloadRows(at: [index], with: .none)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MovieDetailVC") as! MovieDetailVC
        vc.movieDetail = selectedMovie
        self.navigationController!.pushViewController(vc, animated: true)
        
    } 
    
}



extension FilmsVC: UISearchBarDelegate {
    

    
    
    func setSearchBar() {
        
        searchBar.showsCancelButton = true
        navigationItem.titleView = searchBar
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar!.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        textFieldInsideSearchBar!.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        textFieldInsideSearchBar!.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        searchBtn = navigationItem.rightBarButtonItem
        navigationItem.rightBarButtonItem = nil
        searchBar.becomeFirstResponder()

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
       navigationItem.titleView = nil
       navigationItem.rightBarButtonItem = searchBtn
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let numberLbl = searchBar.text?.count else {return}
        guard let query = searchBar.text else {return}
        searchingMovies.removeAll()
        timer.invalidate()
        if numberLbl >= 1 {
            movieType = .searching
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(searchMovies), userInfo: query, repeats: false)
        }
        if numberLbl == 0 && customSegmentController.selectedSegmentIndex == 0 {
            movieType = .popular
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(removeSearchMovie), userInfo: nil, repeats: false)
            
        } else if numberLbl == 0 && customSegmentController.selectedSegmentIndex == 1 {
            movieType = .upcoming
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(removeSearchMovie), userInfo: nil, repeats: false)
        }
        
    }
    
    @objc func removeSearchMovie() {
        searchingMovies.removeAll()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.titleView = nil
        navigationItem.rightBarButtonItem = searchBtn
    }
    
    
}
