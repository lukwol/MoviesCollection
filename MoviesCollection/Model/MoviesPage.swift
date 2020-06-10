//
//  Copyright © 2020 lukwol. All rights reserved.
//

import Foundation

struct MoviesPage: Model {
    
    struct Dates: Model {
        let maximum: Date
        let minimum: Date
    }
    
    let results: [Movie]
    let page: Int
    let totalResults: Int
    let dates: Dates?
    let totalPages: Int
}
