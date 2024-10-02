//
//  HttpClientError.swift
//  CyBus
//
//  Created by Vadim Popov on 24/08/2024.
//

import Foundation

enum HttpClientError: Error {
    case invalidURL
    case requestFailed
    case decodingFailed
}
