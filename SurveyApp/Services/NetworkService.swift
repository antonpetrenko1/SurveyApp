//
//  NetworkService.swift
//  SurveyApp
//
//  Created by Антон Петренко on 15/02/2024.
//

import Foundation

public protocol NetworkServiceInterface {
    func perform<Request: NetworkRequestInterface>(request: Request) async throws -> Request.ResponseDataType
}

public class NetworkService: NetworkServiceInterface {
    
    private let session: SessionProviderInterface
    
    public init(session: SessionProviderInterface) {
        self.session = session
    }
    
    public func perform<Request: NetworkRequestInterface>(request: Request) async throws -> Request.ResponseDataType {
        do {
            let urlRequest = request.create()
            let (data, response) = try await session.fetch(request: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw AppError.networkFailure
            }
            
            guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
                throw AppError.wrongStatusCode
            }
            
            let parsedData = try request.parse(data: data)
            
            return parsedData
        } catch {
            throw AppError.networkFailure
        }
    }
}
