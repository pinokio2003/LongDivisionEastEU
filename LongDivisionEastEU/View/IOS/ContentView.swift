//
//  ContentView.swift
//  LongDivisionEastEU
//
//  Created by Anatolii Kravchuk on 07.02.2024.
//

import SwiftUI

struct ContentView: View {
    
    @State var cellSize: CGFloat = 30
    @State var fontSize: CGFloat = 32
    
    @State private var dividendString: String = ""
    @State private var divisorString: String = ""
    @State var isAllOk: Bool = false
    @State var divider: Int
    @State var dividend: Int
    @State private var taskStatus: TaskStatus = .idle
    @FocusState var isFocusedDividend
    
    //    @StateObject var mathsModel: MathsViewModel
    
    
    var body: some View {
        ZStack {
            Color(Color.background)
                .ignoresSafeArea()
    
            GeometryReader { geometry in
            
            VStack {
                HStack {
                    TextField("Dividend", text: $dividendString)
                        .focused($isFocusedDividend)
                        .padding()
                        .frame(height: 50)
                        .font(.title)
#if os(iOS)
                        .keyboardType(.numberPad)
#endif
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
#if os(iOS)
                        .keyboardType(.numberPad)
#endif
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
                
                
//MARK: --  Main
                if taskStatus == .success {
                      ScrollView([.horizontal, .vertical]) {
                            ZStack(alignment: .topLeading ) {
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
//                            .pinchToZoom(minimumScale: 1, maximumScale: 2.5)
                        }
                      .onTapGesture {
                          isFocusedDividend = false
                      }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
    ContentView(divider: 12 , dividend: 1)
}



