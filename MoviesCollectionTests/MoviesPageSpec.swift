//
//  Copyright © 2020 lukwol. All rights reserved.
//

import Quick
import Nimble
import Foundation
@testable import MoviesCollection

final class MoviesPageSpec: QuickSpec {
    override func spec() {
        describe("MoviesPage") {
            
            var moviesPage: MoviesPage!
            
            afterEach {
                moviesPage = nil
            }
            
            describe("decoding with JSON") {
                
                var moviesPageData: Data!
                
                beforeEach {
                    moviesPageData = try! Data(contentsOf: Bundle(for: Self.self).url(forResource: "movies_page", withExtension: "json")!)
                }
                
                afterEach {
                    moviesPageData = nil
                }
                
                it("should succeed") {
                    expect {
                        moviesPage = try MoviesPage.decode(from: moviesPageData)
                    }.toNot(throwError())
                    expect(moviesPage).toNot(beNil())
                }
            }
        }
    }
}

