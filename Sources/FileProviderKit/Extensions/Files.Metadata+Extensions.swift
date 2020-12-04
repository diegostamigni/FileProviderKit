//
//  Files.FileMetadata+Extensions.swift
//  FileProviderKit
//
//  Created by Diego Stamigni
//  Copyright © 2020 Diego Stamigni. All rights reserved.
//

import SwiftyDropbox

extension Files.Metadata {
	var asFile: Files.FileMetadata? {
		return self as? Files.FileMetadata
	}
	
	var asFolder: Files.FolderMetadata? {
		return self as? Files.FolderMetadata
	}
}

extension Files.Metadata : FileEntry {

	var isFolder: Bool {
		return self.asFolder != nil
	}

	var isPDF: Bool {
		guard let item = self.asFile else { return false }
		return item.name.contains(".pdf")
	}

	var fileSize: UInt64 {
		return self.asFile?.size ?? 0
	}

	var uniqueIdentifier: String? {
		if let file = self.asFile {
			return file.id
		}

		if let folder = self.asFolder {
			return folder.id
		}

		return nil
	}

	var fileName: String? {
		return self.name
	}

	var cloudPath: String? {
		return self.pathLower
	}
}
