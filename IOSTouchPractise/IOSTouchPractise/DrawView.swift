//
//  DrawView.swift
//  IOSTouchPractise
//
//  Created by Johnavan Thomas on 2019-03-14.
//  Copyright © 2019 Johnavan Thomas. All rights reserved.
//

import UIKit

class DrawView: UIView {
    var currentLine : Line?
    var finishedLine = [Line]()
    
    let line1 = Line(begin: CGPoint (x:50,y:50), end: CGPoint(x:100,y:100))
    let line2 = Line(begin: CGPoint (x:50, y:100), end: CGPoint(x:100,y:300))
    
    var finishedLineColor: UIColor = UIColor.blue
    var currentLineColor: UIColor = UIColor.black
    var lineThickness: CGFloat = 10
    
    func strokeLine (line: Line){
        //Use BezierPath to draw lines
        let path = UIBezierPath()
        path.lineWidth = lineThickness
        path.lineCapStyle = CGLineCap.round
        path.move(to:line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    override func draw(_ rect: CGRect) {
        for line in finishedLine{
            strokeLine(line: line)
        }
        
        strokeLine(line: line1);
        strokeLine(line: line2);
        
        //draw current line if it exists
        if let line = currentLine {
            currentLineColor.setStroke(); //set colour to draw
            strokeLine(line: line);
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print(#function)
        let touch = touches.first!
        let location = touch.location(in: self)
        currentLine = Line(begin: location, end: location)
        setNeedsDisplay()
    }
}
