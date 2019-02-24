//
//  ParserTests.swift
//  MoviesTaskTests
//
//  Created by mahmoud ashraf on 2/23/19.
//  Copyright © 2019 SideProject. All rights reserved.
//

import XCTest

class ParserTests: XCTestCase {
    
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testJSONMapping() throws {
        let bundle = Bundle(for: type(of: self))
        
        guard let url = bundle.url(forResource: "Movies", withExtension: "json") else {
            XCTFail("Missing file: Movies.json")
            return
        }
        
        let json = try Data(contentsOf: url)
        let movieResponse = try Parser<MovieResponse>().parse(from: json)
        
        XCTAssertEqual(movieResponse.page, 1)
        XCTAssertEqual(movieResponse.totalResults, 403535)
        XCTAssertEqual(movieResponse.movies?.count, 20)

    }
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
