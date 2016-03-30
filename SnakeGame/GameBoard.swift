//
//  MainBoard.swift
//  SnakeGame
//
//  Created by wanglichun on 15/10/22.
//  Copyright © 2015年 thunder. All rights reserved.
//

import UIKit

protocol GameBoardDelegate: class
{
    func gameScoreChanged(score: Int)
    func gameOver()
}

class GameBoard: UIView {
    weak var delegate: GameBoardDelegate?
    
    var SnakeColor: UIColor = UIColor.redColor()
    var snake: Snake?
    var timer: NSTimer?
    var food: Food?
    var lastScore: Int = 0
    var offsetPoint: CGPoint?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func initGameBord() {
        // 设置背景颜色
        self.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.8)
        self.clipsToBounds = true
        
        // 画蛇
        let width = self.frame.size.width
        let height = self.frame.size.height
        let maxX: CGFloat = CGFloat(Int(width / SnakeBlobSize)) * SnakeBlobSize
        let maxY: CGFloat = CGFloat(Int(height / SnakeBlobSize)) * SnakeBlobSize
        
        let verWidth = (width - maxX) / 2.0
        let horiWidth = (height - maxY) / 2.0
        offsetPoint = CGPointMake(verWidth, horiWidth)
        
        self.snake = Snake(parentView: self, defaultDirection: Direction.Right, originPoint: offsetPoint!, bodyColor: SnakeColor)
        
        // 绘制边框
        let label1 = UILabel(frame:CGRectMake(0, 0, width, horiWidth))
        label1.backgroundColor = BorderColor
        let label2 = UILabel(frame: CGRectMake(0, 0, verWidth, height))
        label2.backgroundColor = BorderColor
        let label3 = UILabel(frame: CGRectMake(0, height - horiWidth, width, horiWidth))
        label3.backgroundColor = BorderColor
        let label4 = UILabel(frame: CGRectMake(width - verWidth, 0, verWidth + 1, height))
        label4.backgroundColor = BorderColor
        self.addSubview(label1)
        self.addSubview(label2)
        self.addSubview(label3)
        self.addSubview(label4)
        
        // 生成实物
        //makeFood()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private APIs
    
    func setSize(width wd: CGFloat, height ht: CGFloat) {
        let position = self.frame.origin
        self.frame = CGRectMake(position.x, position.y, wd, ht)
    }
    
    func isGameOver(position: CGPoint) -> Bool {
        let width = self.frame.size.width
        let height = self.frame.size.height
        let maxX: CGFloat = CGFloat(Int(width / SnakeBlobSize)) * SnakeBlobSize
        let maxY: CGFloat = CGFloat(Int(height / SnakeBlobSize)) * SnakeBlobSize
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
    
    func makeFood() {
        if food?.superview == nil {
            let width = self.frame.size.width
            let height = self.frame.size.height
            // 生成随机数
            let maxX: Int = Int(width / SnakeBlobSize)
            let maxY: Int = Int(height / SnakeBlobSize)
            let randomX = Int(arc4random()) % maxX
            let randomY = Int(arc4random()) % maxY
            
            let position: CGPoint = CGPointMake((offsetPoint?.x)! + CGFloat(randomX) * SnakeBlobSize, (offsetPoint?.y)!+CGFloat(randomY) * SnakeBlobSize)
            
            // 食物不能落在蛇的身上
            var valide = true
            for var i = 0; i < self.snake?.snakeBlobs.count; i++ {
                let snakeBlob = self.snake?.snakeBlobs[i] as? UIButton
                if snakeBlob?.frame.origin == position {
                    valide = false
                }
            }
            
            if valide {
                self.food = Food(parentView: self, position: position)
            } else {
                self.makeFood()
            }
        }
    }
    
    // MARK: - Public APIs
    func startGame() {
        makeFood()
        addSwapGestures()
        startTimer()
    }
    
    func pauseGame() {
        stopTimer()
    }
    
    // MARK: - GestureRecognizer
    
    func addSwapGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "handleSwapGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "handleSwapGesture:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.addGestureRecognizer(swipeLeft)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: "handleSwapGesture:")
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        self.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: "handleSwapGesture:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.addGestureRecognizer(swipeDown)
    }
    
    func handleSwapGesture(gestureRecongizer:UIGestureRecognizer) {
        if let swipeGesture = gestureRecongizer as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Left:
                self.snake?.changeDirection(Direction.Left)
                
            case UISwipeGestureRecognizerDirection.Right:
                self.snake?.changeDirection(Direction.Right)
                
            case UISwipeGestureRecognizerDirection.Up:
                self.snake?.changeDirection(Direction.Up)
                
            case UISwipeGestureRecognizerDirection.Down:
                self.snake?.changeDirection(Direction.Down)
                
            default:
                break
            }
        }
    }

    // MARK: - NSTimer
    
    func startTimer() {
        if self.timer == nil {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "onTimer:", userInfo: nil, repeats: true)
        }
    }
    
    func stopTimer() {
        if self.timer != nil {
            self.timer!.invalidate()
            self.timer = nil
        }
    }
    
    func onTimer(timer:NSTimer) {
        let (isGameOver, currentPosition) = (self.snake?.moveWithFood(self.food!))!
        let score: Int = ((self.snake?.length())! - SnakeInitLength) * 10 // 吃到食物得10分
        if self.lastScore != score {
            if self.delegate != nil {
                self.delegate?.gameScoreChanged(score - self.lastScore)
            }
        }
        self.lastScore = score
        
        if isGameOver {
            stopTimer()
            if self.delegate != nil {
                self.delegate?.gameOver()
            }
        } else {
            let gameOver: Bool = self.isGameOver(currentPosition)
            if gameOver {
                stopTimer()
                if self.delegate != nil {
                    self.delegate?.gameOver()
                }
            } else {
                self.makeFood()
            }
        }
    }
    
    func resetGame() {
        self.snake?.resetSnake()
        self.food?.removeFromSuperview()
    }
}
