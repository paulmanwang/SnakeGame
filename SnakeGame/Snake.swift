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
    var length:Int = 0
    var snakeBlobs:NSMutableArray
    var direction:Direction = Direction.Right
    
    // MARK - Init
    init(parentView:UIView, length: Int, direction:Direction, originPoint:CGPoint)
    {
        self.snakeBlobs = NSMutableArray()
        self.length = length
        for var index = 0; index < length; ++index {
            let snakeBlob = UIButton(frame: CGRectMake(CGFloat(30 * index), 0, 30, 30))
            snakeBlob.backgroundColor = UIColor.redColor()
            snakeBlob.layer.borderWidth = 1
            parentView.addSubview(snakeBlob)
            
            self.snakeBlobs.addObject(snakeBlob)
        }
    }
    
    // MARK - eat
    func eat()
    {
        self.length++;
    }
    
    // MARK - Direction
    func changeDirection(newDirection: Direction)
    {
        self.direction = newDirection
    }
    
    // MARK - Move
    func move()
    {
        switch direction
        {
        case .Left:
            self.moveLeft()
        case .Right:
            self.moveRight()
        case .Up:
            self.moveUp()
        case .Down:
            self.moveDown()
        }
    }
    
    func moveRight()
    {
        for var index: Int = 0; index < self.length; ++index {
            let snakeBlob = self.snakeBlobs[index] as? UIButton
            let originRect = snakeBlob?.frame
            snakeBlob?.frame = CGRectMake((originRect?.origin.x)! + 30.0, (originRect?.origin.y)!, (originRect?.size.width)!, (originRect?.size.height)!)
        }
    }
    
    func moveLeft()
    {
        for var index: Int = 0; index < self.length; ++index {
            let snakeBlob = self.snakeBlobs[index] as? UIButton
            let originRect = snakeBlob?.frame
            snakeBlob?.frame = CGRectMake((originRect?.origin.x)! - 30.0, (originRect?.origin.y)!, (originRect?.size.width)!, (originRect?.size.height)!)
        }
    }
    
    func moveUp()
    {
        for var index: Int = 0; index < self.length; ++index {
            let snakeBlob = self.snakeBlobs[index] as? UIButton
            let originRect = snakeBlob?.frame
            snakeBlob?.frame = CGRectMake((originRect?.origin.x)! + 30.0, (originRect?.origin.y)!, (originRect?.size.width)!, (originRect?.size.height)!)
        }
    }
    
    func moveDown()
    {
        for var index: Int = 0; index < self.length; ++index {
            let snakeBlob = self.snakeBlobs[index] as? UIButton
            let originRect = snakeBlob?.frame
            snakeBlob?.frame = CGRectMake((originRect?.origin.x)! + 30.0, (originRect?.origin.y)!, (originRect?.size.width)!, (originRect?.size.height)!)
        }
    }
}
