//
//  SurveyService.swift
//  SurveyApp
//
//  Created by Антон Петренко on 15/02/2024.
//

import Foundation

final class SurveyService {
    private let host: URL
    private let network: NetworkService
    
    init(host: URL, session: SessionProviderInterface) {
        self.host = host
        self.network = NetworkService(session: session)
    }
    
    func getQuestions() async throws -> [QuestionModel] {
        let request: QuestionsRequest = .init(host: host)
        
        let result = try await network.perform(request: request)
        return result
    }
    
    func submitAnswer(model: AnswerModel) async throws -> String {
        let encoder = JSONEncoder()
        let data = try encoder.encode(model)
        let request: SubmitQuestionRequest = .init(host: host, answerModel: data)
        
        let result = try await network.perform(request: request)
        return result
    }
}
