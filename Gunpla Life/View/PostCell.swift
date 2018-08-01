//
//  PostCell.swift
//  Gunpla Life
//
//  Created by Steven Lattenhauer 2nd on 7/30/18.
//  Copyright © 2018 Steven Lattenhauer 2nd. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

    @IBOutlet weak var userImgView: CircleImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postMainImgView: UIImageView!
    @IBOutlet weak var descTxtField: UITextView!
    @IBOutlet weak var likesCountLbl: UILabel!
    @IBOutlet weak var heartImgView: UIImageView!
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        
        // Initialization code
    }
    
    func configureCell(post: Post, img: UIImage? = nil) {
        
        self.post = post
        self.descTxtField.text = post.caption
        self.likesCountLbl.text = "\(post.likes)"
        
        if img != nil {
            self.postMainImgView.image = img
        } else {
            //download images and save images to cache
                let ref = Storage.storage().reference(forURL: post.imageUrl)
                ref.getData(maxSize: 2 * 1024 * 1024) { (data, error) in
    
                if error != nil {
                    print("Error: \(error.debugDescription)")
                } else {
                    print("Image Downloaded From Firebase Storage")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.postMainImgView.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            }
        }
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
