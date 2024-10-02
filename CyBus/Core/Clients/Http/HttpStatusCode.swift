//
//  HttpStatusCode.swift
//  CyBus
//
//  Created by Vadim Popov on 24/08/2024.
//

import Foundation

enum HTTPStatusCode: Int {
    case ok = 200
    case created = 201
    case accepted = 202
    case noContent = 204
    
    case movedPermanently = 301
    case found = 302
    case notModified = 304
    
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case methodNotAllowed = 405
    
    case internalServerError = 500
    case notImplemented = 501
    case badGateway = 502
    case serviceUnavailable = 503
    
    var isSuccess: Bool {
        return (200...299).contains(self.rawValue)
    }
    
    var isRedirect: Bool {
        return (300...399).contains(self.rawValue)
    }
    
    var isClientError: Bool {
        return (400...499).contains(self.rawValue)
    }
    
    var isServerError: Bool {
        return (500...599).contains(self.rawValue)
    }
}
