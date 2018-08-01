//
//  ViewController.swift
//  Gunpla Life
//
//  Created by Steven Lattenhauer 2nd on 7/24/18.
//  Copyright © 2018 Steven Lattenhauer 2nd. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

class LoginVC: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    @IBOutlet weak var googleLoginBtn: GIDSignInButton!
    @IBOutlet weak var fbLoginBtn: FBSDKLoginButton!
    @IBOutlet weak var emailLoginBtn: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if FBSDKAccessToken.currentAccessTokenIsActive(){
            print("Already Logged In!")
        }
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            //user is signed in, perform segue and show feed
            print("User logged in already, sending to feed")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        } else {
            //user is signed out
            print("No user logged in")
        }
     }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func googleLoginBtnTapped(_ sender: Any) {
        
        GIDSignIn.sharedInstance().signIn()

    }
    
    
    
    @IBAction func fbLoginBtnTapped(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["public_profile"], from: self) { (result, error) in
            
            if error != nil {
                print("Unable to Authenticate with Facebook - \(String(describing: error))")
            } else if result?.isCancelled == true {
                print("User Canceled Facebook Login")
            } else {
                print("Successfully Logged into Facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    @IBAction func emailLoginBtnTapped(_ sender: Any) {
        
        if let email = emailTextField.text, let pwd = passwordTextField.text {
            
            Auth.auth().signIn(withEmail: email, password: pwd) { (user, error) in
                
                if error == nil {
                    print("Signed In Successfully with Email")
                    if let user = user {
                        let last_login = NSDate()
                        let userData = ["last-login":"\(last_login)"]
                        self.completeSignIn(id: user.user.uid, userData: userData)
                    }
                } else {
                    
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        
                        if error != nil {
                            print("Create User Failed. Unable to Authenticate in Firebase \nError: \(String(describing: error))")
                        } else {
                            print("Successfully Authenticated with Firebase")
                            if let user = user {
                                let userData = DataService.dataService.createEmailUser(login_method: user.user.providerID, account_created:NSDate(),
                                                                                  email:user.user.email!)
                                self.completeSignIn(id: user.user.uid, userData: userData)
                            }
                        }
                    })
                }
            }
        }
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print("Sign into Google Failed\nError: \(String(describing: error))")
            return
        } 
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        self.firebaseAuth(credential)
    }
    
    func firebaseAuth(_ credential: AuthCredential) {
        //        Auth.auth().signIn(with: credential) { (user, error) in
        Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
            if (error != nil) {
                print("Unable to sign in\nError: \(String(describing: error))")
            } else {
                print("Sucessful Sign In With Firebase:\nUser ID:\(String(describing: user?.user.uid))\nDisplay Name:\(String(describing:user?.user.displayName))\nEmail:\(String(describing: user?.user.email))\nPhoto Url:\(String(describing: user?.user.photoURL))")
                if let user = user {
                    if credential.provider == "google.com" {
                    let userData = DataService.dataService.createSocialUser(login_method:credential.provider, last_login:NSDate(), name: user.user.displayName!, email:user.user.email!)
                        self.completeSignIn(id: user.user.uid, userData: userData)
                    } else {
                        let userData = DataService.dataService.createSocialUser(login_method:credential.provider, last_login:NSDate(), name: user.user.displayName!, email:"")
                        self.completeSignIn(id: user.user.uid, userData: userData)
                    }
                }
            }
        }
    }
    func completeSignIn(id: String, userData: Dictionary<String, Any>) {
        
    DataService.dataService.createFirebaseDBUser(uid: id, userData: userData)

     let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("User Data Saved To Keychain: \(String(describing: keychainResult))")
        performSegue(withIdentifier: "goToFeed", sender: nil)
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}

