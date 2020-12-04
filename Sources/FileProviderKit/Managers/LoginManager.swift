//
//  LoginManager.swift
//  FileProviderKit
//
//  Created by Diego Stamigni
//  Copyright © 2020 Diego Stamigni. All rights reserved.
//

import Foundation

protocol LoginManagerDelegate : class {
    func loginCompleted(for provider: CloudProviderType, sender: LoginManager)
	func logoutCompleted(for provider: CloudProviderType, sender: LoginManager)
	
	func loginError(for provider: CloudProviderType, sender: LoginManager, error: Error)
	func logoutError(for provider: CloudProviderType, sender: LoginManager, error: Error)
}

class LoginManager {
	weak var delegate: LoginManagerDelegate?
	
    var isLogged: Bool {
        return false
    }
	
	func login() {
	}
	
	func logout() {
	}
}
