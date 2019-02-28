//
//  RouterTests.swift
//  MoviesTaskTests
//
//  Created by mahmoud ashraf on 2/28/19.
//  Copyright © 2019 SideProject. All rights reserved.
//

import XCTest

class RouterTests: XCTestCase {
    var sut: Router<MockApi>!
    let session = MockUrlSession()
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = Router<MockApi>(session: session)
        
    }
    func testUrl(){
        sut.request(.testURL) { (_, _, _) in
            
        }
        XCTAssert(session.lastUrl == URL(string: "https://test.com/testEndpoint"))
    }
    func testUrlAndParametery(){
        sut.request(.test(testParam: 0)) { (_, _, _) in
            
        }
        XCTAssert(session.lastUrl == URL(string: "https://test.com/testEndpoint?testparam=0"))
    }
    
    func testResumeIsCalled() {
        let dataTask = MockUrlSessionDataTask()
        session.nextDataTask = dataTask
        sut.request(.testURL) { (_, _, _) in
            
        }
        XCTAssert(dataTask.isResumeCalled)
    }
    
    func testCancelIsCalled() {
        let dataTask = MockUrlSessionDataTask()
        session.nextDataTask = dataTask
        sut.request(.testURL) { (_, _, _) in
            
        }
        sut.cancel()
        XCTAssert(dataTask.isCancelCalled)
    }
    
    func testData(){
        let expectedData = "test".data(using: .utf8)
        session.nextData = expectedData
        
        var actualData: Data?
        sut.request(.testURL) { (data, _, _) in
            actualData = data
        }
        XCTAssertEqual(expectedData, actualData)
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

class MockUrlSession: URLSessionProtocol {
    var nextDataTask = MockUrlSessionDataTask()
    var nextData: Data?
    var nextError: Error?
    private (set) var lastUrl: URL?
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
       lastUrl = request.url
        completionHandler(nextData,nil,nextError)
        return nextDataTask
    }
    
    
}
class MockUrlSessionDataTask: URLSessionDataTaskProtocol{
    var isResumeCalled = false
    var isCancelCalled = false
    func resume() {
        isResumeCalled = true
    }
    
    func cancel() {
        isCancelCalled = true
    }
}
