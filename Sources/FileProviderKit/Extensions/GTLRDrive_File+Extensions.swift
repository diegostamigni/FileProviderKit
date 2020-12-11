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
	public var isFolder: Bool {
		return self.mimeType == "application/vnd.google-apps.folder"
	}

    public var isPDF: Bool {
		return self.mimeType == (kUTTypePDF as String) || self.mimeType == "application/pdf"
	}

    public var uniqueIdentifier: String? {
		return self.identifier
	}

    public var fileSize: UInt64 {
		return self.size?.uint64Value ?? 0
	}

    public var fileName: String? {
		return self.name
	}

    public var cloudPath: String? {
		return nil
	}
}
