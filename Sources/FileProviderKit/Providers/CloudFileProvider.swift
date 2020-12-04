//
//  CloudFileProvider.swift
//  FileProviderKit
//
//  Created by Diego Stamigni
//  Copyright © 2020 Diego Stamigni. All rights reserved.
//

import Foundation

class CloudFileProvider<Type: FileEntry, Cursor>
    : RemoteFileProvider
    , Importable
    , Resettable
    , ManagerProvider
    , CloudService
{
    typealias FileType = Type

    typealias CursorType = Cursor
    
    typealias ServiceManagerType = CloudServiceManager<FileType, Cursor>
    
    var nextPageToken: Cursor?
    
    var parentFile: FileType?
    
    var manager: CloudServiceManager<Type, Cursor> {
        fatalError("Requires override")
    }
    
    var isLoading: Bool = false
    
    weak var delegate: FileProviderDelegate?
    
    fileprivate var items: [FileType] = []
    
    func numberOfObjects(section: Int = 0) -> Int {
        return self.items.count
    }
    
    func list() -> [FileType] {
        return self.items
    }
    
    // MARK: - RemoteFileProvider
    
    func remoteList(completion: @escaping ([FileType], Error?) -> Void) {
        var options: [String : Any] = [:]
        
        if let nextToken = self.nextPageToken {
            options[kListCursor] = nextToken
        }
        
        self.manager.list(in: self.parentFile, options: options) {
            [weak self] (files, nextToken, error) in
            guard let context = self else { return }
            
			context.nextPageToken = nextToken
            let resetForAppending: Bool = options.count > 0
            
            if error == nil && !files.isEmpty {
                context.reset(with: files, forAppending: resetForAppending)
            }
            
            completion(files, error)
        }
    }
    
    func object(at indexPath: IndexPath) -> FileType {
        return self.items[indexPath.item]
	}

    // MARK: - Resettable
	
    func reset(with items: [FileType], forAppending: Bool) {
        if forAppending {
            self.items.append(contentsOf: items)
        } else {
            self.items = items
        }
	}
	
    // MARK: - Importable
    
    func `import`(at url: URL) {
	}

//	func `import`(at indexPath: IndexPath, completion: @escaping (_ document: Document?) -> ()) {
//		self.import(at: indexPath, in: nil, completion: completion)
//	}
//
//	func `import`(at indexPath: IndexPath, in parent: Document?, completion: @escaping (_ document: Document?) -> ()) {
//	}
//
//	func `import`(at location: URL, in parent: Document?, completion: @escaping (_ document: Document?) -> ()) {
//	}
//
//	func `import`(from: FileType, at location: URL, in parent: Document?, completion: @escaping (_ document: Document?) -> ()) {
//	}
    
    // MARK: - CloudService
    
    @discardableResult
    func list(in folder: FileType?, options: [String : Any]?, completion: @escaping ([FileType], Cursor?, Error?) -> Void) -> CancelableRequest? {
        return self.manager.list(in: folder, options: options, completion: completion)
    }
    
    @discardableResult
	func search(query: String, in folder: FileType?, options: [String : Any]?, completion: @escaping ([FileType], Cursor?, Error?) -> Void) -> CancelableRequest? {
		let request = self.manager.search(query: query, in: folder, options: options) {
			[weak self] (files, nextToken, error) in
			// context.nextPageToken = nextToken
			
			guard let context = self else {
				completion(files, nextToken, error)
				return
			}
			
			context.reset(with: files, forAppending: false)
			completion(files, nextToken, error)
		}
		
        return request
    }
    
    @discardableResult
    func download(file: FileEntry, options: [String : Any]?, completion: @escaping (URL?, Error?) -> Void) -> CancelableRequest? {
        return self.manager.download(file: file, options: options, completion: completion)
    }
    
//    @discardableResult
//    func upload(document: Document, options: [String : Any]?, completion: @escaping (Error?) -> Void) -> CancelableRequest? {
//        return self.manager.upload(document: document, options: options, completion: completion)
//    }
}

