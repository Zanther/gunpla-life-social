//
//  DataService.swift
//  Gunpla Life
//
//  Created by Steven Lattenhauer 2nd on 7/31/18.
//  Copyright © 2018 Steven Lattenhauer 2nd. All rights reserved.
//

import Foundation
import Firebase

let DATABASE_URL = Database.database().reference()
let STORAGE_URL = Storage.storage().reference()

class DataService {
    
    static let dataService = DataService()
    
    //Database References
    private var _REF_BASE = DATABASE_URL
    private var _REF_POSTS = DATABASE_URL.child("posts")
    private var _REF_USERS = DATABASE_URL.child("users")
    
    //Storage References
    private var _REF_SUBMITTED_IMG = STORAGE_URL.child("submitted-images")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: DatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_SUBMITTED_IMG: StorageReference {
        return _REF_SUBMITTED_IMG
    }
    
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func updateLikes(post: Post) {
        
        
    }
    
    
    
    func createEmailUser(login_method: String, account_created: NSDate, email: String) -> Dictionary<String, Any>
    {
        
        let userData = ["login-method": login_method,
                        "account-created":"\(account_created)",
            "last-login":"\(account_created)",
            "email":email] as [String : Any]
        
        return userData
    }
    
    func createSocialUser(login_method: String, last_login: NSDate, name: String, email: String) -> Dictionary<String, Any>
    {
        
        let userData = ["login-method": login_method,
            "last-login":"\(last_login)",
            "name":name,
            "email":email] as [String : Any]
        
        return userData
    }
    
    
    
//    func updateUser(login_method: String, last_login: NSDate, likes: Int, profileImageUrl: String) -> Dictionary<String, Any>
//    {
//        let userData = ["login-method": login_method,
//            "last-login":"\(last_login)",
//            "likes":likes,
//            "profileImageUrl":profileImageUrl] as [String : Any]
//
//        return userData
//    }
    
    
}
