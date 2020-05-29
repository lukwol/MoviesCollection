//
//  Copyright © 2020 lukwol. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class MovieDetailsViewController: UIViewController {
    private let viewModel: MovieDetailsViewModel
    private let disposeBag = DisposeBag()
    
    private lazy var favouriteButton = UIBarButtonItem(image: nil, style: .plain, target: viewModel, action: #selector(MovieDetailsViewModel.toggleMovieFavourite))
    
    var movieDetailsView: MovieDetailsView {
        view as! MovieDetailsView
    }
    
    init(viewModel: MovieDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = MovieDetailsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.rightBarButtonItem = favouriteButton
    }
    
    private func bindViewModel() {
        title = viewModel.title
        
        let placeholderImage = UIImage(named: "movie-placeholder")
        movieDetailsView.imageView.image = placeholderImage
        
        viewModel.movieImage()
            .asObservable()
            .bind(to: movieDetailsView.imageView.rx.image)
            .disposed(by: disposeBag)
                
        movieDetailsView.releaseDateLabel.text = viewModel.releaseDateText
        movieDetailsView.popularityLabel.text = viewModel.popularityText
        movieDetailsView.overviewLabel.text = viewModel.overviewText
                
        viewModel.favouriteImage
            .subscribe(onNext: { [weak self] (image) in
                self?.favouriteButton.image = image
            })
            .disposed(by: disposeBag)
    }
}
