//
//  HelpFiles.swift
//  LongDivisionEastEU
//
//  Created by Anatolii Kravchuk on 07.02.2024.
//

import Foundation
import SwiftUI
//Formatter for numbers

func formatNumbers(_ number: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.groupingSeparator = ""
    return formatter.string(from: NSNumber(value: number)) ?? ""
}

func countSymbolsDivider(argument: Int) -> Double {
     let countSymbolsDivider = (String(argument).compactMap { String($0)}).count
    return Double(countSymbolsDivider)
}

// check what bigger answer or division
func checkWhatBigger(answer: Int, divider: Int) -> Double {
    let answrCount = countSymbolsDivider(argument: answer)
    let dividerCount = countSymbolsDivider(argument: divider)
    
    if answrCount >= dividerCount {
        return answrCount
    } else {
        return dividerCount
    }
}

// проверка разницы в количестве знаков

func checkDifferentCount(firstCount: Int, secondCount: Int) -> Int {
    let firstCount = countSymbolsDivider(argument: firstCount)
    let secondCount = countSymbolsDivider(argument: secondCount)
    
    return Int(firstCount - secondCount)
}


extension Color {
    static let background = Color(red: 232/255, green: 232/255, blue: 232/255)
    static let cellColor = Color(red: 168/255, green: 168/255, blue: 168/255)
    static let buttonFirst = Color(red: 226/255, green: 226/255, blue: 226/255)
}

//extension NSColor {
//    static let backgroundNSColor = NSColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
//}

// Display size calculate
func calculateDisplaySize(width: CGFloat) -> CGFloat {
    // Рассчитываем значение переменной deg в зависимости от ширины экрана
    // Например, половина ширины экрана
    return width * 3.29
}

//Zoom modifire :
struct PinchToZoom: ViewModifier {
    @State private var scale: CGFloat = 1.0
    let minimumScale: CGFloat
    let maximumScale: CGFloat

    init(minimumScale: CGFloat = 1.0, maximumScale: CGFloat = 5.0) {
        self.minimumScale = minimumScale
        self.maximumScale = maximumScale
    }

    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .gesture(
                MagnificationGesture()
                    .onChanged { scale = min(max($0, minimumScale), maximumScale) }
                    .onEnded { _ in scale = scale }
            )
    }
}

extension View {
    func pinchToZoom(minimumScale: CGFloat = 1.0, maximumScale: CGFloat = 5.0) -> some View {
        modifier(PinchToZoom(minimumScale: minimumScale, maximumScale: maximumScale))
    }
}
