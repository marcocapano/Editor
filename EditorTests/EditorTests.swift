//
//  EditorTests.swift
//  EditorTests
//
//  Created by Marco Capano on 18/02/2019.
//  Copyright © 2019 Marco Capano. All rights reserved.
//

import XCTest

class EditorTests: XCTestCase {
    
    func testStatsGeneration() {
        let shapes: [ShapesViewController.ShapeInfo] = [
            (view: UIImageView(), type: .triangle),
            (view: UIImageView(), type: .triangle),
            (view: UIImageView(), type: .circle),
            (view: UIImageView(), type: .square),
            (view: UIImageView(), type: .circle),
            (view: UIImageView(), type: .circle)
        ]
        
        let stats = EditorViewController().generateStats(from: shapes)
        
        XCTAssertEqual(stats.count, 3)
        
        XCTAssertTrue(stats.contains(where: {$0.count == 2 && $0.type == .triangle}))
        XCTAssertTrue(stats.contains(where: {$0.count == 1 && $0.type == .square}))
        XCTAssertTrue(stats.contains(where: {$0.count == 3 && $0.type == .circle}))
    }

}
