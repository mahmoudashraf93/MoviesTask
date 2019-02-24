//
//  MoviesTaskTests.swift
//  MoviesTaskTests
//
//  Created by mahmoud ashraf on 2/22/19.
//  Copyright © 2019 SideProject. All rights reserved.
//

import XCTest
@testable import MoviesTask
enum MockApi {
    case test(testParam: Int)
}
extension MockApi : EndPointType {
    var environmentBaseURL : String {
        switch NetworkManager.environment {
        case .production: return "https://test.com/"
        }
    }
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else {
            fatalError("URL not configured")
        }
        return url
        
    }
    
    var path: String {
        return "testEndpoint"
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .test(let param):
            return .requestParameters(bodyParameters: nil, urlParameters: ["testParam": param])
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    
    
}
class MoviesTaskTests: XCTestCase {
    
    let router = Router<MockApi>()
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

    }
    func testBuildRequest(){
        
        router.request(.test(testParam: 1)) { (data, response, error) in
            XCTAssertNil(data)
        }
      
        
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
