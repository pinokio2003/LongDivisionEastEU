//
//  LongDivisionEastEUApp.swift
//  LongDivisionEastEU
//
//  Created by Anatolii Kravchuk on 07.02.2024.
//

import SwiftUI

@main
struct European_Long_DivisionApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(divider: 12, dividend: 1)
                .environment(\.colorScheme, .light)
        }
        
    }
}
