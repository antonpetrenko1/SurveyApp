//
//  WelcomeViewModel.swift
//  SurveyApp
//
//  Created by Антон Петренко on 15/02/2024.
//

import Foundation

@MainActor
class WelcomeViewModel: ObservableObject {
    @Published var loaderIsShown: Bool = false
    let service: SurveyService = .init(host: URL(filePath: "https://xm-assignment.web.app/"), session: URLSession.shared)
    var questions: [QuestionModel] = []
    
    func getQuestions() {
        loaderIsShown = true
        
        Task { @MainActor in
            do {
                let questions = try await service.getQuestions()
                self.questions = questions
                loaderIsShown = false
            } catch {
                loaderIsShown = false
            }
        }
    }
}
