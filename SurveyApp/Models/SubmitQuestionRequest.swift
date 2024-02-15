//
//  SubmitQuestionRequest.swift
//  SurveyApp
//
//  Created by Антон Петренко on 15/02/2024.
//

import Foundation

struct SubmitQuestionRequest: NetworkRequestInterface {
    typealias ResponseDataType = String
    
    let host: URL
    let answerModel: Data
    
    func create() -> URLRequest {
        let modifiedHost = host.appending(path: "question/submit")
        var request = URLRequest(url: modifiedHost)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = answerModel
        
        return request
    }
    
    func parse(data: Data) throws -> String {
        let decoder = JSONDecoder()
        
        return try decoder.decode(String.self, from: data)
    }
}
