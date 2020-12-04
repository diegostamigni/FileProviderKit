//
//  CloudService.swift
//  FileProviderKit
//
//  Created by Diego Stamigni
//  Copyright © 2020 Diego Stamigni. All rights reserved.
//

import Foundation

protocol CloudService {
	associatedtype FileType : FileEntry
    
	associatedtype CursorType
	
    @discardableResult
    func list(in folder: FileType?, options: [String : Any]?,
              completion: @escaping (_ files: [FileType], _ nextToken: CursorType?, _ error: Error?) -> Void) -> CancelableRequest?
    
    @discardableResult
    func download(file: FileEntry, options: [String : Any]?,
                  completion: @escaping (_ location: URL?, _ error: Error?) -> Void) -> CancelableRequest?

//    @discardableResult
//    func upload(document: Document, options: [String : Any]?, completion: @escaping (_ error: Error?) -> Void) -> CancelableRequest?
    
    @discardableResult
    func search(query: String, in folder: FileType?,
                options: [String : Any]?,
                completion: @escaping (_ files: [FileType], _ nextToken: CursorType?, _ error: Error?) -> Void)  -> CancelableRequest?
}
