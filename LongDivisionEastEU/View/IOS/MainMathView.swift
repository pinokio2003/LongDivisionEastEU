//
//  MainMathView.swift
//  LongDivisionEastEU
//
//  Created by Anatolii Kravchuk on 07.02.2024.
//

import SwiftUI

struct MainMathView: View {
    @ObservedObject var mathsViewModel: MathsViewModel
    
    @State var dividend: Int
    @State var divider: Int
    
    init(mathsViewModel: MathsViewModel, dividend: Int, divider: Int) {
        self._dividend = State(initialValue: dividend)
        self._divider = State(initialValue: divider)
        self.mathsViewModel = mathsViewModel
        self.mathsViewModel.dividend = dividend
        self.mathsViewModel.divider = divider
        self.mathsViewModel.performAllOperations(dividend: mathsViewModel.dividend, divider: mathsViewModel.divider)
    }
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            let values: [[Int?]] = mathsViewModel.finalAnswerArray
            let numbersOfCells: Int = String(dividend).count * 2
            
            ForEach(0..<numbersOfCells, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<numbersOfCells, id: \.self) { column in
                        let index = row * numbersOfCells + column
                        let value = index < values.flatMap { $0 }.count ? values.flatMap { $0 }[index] : nil
                        
                        let blackSide = index < mathsViewModel.blackSideArray.flatMap {$0}.count ? mathsViewModel.blackSideArray.flatMap {$0}[index] : nil
                        
                        CellView(row: row,
                                 column: column,
                                 value: value, longSize: 30,
                                 blackSide: blackSide)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainMathView(mathsViewModel: MathsViewModel(), dividend: 144, divider: 12)
    }
}
