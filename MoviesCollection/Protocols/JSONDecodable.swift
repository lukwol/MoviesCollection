//
//  Copyright © 2020 lukwol. All rights reserved.
//

import Foundation

/// Describes type decodable from JSON
protocol JSONDecodable: Decodable {
    
    /// Decode type from JSON. By default uses "yyyy-MM-dd" date format and conversion from snake case..
    /// - Parameter json: Encoded JSON data
    static func decode(from json: Data) throws -> Self
}

extension JSONDecodable {
    private static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }
    
    private static var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    static func decode(from json: Data) throws -> Self {
        try jsonDecoder.decode(Self.self, from: json)
    }
}
