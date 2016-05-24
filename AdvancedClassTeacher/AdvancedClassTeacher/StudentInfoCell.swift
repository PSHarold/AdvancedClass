//
//  StudentInfoCell.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 16/3/26.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class StudentInfoCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.detailText = ""
    }
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var studentIdLabel: UILabel!
    
    var className: String = ""{
        didSet{
            self.classLabel?.text = className
        }
    }
    
    var studentName: String = ""{
        didSet{
            self.nameLabel?.text = studentName
        }
    }
    
    var studentId: String = ""{
        didSet{
            self.studentIdLabel?.text = studentId
        }
    }
    
    var detailText: String = ""{
        didSet{
            if detailText == ""{
                self.detailLabel?.hidden = true
            }
            else{
                self.detailLabel?.text = detailText
                self.detailLabel?.hidden = false
            }
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
