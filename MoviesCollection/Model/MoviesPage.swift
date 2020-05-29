//
//  Copyright © 2020 lukwol. All rights reserved.
//

import Foundation

struct MoviesPage: Equatable, JSONDecodable {
    
    let results: [Movie]
    
    struct Dates: Equatable, JSONDecodable {
        let maximum: Date
        let minimum: Date
    }
    
    let page: Int
    let totalResults: Int
    let dates: Dates?
    let totalPages: Int
}
