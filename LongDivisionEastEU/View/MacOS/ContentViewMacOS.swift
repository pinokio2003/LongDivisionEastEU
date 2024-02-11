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
                                .stroke(lineWidth: 1)
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
                
//                .keyboardShortcut(.defaultAction) //Use return and enter button
//Zoom Slider
                Slider(value: $cellSize, in: 30...100)
                
//MARK: --  Main
                if taskStatus == .success {
                    //Resize :
                    
                GeometryReader { geo in
                    ScrollView([.horizontal, .vertical]) {
                       
                            HStack {
//
//                                Image(systemName: "square.resize")
//                                    .rotationEffect(Angle(degrees: 90))
//                                    .position(x: geo.size.width / 6 , y: geo.size.height / 6)
//                                    .gesture(
//                                    DragGesture(minimumDistance: 10)
//                                        .onChanged({ value in
//                                            cellSize = cellSize + 5
//                                            print(cellSize)
//                                        })
//                                    
//                                    )
                                
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
//                .frame(width: scrollViewSize.width, height: scrollViewSize.height, alignment: .center)
                }

                }

            }



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
    ContentViewMacOS(divider: 124 , dividend: 12)
}

