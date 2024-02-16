//
//  ContentViewMacOs.swift
//  LongDivisionEastEU
//
//  Created by Anatolii Kravchuk on 10.02.2024.
//

import SwiftUI

struct ContentViewMacOS: View {
    //Size and resizeble properties
    @State var fontSize: CGFloat = 32
    @State var cellSize: CGFloat = 30
    //Other property
    @State private var dividendString: String = ""
    @State private var divisorString: String = ""
    @State var isAllOk: Bool = false
    @State var divider: Int
    @State var dividend: Int
    @State private var taskStatus: TaskStatus = .idle
    @FocusState var isFocusedDividend
    
    var body: some View {
        ZStack {
            Color(Color.background)
                .ignoresSafeArea()
            HStack {
                    if taskStatus == .success {
                        
                        Image(systemName: "plus.magnifyingglass")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(Color.gray)
                        Spacer()
                        Slider(value: $cellSize, in: 30...100)
                }
            }
            .frame(width: 155, height: 30)
            .position(x: 90, y: 110)
            
            //MARK: - Main Content:
            GeometryReader { geometry in
                VStack {
                    HStack {
                        TextField("Dividend", text: $dividendString)
                            .focused($isFocusedDividend)
                            .padding()
                            .frame(height: 50)
                            .font(.title)
                            .background{
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(lineWidth: 2)
                                    .foregroundStyle(LinearGradient(colors: [.gray], startPoint: .top, endPoint: .topTrailing))
                            }
                        Text("/")
                        TextField("Divisor", text: $divisorString)
                            .focused($isFocusedDividend)
                            .padding()
                            .frame(height: 50)
                            .font(.title)
                            .frame(height: 50)
                            .background{
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(lineWidth: 2)
                                    .foregroundStyle(LinearGradient(colors: [.gray], startPoint: .top, endPoint: .topTrailing))
                            }
                    }
                    .padding()
                    
                    //MARK: --  Calculate button:
                    
                    CalculateButton(buttonTint: .clear){
                        HStack {
                            Text("Calculate")
                                .foregroundColor(.black)
                        }
                        .font(.custom("", size: fontSize)).bold()
                        
                    } action: {
                        taskStatus = .idle
                        checkIsAllGood()
                        isFocusedDividend = false
                        try? await Task.sleep(for: .seconds(0.5))
                        
                        print(isAllOk)
                        
                        taskStatus = isAllOk ? .success : .failed(errorAnswer() ?? "The dividend cannot be less than the divisor")
                        
                        return taskStatus
                    }
                    
                    .keyboardShortcut(.defaultAction) //Use return and enter button
                    .buttonStyle(.borderless)
                    
                    //MARK: --  Main
                    if taskStatus == .success {
                        //Resize :
                        
                        GeometryReader { geo in
                            ScrollView([.horizontal, .vertical]) {
                                
                                HStack {
                                    
                                    MainMathViewMacOs(mathsViewModel: MathsViewModel(),
                                                      dividend: dividend,
                                                      divider: divider,
                                                      cellSize: cellSize)
                                    
                                }
                                
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background{
                                    RoundedRectangle(cornerRadius: 10).foregroundColor(.white)
                                        .shadow(color: .black.opacity(0.2), radius: 5, x: 10, y: 4)
                                }
                            }
                            .onTapGesture {
                                isFocusedDividend = false
                            }
                        }
                    }
                }
            }
        }
    }
    
  private func checkIsAllGood() {
        let a = Int(dividendString) ?? 0
        let b = Int(divisorString) ?? 0
        
        if a > 0 && b > 0 && a >= b {
            divider = Int(divisorString)!
            dividend = Int(dividendString)!
            
            return isAllOk = true
        } else {
            return isAllOk = false
        }
    }
    
 private func errorAnswer() -> String? {
        var errorMessage = ""
            //
        if dividendString.contains(".") ||
            divisorString.contains(".") {
            errorMessage += """
                            The symbol "." cannot be used.
                            The number can only be an integer.
                            """
        }
        
         if dividendString.contains("-") ||
            divisorString.contains("-") {
            errorMessage += """
                            The symbol "-" cannot be used.
                            The number can only positive.
                            """
        }
        
        if Int(dividendString) == nil ||
            Int(divisorString) == nil {
            errorMessage += "Use only digits. "
        }
        
        if Int(dividendString) == 0 ||
        Int(divisorString) == 0 {
           errorMessage += """
                           The number can't be 0
                           """
       }
        
        return errorMessage.isEmpty ? nil : errorMessage
    }
    
}

#Preview {
    ContentViewMacOS(divider: 124 , dividend: 12)
}

