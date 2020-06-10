//
//  Copyright © 2020 lukwol. All rights reserved.
//

import UIKit
import SimpleAPIClient

/// Repository responsible for fetching and caching images.
final class ImagesRepository {
    private let apiClient = APIClient()
    private let imagesBaseURL = URL(string: "https://image.tmdb.org/t/p/original")!
    
    /// Fetch image either from https://image.tmdb.org API or from disk
    /// - Parameters:
    ///   - imagePath: Image path appended to API URL.
    ///   - completion: Completion handler invoked after fetching is done.
    func fetchImage(for imagePath: String, completion: @escaping (UIImage?) -> Void) {
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(imagePath)
        if let data = try? Data(contentsOf: fileURL) {
            completion(UIImage(data: data))
        } else {
            var urlRequest = URLRequest(url: imagesBaseURL.appendingPathComponent(imagePath))
            urlRequest.httpMethod = HTTPMethod.get.rawValue
            apiClient.fetchData(request: urlRequest) { (result) in
                let data = try? result.get()
                do {
                    try data?.write(to: fileURL)
                } catch {
                    print(error)
                }
                completion(data.flatMap(UIImage.init(data:)))
            }
        }
    }
}
