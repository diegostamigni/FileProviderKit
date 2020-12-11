//
//  CancelableRequest.swift
//  FileProviderKit
//
//  Created by Diego Stamigni
//  Copyright © 2020 Diego Stamigni. All rights reserved.
//

import Foundation

public protocol CancelableRequest {
    func cancel()
}
