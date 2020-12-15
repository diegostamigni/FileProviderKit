//
//  GoogleDriveManager.swift
//  FileProviderKit
//
//  Created by Diego Stamigni
//  Copyright © 2020 Diego Stamigni. All rights reserved.
//

import Foundation
import GoogleSignIn
import AppAuth

public class GoogleSignInManager : LoginManager, GIDSignInDelegate {
    public static let shared : GoogleSignInManager = {
        let instance = GoogleSignInManager()
        GIDSignIn.sharedInstance().delegate = instance
        return instance
    }()
    
    public override var isLogged: Bool {
        GIDSignIn.sharedInstance()?.currentUser != nil
    }
    
    public var clientID: String? {
        set(value) {
            GIDSignIn.sharedInstance().clientID = value
        }
        get {
            return GIDSignIn.sharedInstance().clientID
        }
    }
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            delegate?.loginError(for: CloudProviderType.google, sender: self, error: error)
            return
        }
        // Perform any operations on signed in user here.
        let userId = user.userID
        print("userID: \(userId ?? "no userId")")
        print("\(user.profile.name ?? "")")
        
        finalizeLogin(for: user, error: error)
        
    }
    
    public func finalizeLogin(for user: GIDGoogleUser?, error: Error?) {
        if error != nil || user == nil {
            self.delegate?.loginError(for: .google,
                                      sender: self,
                                      error: error != nil
                                        ? error!
                                        : NSError(message: NSLocalizedString("User not available", comment: "")))
            
            return
        }
        
        if let auth = user?.authentication, let authorizer = auth.fetcherAuthorizer() {
            print("User Signed Into Google")
            GoogleDriveManager.shared.updateAuthorizer(authorizer: authorizer)
            
            self.delegate?.loginCompleted(for: .google, sender: self)
        }
    }
    
    public override func login() {
        configure()
        
        GIDSignIn.sharedInstance().signIn()
    }
    
    public func loginSilently() {
        configure()
        
        GIDSignIn.sharedInstance().signIn()
    }
    
    // MARK: - Utils
    
    public override func logout() {
        GIDSignIn.sharedInstance().signOut()
        
        self.delegate?.logoutCompleted(for: .google, sender: self)
    }
    
    fileprivate func configure() {
        GIDSignIn.sharedInstance().scopes = kGoogleDriveScopes
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.currentWindow?.rootViewController
    }
}

extension UIApplication {
    public var currentWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
