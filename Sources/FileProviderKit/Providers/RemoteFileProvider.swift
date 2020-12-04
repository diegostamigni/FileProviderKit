//
//  RemoteFileProvider.swift
//  FileProviderKit
//
//  Created by Diego Stamigni
//  Copyright © 2020 Diego Stamigni. All rights reserved.
//

import Foundation

protocol RemoteFileProvider : FileProvider {
    associatedtype FType

    var isLoading: Bool { get set }
    
    func remoteList(completion: @escaping (_ items: [FType], _ error: Error?) -> Void)
}
