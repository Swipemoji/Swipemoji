//
//  DictionaryEntryTableViewCell.swift
//  SwipemojiKeyboard
//
//  Created by Takashi Wickes on 3/21/17.
//  Copyright © 2017 swipemoji. All rights reserved.
//

import UIKit

class DictionaryEntryTableViewCell: UITableViewCell {

    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var gestureDefinitionView: UIView!
    var drawingCanvas:PointDisplayCanvas?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
