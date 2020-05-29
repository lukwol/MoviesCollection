//
//  Copyright © 2020 lukwol. All rights reserved.
//

import UIKit

final class MovieDetailsView: UIView {
    
    private let scrollView = UIScrollView()
    
    let imageView = UIImageView()
    let releaseDateLabel = UILabel()
    let popularityLabel = UILabel()
    let overviewLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    private func setup() {
        backgroundColor = .white
        
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(imageView)
        
        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(releaseDateLabel)
        
        popularityLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(popularityLabel)
        
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.numberOfLines = 0
        scrollView.addSubview(overviewLabel)
    }
    
    private func setupConstraints() {
        let space = CGFloat(10)
        
        scrollView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true

        releaseDateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: space).isActive = true
        releaseDateLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -space).isActive = true
        releaseDateLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: space).isActive = true
        
        popularityLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: space).isActive = true
        popularityLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -space).isActive = true
        popularityLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: space).isActive = true
        
        overviewLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: space).isActive = true
        overviewLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -space).isActive = true
        overviewLabel.topAnchor.constraint(equalTo: popularityLabel.bottomAnchor, constant: space).isActive = true
        overviewLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -space).isActive = true
    }
    
    override class var requiresConstraintBasedLayout: Bool {
        true
    }
}
