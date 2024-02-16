//
//  LongDivisionEastEUApp.swift
//  LongDivisionEastEU
//
//  Created by Anatolii Kravchuk on 07.02.2024.
//

import SwiftUI

@main
struct European_Long_DivisionApp: App {
#if os(iOS)
    var body: some Scene {
        WindowGroup {
            ContentView(divider: 12, dividend: 1)
                .environment(\.colorScheme, .light)
        }
    }
#else
    var body: some Scene {
        WindowGroup {
            ContentViewMacOS(divider: 144, dividend: 12)
                .environment(\.colorScheme, .light)
        }
        
    }
#endif
}
