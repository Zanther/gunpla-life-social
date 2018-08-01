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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var addPostBtn: UIButton!
    
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var submitPostBtn: UIButton!
    @IBOutlet weak var feedTableView: UITableView!
    @IBOutlet weak var submitPostView: CustomView!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var blackBG: UIView!
    @IBOutlet weak var submitThisImage: RoundedCornerImgView!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedTableView.delegate = self
        feedTableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        //Hide the Feed TableView So it doesn't show a blank tableview
        feedTableView.alpha = 0
        self.submitPostView.alpha = 0
        
        let contentInset = self.headerView.frame.size.height-25
        feedTableView.contentInset = UIEdgeInsetsMake(contentInset, 0, 0, 0)
        
        // Create activity Indicator while tableview data loading
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        
        // Add it to the view where you want it to appear
        view.addSubview(activityIndicator)
        // Set up its size (the super view bounds usually)
        activityIndicator.frame = view.bounds
        // Start the loading animation
        activityIndicator.startAnimating()
        // To remove it, just call removeFromSuperview()
        
        
        DataService.dataService.REF_POSTS.observe(.value, with: { (snapshot) in
            self.posts = []
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                
                for snap in snapshot {
                    //                    print("Post:", "\(snap)")
                    if let postDict = snap.value as? Dictionary<String, Any> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
//                    print(self.posts[0].imageUrl)
                }
            }
            if self.posts.count > 0 {
                
                UIView.animate(withDuration: 0.4) {
                    self.feedTableView.alpha = 1
                }
                
            } else {
                
                self.showAlert(title: "No Posts Found!", message: "We could not find any posts, please check your internet connection")
            }
            
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            self.feedTableView.reloadData()
        })
        
    }
    
    @IBAction func addPostBtnTapped(_ sender: Any) {
        
        print("I want to add a New Post!")
        
        present(imagePicker, animated: true, completion:nil)
        
    }
    
    @IBAction func submitPostBtnTapped(_ sender: Any) {
        
        print("New Post Added!")
        
        guard let caption = captionTextField.text, caption != "" else {
            print("Caption must be entered")
            self.showAlert(title: "Oh No!", message: "Please add a caption to your photo")
            return
        }
        guard let img = submitThisImage.image else {
            print("An image must be selected")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.42) {
            
            let imgUid = NSUUID().uuidString
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            DataService.dataService.REF_SUBMITTED_IMG.child(imgUid).putData(imgData, metadata: metaData) { (metaData, error) in
                
                if error != nil {
                    print("Unable to Upload Photo")
                    self.showAlert(title: "Oh No!", message: "Unable to Upload Your Photo!\n\nError:\n\(error.debugDescription)")
                } else {
                    
                    
                    DataService.dataService.REF_SUBMITTED_IMG.child(imgUid).downloadURL(completion: { (url, error) in
                        
                        if error != nil {
                            
                            print("Error:", error.debugDescription)
                            
                        } else {
                            print("Download URL:", url as Any)
                            if let imgUrl = url?.absoluteString {
                            self.postToFirebase(imgUrl:imgUrl)
                            }
                        }
                        
                    })
                    
                    UIView.animate(withDuration: 0.24, animations: {
                        self.blackBG.alpha = 0
                        self.submitPostView.alpha = 0
                    }, completion: { (Success) in
                        self.submitPostView.isHidden = true
                        self.blackBG.isHidden = true
                    })
                    
                }
                
            }
            
        }
        
        self.captionTextField.resignFirstResponder()
        
    }
    
    func postToFirebase(imgUrl: String) {
        
        let post : Dictionary<String, Any> = [
            "caption": captionTextField.text as Any,
            "imageUrl" : imgUrl as Any,
            "likes": 0 as Any
        ]
        
        let firebasePost = DataService.dataService.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        self.feedTableView.reloadData()
        self.captionTextField.text = ""
        
        print("Successful Post to Firebase", post, firebasePost)
    }
    
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
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PostCell {
            
            let post = posts[indexPath.row]
//            print("Cell Post: \(post.imageUrl)")
            
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                
                cell.configureCell(post: post, img: img)
                cell.contentView.alpha = 0
                
                return cell
            } else {
                // The method has the default value set for nil so no need to pass anythign to it.
                cell.configureCell(post: post)
                cell.contentView.alpha = 0
                
                return cell
            }
        } else {
            return PostCell()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        UIView.animate(withDuration: 0.2995, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
            cell.contentView.alpha = 1
        }, completion: nil)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 444
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            submitThisImage.image = image
        } else {
            print("No valid image was selected")
        }
        imagePicker.dismiss(animated: true) {
            if self.submitPostView.isHidden == true {
                UIView.animate(withDuration: 0.24) {
                    self.blackBG.isHidden = false
                    self.blackBG.alpha = 0.5
                    self.submitPostView.isHidden = false
                    self.submitPostView.alpha = 1
                }
            } else {
                UIView.animate(withDuration: 0.24, animations: {
                    self.submitPostView.alpha = 0
                    self.blackBG.alpha = 0
                }, completion: { (Success) in
                    self.submitPostView.isHidden = true
                    self.blackBG.isHidden = true
                    
                })
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title:title, message:message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }

}
