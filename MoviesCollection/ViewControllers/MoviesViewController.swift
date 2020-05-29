//
//  Copyright © 2020 lukwol. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class MoviesViewController: UITableViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = MoviesViewModel()
    
    private let cellIdentifier = "MoviesCell"
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search for movies"
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
        fetchNowPlayingMovies()
    }
    
    private func setupUI() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func bindViewModel() {
        title = viewModel.title
        
        viewModel.state
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.cancelButtonClicked
            .subscribe{ [weak self] _ in
                self?.fetchNowPlayingMovies()
            }
            .disposed(by: disposeBag)
               
        searchController.searchBar.rx.text
            .map { ($0 ?? "").lowercased() }
            .filter { !$0.isEmpty }
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .flatMap { self.viewModel.searchMovies(for: $0)
                .asObservable()
                .catchError{ error in
                    // TODO: Handle error
                    print(error)
                    return .empty()
                }
                .materialize() }
            .subscribe { [weak self] _ in
                self?.viewModel.state.accept(.searching)
            }
            .disposed(by: disposeBag)
    }
    
    private func fetchNowPlayingMovies() {
        viewModel.fetchNowPlayingMovies()
            .subscribe { [weak self] _ in self?.viewModel.state.accept(.nowPlayingMovies) }
            .disposed(by: disposeBag)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.itemsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = viewModel.titleForItem(at: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDetailsViewModel = viewModel.movieDetailsViewModelForItem(at: indexPath)
        let movieDetailsViewController = MovieDetailsViewController(viewModel: movieDetailsViewModel)
        navigationController?.pushViewController(movieDetailsViewController, animated: true)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at:indexPath, animated: true)
        }
    }
}
