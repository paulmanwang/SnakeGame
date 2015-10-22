//
//  Food.swift
//  SnakeGame
//
//  Created by wanglichun on 15/10/22.
//  Copyright © 2015年 thunder. All rights reserved.
//

import UIKit

enum FoodCategory
{
    case Humburg
    case Fruit
}

class Food: NSObject {
    var position: CGPoint?
    
    init(position: CGPoint)
    {
        self.position = position
    }
}