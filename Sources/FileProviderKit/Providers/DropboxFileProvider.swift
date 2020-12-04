//
//  DropboxFileProvider.swift
//  
//
//  Created by Diego Stamigni on 04/12/2020.
//

import Foundation
import SwiftyDropbox

class DropboxFileProvider : CloudFileProvider<Files.Metadata, String> {

	override var manager: DropboxManager {
		return DropboxManager.shared
	}

//	override func `import`(at indexPath: IndexPath, in parent: Document?, completion: @escaping (_ document: Document?) -> ()) {
//		let item = self.object(at: indexPath)
//
//		DropboxManager.sharedInstance.download(file: item, options: nil) { [weak self] (url, error) in
//			guard let location = url else {
//				completion(nil)
//				return
//			}
//
//			self?.import(from: item, at: location, in: parent, completion: completion)
//		}
//	}
//
//	override func `import`(from: Files.Metadata, at location: URL, in parent: Document?, completion: @escaping (Document?) -> ()) {
//		DocumentManager.sharedInstance.import(at: location,
//											  in: parent,
//											  identifier: from.uniqueIdentifier ?? UUID.generate(),
//											  context: self.managedObjectContext)
//		{
//			document in
//
//			guard let document = document else {
//				completion(nil)
//				return
//			}
//
//			if let path = from.pathLower {
//				let url = NSURL(fileURLWithPath: path)
//				document.remoteUrl = url
//			}
//
//			if let provider = CloudProvider.with(identifier: .dropbox) {
//				provider.addToDocuments(document)
//				document.provider = provider
//			}
//
//			((try? document.managedObjectContext?.save()) as ()??)
//			completion(document)
//		}
//	}
}
