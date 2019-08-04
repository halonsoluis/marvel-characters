//
//  XCUIApplication+Extension.swift
//  Marvel CharactersUITests
//
//  Created by Hugo Alonso on 26/07/2019.
//  Copyright © 2019 halonsoluis. All rights reserved.
//

import XCTest

extension XCUIApplication {
    var backButton: XCUIElement {
        return buttons["Back"]
    }

    func configureSuite() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        launchArguments.append("MOCKUP_MODE")
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        launch()
    }

    func goIntoCharacterDetails(characterName: String) {
        tables.buttons[characterName].tap()
    }

    func locateItemInScreen(element: XCUIElement, direction: XCUIElement.Direction) {
        if !element.isHittable {
            scrollToElement(direction, element: element)
        }
    }
}
