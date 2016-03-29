//
//  Snake.swift
//  SnakeGame
//
//  Created by wanglichun on 15/10/20.
//  Copyright © 2015年 thunder. All rights reserved.
//

import UIKit

enum Direction
{
    case Left
    case Right
    case Up
    case Down
}

class Snake: NSObject {
    var snakeBlobs: NSMutableArray
    var direction: Direction = Direction.Right
    var parentView: UIView?
    var snakeColor: UIColor = UIColor.greenColor()
    var originPoint: CGPoint
    
    // MARK: - Init
    init(parentView: UIView, defaultDirection: Direction, originPoint: CGPoint, bodyColor: UIColor)
    {
        self.snakeColor = bodyColor
        self.snakeBlobs = NSMutableArray()
        self.parentView = parentView
        self.originPoint = originPoint
        for var index = 0; index < SnakeInitLength; ++index {
            let frame: CGRect = CGRectMake(originPoint.x + SnakeBlobSize * CGFloat(index), originPoint.y, SnakeBlobSize, SnakeBlobSize)
            let snakeBlob = UIButton(frame: frame)
            snakeBlob.backgroundColor = bodyColor
            snakeBlob.layer.borderWidth = 1
            snakeBlob.userInteractionEnabled = false
            parentView.addSubview(snakeBlob)
            
            self.snakeBlobs.addObject(snakeBlob)
        }
    }
    
    // MARK: - Private APIs
    func isOppositeDirection(direction1:Direction, direction2:Direction) -> Bool {
        if (direction1 == Direction.Left && direction2 == Direction.Right)
            || (direction1 == Direction.Right && direction2 == Direction.Left)
            || (direction1 == Direction.Up && direction2 == Direction.Down)
            || (direction1 == Direction.Down && direction2 == Direction.Up)
        {
            return true
        }
        
        return false
    }
    
    // MARK: Public APIs
    func resetSnake()
    {
        for snakeBlob in self.snakeBlobs {
            snakeBlob.removeFromSuperview()
        }
        self.snakeBlobs.removeAllObjects()
        
        self.direction = Direction.Right
        
        for var index = 0; index < 5; ++index {
            let frame:CGRect = CGRectMake(self.originPoint.x+SnakeBlobSize * CGFloat(index), self.originPoint.y, SnakeBlobSize, SnakeBlobSize)
            let snakeBlob = UIButton(frame: frame)
            snakeBlob.backgroundColor = self.snakeColor
            snakeBlob.layer.borderWidth = 1
            snakeBlob.userInteractionEnabled = false
            self.parentView!.addSubview(snakeBlob)
            
            self.snakeBlobs.addObject(snakeBlob)
        }
    }
    
    func changeDirection(newDirection: Direction)
    {
        if self.isOppositeDirection(self.direction, direction2: newDirection) { // 不能设置为相反方向
            return;
        }
        
        self.direction = newDirection
    }
    
    // 返回元组
    func moveWithFood(food:Food) -> (Bool, CGPoint)
    {
        // 记录蛇尾的位置
        let tailSnakeBlob = self.snakeBlobs.firstObject as? UIButton
        let tailRect: CGRect = (tailSnakeBlob?.frame)!
        
        // 移动蛇身
        for var i = 0; i < self.snakeBlobs.count - 1; i++ {
            let snakeBlob = self.snakeBlobs[i] as? UIButton
            let preSnakeBlob = self.snakeBlobs[i + 1] as? UIButton
            
            snakeBlob?.frame = (preSnakeBlob?.frame)!
        }
        
        // 移动蛇头
        let headSnakeBlob = self.snakeBlobs.lastObject as? UIButton
        let originRect: CGRect = headSnakeBlob!.frame
        switch self.direction {
            case .Left:
                headSnakeBlob!.frame = CGRectMake(originRect.origin.x - SnakeBlobSize, originRect.origin.y, originRect.size.width, originRect.size.height)
            case .Right:
                headSnakeBlob!.frame = CGRectMake(originRect.origin.x + SnakeBlobSize, originRect.origin.y, originRect.size.width, originRect.size.height)
            case .Up:
                headSnakeBlob!.frame = CGRectMake(originRect.origin.x, originRect.origin.y - SnakeBlobSize, originRect.size.width, originRect.size.height)
            case .Down:
                headSnakeBlob!.frame = CGRectMake(originRect.origin.x , originRect.origin.y + SnakeBlobSize, originRect.size.width, originRect.size.height)
        }
        
        // 蛇头位置与食物重合时，说明吃食成功。吃到食物后，蛇尾增加长度1
        if headSnakeBlob!.frame.origin == food.frame.origin {
            food.removeFromSuperview()
            
            let snakeBlob = UIButton(frame: tailRect)
            snakeBlob.backgroundColor = self.snakeColor
            snakeBlob.layer.borderWidth = 1
            snakeBlob.userInteractionEnabled = false
            self.parentView!.addSubview(snakeBlob)
            self.snakeBlobs.insertObject(snakeBlob, atIndex: 0)
        }
        
        // 如果蛇吃到了自己，则游戏结束
        var isGameOver = false
        for var i = 0; i < self.snakeBlobs.count - 1; i++ {
            let snakeBlob = self.snakeBlobs[i] as? UIButton
            if headSnakeBlob?.frame.origin == snakeBlob?.frame.origin {
                isGameOver = true
            }
        }
        
        return (isGameOver, headSnakeBlob!.frame.origin)
    }
    
    func length() -> Int {
        return self.snakeBlobs.count
    }
}
