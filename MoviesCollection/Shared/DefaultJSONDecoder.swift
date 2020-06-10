//
//  Copyright © 2020 lukwol. All rights reserved.
//

import Foundation

final class DefaultJSONDecoder: JSONDecoder {
    override init() {
        super.init()
        
        keyDecodingStrategy = .convertFromSnakeCase
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateDecodingStrategy = .formatted(dateFormatter)
    }
}
