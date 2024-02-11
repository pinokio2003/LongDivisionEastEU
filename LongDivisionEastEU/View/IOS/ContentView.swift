//
//  ContentView.swift
//  LongDivisionEastEU
//
//  Created by Anatolii Kravchuk on 07.02.2024.
//

import SwiftUI

struct ContentView: View {
    
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
                    
                    taskStatus = isAllOk ? .success : .failed("You cannot use 0 as a divisor or dividend")
                    
                    return taskStatus
                }
                
                
//MARK: --  Main
                if taskStatus == .success {
                      ScrollView([.horizontal, .vertical]) {
                            ZStack(alignment: .topLeading ) {

                                MainMathView(mathsViewModel: MathsViewModel(), dividend: dividend,
                                             divider: divider)
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)


        }
//        .ignoresSafeArea()
//        .background(Color.background)
//        .background(ignoresSafeAreaEdges: .bottom)
}
    func checkIsAllGood() {
        let a = Int(dividendString) ?? 0
        let b = Int(divisorString) ?? 0
        
        if a > 0 && b > 0 && a > b {
            divider = Int(divisorString)!
            dividend = Int(dividendString)!
            
            return isAllOk = true
        } else {
            return isAllOk = false
        }
    }
}
#Preview {
    ContentView(divider: 12 , dividend: 1)
}



