//
//  Copyright © 2020 lukwol. All rights reserved.
//

import Foundation

enum APIVersions: String {
    case _1 = "1"
    case _2 = "2"
    case _3 = "3"
    case _4 = "4"
}

protocol ConfigurationType {

    var apiKey: String { get }
    
    var baseAPIURL: URL { get }
    
    var apiVersion: APIVersions { get }
}

extension ConfigurationType {
    var apiURL: URL {
        baseAPIURL.appendingPathComponent(apiVersion.rawValue)
    }
}

enum Configuration: ConfigurationType {
    case debug
    case release
    
    static var current: Self {
        #if DEBUG
        return .debug
        #else
        return .release
        #endif
    }
}

extension Configuration {
    var apiKey: String {
        switch self {
        case .debug:
            return <#API Key#>
        case .release:
            fatalError("Provide production API KEY")
        }
    }
    
    var baseAPIURL: URL {
        switch self {
        case .debug:
            return URL(string: "https://api.themoviedb.org/")!
        case .release:
            fatalError("Provide production API URL")
        }
    }
    
    var apiVersion: APIVersions {
        ._3
    }
    
    /// Complete API URL built with base API URL and API version.
    var apiURL: URL {
        baseAPIURL.appendingPathComponent(apiVersion.rawValue)
    }
}
