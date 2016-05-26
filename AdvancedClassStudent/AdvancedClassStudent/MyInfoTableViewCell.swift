//
//  MyInfoTableViewCell.swift
//  AdvancedClassStudent
//
//  Created by Harold on 16/5/24.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

protocol MyInfoTableViewCellDelegate {
    func avatarClicked()
}

class MyInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!    
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    var delegate: MyInfoTableViewCell?
    var avatar: UIImage?{
        get{
            return self.avatarImageView.image
        }
        set{
            self.avatarImageView.image = newValue
        }
    }
    
    var name: String{
        get{
            return self.nameLabel.text ?? ""
        }
        set{
            self.nameLabel.text = newValue
        }
    }
    
    var detailText: String{
        get{
            return self.detailLabel.text ?? ""
        }
        set{
            self.detailLabel.text = newValue
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2
        self.avatarImageView.clipsToBounds = true;
        self.avatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.avatarClicked)))
    }
    
    func avatarClicked(){
        self.delegate?.avatarClicked()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
