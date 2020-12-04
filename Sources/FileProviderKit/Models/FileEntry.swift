//
//  FileEntry.swift
//  FileProviderKit
//
//  Created by Diego Stamigni
//  Copyright © 2020 Diego Stamigni. All rights reserved.
//

import Foundation

protocol FileEntry {
	var uniqueIdentifier: String? { get }
	
	var isFolder: Bool { get }
	
	var isPDF: Bool { get }
	
	var fileSize: UInt64 { get }
	
	var fileName: String? { get }
    
	var cloudPath: String? { get }
	
	var isImportable: Bool { get }
}

extension FileEntry {
	var isImportable: Bool {
		return self.isPDF
	}
}
