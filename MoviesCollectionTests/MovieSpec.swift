//
//  Copyright © 2020 lukwol. All rights reserved.
//

import Quick
import Nimble
import Foundation
@testable import MoviesCollection

final class MovieSpec: QuickSpec {
    override func spec() {
        describe("Movie") {
            
            var movie: Movie!
            
            afterEach {
                movie = nil
            }
            
            describe("decoding with JSON") {
                
                var movieData: Data!
                
                beforeEach {
                    movieData = try! Data(contentsOf: Bundle(for: Self.self).url(forResource: "movie", withExtension: "json")!)
                }
                
                afterEach {
                    movieData = nil
                }
                
                it("should succeed") {
                    expect {
                        movie = try Movie.decode(from: movieData)
                    }.toNot(throwError())
                    expect(movie).toNot(beNil())
                }
            }
        }
    }
}

