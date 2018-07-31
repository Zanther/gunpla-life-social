//
//  FeedVC.swift
//  Gunpla Life
//
//  Created by Steven Lattenhauer 2nd on 7/27/18.
//  Copyright © 2018 Steven Lattenhauer 2nd. All rights reserved.
//

import UIKit
import Firebase

let cellIdentifier = "PostCell"

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var addPostBtn: UIButton!
    
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var submitPostBtn: UIButton!
    @IBOutlet weak var feedTableView: UITableView!
    @IBOutlet weak var submitPostView: CustomView!
    @IBOutlet weak var headerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        feedTableView.delegate = self
        feedTableView.dataSource = self
        
        let contentInset = self.headerView.frame.size.height-25
        feedTableView.contentInset = UIEdgeInsetsMake(contentInset, 0, 0, 0)
        
    }
    
    @IBAction func addPostBtnTapped(_ sender: Any) {
        
        print("I want to add a New Post!")
        
        if submitPostView.isHidden == true {
            
            submitPostView.isHidden = false
            
        } else {
            
            submitPostView.isHidden = true

        }
    }
    
    @IBAction func submitPostBtnTapped(_ sender: Any) {
        
        print("New Post Added!")
        submitPostView.isHidden = true
        
    }
    
    
//    if let image = UIImage(named:"Unchecked") {
//        sender.setImage(UIImage(named:"Checked.png"), forControlState: .Normal)
//    }
//    if let image = UIImage(named:"Checked") {
//        sender.setImage( UIImage(named:"Unchecked.png"), forControlState: .Normal)
//    }
    
    @IBAction func signoutBtnTapped(_ sender: Any) {
        
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        if removeSuccessful {
            print("Successfully Signed out")
            try! Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        } else {
            print("Sign out Unsuccessful")
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 42
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PostCell {
            
            cell.contentView.alpha = 0
            
            return cell
        } else {
            return UITableViewCell()
        }
        
//        return tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! PostCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.4) {
            cell.contentView.alpha = 1
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 420
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
