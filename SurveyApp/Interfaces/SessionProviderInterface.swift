//
//  SessionProviderInterface.swift
//  SurveyApp
//
//  Created by Антон Петренко on 15/02/2024.
//

import Foundation

public protocol SessionProviderInterface {
    func fetch(request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: SessionProviderInterface {
    public func fetch(request: URLRequest) async throws -> (Data, URLResponse) {
        let (data, response) = try await data(from: request.url!)
        return (data, response)
    }
}
