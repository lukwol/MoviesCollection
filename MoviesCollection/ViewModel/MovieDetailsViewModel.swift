//
//  Copyright © 2020 lukwol. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

final class MovieDetailsViewModel {
    
    private let favouritesRepository = FavouritesRepository()
    private let imagesRepository = ImagesRepository()
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter
    }()
    
    private let emptyStarIcon = UIImage(named: "star-empty")!
    private let filledStarIcon = UIImage(named: "star-filled")!
    
    private lazy var favouriteImageSubject: BehaviorSubject<UIImage> = {
        if favouritesRepository.isFavourite(movie: movie) {
            return BehaviorSubject(value: filledStarIcon)
        } else {
            return BehaviorSubject(value: emptyStarIcon)
        }
    }()
    
    private let movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    var title: String {
        movie.title
    }
    
    var releaseDateText: String {
        "Release Date: \(dateFormatter.string(from: movie.releaseDate))"
    }
    
    var popularityText: String {
        "Popularity: \(movie.popularity)"
    }
    
    var overviewText: String {
        movie.overview
    }
    
    var favouriteImage: Observable<UIImage> {
        favouriteImageSubject.asObservable()
    }
    
    
    @objc func toggleMovieFavourite() {
        if favouritesRepository.isFavourite(movie: movie) {
            favouritesRepository.setNotFavourite(movie: movie)
            favouriteImageSubject.onNext(emptyStarIcon)
        } else {
            favouritesRepository.setFavourite(movie: movie)
            favouriteImageSubject.onNext(filledStarIcon)
        }
    }
    
    func movieImage() -> Single<UIImage?> {
        Single.create { [weak self] single in
            guard let imagePath = self?.movie.backdropPath else {
                single(.success(nil))
                return Disposables.create()
            }
            self?.imagesRepository.fetchImage(for: imagePath) { image in
                single(.success(image))
            }
            return Disposables.create()
        }
    }
}
