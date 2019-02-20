//
//  ExtensionsTests.swift
//  EditorTests
//
//  Created by Marco Capano on 18/02/2019.
//  Copyright © 2019 Marco Capano. All rights reserved.
//

import XCTest

class ExtensionsTests: XCTestCase {

    func testButtonInitializer() {
        let image = UIImage()
        
        let button = UIButton(image: image)
        let producedImage = button.image(for: .normal)
        
        XCTAssertNotNil(producedImage)
        XCTAssertTrue(image === producedImage)
    }
    
    func testAddChildViewController() {
        let parentViewController = UIViewController()
        let childViewController = UIViewController()
        
        XCTAssert(parentViewController.children.isEmpty)
        XCTAssertNil(childViewController.parent)
        
        parentViewController.addChildViewController(childViewController, toContainerView: parentViewController.view)
        
        XCTAssertEqual(parentViewController.children, [childViewController])
        XCTAssertNotNil(childViewController.parent)
        XCTAssertEqual(childViewController.parent, parentViewController)
    }
    
    func testRemoveChildViewController() {
        let parentViewController = UIViewController()
        let childViewController = UIViewController()
        
        parentViewController.addChild(childViewController)
        parentViewController.view.addSubview(childViewController.view)
        childViewController.didMove(toParent: parentViewController)
        
        XCTAssertEqual(parentViewController.children, [childViewController])
        XCTAssertNotNil(childViewController.parent)
        XCTAssertEqual(childViewController.parent, parentViewController)
        
        childViewController.removeViewAndControllerFromParentViewController()
        
        XCTAssert(parentViewController.children.isEmpty)
        XCTAssertNil(childViewController.parent)
    }
    
    func testRemoveChildViewControllerWithNoParent() {
        let childViewController = UIViewController()
        XCTAssertNil(childViewController.parent)
        
        childViewController.removeViewAndControllerFromParentViewController()
        
        XCTAssertNil(childViewController.parent)
    }


}
