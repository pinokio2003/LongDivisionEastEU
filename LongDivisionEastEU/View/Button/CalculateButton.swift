//
//  CalculateButton.swift
//  LongDivisionEastEU
//
//  Created by Anatolii Kravchuk on 07.02.2024.
//

import SwiftUI

struct CalculateButton<ButtonContent: View>: View {
    var buttonTint: Color = .clear
    var content: () -> ButtonContent
    let deg: CGFloat = 164
    /// action
    var action: () async -> TaskStatus
    
    /// View properties
    @State private var isLoading: Bool = false
    @State private var taskStatus: TaskStatus = .idle
    @State private var isFailed: Bool = false
    @State private var wiggle: Bool = false
    ///Popup properties
    @State private var showPopup: Bool = false
    @State private var popupMassage: String = ""
    
    var body: some View {
        Button(action: {
            Task {
                isLoading = true
                let taskStatus = await action()
                
                switch taskStatus {
                case .idle:
                    isFailed = false
                case .failed(let string):
                    isFailed = true
                    popupMassage = string
                case .success:
                    isFailed = false
                }
                self.taskStatus = taskStatus
                if isFailed {
                    try? await Task.sleep(for: .seconds(0.5))
                    wiggle.toggle()
                }
                try? await Task.sleep(for: .seconds(0.8))
                if isFailed {
                    showPopup = true
                }
                self.taskStatus = .idle
                isLoading = false
            }
            
        }, label: {
            content()
                .padding(.horizontal, 20)
                .padding(.vertical, 2)
                .opacity(isLoading ? 0 : 1)
                .lineLimit(1)
                .frame(width: isLoading ? 35 : nil,
                       height: isLoading ? 35 : nil)
                .background {
                    GeometryReader {
                        let size = $0.size
                        let circleRadius = 35.0
                        
                        Capsule()
                            .fill(Color(taskStatus == .idle ? buttonTint : taskStatus == .success ? .blue : .red).shadow(.drop(color: .black.opacity(0.15), radius: 6)))
                            .frame(width: isLoading ? circleRadius : nil, height: isLoading ? circleRadius : nil)
                            .frame(width: size.width, height: size.height, alignment: .center)
                    }
                }
                
                .background{
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(
                            LinearGradient(gradient: Gradient(colors: [Color.gray,.white]), startPoint: .top, endPoint: .bottomTrailing)
                        )
                        .blur(radius: 10)
                        .offset(x: -10, y: -10)
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(
                            LinearGradient(gradient: Gradient(colors: [Color.buttonFirst,.white]), startPoint: .top, endPoint: .bottom)
                        )
                        .padding(2)
                        .blur(radius: 1)
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .stroke(lineWidth: 0.1)
                        .blur(radius: 1)
                }
                .clipShape(RoundedRectangle(cornerRadius: 30,style: .continuous))
                .shadow(color: .black.opacity(0.2), radius: 20, x: 25, y: 15)
            
                .overlay {
                    if isLoading && taskStatus == .idle {
                        ProgressView()
                    }
                }
                .overlay {
                    if taskStatus != .idle {
                        Image(systemName: isFailed ? "exclamationmark.octagon.fill" : "equal")
                            .font(.title2.bold())
                            .foregroundStyle(.background)
                    }
                }
                .wiggle(wiggle)
        })
        .disabled(isLoading)
        .popover(isPresented: $showPopup, content: {
            Text(popupMassage)
                .font(.caption)
                .foregroundStyle(.gray)
                .padding(.horizontal, 10)
                .presentationCompactAdaptation(.popover)
        })
        .animation(.snappy, value: isLoading)
        .animation(.snappy, value: taskStatus)
     
    }
}

enum TaskStatus: Equatable {
    case idle
    case failed(String)
    case success
}

//extention дрожжание красной кнопки:
extension View {
    @ViewBuilder
    func wiggle(_ animate: Bool) -> some View {
        self
            .keyframeAnimator(initialValue: CGFloat.zero, trigger: animate) { view,
                value in view
                    .offset(x: value)
            } keyframes: { _ in
                KeyframeTrack {
                    CubicKeyframe(0, duration: 0.1)
                    CubicKeyframe(-5, duration: 0.1)
                    CubicKeyframe(5, duration: 0.1)
                    CubicKeyframe(-5, duration: 0.1)
                    CubicKeyframe(5, duration: 0.1)
                    CubicKeyframe(-5, duration: 0.1)
                    CubicKeyframe(5, duration: 0.1)
                    CubicKeyframe(0, duration: 0.1)
                }
            }
    }
}

#Preview {
    ContentViewMacOS(divider: 12, dividend: 2)
}


