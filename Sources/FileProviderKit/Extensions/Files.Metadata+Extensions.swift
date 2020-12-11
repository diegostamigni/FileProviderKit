//
//  Files.FileMetadata+Extensions.swift
//  FileProviderKit
//
//  Created by Diego Stamigni
//  Copyright © 2020 Diego Stamigni. All rights reserved.
//

import SwiftyDropbox

public extension Files.Metadata {
	var asFile: Files.FileMetadata? {
		return self as? Files.FileMetadata
	}
	
	var asFolder: Files.FolderMetadata? {
		return self as? Files.FolderMetadata
	}
}

extension Files.Metadata : FileEntry {

    public var isFolder: Bool {
		return self.asFolder != nil
	}

    public var isPDF: Bool {
		guard let item = self.asFile else { return false }
		return item.name.contains(".pdf")
	}

    public var fileSize: UInt64 {
		return self.asFile?.size ?? 0
	}

    public var uniqueIdentifier: String? {
		if let file = self.asFile {
			return file.id
		}

		if let folder = self.asFolder {
			return folder.id
		}

		return nil
	}

    public var fileName: String? {
		return self.name
	}

    public var cloudPath: String? {
		return self.pathLower
	}
}
