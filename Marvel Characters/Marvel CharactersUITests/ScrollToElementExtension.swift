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
        case Up, Down, Right, Left
        
        func scroll(pivot: XCUIElement) {
            let topPoint = pivot.coordinateWithNormalizedOffset(CGVectorMake(0.5, 0.25))
            let bottomPoint =  pivot.coordinateWithNormalizedOffset(CGVectorMake(0.5, 0.75))
            
            let leadingPoint =  pivot.coordinateWithNormalizedOffset(CGVectorMake(0.15, 0.5))
            let trailingPoint =  pivot.coordinateWithNormalizedOffset(CGVectorMake(0.65, 0.5))
            
            switch self {
            case .Up:   topPoint.pressForDuration(0.1, thenDragToCoordinate: bottomPoint)
            case .Down: bottomPoint.pressForDuration(0.1, thenDragToCoordinate: topPoint)
                
            case .Left: leadingPoint.pressForDuration(0.1, thenDragToCoordinate: trailingPoint)
            case .Right: trailingPoint.pressForDuration(0.1, thenDragToCoordinate: leadingPoint)
                
            }
        }
        
        func swipe(pivot: XCUIElement) {
            switch self {
            case .Up:   pivot.swipeDown()
            case .Down: pivot.swipeUp()
                
            case .Left: pivot.swipeRight()
            case .Right: pivot.swipeLeft()
                
            }
        }
    }
    
    func scrollToElement(direction: Direction, element: XCUIElement) {
        while !element.visible() {
            direction.scroll(self)
        }
    }
    
    /**
     This may fail, do not use it
     
     - parameter direction: <#direction description#>
     - parameter element:   <#element description#>
     */
    func swipeInDirection(direction: Direction, times: UInt) {
        for _ in 0..<times {
            direction.swipe(self)
        }
    }
    
    func visible() -> Bool {
        guard self.exists && !CGRectIsEmpty(self.frame) else { return false }
        return CGRectContainsRect(XCUIApplication().windows.elementBoundByIndex(0).frame, self.frame)
    }
    
}