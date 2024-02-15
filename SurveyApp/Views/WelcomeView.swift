//
//  WelcomeView.swift
//  SurveyApp
//
//  Created by Антон Петренко on 15/02/2024.
//

import SwiftUI

struct WelcomeView: View {
    @State private var path = NavigationPath()
    @StateObject private var viewModel: WelcomeViewModel
    
    private struct Constants {
        static let navigationTitle: String = "Welcome!"
        static let buttonTitle: String = "Start survey"
    }
    
    init(viewModel: WelcomeViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(alignment: .center, content: {
                Button {
                    viewModel.getQuestions()
                } label: {
                    Text(Constants.buttonTitle)
                }
                .buttonStyle(MainButtonStyle())
            })
            .navigationTitle(Constants.navigationTitle)
        }
        .overlay {
            loader
        }
    }
    
    @ViewBuilder
    private var loader: some View {
        if viewModel.loaderIsShown {
            ZStack {
                Color.gray.opacity(0.7)
                    .ignoresSafeArea()
                ProgressView()
            }
        }
    }
}

#Preview {
    WelcomeView(viewModel: .init())
}
