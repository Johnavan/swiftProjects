//
//  DrawView.swift
//  TicTacToe
//
//  Created by Johnavan Thomas on 2019-03-20.
//  Copyright © 2019 Johnavan Thomas. All rights reserved.


import UIKit

class DrawView: UIView {
    
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

    var boardLines =     [NSValue:Line]()
    var turnLines  =     [Line]()
    var finishedLines =  [Line]()
    var selectedLineIndex: Int?
    
    
    
    
    func strokeLine (line: Line){
        let path = UIBezierPath()
        path.lineWidth = lineThickness
        path.lineCapStyle = CGLineCap.round
        path.move(to:line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }

}

