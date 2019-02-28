//
//  MoviesTaskUITests.swift
//  MoviesTaskUITests
//
//  Created by mahmoud ashraf on 2/22/19.
//  Copyright © 2019 SideProject. All rights reserved.
//

import XCTest

class MoviesTaskUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        
        app.launchArguments += ["UI-TESTING"]
        app.launch()


        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    func testAddingMovieWithoutTitle(){
   
        app.buttons["plus"].tap()
        app.scrollViews.otherElements.buttons["Add"].tap()
        XCTAssertEqual(app.alerts.element.label, "Invalid Input")


    }
    func testAddingMovie(){
        app.buttons["plus"].tap()
        
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.textFields["Movie Name"].tap()
        elementsQuery.textFields["Movie Name"].typeText("movie")
        
        let overviewTextView = elementsQuery.textViews["Overview"]
        overviewTextView.tap()
        let expectedOverView = "Movie overview"
        overviewTextView.typeText(expectedOverView)
        app.toolbars["Toolbar"].buttons["Cancel"].tap()
        elementsQuery.buttons["Add"].tap()
        
        XCTAssert(app.tables.otherElements["My Movies"].exists)
        XCTAssert(app.staticTexts[expectedOverView].exists)

        

    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
