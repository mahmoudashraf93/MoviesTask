//
//  MoviesViewController.swift
//  MoviesTask
//
//  Created by mahmoud ashraf on 2/22/19.
//  Copyright © 2019 SideProject. All rights reserved.
//

import UIKit


class MoviesViewController: UIViewController {
    
    @IBOutlet weak var moviesTableView: UITableView!
    lazy var loadingView : UIAlertController = {
        
        return UIAlertController(title: "", message: nil, preferredStyle: .alert)
    }()
    lazy var viewModel: MoviesViewModel = {
        let moviesViewModel = MoviesViewModel()
        return moviesViewModel
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupTableView()
        self.setupViewModel()
        
    }
    func setupViewModel(){
        self.startLoading()
        self.viewModel.getMovies()
        
        self.viewModel.reloadTableviewClosure = { [unowned self] in
            self.stopLoading()
            DispatchQueue.main.async {
                self.moviesTableView.reloadData()
            }
        }
        
        self.viewModel.failureClosure = { [unowned self] (error) in
            self.stopLoading(completion: {
                if let errorMsg = error {
                    self.presentAlertView(withTitle: "Failed", message: errorMsg, cancelActionTitle: "Cancel", confirmActionTitle: "Retry", cancelAction: nil, confirmAction: {
                        self.startLoading()
                        self.viewModel.getMovies()
                    })
                }
            })
            
        }
    }
    
    func setupTableView(){
        self.moviesTableView.delegate = self
        self.moviesTableView.dataSource = self
        self.moviesTableView.estimatedRowHeight = 100
        self.moviesTableView.rowHeight = UITableView.automaticDimension
        
        self.moviesTableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
        
        self.moviesTableView.register(UINib(nibName: "LoadingTableViewCell", bundle: nil), forCellReuseIdentifier: "LoadingTableViewCell")
        
    }
    @IBAction func btnAddMoviePressed(_ sender: Any) {
        
        if let addMovieVC = self.storyboard?.instantiateViewController(withIdentifier: "AddMovieViewController") as? AddMovieViewController {
            addMovieVC.delegate = self.viewModel
            self.present(addMovieVC, animated: true, completion: nil)
        }
    }
}

extension MoviesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.numberOfRowsForUserAddedMovies > 0 && section == 0 {
            return self.viewModel.numberOfRowsForUserAddedMovies
        }
        return self.viewModel.numberOfRowsForMovies
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfRowsForUserAddedMovies > 0 ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.viewModel.isCellForMyMoviesSection(indexPath: IndexPath(row: 0, section: section)){
            return "My Movies"
        }
        return "Movies"
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.viewModel.shouldShowLoadingRow(indexPath: indexPath) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingTableViewCell") as? LoadingTableViewCell {
                self.viewModel.getMovies()
                cell.loadingActivityIndicator.startAnimating()
                return cell
            }
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell",for: indexPath) as? MovieTableViewCell {
            if self.viewModel.isCellForMyMoviesSection(indexPath: indexPath) {
                let movieCellVM = self.viewModel.getUserAddedMovieCellViewModel(at: indexPath.row)
                cell.userAdddedMovieCellViewModel = movieCellVM
                return cell
                
            }
            let movieCellVM = self.viewModel.getWebMovieCellViewModel(at: indexPath.row)
            cell.webMovieCellViewModel = movieCellVM
            return cell
        }
        
        
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let movieCell = cell as? MovieTableViewCell {
            let movieCellVM = self.viewModel.getWebMovieCellViewModel(at: indexPath.row)
            movieCell.imgPoster.cancelTask(for: "\(movieCellVM.imagePath ?? "")")
        }
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = .white
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
extension MoviesViewController {
    func startLoading() {
        
        let indicator = UIActivityIndicatorView(frame: loadingView.view.bounds)
        indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        loadingView.view.addSubview(indicator)
        indicator.style = .gray
        indicator.isUserInteractionEnabled = false
        indicator.startAnimating()
        
        DispatchQueue.main.async {
            self.present(self.loadingView, animated: true, completion: nil)
        }
    }
    
    func stopLoading(completion: AlertViewAction? = nil){
        DispatchQueue.main.async {
            self.loadingView.dismiss(animated: true, completion: completion)
        }
    }
}
