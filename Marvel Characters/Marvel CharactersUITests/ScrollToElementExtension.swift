//
//  ScrollToElementExtension.swift
//  Marvel Characters
//
//  Created by Hugo on 6/8/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//
import XCTest
import Foundation

extension XCUIElement {

    enum Direction {
        case up, down, right, left

        func scroll(_ pivot: XCUIElement) {
            let topPoint = pivot.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.25))
            let bottomPoint =  pivot.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.75))

            let leadingPoint =  pivot.coordinate(withNormalizedOffset: CGVector(dx: 0.15, dy: 0.5))
            let trailingPoint =  pivot.coordinate(withNormalizedOffset: CGVector(dx: 0.65, dy: 0.5))

            switch self {
            case .up:   topPoint.press(forDuration: 0.1, thenDragTo: bottomPoint)
            case .down: bottomPoint.press(forDuration: 0.1, thenDragTo: topPoint)

            case .left: leadingPoint.press(forDuration: 0.1, thenDragTo: trailingPoint)
            case .right: trailingPoint.press(forDuration: 0.1, thenDragTo: leadingPoint)

            }
        }

        func swipe(_ pivot: XCUIElement) {
            switch self {
            case .up:   pivot.swipeDown()
            case .down: pivot.swipeUp()

            case .left: pivot.swipeRight()
            case .right: pivot.swipeLeft()

            }
        }
    }

    func scrollToElement(_ direction: Direction, element: XCUIElement) {
        while !element.visible() {
            direction.scroll(self)
        }
    }

    /**
     This may fail, do not use it
     
     - parameter direction: <#direction description#>
     - parameter element:   <#element description#>
     */
    func swipeInDirection(_ direction: Direction, times: UInt) {
        for _ in 0..<times {
            direction.swipe(self)
        }
    }

    func visible() -> Bool {
        guard self.exists && !self.frame.isEmpty else { return false }
        return XCUIApplication().windows.element(boundBy: 0).frame.contains(self.frame)
    }

}
