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

class LoginVC: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var googleLoginBtn: GIDSignInButton!
    @IBOutlet weak var fbLoginBtn: FBSDKLoginButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if FBSDKAccessToken.currentAccessTokenIsActive(){
            
            print("Already Logged In!")
            
        }
        
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    @IBAction func googleLoginBtnTapped(_ sender: Any) {
        
        GIDSignIn.sharedInstance().signIn()

    }
    
    @IBAction func fbLoginBtnTapped(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            if error != nil {
                print("Unable to Authenticate with Facebook - \(String(describing: error))")
            } else if result?.isCancelled == true {
                print("User Canceled Facebook Login")
            } else {
                print("Successfully Logged in")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
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
        Auth.auth().signInAndRetrieveData(with: credential) { (result, error) in
            if (error != nil) {
                print("Unable to sign in")
            } else {
                print("Sucessful Sign In With Firebase")
            }
        }
    }
}

