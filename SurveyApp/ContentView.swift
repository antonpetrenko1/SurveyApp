//
//  ContentView.swift
//  SurveyApp
//
//  Created by Антон Петренко on 15/02/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(alignment: .center, content: {
                Button {
                    debugPrint("Should start survey")
                } label: {
                    Text("Start survey")
                }
                .buttonStyle(MainButtonStyle())
            })
            .navigationTitle("Welcome!")
        }
    }
}

#Preview {
    ContentView()
}
