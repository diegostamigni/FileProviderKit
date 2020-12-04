//
//  GoogleDriveManager.swift
//  FileProviderKit
//
//  Created by Diego Stamigni
//  Copyright © 2020 Diego Stamigni. All rights reserved.
//

import Foundation
import GoogleSignIn

class GoogleSignInManager : LoginManager {
	static let shared : GoogleSignInManager = {
		let instance = GoogleSignInManager()
		return instance
	}()
    
    override var isLogged: Bool {
		GIDSignIn.sharedInstance()?.currentUser != nil
    }
	
	var clientID: String? {
		set(value) {
			GIDSignIn.sharedInstance().clientID = value
		}
		get {
			return GIDSignIn.sharedInstance().clientID
		}
	}
	
	weak var googleLoginDelegate: GIDSignInDelegate? {
		set(value) {
			GIDSignIn.sharedInstance().delegate = value
		}
		get {
			return GIDSignIn.sharedInstance().delegate
		}
	}
    
    func finalizeLogin(for user: GIDGoogleUser?, error: Error?) {
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
    
	override func login() {
        configure()
        
		GIDSignIn.sharedInstance().signIn()
    }
    
    func loginSilently() {
        configure()
        
        GIDSignIn.sharedInstance().signIn()
    }
    
    // MARK: - Utils
	
	override func logout() {
		GIDSignIn.sharedInstance().signOut()
        
		self.delegate?.logoutCompleted(for: .google, sender: self)
	}
    
    fileprivate func configure() {
        GIDSignIn.sharedInstance().scopes = kGoogleDriveScopes
    }
}
