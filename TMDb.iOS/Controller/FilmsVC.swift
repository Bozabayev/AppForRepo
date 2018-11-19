//
//  FilmsVC.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/6/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import UIKit
import Moya



class FilmsVC: UIViewController {
    
    
    
    fileprivate enum MovieType{
        case popular
        case upcoming
        case searching
    }
    
    @IBOutlet var tapView: UIView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Private variables
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
        self.tableView.rowHeight = 170.0
        movieType = .popular
    }
    
    @IBAction func segmentControl(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            movieType = .popular
        case 1:
            movieType = .upcoming
        default:
            break
        }
    }
    @IBAction func searchBtnPressed(_ sender: Any) {
        setSearchBar()
    }
    
    @objc func handleTap() {
        navigationItem.titleView = nil
        navigationItem.rightBarButtonItem = searchBtn
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
        movieType = .popular
        guard let page = pageNumberOfPopular else {return}
        print(page)
        provider.request(.popularList(page: page)) { [weak self](result) in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let response):
                do {
                    if page == 1 {
                    let jsonData = try response.mapJSON() as! [String: Any]
                    let array = jsonData["results"] as! [[String: Any]]
                    strongSelf.popularMovies = array.map({Movie(JSON: $0)!})
                    strongSelf.tableView.reloadData()
                    } else {
                        let jsonData = try response.mapJSON() as! [String: Any]
                        let array = jsonData["results"] as! [[String: Any]]
                        strongSelf.popularMovies.append(contentsOf: array.map({Movie(JSON: $0)!}))
                        strongSelf.tableView.reloadData()
                    }
                } catch {
                    print("Mapping Error")
                }
            case . failure(let error):
                print("Server error: \(error)")
            }
        }
    }
    
  @objc  private func loadUpcomingMovies() {
        movieType = .upcoming
        guard let page = pageNumberOfUpcoming else {return}
        provider.request(.upcomingList(page: page)) { [weak self](result) in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let response):
                do {
                    if page == 1 {
                    let jsonData = try response.mapJSON() as! [String:Any]
                    let array = jsonData["results"] as! [[String: Any]]
                    strongSelf.upcomingMovies = array.map({Movie(JSON: $0)!})
                    strongSelf.tableView.reloadData()
                    } else {
                        let jsonData = try response.mapJSON() as! [String:Any]
                        let array = jsonData["results"] as! [[String: Any]]
                        strongSelf.upcomingMovies.append(contentsOf: array.map({Movie(JSON: $0)!}))
                        strongSelf.tableView.reloadData()
                    }
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
        if indexPath.row == popularMovies.count - 6 {
            pageNumberOfPopular! += 1
            print(pageNumberOfPopular)
            loadPopularMovies()
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
        self.selectedMovie = unwMovie
        let index = IndexPath(row: indexPath.row, section: 0)
        tableView.reloadRows(at: [index], with: .none)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MovieDetailVC") as! MovieDetailVC
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    
    
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if (popularMovies.count - indexPath.row) == 4 && movieType == .popular {
//            pageNumberOfPopular! += 1
//            loadPopularMovies()
//
//        }
//        if (upcomingMovies.count - indexPath.row) == 1 && movieType == .upcoming {
//            pageNumberOfUpcoming = pageNumberOfUpcoming! + 1
//            loadUpcomingMovies()
//        }
//    }
    
    
}



extension FilmsVC: UISearchBarDelegate {
    

    func setSearchBar() {
        searchBar.showsCancelButton = true
        navigationItem.titleView = searchBar
        searchBtn = navigationItem.rightBarButtonItem
        navigationItem.rightBarButtonItem = nil
        self.view.addGestureRecognizer(tap)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.titleView = nil
        navigationItem.rightBarButtonItem = searchBtn
        self.view.removeGestureRecognizer(tap)
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
        if numberLbl == 0 && segmentedControl.selectedSegmentIndex == 0 {
            movieType = .popular
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(removeSearchMovie), userInfo: nil, repeats: false)
            
        } else if numberLbl == 0 && segmentedControl.selectedSegmentIndex == 1 {
            movieType = .upcoming
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(removeSearchMovie), userInfo: nil, repeats: false)
        }
        
    }
    
    @objc func removeSearchMovie() {
        searchingMovies.removeAll()
    }
    
}
