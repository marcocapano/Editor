//
//  EditorUITests.swift
//  EditorUITests
//
//  Created by Marco Capano on 18/02/2019.
//  Copyright © 2019 Marco Capano. All rights reserved.
//

import XCTest

class EditorUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    func testInitialState() {
        XCTAssertTrue(app.buttons["Stats"].exists)
        XCTAssertTrue(app.buttons["Undo"].exists)
    }
    
    //MARK: - Adding
    
    func testAdding() {
        XCTAssertFalse(app.images["Triangle.png"].exists)
        app.buttons["Triangle"].tap()
        XCTAssertTrue(app.images["Triangle.png"].exists)
    }
    
    func testUndoAdding() {
        app.buttons["Triangle"].tap()
        XCTAssertTrue(app.images["Triangle.png"].exists)
        
        app.buttons["Undo"].tap()
        XCTAssertFalse(app.images["Triangle.png"].exists)
    }
    
    func testUndoMultipleAdding() {
        app.buttons["Triangle"].tap()
        XCTAssertTrue(app.images["Triangle.png"].exists)
        XCTAssertFalse(app.images["Oval.png"].exists)
        
        app.buttons["Oval"].tap()
        XCTAssertTrue(app.images["Triangle.png"].exists)
        XCTAssertTrue(app.images["Oval.png"].exists)
        
        app.buttons["Undo"].tap()
        XCTAssertTrue(app.images["Triangle.png"].exists)
        XCTAssertFalse(app.images["Oval.png"].exists)
        
        app.buttons["Undo"].tap()
        XCTAssertFalse(app.images["Triangle.png"].exists)
        XCTAssertFalse(app.images["Oval.png"].exists)
    }
    
    //MARK: - Dragging
    func testDraggingShapeWithUndo() {
        app.buttons["Triangle"].tap()
        
        let trianglePngImage = app.images["Triangle.png"]
        let initialPosition = trianglePngImage.frame
        
        trianglePngImage.swipeRight()
        let positionAfterDragging = trianglePngImage.frame
        XCTAssertNotEqual(initialPosition, positionAfterDragging)
        
        app.buttons["Undo"].tap()
        let positionAfterUndo = trianglePngImage.frame
        XCTAssertEqual(initialPosition, positionAfterUndo)
    }
    
    func testMultipleDraggingShapeWithUndo() {
        app.buttons["Rectangle"].tap()
        
        let squarePngImage = app.images["Rectangle.png"]
        let initialPosition = squarePngImage.frame
        
        squarePngImage.swipeRight()
        let positionAfterDragging = squarePngImage.frame
        XCTAssertNotEqual(initialPosition, positionAfterDragging)
        
        squarePngImage.swipeUp()
        let positionAfterSecondDragging = squarePngImage.frame
        XCTAssertNotEqual(positionAfterDragging, positionAfterSecondDragging)
        XCTAssertNotEqual(initialPosition, positionAfterSecondDragging)
        
        app.buttons["Undo"].tap()
        let positionAfterUndo = squarePngImage.frame
        XCTAssertNotEqual(initialPosition, positionAfterUndo)
        XCTAssertEqual(positionAfterUndo, positionAfterDragging)
        
        app.buttons["Undo"].tap()
        let positionAfterSecondUndo = squarePngImage.frame
        XCTAssertEqual(positionAfterSecondUndo, initialPosition)
    }
    
    //MARK: - Stats
    func testShowingStats() {
        app.buttons["Triangle"].tap()
        app.buttons["Oval"].tap()
        app.buttons["Rectangle"].tap()
        app.buttons["Rectangle"].tap()
        
        app.navigationBars["Editor"].buttons["Stats"].tap()
        
        XCTAssert(app.navigationBars["Stats"].exists)
        XCTAssertTrue(app.buttons["Delete all"].exists)

        XCTAssertTrue(app.staticTexts["Triangle: 1 shape(s)"].exists)
        XCTAssertTrue(app.staticTexts["Circle: 1 shape(s)"].exists)
        XCTAssertTrue(app.staticTexts["Square: 2 shape(s)"].exists)
    }
    
    func testDeleteAll() {
        app.buttons["Oval"].tap()
        app.buttons["Triangle"].tap()
        app.buttons["Rectangle"].tap()
        app.navigationBars["Editor"].buttons["Stats"].tap()
        
        XCTAssertEqual(app.cells.count, 3)
        XCTAssertTrue(app.staticTexts["Triangle: 1 shape(s)"].exists)
        XCTAssertTrue(app.staticTexts["Circle: 1 shape(s)"].exists)
        XCTAssertTrue(app.staticTexts["Square: 1 shape(s)"].exists)

        app.navigationBars["Stats"].buttons["Delete all"].tap()
        
        XCTAssertEqual(app.cells.count, 3)
        XCTAssertTrue(app.staticTexts["Triangle: 0 shape(s)"].exists)
        XCTAssertTrue(app.staticTexts["Circle: 0 shape(s)"].exists)
        XCTAssertTrue(app.staticTexts["Square: 0 shape(s)"].exists)
    }
    
    func testDeleteTypeOfShape() {
        app.buttons["Triangle"].tap()
        app.buttons["Rectangle"].tap()
        XCTAssertTrue(app.images["Triangle.png"].exists)
        XCTAssertTrue(app.images["Rectangle.png"].exists)

        //Delete
        app.navigationBars["Editor"].buttons["Stats"].tap()
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.cells.staticTexts["Square: 1 shape(s)"]/*[[".cells.staticTexts[\"Square: 1 shape(s)\"]",".staticTexts[\"Square: 1 shape(s)\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.swipeLeft()
        tablesQuery.buttons["Delete"].tap()
        
        XCTAssertTrue(tablesQuery.staticTexts["Square: 0 shape(s)"].exists)
        
        app.navigationBars["Stats"].buttons["Editor"].tap()
        
        //Make sure only sqares are deleted
        XCTAssertTrue(app.images["Triangle.png"].exists)
        XCTAssertFalse(app.images["Rectangle.png"].exists)
    }
    
    func testDeleteSingleShapeWithUndo() {
        //Add shape
        app.buttons["Rectangle"].tap()
        XCTAssertTrue(app.images["Rectangle.png"].exists)
        
        //Trigger prompt
        let rectanglePngImage = app.images["Rectangle.png"]
        rectanglePngImage/*@START_MENU_TOKEN@*/.press(forDuration: 0.9);/*[[".tap()",".press(forDuration: 0.9);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        let doYouWantDoDeleteThisShapeAlert = app.alerts["Do you want do delete this shape?"]
        XCTAssertTrue(doYouWantDoDeleteThisShapeAlert.exists)
        
        //Cancel
        doYouWantDoDeleteThisShapeAlert.buttons["Cancel"].tap()
        XCTAssertFalse(doYouWantDoDeleteThisShapeAlert.exists)
        
        //Trigger prompt again
        rectanglePngImage/*@START_MENU_TOKEN@*/.press(forDuration: 0.9);/*[[".tap()",".press(forDuration: 0.9);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(doYouWantDoDeleteThisShapeAlert.exists)
        
        //Confirm and check if deletion happened
        doYouWantDoDeleteThisShapeAlert.buttons["Yes"].tap()
        XCTAssertFalse(app.images["Rectangle.png"].exists)

        //Undo and check if the shape is back on screen
        app.navigationBars["Editor"].buttons["Undo"].tap()
        XCTAssertTrue(app.images["Rectangle.png"].exists)
    }

}
