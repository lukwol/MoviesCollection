//
//  Copyright © 2020 lukwol. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

final class MoviesViewModel {
    
    enum DisplayState {
        case searching
        case nowPlayingMovies
    }
    
    init(moviesRepository: MoviesRepository = MoviesRepository()) {
        self.moviesRepository = moviesRepository
    }
    
    private let moviesRepository: MoviesRepository
    
    private (set) var nowPlayingMovies = [Movie]()
    private (set) var moviesFound = [Movie]()
    
    let state = BehaviorRelay(value: DisplayState.nowPlayingMovies)
    
    var title: String {
        "Movies"
    }
    
    var itemsCount: Int {
        switch state.value {
        case .nowPlayingMovies:
            return nowPlayingMovies.count
        case .searching:
            return moviesFound.count
        }
    }
    
    func titleForItem(at indexPath: IndexPath) -> String {
        switch state.value {
        case .nowPlayingMovies:
            return nowPlayingMovies[indexPath.row].title
        case .searching:
            return moviesFound[indexPath.row].title
        }
    }
    
    func movieDetailsViewModelForItem(at indexPath: IndexPath) -> MovieDetailsViewModel {
        switch state.value {
        case .nowPlayingMovies:
            return MovieDetailsViewModel(movie: nowPlayingMovies[indexPath.row])
        case .searching:
            return MovieDetailsViewModel(movie: moviesFound[indexPath.row])
        }
    }
    
    func fetchNowPlayingMovies() -> Single<[Movie]> {
        Single.create { [weak self] single in
            self?.moviesRepository.nowPlayingMovies { [weak self] (result) in
                switch result {
                case .success(let moviesPage):
                    let movies = moviesPage.results
                    self?.nowPlayingMovies = movies
                    single(.success(movies))
                case .failure(let error):
                    self?.nowPlayingMovies.removeAll()
                    single(.error(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func searchMovies(for query: String) -> Single<[Movie]> {
        Single.create { [weak self] single in
            guard !query.isEmpty else {
                let movies = [Movie]()
                self?.moviesFound = movies
                single(.success(movies))
                return Disposables.create()
            }
            self?.moviesRepository.searchMovies(for: query) { [weak self] (result) in
                switch result {
                case .success(let moviesPage):
                    let movies = moviesPage.results
                    self?.moviesFound = movies
                    single(.success(movies))
                case .failure(let error):
                    single(.error(error))
                }
            }
            return Disposables.create()
        }
    }
}
