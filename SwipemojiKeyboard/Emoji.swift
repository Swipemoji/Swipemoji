//
//  Emoji.swift
//  SwipemojiKeyboard
//
//  Created by Shakeeb Majid on 12/20/17.
//  Copyright © 2017 swipemoji. All rights reserved.
//

import UIKit

class Emoji: NSObject {
    var emoji: String
    var pointCloud: PointCloud
    var lastUsed: NSDate?
    var useCount: Int?
    
    
    init(emoji: String, pointCloud: PointCloud) {
        self.emoji = emoji
        self.pointCloud = pointCloud
    }

}
