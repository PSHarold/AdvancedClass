//
//  StudentTestResultInfoTableViewCell.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 16/3/25.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class StudentTestResultInfoTableViewCell: UITableViewCell {

    @IBOutlet var studentIdLabel: UILabel!
    @IBOutlet var classLabel: UILabel!
    
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    
    var studentName: String!{
        didSet{
            self.nameLabel?.text = self.studentName
        }
    }
    
    var studentId: String!{
        didSet{
            self.studentIdLabel?.text = self.studentId
        }
    }
    var className: String!{
        didSet{
            self.classLabel?.text = self.className
        }
    }
    
    var score: String!{
        didSet{
            self.scoreLabel?.text = self.score
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
