//
//  NewStatusAskTableViewCell.swift
//  Face
//
//  Created by Harold on 16/4/8.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class NewStatusAskTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var studentLabel: UILabel!
    @IBOutlet weak var courseNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var courseName: String?{
        didSet{
            self.courseNameLabel?.text = courseName ?? ""
        }
    }
    var timeString: String?{
        didSet{
            self.timeLabel?.text = timeString ?? ""
        }
    }
    
    var studentString: String?{
        didSet{
            self.studentLabel?.text = studentString ?? ""
        }
    }
    
}
