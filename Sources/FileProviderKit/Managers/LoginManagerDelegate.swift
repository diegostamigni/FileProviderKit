//
//  File.swift
//  
//
//  Created by Gianluca Saroni on 11/12/20.
//

import Foundation

public protocol LoginManagerDelegate : class {
    func loginCompleted(for provider: CloudProviderType, sender: LoginManager)
    func logoutCompleted(for provider: CloudProviderType, sender: LoginManager)
    
    func loginError(for provider: CloudProviderType, sender: LoginManager, error: Error)
    func logoutError(for provider: CloudProviderType, sender: LoginManager, error: Error)
}
