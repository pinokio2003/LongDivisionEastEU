//
//  Cell.swift
//  LongDivisionEastEU
//
//  Created by Anatolii Kravchuk on 07.02.2024.
//

import SwiftUI

struct CellView: View {
    let row: Int
    let column: Int
    let value: Int?
    let longSize: CGFloat = 30
    let shortSize: CGFloat = 1
    @State var blackSide: String?
    
    var body: some View {

        ZStack {
            Rectangle()
                .fill(Color.clear)
                .frame(width: longSize, height: longSize)
                .overlay(
                    Text(value.map { "\($0)" } ?? "")
                        .foregroundColor(value != nil ? .black : .clear)
                        .font(.system(size: 22))
                )
                .overlay {
                    let offset = longSize / 2
                    let color: Color = (blackSide != nil ) ? .black : .blue.opacity(0.3)

                    Rectangle().stroke(Color.blue.opacity(0.3))
                    
                    if blackSide == "up" {
                        Rectangle().stroke(color)
                            .frame(width: longSize, height: shortSize)
                            .offset(x: 0, y: -offset)
                    }
                    if blackSide == "down" {
                        Rectangle().stroke(color)
                            .frame(width: longSize, height: shortSize)
                            .offset(x: 0, y: offset)
                    }
                    if blackSide == "left" {
                        Rectangle().stroke(color)
                            .frame(width: shortSize, height: longSize)
                            .offset(x: -offset, y: 0)
                    }
                    if blackSide == "right" {
                        Rectangle().stroke(color)
                            .frame(width: shortSize, height: longSize)
                            .offset(x: offset, y: 0)
                    }
                    if blackSide == "topLeft" {
                        Rectangle().stroke(color)
                            .frame(width: shortSize, height: longSize)
                            .offset(x: -offset, y: 0)
                        Rectangle().stroke(color)
                            .frame(width: longSize, height: shortSize)
                            .offset(x: 0, y: -offset)
                    }
                }
        }
    }
}


#Preview {
    CellView(row: 1, column: 1, value: 42, blackSide: "topLeft")
}


