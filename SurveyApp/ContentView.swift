//
//  ContentView.swift
//  SurveyApp
//
//  Created by Антон Петренко on 15/02/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        WelcomeView(viewModel: .init())
    }
}

#Preview {
    ContentView()
}
