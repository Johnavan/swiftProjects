//
//  DrawView.swift
//  TicTacToe
//
//  Created by Johnavan Thomas on 2019-03-20.
//  Copyright © 2019 Johnavan Thomas. All rights reserved.


import UIKit


class DrawView: UIView{
    
    @IBInspectable var gridColour: UIColor = UIColor.black { didSet {setNeedsDisplay()} }
    @IBInspectable var moveColour: UIColor = UIColor.yellow { didSet {setNeedsDisplay()} }
    @IBInspectable var currentLineColor: UIColor = UIColor.blue { didSet {setNeedsDisplay()} }
    @IBInspectable var lineThickness: CGFloat = 7 { didSet {setNeedsDisplay()} }
    
    
    var viewController: ViewController!
    var game: TicTacToeGame = TicTacToeGame()
    
    var boardLines = [NSValue:Line]()
    var turnLines = [Line]()
    var finishedLines = [Line]()
    var selectedLineIndex: Int? = nil
    
    var boardDrawn: Bool = false
    var boardCoordinates = [CGPoint]()
    
    var usrMove: Int = 0
    
    
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
        
        if (game.gameWon) {
            if (selectedLineIndex == nil) {
                resetGame()
            } else {
                finishedLines.remove(at: selectedLineIndex!)
                selectedLineIndex = nil
            }
            setNeedsDisplay()
        }
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
        for(index,line) in finishedLines.enumerated(){
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
    
    func strokeLine(line: Line) {
        
        let path = UIBezierPath();
        path.lineWidth = lineThickness;
        path.lineCapStyle = CGLineCap.round;
        
        path.move(to: line.begin);
        path.addLine(to: line.end);
        path.stroke();
    }
    
    override func draw(_ rect: CGRect) { // finished lines
        
        for line in finishedLines{
            if ((finishedLines.firstIndex(where: {$0.begin == line.begin && $0.end == line.end})) != nil) {
                gridColour.setStroke()
            } else {
                moveColour.setStroke()
            }
            strokeLine(line: line);
        }
        
        //draw current line if it exists
        for (_,line) in boardLines {
            currentLineColor.setStroke()
            strokeLine(line: line)
        }
        
        for line in turnLines {
            currentLineColor.setStroke()
            strokeLine(line: line)
        }
        
        //over-draw the selected line
        if let index = selectedLineIndex {
            UIColor.yellow.setStroke()
            let selectedLine = finishedLines[index]
            strokeLine(line: selectedLine)
        }
    }
    
    //Override Touch Functions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!game.gameWon) {
            for touch in touches {
                let location = touch.location(in: self)
                let newLine = Line(begin: location, end: location)
                let key = NSValue(nonretainedObject: touch)
                
                if (boardDrawn) {
                    turnLines.append(newLine)
                } else {
                    boardLines[key] = newLine
                }
            }
            setNeedsDisplay()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!game.gameWon) {
            for touch in touches {
                let location = touch.location(in: self)
                let key = NSValue(nonretainedObject: touch)
                
                if (boardDrawn) {
                    let newLine = Line(begin: turnLines[turnLines.count - 1].end, end: location)
                    turnLines.append(newLine)
                } else {
                    boardLines[key]?.end = location
                }
            }
            setNeedsDisplay()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!game.gameWon) {
            for touch in touches {
                let location = touch.location(in: self)
                let key = NSValue(nonretainedObject: touch)
                
                if (boardDrawn) {
                    usrMove += 1
                    let newLine = Line(begin: turnLines[turnLines.count - 1].end, end: location)
                    turnLines.append(newLine)
                    
                    // the distance between the endpoints of a drawn line
                    let delta = distanceBetween(from: turnLines[0].begin, to: turnLines[turnLines.count - 1].end)
                    
                    if ((game.turn == gameVar.o || game.turn == gameVar.e) && usrMove == 1 && delta < 20) {
                        let turnRect = getTurnRect(lines: turnLines)
                        
                        if (turnRect.1 < 20) { // check if the rect is a square
                            let rectLocation = checkLocation(rect: turnRect.0)
                            if (rectLocation.0) { // check if the move is in a valid space
                                if (!game.isOccupied(row: rectLocation.1, col: rectLocation.2)) {
                                    finishedLines.append(contentsOf:turnLines)
                                    game.addMove(row: rectLocation.1, col: rectLocation.2, type: gameVar.o)
                                }
                                turnLines = []
                                usrMove = 0
                            }
                        }
                        turnLines = []
                        usrMove = 0
                    } else if ((game.turn == gameVar.x || game.turn == gameVar.e) && usrMove < 3 && delta > 20) {
                        if (usrMove == 2) { // second line of the X
                            let turnRect = getTurnRect(lines: turnLines)
                            
                            if (turnRect.1 < 20) { // check if the rect is a square
                                let rectLocation = checkLocation(rect: turnRect.0)
                                if (rectLocation.0) { // check if move is in a valid area
                                    for line in turnLines {
                                        if (distanceBetween(from: turnRect.2, to: line.begin) < 5) { // to know the difference of O and X
                                            if (!game.isOccupied(row: rectLocation.1, col: rectLocation.2)) {
                                                finishedLines.append(contentsOf:turnLines)
                                                game.addMove(row: rectLocation.1, col: rectLocation.2, type: gameVar.x)
                                            }
                                            break
                                        }
                                    }
                                }
                            }
                            turnLines = []
                            usrMove = 0
                        }
                    } else {
                        turnLines = []
                        usrMove = 0
                    }
                    
                    if (usrMove == 0) {
                        turnLines = []
                        print(game)
                        let gameResults = game.isGameOver()
                        if (gameResults.0) {
                            gameOver(start: gameResults.2, end: gameResults.3, winner: gameResults.1)
                        }
                    }
                } else {
                    boardLines[key]?.end = location
                    finishedLines.append(boardLines[key]!)
                    boardLines[key] = nil
                    checkBoard()
                }
            }
            setNeedsDisplay()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print(#function)
    }
    
    func checkLocation(rect: CGRect) -> (Bool, Int, Int) {
      
        let r0c0 = CGRect(x: 0, y: 0, width: boardCoordinates[0].x, height: boardCoordinates[0].y)
        let r0c1 = CGRect(x: boardCoordinates[0].x, y: 0, width: boardCoordinates[1].x - boardCoordinates[0].x, height: boardCoordinates[1].x)
        let r0c2 = CGRect(x: boardCoordinates[1].x, y: 0, width: superview!.frame.size.width - boardCoordinates[1].x, height: boardCoordinates[1].y)
        let r1c0 = CGRect(x: 0, y: boardCoordinates[0].y, width: (boardCoordinates[0].x + boardCoordinates[2].x)/2, height: boardCoordinates[2].y - boardCoordinates[0].y)
        let r1c1 = CGRect(x: boardCoordinates[0].x, y: boardCoordinates[0].y, width: boardCoordinates[1].x - boardCoordinates[0].x, height: boardCoordinates[3].y - boardCoordinates[1].y)
        let r1c2 = CGRect(x: boardCoordinates[1].x, y: boardCoordinates[1].y, width: superview!.frame.size.width - boardCoordinates[1].x, height: boardCoordinates[3].y - boardCoordinates[1].y)
        let r2c0 = CGRect(x: 0, y: boardCoordinates[2].y, width: boardCoordinates[2].x, height: superview!.frame.size.height - boardCoordinates[2].y)
        let r2c1 = CGRect(x: boardCoordinates[2].x, y: boardCoordinates[2].y, width: boardCoordinates[3].x - boardCoordinates[2].x, height: superview!.frame.height - boardCoordinates[3].y)
        let r2c2 = CGRect(x: boardCoordinates[3].x, y: boardCoordinates[3].y, width: superview!.frame.size.width - boardCoordinates[3].x, height: superview!.frame.size.height - boardCoordinates[3].y)
        
        if (r0c0.contains(rect)) { return (true, 0, 0) }
        else if (r0c1.contains(rect)) { return (true, 0, 1) }
        else if (r0c2.contains(rect)) { return (true, 0, 2) }
        else if (r1c0.contains(rect)) { return (true, 1, 0) }
        else if (r1c1.contains(rect)) { return (true, 1, 1) }
        else if (r1c2.contains(rect)) { return (true, 1, 2) }
        else if (r2c0.contains(rect)) { return (true, 2, 0) }
        else if (r2c1.contains(rect)) { return (true, 2, 1) }
        else if (r2c2.contains(rect)) { return (true, 2, 2) }
        
        return (false, -1, -1)
    }
    
    func getTurnRect(lines: [Line]) -> (CGRect, CGFloat, CGPoint) {
        
        var min_x: CGFloat = lines[0].begin.x
        var max_x: CGFloat = lines[0].begin.x
        var min_y: CGFloat = lines[0].begin.y
        var max_y: CGFloat = lines[0].begin.y
        
        for line in lines {
            if (line.begin.x < min_x) { min_x = line.begin.x }
            else if (line.begin.x > max_x) { max_x = line.begin.x }
            else if (line.begin.y < min_y) { min_y = line.begin.y }
            else if (line.begin.y > max_y) { max_y = line.begin.y }
        }
        
        let rect: CGRect = CGRect(x: min_x, y: min_y, width: max_x - min_x, height: max_y - min_y)
        let center: CGPoint = getCenter(rect: rect)
        return (rect, abs(rect.width - rect.height), center)
    }
    
    func getCenter(rect: CGRect) -> CGPoint {
        
        let center: CGPoint = CGPoint(x: rect.origin.x + (rect.width)/2, y: rect.origin.y + (rect.height)/2)
        return center
    }
    
    func resetGame() {
        // Reset the settings for the game
        
        game.resetGame()
        boardCoordinates = []
        boardLines = [NSValue:Line]()
        turnLines = []
        finishedLines = []
        usrMove = 0
        boardDrawn = false
        let tapRecognizer = self.gestureRecognizers![1]
        tapRecognizer.delaysTouchesBegan = true
        setNeedsDisplay() // this view needs to be updated
    }
    
    func checkCoordinates() {
        boardCoordinates.sort(by:{ $0.y < $1.y })
        var top: [CGPoint] = [boardCoordinates[0], boardCoordinates[1]]
        var bot: [CGPoint] = [boardCoordinates[2], boardCoordinates[3]]
        top.sort(by:{ $0.x < $1.x })
        bot.sort(by:{ $0.x < $1.x })
        boardCoordinates = [top[0], top[1], bot[0], bot[1]]
    }
    
    func checkBoard() {
        if (finishedLines.count == 4) {
            var numOfInter: Int = 0 // needs to be 4 lines
            for line in finishedLines {
                for otherLine in finishedLines {
                    if (line.begin != otherLine.begin && line.end != otherLine.end) {
                        let doesIntersect = line.intersection(someLine: otherLine) //check for intersection
                        if (doesIntersect.0) {
                            numOfInter += 1
                            boardCoordinates.append(doesIntersect.1!)
                        }
                    }
                }
            }
            if (numOfInter == 4) {
                checkCoordinates()
                boardDrawn = true
                let tapRecognizer = self.gestureRecognizers![1]
                tapRecognizer.delaysTouchesBegan = false
                print(game)
               // viewController.updateUIP1();
            } else {
                viewController.invalidBoardPopup()
                numOfInter = 0
                resetGame()
            }
        }
    }
    
    func gameOver(start: Int, end: Int, winner: String) {
       if (winner == gameVar.e) {
        viewController.gameOverPopup(winner: winner)
        } else {
        let r0c0 = CGRect(x: 0, y: 0, width: boardCoordinates[0].x, height: boardCoordinates[0].y)
        let r0c1 = CGRect(x: boardCoordinates[0].x, y: 0, width: boardCoordinates[1].x - boardCoordinates[0].x, height: boardCoordinates[1].x)
        let r0c2 = CGRect(x: boardCoordinates[1].x, y: 0, width: superview!.frame.size.width - boardCoordinates[1].x, height: boardCoordinates[1].y)
        let r1c0 = CGRect(x: 0, y: boardCoordinates[0].y, width: (boardCoordinates[0].x + boardCoordinates[2].x)/2, height: boardCoordinates[2].y - boardCoordinates[0].y)
        let r1c1 = CGRect(x: boardCoordinates[0].x, y: boardCoordinates[0].y, width: boardCoordinates[1].x - boardCoordinates[0].x, height: boardCoordinates[3].y - boardCoordinates[1].y)
        let r1c2 = CGRect(x: boardCoordinates[1].x, y: boardCoordinates[1].y, width: superview!.frame.size.width - boardCoordinates[1].x, height: boardCoordinates[3].y - boardCoordinates[1].y)
        let r2c0 = CGRect(x: 0, y: boardCoordinates[2].y, width: boardCoordinates[2].x, height: superview!.frame.size.height - boardCoordinates[2].y)
        let r2c1 = CGRect(x: boardCoordinates[2].x, y: boardCoordinates[2].y, width: boardCoordinates[3].x - boardCoordinates[2].x, height: superview!.frame.height - boardCoordinates[3].y)
        let r2c2 = CGRect(x: boardCoordinates[3].x, y: boardCoordinates[3].y, width: superview!.frame.size.width - boardCoordinates[3].x, height: superview!.frame.size.height - boardCoordinates[3].y)
            
            let boardSpots = [r0c0, r0c1, r0c2, r1c0, r1c1, r1c2, r2c0, r2c1, r2c2]
            
        let startSpot = getCenter(rect: boardSpots[start])
        let endSpot = getCenter(rect: boardSpots[end])
            
            let winnerLine = Line(begin: startSpot, end: endSpot)
            
            finishedLines.append(winnerLine)
        viewController.gameOverPopup(winner: winner)
        
    }
    
}

}
