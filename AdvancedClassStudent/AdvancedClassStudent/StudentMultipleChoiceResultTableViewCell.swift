//
//  StudentMultipleChoiceResultTableViewCell.swift
//  AdvancedClassStudent
//
//  Created by Harold on 16/3/31.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class StudentMultipleChoiceResultTableViewCell: UITableViewCell {

    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var myImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var content: String!{
        didSet{
            self.contentLabel?.text = content
        }
    }
    
    var correct: Bool!{
        didSet{
            if correct!{
                self.myImageView.image = UIImage(named: "correct.png")
            }
            else{
                self.myImageView.image = UIImage(named: "incorrect.png")
            }
        }
    }
    
    var isMyChoice: Bool!{
        didSet{
            self.myLabel.hidden = !isMyChoice
        }
    }
    
    var choiceNumber: Int!{
        didSet{
            if let number = choiceNumber{
                var choice: String
                switch number{
                case 0:
                    choice = "A"
                case 1:
                    choice = "B"
                case 2:
                    choice = "C"
                case 3:
                    choice = "D"
                case 4:
                    choice = "E"
                case 5:
                    choice = "F"
                case 6:
                    choice = "G"
                default:
                    choice = ""
                }
                self.myImageView?.image = UIImage(named: choice)
            }
        }
    }


    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
