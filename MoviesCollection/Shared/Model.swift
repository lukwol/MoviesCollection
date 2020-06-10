//
//  Copyright © 2020 lukwol. All rights reserved.
//

import Foundation
import SimpleAPIClient

protocol Model: Equatable, JSONDecodable {}

extension Model {
    static var jsonDecoder: JSONDecoder {
        DefaultJSONDecoder()
    }
}
