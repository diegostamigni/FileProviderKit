//
//  FileProvider.swift
//  FileProviderKit
//
//  Created by Diego Stamigni
//  Copyright © 2020 Diego Stamigni. All rights reserved.
//

import Foundation

#if os(iOS) || os(tvOS)
	import UIKit
#endif

protocol FileProviderDelegate : class {
	func reloadDataRequired()
}

protocol FileProvider {
    associatedtype FileType
    
    var parentFile: FileType? { get set }
	
    var delegate: FileProviderDelegate? { get set }
	
	func numberOfObjects(section: Int) -> Int
	
	func list() -> [FileType]
	
	func object(at indexPath: IndexPath) -> FileType
}

protocol Resettable {
    associatedtype FileType
    
    associatedtype CursorType
    
    var nextPageToken: CursorType? { get set }
    
    func reset(with items: [FileType], forAppending: Bool)
}

protocol Movable {
	associatedtype FileType
	
	func isMovable(at indexPath: IndexPath) -> Bool
	
	func isMovable(item: FileType) -> Bool
	
	func move(item document: FileType, to: FileType?)
}

protocol Copyable {
	associatedtype FileType
	
	func isCopyable(at indexPath: IndexPath) -> Bool
	
	func isCopyable(item: FileType) -> Bool
	
	func copy(to: FileType?)
}

protocol Renamable {
	associatedtype FileType

	func isRenamable(at indexPath: IndexPath) -> Bool
	
	func isRenamable(item: FileType) -> Bool
	
	func rename(document: FileType, with newName: String)
}

protocol Searchable {
	var filterByString: String? { get set }
	
	func validateFilter(query: String) -> Bool
}

protocol Importable {
    associatedtype FileType
    
	func `import`(at url: URL)

#if os(iOS) || os(tvOS)
/*
	func `import`(at indexPath: IndexPath, completion: @escaping (_ document: Document?) -> ())
	
	func `import`(at indexPath: IndexPath, in parent: Document?, completion: @escaping (_ document: Document?) -> ())
	
    func `import`(at location: URL, in parent: Document?, completion: @escaping (_ document: Document?) -> ())
    
    func `import`(from: FileType, at location: URL, in parent: Document?, completion: @escaping (_ document: Document?) -> ())
*/
#endif
}

protocol Navigatable {
	associatedtype FileType
	
	func parent(of item: FileType) -> FileType?
	
	func parent(at indexPath: IndexPath) -> FileType?
	
	func isFolder(at indexPath: IndexPath) -> Bool
	
	func isFolder(item: FileType) -> Bool
	
	func createFolder(name: String)
}

protocol Deletable {
	associatedtype FileType
	
	func isDeletable(at indexPath: IndexPath) -> Bool
	
	func isDeletable(item: FileType) -> Bool
	
	func delete(at indexPath: IndexPath)
	
	func delete(item: FileType)
}

protocol ManagerProvider {
    associatedtype FileType
    
    associatedtype CursorType
    
    associatedtype ServiceManagerType
    
    var manager: ServiceManagerType { get }
}
