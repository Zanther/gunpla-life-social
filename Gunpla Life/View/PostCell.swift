//
//  PostCell.swift
//  Gunpla Life
//
//  Created by Steven Lattenhauer 2nd on 7/30/18.
//  Copyright © 2018 Steven Lattenhauer 2nd. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var userImgView: CircleImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var mainImgViewPost: UIImageView!
    @IBOutlet weak var descTxtField: UITextView!
    @IBOutlet weak var likesCountLbl: UILabel!
    @IBOutlet weak var heartImgView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        
        // Initialization code
    }
    
    @IBAction func likeBtnTapped(_ sender: Any) {
        
        if heartImgView.image == UIImage(named: "grey_heart") {
            print("I like this Content")
            heartImgView.image = UIImage(named: "full_heart")
        } else {
            print("I dislike this Content")
            heartImgView.image = UIImage(named: "grey_heart")
        }
        
    }

}
