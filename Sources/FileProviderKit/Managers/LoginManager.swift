//
//  LoginManager.swift
//  FileProviderKit
//
//  Created by Diego Stamigni
//  Copyright © 2020 Diego Stamigni. All rights reserved.
//

import Foundation

public class LoginManager: NSObject {
	public weak var delegate: LoginManagerDelegate?
	
    var isLogged: Bool {
        return false
    }
	
	func login() {
	}
	
	func logout() {
	}
}
