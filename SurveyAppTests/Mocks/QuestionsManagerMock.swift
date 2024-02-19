//
//  QuestionsManagerMock.swift
//  SurveyAppTests
//
//  Created by Антон Петренко on 19/02/2024.
//

@testable import SurveyApp

class QuestionsManagerMock: QuestionsManagerInterface {
    var isFirst: Bool = false
    var isLast: Bool = false
    var currentQuestion: SurveyApp.QuestionModel? = nil
    var currentQuestionIsAnswered: Bool = false
    var savedQuestions: [SurveyApp.QuestionModel] = []
    var submittedQuestionIds: [UInt] = []
    
    var getQuestionsShouldThrow: Bool = false
    
    func getQuestions() async throws {
        if getQuestionsShouldThrow {
            throw AppError.networkFailure
        }
        return
    }
    
    func switchToTheNextQuestion() { }
    func switchToThePreviousQuestion() { }
    func submitAnswer(_ answerModel: SurveyApp.AnswerModel) async throws { }
    func resetSubmittedQuestions() { }
}
