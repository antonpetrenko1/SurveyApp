//
//  QuestionViewModel.swift
//  SurveyApp
//
//  Created by Антон Петренко on 16/02/2024.
//

import Foundation
import Combine

@MainActor
class QuestionViewModel: ObservableObject {
    @Published var enteredText: String = ""
    @Published var screenState: QuestionViewState = .loaded
    @Published var toastIsShown = false
    @Published var isSubmitButtonDisabled: Bool = true
    @Published var navigationTitle: String
    private let questionsManager: QuestionsManagerInterface
    private var kindOfToast: Toast.KindOfToast = .success
    private var cancellables = Set<AnyCancellable>()
    
    init(questionsManager: QuestionsManagerInterface) {
        self.questionsManager =  questionsManager
        self.navigationTitle = "Question \(questionsManager.submittedQuestionIds.count)/\(questionsManager.savedQuestions.count)"
        $enteredText.sink { [weak self] newValue in
            self?.validateSubmitButtonState()
        }
        .store(in: &cancellables)
    }
    
    var isLast: Bool {
        questionsManager.isLast
    }
    
    var isFirst: Bool {
        questionsManager.isFirst
    }
    
    private func validateSubmitButtonState() {
        let enteredTextIsEmpty = enteredText.isEmpty
        let currentQuestionIsAnswered = questionsManager.currentQuestionIsAnswered
        let result = enteredTextIsEmpty || currentQuestionIsAnswered
        isSubmitButtonDisabled = result
    }
    
    private func recalculateNavigationTitle() {
        navigationTitle = "Question \(questionsManager.submittedQuestionIds.count)/\(questionsManager.savedQuestions.count)"
    }
    
    func enteredTextIsValid() -> Bool {
        !enteredText.isEmpty
    }
    
    func switchToPreviousQuestion() {
        questionsManager.switchToThePreviousQuestion()
    }
    
    func switchToNextQuestion() {
        questionsManager.switchToTheNextQuestion()
    }
    
    func uploadAnswer() async {
        guard let currentQuestion = questionsManager.currentQuestion else {
            changeScreenStateToError()
            return
        }
        
        toastIsShown = false
        screenState = .isLoading
        do {
            let _ = try await questionsManager.submitAnswer(.init(id: currentQuestion.id, answer: enteredText))
            screenState = .loaded
            validateSubmitButtonState()
            recalculateNavigationTitle()
            showToast(.success)
        } catch {
            screenState = .loaded
            validateSubmitButtonState()
            showToast(.failure)
        }
    }
    
    func changeScreenStateToError() {
        screenState = .error
    }
    
    func getToastConfig() -> Toast.Config {
        switch kindOfToast {
        case .success:
            Toast.Config(message: "Succcess 👌", addButton: false, buttonAction: nil)
        case .failure:
            Toast.Config(message: "Failure", addButton: true, buttonAction: {
                Task { @MainActor [weak self] in
                    await self?.uploadAnswer()
                }
            })
        }
    }
    
    func resetSubmittedQuestions() {
        questionsManager.resetSubmittedQuestions()
    }
    
    func getCurrentQuestionText() -> String {
        // Ideally we should throw an error and handle the case where question is absent separately.
        // I use such solution to speed up the process.
        questionsManager.currentQuestion?.question ?? ""
    }
    
    private func showToast(_ kind: Toast.KindOfToast) {
        kindOfToast = kind
        toastIsShown = true
    }
}
