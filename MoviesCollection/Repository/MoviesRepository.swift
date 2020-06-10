//
//  Copyright © 2020 lukwol. All rights reserved.
//

import Foundation
import SimpleAPIClient

/// Manages fetching for now playing movies and provides search results.
final class MoviesRepository {
    private let apiClient: APIClientType
    private let configuration: ConfigurationType
    
    init(apiClient: APIClientType = APIClient(), configuration: ConfigurationType = Configuration.current) {
        self.apiClient = apiClient
        self.configuration = configuration
    }
    
    private var nowPlayingUrl: URL {
        configuration.apiURL
            .appendingPathComponent("movie/now_playing")
            .appending(apiKey: configuration.apiKey)
    }
    
    private var searchMoviegUrl: URL {
        configuration.apiURL
            .appendingPathComponent("search/movie")
            .appending(apiKey: configuration.apiKey)
    }
    
    /// Fetch first page of now playing movies.
    /// - Parameter completion: Completion handler with fetch result
    func nowPlayingMovies(completion: @escaping (Result<MoviesPage, RequestError>) -> Void) {
        var urlRequest = URLRequest(url: nowPlayingUrl)
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        apiClient.fetch(request: urlRequest, completion: completion)
    }
    
    /// Fetch first page of search results for specific query.
    /// - Parameters:
    ///   - query: Search query
    ///   - completion: Completion handler with fetch result
    func searchMovies(for query: String, completion: @escaping (Result<MoviesPage, RequestError>) -> Void) {
        var urlRequest = URLRequest(url: searchMoviegUrl.appending(searchQuery: query))
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        apiClient.fetch(request: urlRequest, completion: completion)
    }
}

// MARK - Private extension for URL

private extension URL {
    func appending(apiKey: String) -> URL {
        appending(queryItem: URLQueryItem(name: "api_key", value: apiKey))
    }
    
    func appending(searchQuery: String) -> URL {
        appending(queryItem: URLQueryItem(name: "query", value: searchQuery))
    }
    
    func appending(queryItem: URLQueryItem) -> URL {
        var urlComponents = URLComponents(
            url: self,
            resolvingAgainstBaseURL: true
        )!
        if urlComponents.queryItems != nil {
            urlComponents.queryItems?.append(queryItem)
        } else {
            urlComponents.queryItems = [queryItem]
        }
        return urlComponents.url!
    }
}
