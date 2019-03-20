//
//  DrawView.swift
//  IOSTouchPractise
//
//  Created by Johnavan Thomas on 2019-03-14.
//  Copyright © 2019 Johnavan Thomas. All rights reserved.
//

import UIKit

class DrawView: UIView {
   // var currentLine : Line?
    var currentLines = [NSValue:Line]()
    var finishedLine = [Line]()
    var selectedLineIndex: Int?
    
    let line1 = Line(begin: CGPoint (x:50,y:50), end: CGPoint(x:100,y:100))
    let line2 = Line(begin: CGPoint (x:50, y:100), end: CGPoint(x:100,y:300))
    
   // var finishedLineColor: UIColor = UIColor.blue
   // var currentLineColor: UIColor = UIColor.black
   // var lineThickness: CGFloat = 10
    
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
            finishedLineColor.setStroke(); //set colour to draw
            strokeLine(line: line)
        }
        
        strokeLine(line: line1);
        strokeLine(line: line2);
        
        //draw current line if it exists
        for (_,line) in currentLines{
            currentLineColor.setStroke()
            strokeLine(line: line)
        }
        
        //over-draw the selected line
        if let index = selectedLineIndex {
            UIColor.yellow.setStroke()
            let selectedLine = finishedLine[index]
            strokeLine(line: selectedLine)
        }
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        let doubleTapRecognizer =
            UITapGestureRecognizer(target: self,
                                   action: #selector(DrawView.doubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.delaysTouchesBegan = true
        addGestureRecognizer(doubleTapRecognizer)
        
        let tapRecognizer =
            UITapGestureRecognizer(target: self,
                                   action: #selector(DrawView.tap(_:)))
        tapRecognizer.delaysTouchesBegan = true
        tapRecognizer.require(toFail: doubleTapRecognizer)
        addGestureRecognizer(tapRecognizer)
        
    }
    
    

    
    @objc func doubleTap(_ gestureRecognizer: UIGestureRecognizer){
        print("I got a double tap")
        
        if (selectedLineIndex != nil) {
            finishedLine.remove(at: selectedLineIndex!)
        } else {
            selectedLineIndex = nil
            currentLines.removeAll(keepingCapacity: false)
            finishedLine.removeAll(keepingCapacity: false)
        }
        //currentLines.removeAll(keepingCapacity: false)
        setNeedsDisplay()
    }
    

    
    @objc func tap(_ gestureRecognizer: UIGestureRecognizer){
        print("I got a tap")
        let tapPoint = gestureRecognizer.location(in: self)
        selectedLineIndex = indexOfLineNearPoint(point: tapPoint)
        setNeedsDisplay()
    }
    
    func distanceBetween(from: CGPoint, to: CGPoint) -> CFloat{
        let distXsquared = Float((to.x-from.x)*(to.x-from.x))
        let distYsquared = Float((to.y-from.y)*(to.y-from.y))
        return sqrt(distXsquared + distYsquared);
    }
    
    func indexOfLineNearPoint(point: CGPoint) -> Int? {
        let tolerence: Float = 1.0 //experiment with this value
        for(index,line) in finishedLine.enumerated(){
            let begin = line.begin
            let end = line.end
            let lineLength = distanceBetween(from: begin, to: end)
            let beginToTapDistance = distanceBetween(from: begin, to: point)
            let endToTapDistance = distanceBetween(from: end, to: point)
            if (beginToTapDistance + endToTapDistance - lineLength) < tolerence {
                return index
            }
        }
        return nil
    }
    
   /* override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print(#function)
        for touch in touches {
        let location = touch.location(in: self)
        currentLine = Line(begin: location, end: location)
        setNeedsDisplay()
    }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print(#function)
        let touch = touches.first!
        let location = touch.location(in: self);
        currentLine?.end = location;
        setNeedsDisplay();
     
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        print(#function)
        if var line = currentLine {
            let touch = touches.first!;
            let location = touch.location(in: self);
            line.end = location;
            finishedLine.append(line);
        }
        currentLine = nil;
        setNeedsDisplay();
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        
        print(#function)
        currentLine = nil;
        setNeedsDisplay();
    
    }
 */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    print(#function)
    for touch in touches {
    let location = touch.location(in: self)
    let newLine = Line(begin: location, end: location)
    let key = NSValue(nonretainedObject: touch)
    currentLines[key] = newLine
    }
    setNeedsDisplay()
}

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    print(#function)
    for touch in touches {
        let key = NSValue(nonretainedObject: touch)
        currentLines[key]?.end  = touch.location(in:self)
    }
    setNeedsDisplay()
    
}
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print(#function)
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
    
        if var line = currentLines[key]{
        
            line.end = touch.location(in: self)
            finishedLine.append(line)
            currentLines.removeValue(forKey: key)
        }

        setNeedsDisplay();
    }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        
        print(#function)
        currentLines.removeAll()
        setNeedsDisplay()
        
    }
    
        
    @IBInspectable var finishedLineColor: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var currentLineColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var lineThickness: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
}
