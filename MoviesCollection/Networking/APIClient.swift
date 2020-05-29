//
//  Copyright © 2020 lukwol. All rights reserved.
//

import Foundation

enum RequestError: Error {
    case badResponse(HTTPURLResponse)
    case unsupportedResponseType(URLResponse)
    case noResponse
    case missingData
    case jsonDecodeError(Error)
    case otherError(Error)
}

protocol APIClientType {
    var urlSession: URLSession { get }

    func fetch<T>(
        request: URLRequest,
        completion: @escaping (Result<T, RequestError>) -> Void)
        where T: JSONDecodable
}

final class APIClient: APIClientType {
    let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession(configuration: .default)) {
        self.urlSession = urlSession
    }
    
    func fetchData(
        request: URLRequest,
        completion: @escaping (Result<Data, RequestError>) -> Void)
    {
        urlSession.dataTask(with: request) { (data, response, error) in
            guard let response = response else {
                completion(.failure(.noResponse))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.unsupportedResponseType(response)))
                return
            }
            guard httpResponse.statusCode == 200 else {
                completion(.failure(.badResponse(httpResponse)))
                return
            }
            guard let data = data else {
                completion(.failure(.missingData))
                return
            }
            if let error = error {
                completion(.failure(.otherError(error)))
                return
            } else {
                completion(.success(data))
            }
        }.resume()
    }
    
    func fetch<T>(
        request: URLRequest,
        completion: @escaping (Result<T, RequestError>) -> Void)
        where T: JSONDecodable
    {
        fetchData(request: request) { (result) in
            completion(
                result.flatMap { data -> Result<T, RequestError> in
                    do {
                        return .success(try T.decode(from: data))
                    } catch  {
                        return .failure(.jsonDecodeError(error))
                    }
                }
            )
        }
    }
}
