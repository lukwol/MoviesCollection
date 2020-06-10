//
//  Copyright © 2020 lukwol. All rights reserved.
//

import Foundation

struct Movie: Model {    
    let popularity: Float
    let voteCount: Int
    let video: Bool
    let posterPath: String?
    let id: Int
    let adult: Bool
    let backdropPath: String?
    let originalLanguage: String
    let originalTitle: String
    let genreIds: [Int]
    let title: String
    let voteAverage: Float
    let overview: String
    let releaseDate: Date
}
