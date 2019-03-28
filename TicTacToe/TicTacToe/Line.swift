//
//  Line.swift
//  TicTacToe
//
//  Created by Johnavan Thomas on 2019-03-20.
//  Copyright © 2019 Johnavan Thomas. All rights reserved.
//

import Foundation
import CoreGraphics

struct Line {
    var begin = CGPoint.zero
    var end = CGPoint.zero
    func intersection(someLine: Line) -> (Bool, CGPoint?) {
        
        let bx1 = self.begin.x
        let by1 = self.begin.y
        let ex1 = self.end.x
        let ey1 = self.end.y
        
        let bx2 = someLine.begin.x
        let by2 = someLine.begin.y
        let ex2 = someLine.end.x
        let ey2 = someLine.end.y
        
        let dx1 = ex1 - bx1
        let dy1 = ey1 - by1
        let dx2 = ex2 - bx2
        let dy2 = ey2 - by2
        
        let s = (-dy1 * (bx1 - bx2) + dx1 * (by1 - by2)) / (-dx2 * dy1 + dx1 * dy2);
        let t = ( dx2 * (by1 - by2) - dy2 * (ex1 - ex2)) / (-dx2 * dy1 + dx1 * dy2);
        
        if (s >= 0 && s <= 1 && t >= 0 && t <= 1) {
            // The lines are intersecting
            let col_x = bx1 + (t * dx1); // x-coordinate of the intersection
            let col_y = by1 + (t * dy1); // y-coordinate of the intersection
            return (true, CGPoint(x:col_x, y:col_y));
        }
        
        return (false, nil)
    }
}

