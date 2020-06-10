//
//  Copyright © 2020 lukwol. All rights reserved.
//

import Quick
import Nimble
import Foundation
@testable import MoviesCollection

final class JSONDecodableSpec: QuickSpec {
    override func spec() {
        describe("JSONDecodable") {
            
            var model: MockModel!
            
            beforeEach {
                let jsonString = """
                { "example_date": "2020-05-25" }
                """
                model = try! MockModel.decode(from: jsonString.data(using: .utf8)!)
            }
            
            afterEach {
                model = nil
            }
            
            describe("decoding with JSON") {
                it("should properly decode date and convert from snake case") {
                    expect(model.exampleDate).to(equal(DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, year: 2020, month: 5, day: 25).date))
                }
            }
        }
    }
}

private struct MockModel: Model {
    let exampleDate: Date
}
