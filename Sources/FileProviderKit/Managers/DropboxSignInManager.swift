//
//  DropboxSignInManager.swift
//  FileProviderKit
//
//  Created by Diego Stamigni
//  Copyright © 2020 Diego Stamigni. All rights reserved.
//

import UIKit
import SwiftyDropbox

class DropboxSignInManager : LoginManager {
	static let shared : DropboxSignInManager = {
		let instance = DropboxSignInManager()
		return instance
	}()
	
	var authorizedClient: DropboxClient? {
		return DropboxClientsManager.authorizedClient
	}
	
	override var isLogged: Bool {
		return self.authorizedClient != nil
	}
	
	func finalizeLogin(with authResult: DropboxOAuthResult) {
		switch authResult {
		case .success:
			print("User Signed Into Dropbox")
			self.delegate?.loginCompleted(for: .dropbox, sender: self)
            
		case .cancel:
			let message = "Authorization flow was manually canceled by user!"
			print(message)
            
			self.delegate?.loginError(for: .dropbox, sender: self, error: NSError(message: message))
            
		case .error(_, let description):
			self.delegate?.loginError(for: .dropbox, sender: self, error: NSError(message: description))
		}
	}
	
	func login(in controller: UIViewController) {
		configure()

		DropboxClientsManager.authorizeFromController(UIApplication.shared, controller: controller, openURL: {
            (url: URL) -> Void in
			UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
		})
	}
	
	func loginSilently() {
		configure()
	}
	
	override func logout() {
		DropboxClientsManager.unlinkClients()
		
		self.delegate?.logoutCompleted(for: .dropbox, sender: self)
	}
	
	// MARK: - Utils
	
	fileprivate func configure() {
	}
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
