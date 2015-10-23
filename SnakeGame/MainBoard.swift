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
    let snakeBlobWidth: CGFloat = 20
    
    var gameBoard: UIView
    var snake: Snake
    var timer: NSTimer?
    var food: Food?
    
    var isGamePlaying: Bool
    
    var score: Int = 0
    
    // MARK: - Init
    
    init(parent: UIView, width: CGFloat, height: CGFloat)
    {
        self.isGamePlaying = false
        
        self.width = width
        self.height = height
        
        self.gameBoard = parent
        self.snake = Snake(parentView: self.gameBoard, blobWidth:snakeBlobWidth, length: 5, defaultDirection: Direction.Right, originPoint: CGPointMake(0, 0))
    }
    
    // MARK: - Private APIs
    
    func setSize(width wd: CGFloat, height ht: CGFloat)
    {
        self.width = wd;
        self.height = ht;
    }
    
    func isGameOver(position: CGPoint) -> Bool
    {
        let maxX: CGFloat = CGFloat(Int(self.width / self.snakeBlobWidth)) * CGFloat(20)
        let maxY: CGFloat = CGFloat(Int(self.height / self.snakeBlobWidth) - 1) * CGFloat(20)
        let x: CGFloat = position.x
        let y: CGFloat = position.y
        
        if x < 0 || x > maxX || y < 0 || y > maxY {
            return true
        }
        
        return false
    }
    
    func randomInRange(range: Range<Int>) -> Int {
        let count = UInt32(range.endIndex - range.startIndex)
        return  Int(arc4random_uniform(count)) + range.startIndex
    }
    
    func makeFood()
    {
        if food?.superview == nil {
            // 生成随机数
            let maxX: Int = Int(self.width / self.snakeBlobWidth)
            let maxY: Int = Int(self.height / self.snakeBlobWidth)
            let randomX = Int(arc4random()) % maxX
            let randomY = Int(arc4random()) % maxY
            
            let position: CGPoint = CGPointMake(CGFloat(randomX) * 20, CGFloat(randomY) * 20)
            
            // 食物不能落在蛇的身上
            var valide = true
            for var i = 0; i < self.snake.snakeBlobs.count; i++ {
                let snakeBlob = self.snake.snakeBlobs[i] as? UIButton
                if snakeBlob?.frame.origin == position {
                    valide = false
                }
            }
            
            if valide {
                self.food = Food(parentView: self.gameBoard, position: position)
            } else {
                self.makeFood()
            }
        }
    }
    
    // MARK: - Public APIs
    
    func startGame()
    {
        self.isGamePlaying = true
        self.makeFood()
        self.addSwapGestures()
        self.startTimer()
    }
    
    // MARK: - GestureRecognizer
    
    func addSwapGestures()
    {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "handleSwapGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.gameBoard.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "handleSwapGesture:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.gameBoard.addGestureRecognizer(swipeLeft)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: "handleSwapGesture:")
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        self.gameBoard.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: "handleSwapGesture:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.gameBoard.addGestureRecognizer(swipeDown)
    }
    
    func handleSwapGesture(gestureRecongizer:UIGestureRecognizer)
    {
        if let swipeGesture = gestureRecongizer as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Left:
                self.snake.changeDirection(Direction.Left)
                
            case UISwipeGestureRecognizerDirection.Right:
                self.snake.changeDirection(Direction.Right)
                
            case UISwipeGestureRecognizerDirection.Up:
                self.snake.changeDirection(Direction.Up)
                
            case UISwipeGestureRecognizerDirection.Down:
                self.snake.changeDirection(Direction.Down)
                
            default:
                break
            }
        }
    }

    // MARK: - NSTimer
    
    func startTimer()
    {
        if self.timer == nil {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "timeout:", userInfo: nil, repeats: true)
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
        let (isGameOver, currentPosition) = self.snake.moveWithFood(self.food!)
        if isGameOver {
            stopTimer()
            let score: Int = self.snake.length() - 5
            print("玩家得分 = \(score)")
            self.showAlertView()
        } else {
            let gameOver: Bool = self.isGameOver(currentPosition)
            if gameOver {
                stopTimer()
                let score: Int = self.snake.length() - 5
                print("玩家得分 = \(score)")
                self.showAlertView()
            } else {
                self.makeFood()
            }
        }
    }
    
    // MARK: - AlertView
    
    func showAlertView()
    {
        let alertView = UIAlertView(title: "温馨提示", message: "游戏结束！", delegate: self, cancelButtonTitle: "确定")
        alertView.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int)
    {
        self.isGamePlaying = false
        self.snake.resetSnake()
        self.food?.removeFromSuperview()
    }
}
