//
//  MainBoard.swift
//  SnakeGame
//
//  Created by wanglichun on 15/10/22.
//  Copyright © 2015年 thunder. All rights reserved.
//

import UIKit

enum GameState {
    case GameIsReady
    case GameIsPlaying
    case GameIsPaused
}

protocol GameBoardDelegate: class
{
    func gameScoreChanged(score: Int)
    func gameOver()
}

class GameBoard: UIView {
    weak var delegate: GameBoardDelegate?
    let snakeBlobWidth: CGFloat = 20
    
    var snake: Snake?
    var timer: NSTimer?
    var food: Food?
    var gameState: GameState = .GameIsReady
    var lastScore: Int = 0
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func drawSankeAndFood() {
        self.snake = Snake(parentView: self, blobWidth:snakeBlobWidth, length: 5, defaultDirection: Direction.Right, originPoint: CGPointMake(0, 0))
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
        let maxX: CGFloat = CGFloat(Int(width / self.snakeBlobWidth)) * CGFloat(20)
        let maxY: CGFloat = CGFloat(Int(height / self.snakeBlobWidth) - 1) * CGFloat(20)
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
            let maxX: Int = Int(width / self.snakeBlobWidth)
            let maxY: Int = Int(height / self.snakeBlobWidth)
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
                self.food = Food(parentView: self, position: position)
            } else {
                self.makeFood()
            }
        }
    }
    
    // MARK: - Public APIs
    func startGame() {
        self.gameState = .GameIsPlaying
        self.makeFood()
        self.addSwapGestures()
        self.startTimer()
    }
    
    func pauseGame() {
        self.gameState = .GameIsPaused
        self.stopTimer()
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
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "onTimer:", userInfo: nil, repeats: true)
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
        let score: Int = ((self.snake?.length())! - 5) * 10 // 吃到食物得10分
        if self.lastScore != score {
            if self.delegate != nil {
                self.delegate?.gameScoreChanged(score)
            }
        }
        self.lastScore = score
        
        if isGameOver {
            stopTimer()
            self.showAlertView()
        } else {
            let gameOver: Bool = self.isGameOver(currentPosition)
            if gameOver {
                stopTimer()
                self.showAlertView()
            } else {
                self.makeFood()
            }
        }
    }
    
    // MARK: - AlertView
    
    func showAlertView() {
        let alertView = UIAlertView(title: "温馨提示", message: "游戏结束！", delegate: self, cancelButtonTitle: "确定")
        alertView.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        self.gameState = .GameIsReady
        self.snake?.resetSnake()
        self.food?.removeFromSuperview()
        
        if self.delegate != nil {
            self.delegate?.gameOver()
        }
    }
}
