//
//  WelcomeViewModelTests.swift
//  SurveyAppTests
//
//  Created by Антон Петренко on 19/02/2024.
//
@testable import SurveyApp
import XCTest
@MainActor
final class WelcomeViewModelTests: XCTestCase {

    private var viewModel: WelcomeViewModel!
    private var questionsManager: QuestionsManagerMock!
    
    override func setUpWithError() throws {
        questionsManager = QuestionsManagerMock()
        viewModel = WelcomeViewModel(questionsManager: questionsManager)
    }

    override func tearDownWithError() throws {
        questionsManager = nil
        viewModel = nil
    }

    func testStateAfterSuccessQueryShouldBeLoaded() async throws {
        // Given
        
        // When
        await viewModel.getQuestions()
        
        // Then
        XCTAssertEqual(viewModel.screenState, .loaded)
    }

    func testStateAfterFailedQueryShouldBeError() async throws {
        // Given
        questionsManager.getQuestionsShouldThrow = true
        
        // When
        await viewModel.getQuestions()
        
        // Then
        XCTAssertEqual(viewModel.screenState, .error)
    }
}
