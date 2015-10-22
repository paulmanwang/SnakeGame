//
//  MainBoard.swift
//  SnakeGame
//
//  Created by wanglichun on 15/10/22.
//  Copyright © 2015年 thunder. All rights reserved.
//

import UIKit

class MainBoard: NSObject {
    var width: CGFloat = 0
    var height: CGFloat = 0
    var gameBoard: UIView?
    var snake: Snake?
    var timer: NSTimer?
    
    // MARK: - Init
    
    init(parent: UIView, width: CGFloat, height: CGFloat)
    {
        self.width = width
        self.height = height
        
        self.gameBoard = parent
        self.snake = Snake(parentView: self.gameBoard!, length: 5, direction: Direction.Right, originPoint: CGPointMake(0, 0))
    }
    
    // MARK: - Public APIs
    
    func startGame()
    {
        self.addSwapGestures()
        self.startTimer()
    }
    
    // MARK: - GestureRecognizer
    
    func addSwapGestures()
    {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "handleSwapGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.gameBoard!.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "handleSwapGesture:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.gameBoard!.addGestureRecognizer(swipeLeft)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: "handleSwapGesture:")
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        self.gameBoard!.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: "handleSwapGesture:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.gameBoard!.addGestureRecognizer(swipeDown)
    }
    
    func handleSwapGesture(gestureRecongizer:UIGestureRecognizer)
    {
        if let swipeGesture = gestureRecongizer as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Left:
                print("向左")
                self.snake?.changeDirection(Direction.Left)
                
            case UISwipeGestureRecognizerDirection.Right:
                print("向右")
                self.snake?.changeDirection(Direction.Right)
                
            case UISwipeGestureRecognizerDirection.Up:
                print("向上")
                self.snake?.changeDirection(Direction.Up)
                
            case UISwipeGestureRecognizerDirection.Down:
                print("向下")
                self.snake?.changeDirection(Direction.Down)
                
            default:
                break
            }
        }
    }

    // MARK: - NSTimer
    
    func startTimer()
    {
        if self.timer == nil {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "timeout:", userInfo: nil, repeats: true)
        }
    }
    
    func stopTimer()
    {
        if self.timer != nil {
            self.timer!.invalidate()
            self.timer = nil
        }
    }
    
    func timeout(timer:NSTimer)
    {
        self.snake!.move()
    }
}
