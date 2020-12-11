//
//  DropboxSignInManager.swift
//  FileProviderKit
//
//  Created by Diego Stamigni
//  Copyright © 2020 Diego Stamigni. All rights reserved.
//

import UIKit
import SwiftyDropbox

public class DropboxSignInManager : LoginManager {
	public static let shared : DropboxSignInManager = {
        DropboxClientsManager.setupWithAppKey(DropboxConfig.apiKey)
		let instance = DropboxSignInManager()
		return instance
	}()
	
    public var authorizedClient: DropboxClient? {
		return DropboxClientsManager.authorizedClient
	}
	
    public override var isLogged: Bool {
		return self.authorizedClient != nil
	}
	
    public func finalizeLogin(with authResult: DropboxOAuthResult) {
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
	
    public func login(in controller: UIViewController) {
		configure()

		DropboxClientsManager.authorizeFromController(UIApplication.shared, controller: controller, openURL: {
            (url: URL) -> Void in
			UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
		})
	}
	
    public func loginSilently() {
		configure()
	}
	
    public override func logout() {
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
