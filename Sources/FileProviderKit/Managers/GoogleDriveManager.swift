//
//  GoogleDriveManager.swift
//  FileProviderKit
//
//  Created by Diego Stamigni
//  Copyright © 2020 Diego Stamigni. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST_Drive
import GTMSessionFetcherCore
import GoogleSignIn

extension GTLRServiceTicket : CancelableRequest {
}

class GoogleDriveConfig {
	static var apiKey: String!
	static var listPageSize = 50
	static var listQueryFields = "kind,nextPageToken,files(mimeType,id,kind,name,webViewLink,thumbnailLink,fullFileExtension,size)"
}

class GoogleDriveManager : CloudServiceManager<GTLRDrive_File, String> {
    fileprivate var service = GTLRDriveService()
    
    static let shared : GoogleDriveManager = {
        let instance = GoogleDriveManager()
		instance.service.apiKey = GoogleDriveConfig.apiKey
        instance.service.isRetryEnabled = true
        return instance
    }()
    
    @discardableResult
    override func list(in folder: GTLRDrive_File?, options: [String : Any]?,
			completion: @escaping (_ files: [GTLRDrive_File], _ nextPageToken: GoogleDriveManager.CursorType?, _ error: Error?) -> Void) -> CancelableRequest? {
		return listOrSearch(in: folder, options: options, filter: nil, completion: completion)
    }
    
    @discardableResult
    override func search(query: String, in folder: GTLRDrive_File?,
                         options: [String : Any]?,
			completion: @escaping (_ files: [GTLRDrive_File], _ nextPageToken: GoogleDriveManager.CursorType?, _ error: Error?) -> Void) -> CancelableRequest? {
		return listOrSearch(in: folder, options: options, filter: query, completion: completion)
    }
    
    @discardableResult
    override func download(file: FileEntry, options: [String : Any]?,
                           completion: @escaping (_ location: URL?, _ error: Error?) -> Void) -> CancelableRequest? {
        guard let identifier = file.uniqueIdentifier, let name = file.fileName else {
            completion(nil, NSError(message: NSLocalizedString("Wrong items", comment: "")))
            return nil
        }
        
        let query = GTLRDriveQuery_FilesGet.queryForMedia(withFileId: identifier)
        let request = self.service.executeQuery(query) { (ticket, item, error) in
            if let error = error as NSError? {
                print(error.debugDescription)
                completion(nil, error)
                return
            }
            
            guard let item = item as? GTLRDataObject else {
                completion(nil, NSError(message: NSLocalizedString("No content or wrong file", comment: "")))
                return
            }
            
            completion(DocumentManager.shared.import(from: item.data, with: name), nil)
        }
        
        return request
    }
    
//    @discardableResult
//    override func upload(document: Document, options: [String : Any]?,
//                         completion: @escaping (_ error: Error?) -> Void) -> CancelableRequest? {
//        guard let identifier = document.uniqueIdentifier,
//            let localUrl = document.localUrl as? URL,
//            FileManager.default.fileExists(atPath: localUrl.path) else {
//                completion(NSError(message: "Missing local/remote url for '\(document.title ?? "")'"))
//                return nil
//        }
//
//        let now = Date()
//        let file = GTLRDrive_File()
//        file.identifier = identifier
//        file.modifiedTime = GTLRDateTime(date: now)
//        file.modifiedByMeTime = GTLRDateTime(date: now)
//
//        let params = GTLRUploadParameters(fileURL: localUrl, mimeType: file.mimeType ?? "application/pdf")
//        params.shouldUploadWithSingleRequest = false
//        params.shouldSendUploadOnly = true
//
//        let uploadQuery = GTLRDriveQuery_FilesUpdate.query(withObject: file, fileId: identifier, uploadParameters: params)
//        document.isModified = false
//        document.isEnabled = false
//
//        let request = self.service.executeQuery(uploadQuery) { (ticket, item, error) in
//            document.isEnabled = true
//
//            completion(error)
//        }
//
//        return request
//    }
    
    // MARK: - Utils
    
    func updateAuthorizer() {
        guard self.service.authorizer != nil else {
            GoogleSignInManager.shared.loginSilently()
            return
        }
        
        if let user = GIDSignIn.sharedInstance().currentUser, let auth = user.authentication, let authorizer = auth.fetcherAuthorizer() {
            updateAuthorizer(authorizer: authorizer)
        }
    }
    
    func updateAuthorizer(authorizer: GTMFetcherAuthorizationProtocol) {
        self.service.authorizer = authorizer
    }
	
	fileprivate func listOrSearch(in folder: GTLRDrive_File?, options: [String : Any]?, filter with: String?,
		completion: @escaping (_ files: [GTLRDrive_File], _ nextPageToken: GoogleDriveManager.CursorType?, _ error: Error?) -> Void) -> CancelableRequest?
	{
		guard folder?.isFolder ?? true else {
			completion([], nil, NSError(message: "Wrong items"))
			return nil
		}
		
		let driveQuery = GTLRDriveQuery_FilesList.query()
		driveQuery.fields = GoogleDriveConfig.listQueryFields
        driveQuery.orderBy = "folder, name"
		
		if let query = with {
			driveQuery.q = "name contains '\(query)' and trashed = false"
		} else {
			driveQuery.q = "'\(folder?.identifier ?? "root")' in parents and trashed = false"
		}
        
        if let nextPageToken = options?[kListCursor] as? String {
            driveQuery.pageToken = nextPageToken
        }

		let request = self.service.executeQuery(driveQuery) { (ticket, responseObject, error) in
			if let error = error as NSError? {
				print(error.debugDescription)
				completion([], nil, error)
				return
			}
			
			guard let fileList = responseObject as? GTLRDrive_FileList, let files =  fileList.files else {
				print("Wrong object found in response")
				completion([], nil, error)
				return
			}
			
			completion(files, fileList.nextPageToken, nil)
		}
		
		return request
	}
}
