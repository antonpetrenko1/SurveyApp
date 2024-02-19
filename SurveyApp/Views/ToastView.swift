//
//  ToastView.swift
//  SurveyApp
//
//  Created by Антон Петренко on 19/02/2024.
//

import SwiftUI

// Ideally we'd need to add animation for toas appearing and disappearing. To speed up the process I'll skip these steps.

struct Toast: ViewModifier {
    
    enum KindOfToast {
        case success, failure
    }
    
    @Binding var isShowing: Bool
    let config: Config
    
    func body(content: Content) -> some View {
        ZStack {
            content
            toastView
        }
    }
    
    private var toastView: some View {
        VStack {
            Spacer()
            if isShowing {
                HStack {
                    Text(config.message)
                        .multilineTextAlignment(.center)
                        .foregroundColor(config.textColor)
                        .font(config.font)
                    if config.addButton {
                        Button {
                            config.buttonAction?()
                        } label: {
                            Image(systemName: "gobackward")
                                .foregroundStyle(config.textColor)
                        }
                    }
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 30)
                .background(Capsule().foregroundColor(config.backgroundColor))
                .onTapGesture {
                    isShowing = false
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 18)
    }
    
    struct Config {
        let message: String
        let addButton: Bool
        let buttonAction: (() -> Void)?
        let textColor: Color
        let font: Font
        let backgroundColor: Color
        let transition: AnyTransition
        let animation: Animation
        
        init(message: String,
             addButton: Bool,
             buttonAction: (() -> Void)?,
             textColor: Color = .white,
             font: Font = .system(size: 14),
             backgroundColor: Color = .black.opacity(0.588),
             transition: AnyTransition = .opacity,
             animation: Animation = .linear(duration: 0.3)) {
            self.message = message
            self.addButton = addButton
            self.buttonAction = buttonAction
            self.textColor = textColor
            self.font = font
            self.backgroundColor = backgroundColor
            self.transition = transition
            self.animation = animation
        }
    }
}

extension View {
    func toast(isShowing: Binding<Bool>,
               config: Toast.Config) -> some View {
        self.modifier(Toast(isShowing: isShowing,
                            config: config))
    }
}
