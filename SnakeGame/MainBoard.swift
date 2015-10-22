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
    
    var gameBoard: UIView?
    var snake: Snake?
    var timer: NSTimer?
    var food: Food?
    
    var score: Int = 0
    
    // MARK: - Init
    
    init(parent: UIView, width: CGFloat, height: CGFloat)
    {
        self.width = width
        self.height = height
        
        self.gameBoard = parent
        self.snake = Snake(parentView: self.gameBoard!, blobWidth:snakeBlobWidth, length: 5, defaultDirection: Direction.Right, originPoint: CGPointMake(0, 0))
    }
    
    // MARK: - Private APIs
    
    func isGameOver(position: CGPoint) -> Bool
    {
        let maxX: CGFloat = CGFloat(Int(self.width / self.snakeBlobWidth)) * CGFloat(20)
        let maxY: CGFloat = CGFloat(Int(self.height / self.snakeBlobWidth) - 1) * CGFloat(20)
        print("srceen height = \(maxY)")
        let x: CGFloat = position.x
        let y: CGFloat = position.y
        
        print("y = \(y)")
        if x < 0 || x > maxX || y < 0 || y > maxY {
            return true
        }
        
        return false
    }
    
    // MARK: - Public APIs
    
    func randomInRange(range: Range<Int>) -> Int {
        let count = UInt32(range.endIndex - range.startIndex)
        return  Int(arc4random_uniform(count)) + range.startIndex
    }
    
    func makeFood()
    {
        if food?.superview == nil {
            let maxX: Int = Int(self.width / self.snakeBlobWidth)
            let maxY: Int = Int(self.height / self.snakeBlobWidth)
            
            // 生成随机数
            let randomX = Int(arc4random()) % maxX
            let randomY = Int(arc4random()) % maxY
            
            let position: CGPoint = CGPointMake(CGFloat(randomX) * 20, CGFloat(randomY) * 20)
            
            // 食物不能落在蛇的身上
            var valide = true
            for var i = 0; i < self.snake?.snakeBlobs.count; i++ {
                let snakeBlob = self.snake?.snakeBlobs[i] as? UIButton
                if snakeBlob?.frame.origin == position {
                    valide = false
                }
            }
            
            if valide {
                self.food = Food(parentView: self.gameBoard!, position: position)
            } else {
                self.makeFood()
            }
        }
    }
    
    func startGame()
    {
        self.makeFood()
        self.addSwapGestures()
        self.startTimer()
    }
    
    func restartGame()
    {
        self.startTimer()
        self.snake?.resetSnake()
        self.food?.removeFromSuperview()
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
        let (isGameOver, currentPosition) = self.snake!.moveWithFood(self.food!)
        if isGameOver {
            stopTimer()
            let score: Int = (self.snake?.length())! - 5
            print("玩家得分 = \(score)")
            self.showAlertView()
        } else {
            let gameOver: Bool = self.isGameOver(currentPosition)
            if gameOver {
                stopTimer()
                let score: Int = (self.snake?.length())! - 5
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
        let alert: UIAlertView = UIAlertView()
        alert.delegate = self
        alert.title = "游戏结束"
        alert.message = "再试一次？"
        alert.addButtonWithTitle("取消")
        alert.addButtonWithTitle("确定")
        alert.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int)
    {
        switch buttonIndex {
        case 0:
            print("游戏结束")
            
        case 1:
            print("确定")
            self.restartGame()
            
        default:
            break
        }
    }
}
