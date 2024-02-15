//
//  SettingsButtonMacOS.swift
//  LongDivisionEastEU
//
//  Created by Anatolii Kravchuk on 13.02.2024.
//

import SwiftUI

struct SettingsButtonMacOS: View {
    @Binding var isSettingsOn: Bool
    @State var rotationAngle = 0
    @State var speed = 2.0
    @State var cellSize: CGFloat
    
    var body: some View {
        VStack {
            Button {
                isSettingsOn.toggle()
                
            } label: {
                Image(systemName: "gear")
                    .resizable()
                    .scaledToFill()
                    .foregroundStyle(.gray)
                    .frame(width: cellSize, height: cellSize)
                    .rotationEffect(.degrees(Double(rotationAngle)))
                    .animation(Animation.linear(duration: isSettingsOn ? 1 : 0).repeatForever(autoreverses: false), value:  rotationAngle)
                    .onChange(of: isSettingsOn) { newValue in
                        
                        rotationAngle = newValue ? 360 : 0
                        
                    }
                
            }
            .background(Color.clear)
        }
    }
}

#Preview {
    SettingsButtonMacOS(isSettingsOn: .constant(true), cellSize: 30)
}
