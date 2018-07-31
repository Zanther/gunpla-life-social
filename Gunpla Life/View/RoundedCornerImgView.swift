//
//  RoundedCornerImgView.swift
//  Gunpla Life
//
//  Created by Steven Lattenhauer 2nd on 7/30/18.
//  Copyright © 2018 Steven Lattenhauer 2nd. All rights reserved.
//

import UIKit

class RoundedCornerImgView: UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 15.0
        self.clipsToBounds = true
    }
    
    
}
