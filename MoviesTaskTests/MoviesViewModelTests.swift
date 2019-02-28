//
//  MoviesViewModelTests.swift
//  MoviesTaskTests
//
//  Created by mahmoud ashraf on 2/28/19.
//  Copyright © 2019 SideProject. All rights reserved.
//

import XCTest

class MoviesViewModelTests: XCTestCase {
    let mockMoviesRepo = MockWebMoviesRepository()
    var sut = MoviesViewModel()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.sut = MoviesViewModel(webMoviesRepo: mockMoviesRepo)

    }
    func testGetMoviesCalled() {
        self.sut.getMovies()
        XCTAssertTrue(mockMoviesRepo.isGetMoviesCalled)
    }
    func testGetMoviesError() {
        let networkError = NetworkError.encodingFailed
        
        self.sut.getMovies()
        self.mockMoviesRepo.getFail(error: networkError.rawValue)
        let expect = XCTestExpectation(description: "failure closure triggered")
        sut.failureClosure = { (error) in
            expect.fulfill()
            XCTAssertEqual(error, error)

        }
        XCTAssertEqual(self.sut.error, networkError.rawValue)

    }
    func testLoadingClosureCalled(){
        self.sut.getMovies()
        let expect = XCTestExpectation(description: "loading closure triggered")
        sut.startLoadingClosure = {
            expect.fulfill()
            
        }
        XCTAssertEqual(self.sut.isLoading, true)

    }
    func testCreateCellViewModelWhenPaging() {
        // Given
        let movie = StubGenerator().stubMovie()
        mockMoviesRepo.movie = movie
        let expect = XCTestExpectation(description: "reload closure triggered")
        sut.reloadTableviewClosure = { () in
            expect.fulfill()
        }
        
        // When
        sut.getMovies()
        mockMoviesRepo.getSuccess()
    
        // total pages is > pagenumber
        XCTAssertEqual( sut.numberOfRowsForMovies, movie.movies!.count + 1 )
        
        // XCTAssert reload closure triggered
        wait(for: [expect], timeout: 1.0)
        
    }
    func testCreateCellViewModelWhenNotPaging() {
        // Given
        let movie = StubGenerator().stubMovie()
        movie.totalPages = 1
        mockMoviesRepo.movie = movie
        let expect = XCTestExpectation(description: "reload closure triggered")
        sut.reloadTableviewClosure = { () in
            expect.fulfill()
        }
        
        // When
        sut.getMovies()
        mockMoviesRepo.getSuccess()
        
        // total pages is = pagenumber
        XCTAssertEqual( sut.numberOfRowsForMovies, movie.movies!.count)
        
        // XCTAssert reload closure triggered
        wait(for: [expect], timeout: 1.0)
        
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
class MockWebMoviesRepository: WebRepository {
    var isGetMoviesCalled = false
    var movie: MovieResponse = MovieResponse()
    var completionClosure: ((MovieResponse, String?) -> ())!
    
    func get(page: Int, completion: @escaping (MovieResponse?, String?) -> ()) {
        isGetMoviesCalled = true
        completionClosure = completion
    }
    func getSuccess() {
        completionClosure( movie, nil )
    }
    
    func getFail(error: String?) {
        completionClosure(movie, error )
    }
    
}
