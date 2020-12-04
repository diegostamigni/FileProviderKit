//
//  GTLRDrive_File+Extensions.swift
//  
//
//  Created by Diego Stamigni on 04/12/2020.
//

import Foundation
import GoogleAPIClientForREST_Drive
import MobileCoreServices

extension GTLRDrive_File : FileEntry {
	var isFolder: Bool {
		return self.mimeType == "application/vnd.google-apps.folder"
	}

	var isPDF: Bool {
		return self.mimeType == (kUTTypePDF as String) || self.mimeType == "application/pdf"
	}

	var uniqueIdentifier: String? {
		return self.identifier
	}

	var fileSize: UInt64 {
		return self.size?.uint64Value ?? 0
	}

	var fileName: String? {
		return self.name
	}

	var cloudPath: String? {
		return nil
	}
}
