//
//  DocumentManager.swift
//  FileProviderKit
//
//  Created by Diego Stamigni
//  Copyright © 2020 Diego Stamigni. All rights reserved.
//

import Foundation

class DocumentManager {
	static let shared : DocumentManager = {
		let instance = DocumentManager()
		return instance
	}()

	var cacheDirectory: URL? {
		FileManager.default.temporaryDirectory
	}
	
    var documentDirectory: URL? {
		try? FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: true)
	}
	
	func locationInCacheDirectory(with name: String, isDirectory: Bool = false) -> URL? {
		return self.location(in: self.cacheDirectory, with: name, isDirectory: isDirectory)
	}
	
	func locationInDocumentDirectory(with name: String, isDirectory: Bool = false) -> URL? {
		return self.location(in: self.documentDirectory, with: name, isDirectory: isDirectory)
	}
	
	fileprivate func location(in url: URL?, with name: String, isDirectory: Bool) -> URL? {
		guard let url = url else { return nil }
		let pathComponent = url.appendingPathComponent(name, isDirectory: isDirectory)
        let destination = NSURL(fileURLWithPath: pathComponent.path, isDirectory: isDirectory)
		return destination as URL
	}
	
    func remove(at url: URL) -> Bool {
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            let error = error as Error
            print(error.localizedDescription)
            return false
        }
        
        return true
	}
	
	func `import`(from data: Data, with name: String) -> URL? {
		guard let documentDirectory = self.documentDirectory else { return nil }
		let fileDst = documentDirectory.appendingPathComponent(name)
		
		do {
			try data.write(to: fileDst, options: .atomic)
			return fileDst
		} catch let error as NSError {
			print(error.debugDescription)
			return nil
		}
	}
	
	func `import`(at url: URL) -> URL? {
		guard let documentDirectory = self.documentDirectory else { return nil }
		return self.import(at: url, in: documentDirectory)
	}
	
	func `import`(at url: URL, with name: String) -> URL? {
		guard let documentDirectory = self.documentDirectory else { return nil }
		return self.import(at: url, in: documentDirectory, with: name)
	}
	
	func `import`(at url: URL, in containerURL: URL) -> URL? {
        return self.import(at: url, in: containerURL, with: url.lastPathComponent)
	}
	
	func `import`(at url: URL, in containerURL: URL, with name: String) -> URL? {
		let fileCoordinator = NSFileCoordinator()
		let fileDst = containerURL.appendingPathComponent(name)
        let options: NSFileCoordinator.ReadingOptions = []
        
		fileCoordinator.coordinate(readingItemAt: url, options: options, error: nil) { (newUrl) in
			do {
                let data = try Data(contentsOf: newUrl)
                try data.write(to: fileDst, options: .atomic)
			} catch let error as NSError {
				print(error.debugDescription)
			}
		}
		
		return fileDst
	}

}

#if os(iOS)
import UIKit

extension DocumentManager {
	func showDocumentPickerViewControllerFrom(_ rootViewController: UIViewController,
	                                          animated: Bool,
	                                          delegate: UIDocumentPickerDelegate?,
	                                          completion: (() -> Void)?) {
		let documentPicker = UIDocumentPickerViewController(documentTypes: kDocumentProviderSupportedDocumentTypes, in: .import)
		documentPicker.delegate = delegate
		documentPicker.modalPresentationStyle = .formSheet
		
		rootViewController.present(documentPicker, animated: animated, completion: completion)
	}
}

#endif
