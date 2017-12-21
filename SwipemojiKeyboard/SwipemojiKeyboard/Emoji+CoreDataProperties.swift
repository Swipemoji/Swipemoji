//
//  Emoji+CoreDataProperties.swift
//  SwipemojiKeyboard
//
//  Created by Shakeeb Majid on 12/20/17.
//  Copyright © 2017 swipemoji. All rights reserved.
//
//

import Foundation
import CoreData


extension Emoji {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Emoji> {
        return NSFetchRequest<Emoji>(entityName: "Emoji")
    }

    @NSManaged public var emoji: String?

}
