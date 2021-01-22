//
//  MovieAPIServiceTests.swift
//  MovieDatabaseTests
//
//  Created by Sumit Kumar on 22/01/21.
//  Copyright © 2021 sumitkr110. All rights reserved.
//

import XCTest
@testable import MovieDatabase
class MovieAPIServiceTests: XCTestCase {
    let apiService = MockAPIServiceClient()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    func testGetBookListForPublishedDateResponse()  {
        
        let expectation = self.expectation(description: "Movie Data Response Successful")
        //Uncomment for testing API failure flow
        //apiService.shouldReturnError = true
        apiService.getNowPlayingList { result in
            switch result{
            case .failure (let error):
                XCTFail(error.localizedDescription)
                XCTAssertNil(error)
            case .success (let homeData):
                XCTAssertNotNil(homeData)
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 10.0, handler: nil)
    }
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

}
