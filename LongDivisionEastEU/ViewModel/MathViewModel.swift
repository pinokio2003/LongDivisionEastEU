//
//  MathViewModel.swift
//  LongDivisionEastEU
//
//  Created by Anatolii Kravchuk on 07.02.2024.
//

import Foundation

class MathsViewModel: ObservableObject {
    @Published var result: [Int] = []               // [1,2]
    @Published var dividendArray: [Int] = []        // [1,4,4]
    @Published var divireArray: [Int] = []          // [14, 24]
    @Published var answerArrayTwo: [Int] = []       // result * dividend
    @Published var finalAnswerArray: [[Int?]] = []  // [Optional(1), Optional(2), nil, nil, nil, nil, nil, nil, nil], ..]
    @Published var blackSideArray: [[String?]] = []
    
    var dividend: Int = 0
    var divider: Int = 0
    
    func addResultToDividentArr(dividend: Int) -> [Int] {
        let divireString = String(dividend / 1)
        let divireIntArr = divireString.map { Int(String($0)) }
        
        for i in divireIntArr {
            dividendArray.insert(Int(i ?? 0), at: 0)
        }
        return dividendArray
    }
    
    func addResultToArr(dividend: Int, divider: Int) -> [Int] {
        let divireString = String(dividend / divider)
        let divireIntArr = divireString.map { Int(String($0)) }
        
        for i in divireIntArr {
            result.insert(Int(i ?? 0), at: 0)
        }
        return result
    }
    
    func addDivireArray() -> [Int] {
        var testArr: [Int] = dividendArray
        let resultCopy = result
        var prefix = 0
        var step: Int = 1
        var checkArray: [Int] = resultCopy.map { $0 * divider }
        
        while checkArray.count != 0 {
            let check: Int = checkArray[0]
            let checkDivider = Int((testArr.map {String($0)}).joined())
            
            print("-------- Step: \(step) ----------")
            step += 1
            
            print("result \(result)")
            print("dividendArray \(dividendArray)")
            print("divireArray \(divireArray)")
            
            if checkDivider ?? 0 >= check && check != 0 {
                var tempArrDividendArr:[Int] = [0]
                
                while  tempArrDividendArr[0] / check < 1 || testArr.count > 1 {
                    
                    let insertedNum = (testArr.prefix(prefix).map {String($0)}).joined()
                    prefix += 1
                    
                    var a = Int(insertedNum) ?? 0 // результат для добавления(отнимания)
                    
                    if tempArrDividendArr.count > 1 && tempArrDividendArr.last == 0 {
                        tempArrDividendArr.removeLast()
                    }
                    if a / check >= 1 {
                        tempArrDividendArr.insert(a, at: 0)
                    }
                    // divireArray
                    if a >= divider {
                        divireArray.append(a)
                        rest()
                        break
                    }
                    // REST
                    func rest() {
                        var g: [Int] = testArr
                        let rest = a - check
                        let newA = (String(a).compactMap {String($0)}).count
                        
                        if newA <= g.count && rest > 0{
                            g.removeFirst(newA)
                            let aArray = String(rest).compactMap {Int(String($0))}
                            g = aArray + g
                        } else if rest == 0 {
                            g.removeFirst(newA)
                        } else if newA == g.count && rest == 0 {
                            g.removeFirst()
                        }
                        a = 0
                        prefix = 0
                        testArr = g
                    }
                }
            }
            checkArray.removeFirst()
        }
        return divireArray
    }

    // Create second array result * dividend
    func createSecondArray() -> [Int] {
        answerArrayTwo = result.map { $0 * divider }
        return answerArrayTwo
    }
    
    // MARK: - Transform result array + divireArray in answer array: ->
    
    func transformArray() -> [[Int?]] {
        var combinedArray: [Int] = []
        var prevIndexvalue: Int = 0
        var positionArray: [Int] = [0]
        var shift = 0
        let tempArr = answerArrayTwo.filter {$0 != 0}
        
        let numbersOfCells = String(dividend).count * 2
        
        for i in 0..<divireArray.count {
            if i < divireArray.count {
                combinedArray.append(divireArray[i])
            }
            if i < answerArrayTwo.count {
                combinedArray.append(tempArr[i])
            }
        }
        
        for j in 1..<combinedArray.count / 2 {
            let difernceOfIndex = divireArray[j - 1] - tempArr[j - 1]
            //Prefix
            if difernceOfIndex == 0 {
                prevIndexvalue += String(tempArr[j - 1]).count
                positionArray.append(prevIndexvalue)
                
            } else {
                prevIndexvalue += String(tempArr[j - 1]).count - String((divireArray[j - 1] - tempArr[j - 1])).count
                positionArray.append(prevIndexvalue)
            }
            //suffix
            if String(divireArray[j]).count == String(tempArr[j]).count {
                positionArray.append(prevIndexvalue)
            } else if String(divireArray[j]).count != String(tempArr[j]).count {
                
                prevIndexvalue += String(divireArray[j]).count - String(tempArr[j]).count
                positionArray.append(prevIndexvalue)
                
                //        } else {
                //            prevIndexvalue += String(divireArray[j - 1] - tempArr[j - 1]).count
                //
                //            positionArray.append(prevIndexvalue)
            }
        }
        positionArray.insert(0, at: 0)
        
        //Create first line: dividend+divire example: 144 + 12 = 14412
        let firstLine: Int = Int(String(dividend) + String(divider))!
        combinedArray.removeFirst()
        combinedArray.insert(firstLine, at: 0)
        var finalAnswerArray = combinedArray.map { Array(String($0)).map { Int(String($0)) } }
        
        finalAnswerArray = finalAnswerArray.enumerated().map { index, arr in
            var newArr = arr
            
            shift = positionArray[index]
            newArr = Array(repeating: nil, count: shift) + newArr
            while newArr.count < numbersOfCells {
                newArr.append(nil)
            }
            return newArr
        }
        
        //Изменяем вторую строку для добавления ответа:
        
        let firstSolution = result[0] * divider
        let differenceOfCounts = String(dividend).count - String(firstSolution).count
        var secondCount = finalAnswerArray[1]
        let numbersCount = String(dividend).count * 2
        
        secondCount.removeAll(where: { $0 == nil })
        
        for _ in 0..<differenceOfCounts {
            secondCount.append(nil)
        }
        
        secondCount.append(contentsOf: result)
        
        while secondCount.count < numbersCount {
            secondCount.append(nil)
        }
        
        // change 2-nd line в finalAnswerArray
        
        finalAnswerArray.remove(at: 1)
        finalAnswerArray.insert(secondCount, at: 1)
        
        // add last line with remainder
        let remainderString: String = String(dividend % divider)
        let remainder: [Int?] = (remainderString.map { Int(String($0)) }).reversed()
        var remainderLine: [Int?] = []
        var tempRemainder = remainder
        
        for i in 1...numbersCount {
            if i > numbersCount / 2 && i < (numbersCount / 2) + remainder.count + 1 {
                remainderLine.append(tempRemainder[0])
                tempRemainder.removeFirst()
            } else {
                remainderLine.append(nil)
            }
        }
        finalAnswerArray.append(remainderLine.reversed())
        return finalAnswerArray
    }
    
    //MARK: - generateBlackSideArray
    func generateBlackSideArray() -> [[String?]] {
        //    let rowCount = finalAnswerArray.count
        let firstSolution = result[0] * divider
        let colCount = finalAnswerArray.first?.count ?? 0
        
        var blackSideArray: [[String?]] = []
        
        for (index, row) in finalAnswerArray.enumerated() {
            var blackSideRow: [String?] = []
            
            if index == 0 {
                for _ in row {
                    blackSideRow.append(nil)
                }
                blackSideRow[String(dividend).count] = "left"
                
                // Format second line (first numbers: down, else: left и up)
            } else if index == 1 {
                for (i, element) in row.enumerated() {
                    if i == String(firstSolution).count { // ???? why 2 ?
                        blackSideRow.append(nil)
                    } else if i > String(dividend).count {
                        if result.count >= String(divider).count {
                            blackSideRow.append(element.map { _ in "up" })
                        } else if result.count < String(divider).count {
                            
                            for _ in i...i {
                                blackSideRow.append("up")
                            }
                            blackSideRow[i] = "up"
                        }
                    } else {
                        blackSideRow.append(element.map { _ in "down" })
                    }
                }
                blackSideRow[String(dividend).count] = "topLeft"
            }
            else if index % 2 != 0 && index != 1 {
                // Если индекс строки четный, заменяем значения на "down"
                for element in row {
                    blackSideRow.append(element.map { _ in "down" })
                }
                // Format 1-st lune: "Left"
            } else {
                // Если индекс строки нечетный, оставляем nil
                blackSideRow = Array(repeating: nil, count: colCount)
            }
            
            blackSideArray.append(blackSideRow)
        }
        return blackSideArray
    }
    
    func performAllOperations(dividend: Int, divider: Int) {
        result = addResultToArr(dividend: dividend, divider: divider).reversed()
        dividendArray = addResultToDividentArr(dividend: dividend).reversed()
        divireArray = addDivireArray()
        answerArrayTwo = createSecondArray()
        finalAnswerArray = transformArray()
        blackSideArray = generateBlackSideArray()
    }
}
