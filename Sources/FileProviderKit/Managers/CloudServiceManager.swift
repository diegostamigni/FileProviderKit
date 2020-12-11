//
//  CloudServiceManager.swift
//  FileProviderKit
//
//  Created by Diego Stamigni
//  Copyright © 2020 Diego Stamigni. All rights reserved.
//

import Foundation

public class BaseCloudServiceManager<CloudFile : FileEntry, Cursor> : CloudService {
    public typealias FileType = CloudFile
    
    public typealias CursorType = Cursor
	
	@discardableResult
    public func list(in folder: CloudFile?, options: [String : Any]?,
              completion: @escaping (_ files: [FileType], _ nextToken: CursorType?, _ error: Error?) -> Void) -> CancelableRequest? {
        return nil
    }
    
    @discardableResult
    public func download(file: FileEntry, options: [String : Any]?, completion: @escaping (URL?, Error?) -> Void) -> CancelableRequest? {
        return nil
    }
    
//    @discardableResult
//    func upload(document: Document, options: [String : Any]?, completion: @escaping (_ error: Error?) -> Void) -> CancelableRequest? {
//        return nil
//    }
    
    @discardableResult
    public func search(query: String, in folder: FileType?,
                options: [String : Any]?,
                completion: @escaping (_ files: [FileType], _ nextToken: CursorType?, _ error: Error?) -> Void)  -> CancelableRequest? {
        return nil
    }
}

public class CloudServiceManager<FileType : FileEntry, CursorType> : BaseCloudServiceManager<FileType, CursorType> {
}
