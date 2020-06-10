//
//  Copyright © 2020 lukwol. All rights reserved.
//

import Quick
import Nimble
import Foundation
import SimpleAPIClient
@testable import MoviesCollection

final class MoviesRepositorySpec: QuickSpec {
    override func spec() {
        describe("MoviesRepository") {
            
            var moviesRepository: MoviesRepository!
            var mockAPIClient: MockAPIClient!
            
            beforeEach {
                mockAPIClient = MockAPIClient()
                moviesRepository = MoviesRepository(
                    apiClient: mockAPIClient,
                    configuration: MockConfiguration()
                )
            }
            
            afterEach {
                moviesRepository = nil
            }
            
            describe("fetching now playing movies") {
                                
                beforeEach {
                    moviesRepository.nowPlayingMovies { _ in }
                }
                
                describe("request") {
                    
                    var request: URLRequest!
                    
                    beforeEach {
                        request = mockAPIClient.request
                    }
                    
                    afterEach {
                        request = nil
                    }
                    
                    it("should have GET method") {
                        expect(request.httpMethod).to(equal("GET"))
                    }
                    
                    it("should point to proper API version and encode API key in URL") {
                        expect(request.url).to(equal(URL(string: "https://mock.api/4/movie/now_playing?api_key=mockAPIKey")))
                    }
                }
            }
            
            describe("searching for movies") {
                                
                beforeEach {
                    moviesRepository.searchMovies(for: "Avatar") { _ in }
                }
                
                describe("request") {
                    
                    var request: URLRequest!
                    
                    beforeEach {
                        request = mockAPIClient.request
                    }
                    
                    afterEach {
                        request = nil
                    }
                    
                    it("should have GET method") {
                        expect(request.httpMethod).to(equal("GET"))
                    }
                    
                    it("should point to proper API version and encode API key in URL") {
                        expect(request.url).to(equal(URL(string: "https://mock.api/4/search/movie?api_key=mockAPIKey&query=Avatar")))
                    }
                }
            }
        }
    }
}

private final class MockAPIClient: APIClientType {
    let urlSession = URLSession(configuration: .default)
    var request: URLRequest!
    
    func fetch<T>(request: URLRequest, completion: @escaping (Result<T, RequestError>) -> Void) where T : JSONDecodable {
        self.request = request
        do {
            completion(.success(try T.decode(from: Data())))
        } catch  {
            completion(.failure(.jsonDecodeError(error)))
        }
    }
}

private final class MockConfiguration: ConfigurationType {
    var apiKey: String {
        "mockAPIKey"
    }
    
    var baseAPIURL: URL {
        URL(string: "https://mock.api")!
    }
    
    var apiVersion: APIVersions {
        ._4
    }
}

