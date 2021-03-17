//
//  ResourceRequestError.swift
//  ShareRecipeiOSApp
//
//  Created by Cameron Augustine on 3/16/21.
//

import Foundation

enum ResourceRequestError: Error {
    case noData
    case decodingError
    case encodingError
}
