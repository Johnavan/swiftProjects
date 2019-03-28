//
//  TicTacToeGame.swift
//  TicTacToe
//
//  Created by Johnavan Thomas on 2019-03-26.
//  Copyright © 2019 Johnavan Thomas. All rights reserved.
//

import Foundation

class TicTacToeGame: CustomStringConvertible {
    var viewC: ViewController!
    var rwT: [String]
    var rwM: [String]
    var rwB: [String]
    var rows: [[String]]
    
    // Move locations are stored as follows (by index):
    // rwT:  0 | 1 | 2
    //       ---+---+---
    // rwM:  0 | 1 | 2
    //       ---+---+---
    // rwB:  0 | 1 | 2
    
    var turn: String
    var moves: Int
    var gameWon: Bool
    
    var description: String {
        var toReturn: String = ""
        toReturn += " \(self.rwT[0]) | \(self.rwT[1]) | \(self.rwT[2])\n"
        toReturn += "---+---+---\n"
        toReturn += " \(self.rwM[0]) | \(self.rwM[1]) | \(self.rwM[2])\n"
        toReturn += "---+---+---\n"
        toReturn += " \(self.rwB[0]) | \(self.rwB[1]) | \(self.rwB[2])\n"
        return toReturn
    }
    
    init() {
        rwT = [gameVar.e, gameVar.e, gameVar.e]
        rwM = [gameVar.e, gameVar.e, gameVar.e]
        rwB = [gameVar.e, gameVar.e, gameVar.e]
        rows = [rwT, rwM, rwB]
        
        turn = gameVar.e
        moves = 0
        gameWon = false
    }
    
    func isGameOver() -> (Bool, String, Int, Int) {
        // logic to check if game is over
        // returns:
        //   * Bool: true or false if the game is over
        //   * String: the winner's symbol if applicable
        //   * Int: the start position of the win line
        //   * Int: the end position of the win line
        
        gameWon = true
        // across rows
        if (rwT[0] == gameVar.x && rwT[1] == gameVar.x && rwT[2] == gameVar.x) { return (true, gameVar.x, 0, 2) }
        else if (rwM[0] == gameVar.x && rwM[1] == gameVar.x && rwM[2] == gameVar.x) { return (true, gameVar.x, 3, 5) }
        else if (rwB[0] == gameVar.x && rwB[1] == gameVar.x && rwB[2] == gameVar.x) { return (true, gameVar.x, 6, 8) }
        else if (rwT[0] == gameVar.o && rwT[1] == gameVar.o && rwT[2] == gameVar.o) { return (true, gameVar.o, 0, 2) }
        else if (rwM[0] == gameVar.o && rwM[1] == gameVar.o && rwM[2] == gameVar.o) { return (true, gameVar.o, 3, 5) }
        else if (rwB[0] == gameVar.o && rwB[1] == gameVar.o && rwB[2] == gameVar.o) { return (true, gameVar.o, 6, 8) }
            
            // across columns
        else if (rwT[0] == gameVar.x && rwM[0] == gameVar.x && rwB[0] == gameVar.x) { return (true, gameVar.x, 0, 6) }
        else if (rwT[1] == gameVar.x && rwM[1] == gameVar.x && rwB[1] == gameVar.x) { return (true, gameVar.x, 1, 7) }
        else if (rwT[2] == gameVar.x && rwM[2] == gameVar.x && rwB[2] == gameVar.x) { return (true, gameVar.x, 2, 8) }
        else if (rwT[0] == gameVar.o && rwM[0] == gameVar.o && rwB[0] == gameVar.o) { return (true, gameVar.o, 0, 6) }
        else if (rwT[1] == gameVar.o && rwM[1] == gameVar.o && rwB[1] == gameVar.o) { return (true, gameVar.o, 1, 7) }
        else if (rwT[2] == gameVar.o && rwM[2] == gameVar.o && rwB[2] == gameVar.o) { return (true, gameVar.o, 2, 8) }
            
            // across diagonals
        else if (rwT[0] == gameVar.x && rwM[1] == gameVar.x && rwB[2] == gameVar.x) { return (true, gameVar.x, 0, 8) }
        else if (rwT[2] == gameVar.x && rwM[1] == gameVar.x && rwB[0] == gameVar.x) { return (true, gameVar.x, 2, 6) }
        else if (rwT[0] == gameVar.o && rwM[1] == gameVar.o && rwB[2] == gameVar.o) { return (true, gameVar.o, 0, 8) }
        else if (rwT[2] == gameVar.o && rwM[1] == gameVar.o && rwB[0] == gameVar.o) { return (true, gameVar.o, 2, 6) }
            
            // draw
        else if (moves == 9) { return (true, gameVar.e, -1, -1) }
        
        gameWon = false
        return (false, gameVar.e, -1, -1)
    }
    
    func resetGame() {
        self.rwT = [gameVar.e, gameVar.e, gameVar.e]
        self.rwM = [gameVar.e, gameVar.e, gameVar.e]
        self.rwB = [gameVar.e, gameVar.e, gameVar.e]
        self.rows = [rwT, rwM, rwB]
        
        turn = gameVar.e
        moves = 0
        gameWon = false
    }
    
    func isOccupied(row: Int, col: Int) -> Bool {
        if (row == 0) {
            if (self.rwT[col] == gameVar.e) { return false }
        } else if (row == 1) {
            if (self.rwM[col] == gameVar.e) { return false }
        } else if (row == 2) {
            if (self.rwB[col] == gameVar.e) { return false }
        }
        return true
    }
    
    func addMove(row: Int, col: Int, type: String) {
        if (type == gameVar.o && (self.turn == gameVar.o || self.turn == gameVar.e)) {
            self.turn = gameVar.x
            print("X turn") // UPDATE FUNC

        } else if (type == gameVar.x && (self.turn == gameVar.x || self.turn == gameVar.e)) {
            self.turn = gameVar.o
            print("O turn") // UPDATE FUNC
        }
        
        if (row == 0) {
            self.rwT[col] = type
        } else if (row == 1) {
            self.rwM[col] = type
        } else {
            self.rwB[col] = type
        }
        moves += 1
    }
}
