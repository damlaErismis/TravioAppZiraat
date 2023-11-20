//
//  APIError.swift
//  TravioProject
//
//  Created by Burak Özer on 30.10.2023.
//

import Foundation

struct APIError: Error {
    let statusCode: Int
    let message: String
}
