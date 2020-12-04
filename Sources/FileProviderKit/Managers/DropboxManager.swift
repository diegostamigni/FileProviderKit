//
//  DropboxManager.swift
//  FileProviderKit
//
//  Created by Diego Stamigni
//  Copyright © 2020 Diego Stamigni. All rights reserved.
//

import Foundation
import SwiftyDropbox

extension RpcRequest : CancelableRequest {
}

extension DownloadRequestFile : CancelableRequest {
}

extension UploadRequest : CancelableRequest {
}

class DropboxConfig {
	static var apiKey: String!
	static var listPageSize = 50
}

class DropboxManager : CloudServiceManager<Files.Metadata, String> {
    
	static let shared : DropboxManager = {
		DropboxClientsManager.setupWithAppKey(DropboxConfig.apiKey)

		let instance = DropboxManager()
		return instance
	}()
	
	fileprivate var authorizedClient: DropboxClient? {
		return DropboxSignInManager.shared.authorizedClient
	}
    
    @discardableResult
	override func list(in folder: Files.Metadata?, options: [String : Any]?,
	                   completion: @escaping ([Files.Metadata], DropboxManager.CursorType?, Error?) -> Void) -> CancelableRequest? {
		guard let client = self.authorizedClient else {
			completion([], nil, NSError(message: NSLocalizedString("Client is not authorized", comment: "")))
			return nil
		}
		
		func cmp<ErrorType>(_ result: Files.ListFolderResult?, _ error: CallError<ErrorType>?) {
			if let error = error {
				completion([], nil, NSError(message: error.description))
				return
			}
			
			completion(result?.entries ?? [], result?.cursor, nil)
		}
		
		var request: CancelableRequest? = nil
		if let cursor = options?[kListCursor] as? String {
			request = client.files.listFolderContinue(cursor: cursor).response(completionHandler: cmp)
		} else {
			request = client.files.listFolder(path: folder?.pathLower ?? "").response(completionHandler: cmp)
		}
		
        return request
	}
    
    @discardableResult
	override func download(file: FileEntry, options: [String : Any]?,
	              completion: @escaping (_ location: URL?, _ error: Error?) -> Void) -> CancelableRequest? {
		guard let client = self.authorizedClient else {
			completion(nil, NSError(message: NSLocalizedString("Client is not authorized", comment: "")))
			return nil
        }
		
		guard let fileName = file.fileName,
            let destinationURL = DocumentManager.shared.locationInCacheDirectory(with: fileName, isDirectory: false) else {
			completion(nil, NSError(message: NSLocalizedString("Wrong file location for file \(file.fileName ?? "" )", comment: "")))
			return nil
		}
		
		let destination: (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
			return destinationURL
		}
		
		let request = client.files.download(path: file.cloudPath ?? "", overwrite: true, destination: destination).response {
			(response, error) in

			if let error = error {
				completion(nil, NSError(message: error.description))
				return
			}
			
			completion(destinationURL, nil)
		}
        
        return request
	}
	
//    @discardableResult
//    override func upload(document: Document, options: [String : Any]?,
//                         completion: @escaping (_ error: Error?) -> Void) -> CancelableRequest? {
//        let fileManager = FileManager.default
//
//        guard let remoteUrl = document.remoteUrl as? URL,
//            let localUrl = document.localUrl as? URL,
//            document.isEnabled, fileManager.fileExists(atPath: localUrl.path)
//        else {
//            completion(NSError(message: "Missing local/remote url for '\(document.title ?? "")'"))
//            return nil
//        }
//
//        document.isModified = false
//        document.isEnabled = false
//
//        let request = self.authorizedClient?.files.upload(path: remoteUrl.path, mode: .overwrite, input: localUrl).response {
//            response, error in
//
//			document.isEnabled = true
//
//			if let error = error {
//                completion(NSError(message: error.description))
//                return
//            }
//
//            ((try? document.managedObjectContext?.save()) as ()??)
//            completion(nil)
//        }
//
//        return request
//    }
	
	@discardableResult
	override func search(query: String, in folder: Files.Metadata?, options: [String : Any]?,
	                     completion: @escaping ([Files.Metadata], String?, Error?) -> Void) -> CancelableRequest? {
		guard let client = self.authorizedClient else {
			completion([], nil, NSError(message: NSLocalizedString("Client is not authorized", comment: "")))
			return nil
		}

		let options = Files.SearchOptions(
			path: folder?.pathLower,
			maxResults: 50,
			fileStatus: .active,
			filenameOnly: true)

		let matchOptions = Files.SearchMatchFieldOptions(includeHighlights: false)

		let request = client.files.searchV2(query: query, options: options, matchFieldOptions: matchOptions, includeHighlights: false).response { (result, error) in
			if let error = error {
				completion([], nil, NSError(message: error.description))
				return
			}

			// completion(result?.matches.map { $0.metadata }, nil, nil)
			//
			// MetadataV2 from Dropbox V2 APIs is now an enum string convertible. I suspect it's now a JSON that needs to
			// be decoded. Something to look into at some point.
			fatalError("Dropbox searchv2 API not fully supported.")
		}
        
        return request
	}
}
