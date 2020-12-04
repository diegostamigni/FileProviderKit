//
//  UUID+Extensions.swift
//  FileProviderKit
//
//  Created by Diego Stamigni
//  Copyright © 2020 Diego Stamigni. All rights reserved.
//

import Foundation

extension UUID {
	static func generate() -> String {
		return UUID().uuidString
	}
}
