//
//  Post.swift
//  Gunpla Life
//
//  Created by Steven Lattenhauer 2nd on 7/31/18.
//  Copyright © 2018 Steven Lattenhauer 2nd. All rights reserved.
//

import Foundation


class Post {
    
    private var _name: String!
    private var _profileImgUrl: String!
    private var _imageUrl: String!
    private var _caption: String!
    private var _likes: Int!
    
    private var _postKey: String!
    
    var name: String {
        if _name == nil {
            _name = ""
        }
        return _name
    }
    
    var profileImgUrl: String {
        if _profileImgUrl == nil {
            _profileImgUrl = ""
        }
        return _profileImgUrl
    }
    
    var imageUrl: String {
        if _imageUrl == nil {
            _imageUrl = ""
        }
        return _imageUrl
    }
    
    var caption: String {
        if _caption == nil {
            _caption = ""
        }
        return _caption
    }
    
    var likes: Int {
        if _likes == nil {
            _likes = 0
        }
        return _likes
    }
    
    var postKey: String {
        if _postKey == nil {
            _postKey = ""
        }
        return _postKey
    }
    
    init(caption: String, postImageUrl: String, likes: Int) {
        
        self._caption = caption
        self._imageUrl = imageUrl
        self._likes = likes
        
    }
    
    init(postKey: String, postData: Dictionary<String, Any>) {
        
        self._postKey = postKey
        
        if let caption = postData["caption"] as? String {

            self._caption = caption
        }
        
        if let imageUrl = postData["imageUrl"] as? String {

            self._imageUrl = imageUrl
        }
        
        if let likes = postData["likes"] as? Int {
            
            self._likes = likes
        }
        
    }
    
}
