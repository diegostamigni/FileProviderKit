//
//  Constants.swift
//  FileProviderKit
//
//  Created by Diego Stamigni
//  Copyright © 2020 Diego Stamigni. All rights reserved.
//

import CoreGraphics
import Foundation
import MobileCoreServices

enum CloudProviderType : Int {
    case local = -1
    case google = 0
	case dropbox
    case box
	case onedrive
}

let kDocumentProviderSupportedDocumentTypes = [
	kUTTypePDF as String,
    kUTTypeURL as String
]

let kListCursor = "NextPageCursor"

#if !EXTENSION

import SwiftyDropbox
import GoogleAPIClientForREST_Drive

let kGoogleDriveScopes: [String] = [
    // View and manage the files in your Google Drive
    kGTLRAuthScopeDrive,
    
    // View and manage its own configuration data in your Google Drive
    // kGTLRAuthScopeDriveAppdata,
    
    // View and manage Google Drive files and folders that you have opened or created with this app
    // kGTLRAuthScopeDriveFile,
    
    // View and manage metadata of files in your Google Drive
    // kGTLRAuthScopeDriveMetadata,
    
    // View metadata for files in your Google Drive
    // kGTLRAuthScopeDriveMetadataReadonly,
    
    // View the photos, videos and albums in your Google Photos
    // kGTLRAuthScopeDrivePhotosReadonly,
    
    // View the files in your Google Drive
    // kGTLRAuthScopeDriveReadonly,
    
    // Modify your Google Apps Script scripts' behavior
    // kGTLRAuthScopeDriveScripts,
]
	
#endif

private let kByte: UInt64 = 1000
private let kKilobyte: UInt64 = kByte*kByte
private let kMega: UInt64 = kKilobyte*kByte
private let kGiga: UInt64 = kMega*kMega

func bytesToString(bytes: UInt64) -> String {
	if bytes <= kByte {
		return "\(bytes) Bytes"
	} else if bytes > kByte && bytes <= kKilobyte {
		return "\(bytes/kByte) Kilobytes"
	} else if bytes > kKilobyte && bytes <= kMega {
		return "\(bytes/kKilobyte) Megabytes"
	} else if bytes > kMega && bytes <= kGiga {
		return "\(bytes/kMega) Gigabytes"
	}
	return ""
}
