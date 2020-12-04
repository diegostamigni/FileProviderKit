//
//  GoogleDriveFileProvider.swift
//  
//
//  Created by Diego Stamigni on 04/12/2020.
//

import Foundation
import GoogleAPIClientForREST_Drive

class GoogleDriveFileProvider : CloudFileProvider<GTLRDrive_File, String> {

	override var manager: GoogleDriveManager {
		return GoogleDriveManager.shared
	}

//	override func `import`(at indexPath: IndexPath, in parent: Document?, completion: @escaping (_ document: Document?) -> ()) {
//		let item = self.object(at: indexPath)
//
//		GoogleDriveManager.sharedInstance.download(file: item, options: nil) { [weak self] (url, error) in
//			guard let location = url else {
//				completion(nil)
//				return
//			}
//
//			self?.import(from: item, at: location, in: parent, completion: completion)
//		}
//	}
//
//	override func `import`(from: GTLRDrive_File, at location: URL, in parent: Document?, completion: @escaping (Document?) -> ()) {
//		let identifier = from.uniqueIdentifier ?? UUID.generate()
//
//		DocumentManager.sharedInstance.import(at: location,
//											  in: parent,
//											  identifier: identifier,
//											  context: self.managedObjectContext)
//		{
//			[weak self] document in
//			guard let context = self, let document = document else {
//				completion(nil)
//				return
//			}
//
//			if let provider = CloudProvider.with(identifier: .google),
//			   let doc = Document.with(identifier: identifier, in: context.managedObjectContext)
//			{
//				provider.addToDocuments(doc)
//				doc.provider = provider
//
//				try? context.managedObjectContext.save()
//				completion(doc)
//			} else {
//				completion(document)
//			}
//		}
//	}
}
