//
//  NSError+Extensions.swift
//  FileProviderKit
//
//  Created by Diego Stamigni
//  Copyright © 2020 Diego Stamigni. All rights reserved.
//

import Foundation

extension NSError {
	convenience init(message: String?) {
		var userInfo = [String: Any]()
		if let message = message {
			userInfo[NSLocalizedDescriptionKey] = message
		}
		
		self.init(domain: "FileProviderKit", code: -1, userInfo: userInfo)
	}
}
