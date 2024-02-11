//
//  MainMathViewMacOs.swift
//  LongDivisionEastEU
//
//  Created by Anatolii Kravchuk on 10.02.2024.
//

import SwiftUI

struct MainMathViewMacOs: View {
<<<<<<< HEAD
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    MainMathViewMacOs()
=======
    @ObservedObject var mathsViewModel: MathsViewModel
    
    @State var dividend: Int
    @State var divider: Int
    //New :
    var cellSize: CGFloat
    
    init(mathsViewModel: MathsViewModel, dividend: Int, divider: Int, cellSize: CGFloat) {
        self._dividend = State(initialValue: dividend)
        self._divider = State(initialValue: divider)
        self.cellSize = cellSize
        self.mathsViewModel = mathsViewModel
        self.mathsViewModel.dividend = dividend
        self.mathsViewModel.divider = divider
        self.mathsViewModel.performAllOperations(dividend: mathsViewModel.dividend, divider: mathsViewModel.divider)
    }
    
    
    var body: some View {
        let values: [[Int?]] = mathsViewModel.finalAnswerArray
        let numbersOfCells: Int = String(dividend).count * 2
        // frame size calculate:
        let frameSize = CGFloat(Int(cellSize) * numbersOfCells)
        
        VStack(alignment: .leading, spacing: 0) {
            
//            Slider(value: $cellSize, in: 30...100)
            
            ForEach(0..<numbersOfCells, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<numbersOfCells, id: \.self) { column in
                        let index = row * numbersOfCells + column
                        let value = index < values.flatMap { $0 }.count ? values.flatMap { $0 }[index] : nil
                        
                        let blackSide = index < mathsViewModel.blackSideArray.flatMap {$0}.count ? mathsViewModel.blackSideArray.flatMap {$0}[index] : nil
                        
                        CellView(row: row,
                                 column: column,
                                 value: value, 
                                 longSize: cellSize,
                                 blackSide: blackSide)
                    }
                }
            }
            
        }
        .frame(width: frameSize + frameSize * 0.1,
               height: frameSize + frameSize * 0.1)
    }
}

struct MainMathViewMacOs_Previews: PreviewProvider {
    static var previews: some View {
        MainMathViewMacOs(mathsViewModel: MathsViewModel(), dividend: 144, divider: 12, cellSize: 30)
    }
>>>>>>> MacOsContentView
}
