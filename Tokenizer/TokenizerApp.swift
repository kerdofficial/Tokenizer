//
//  TokenizerApp.swift
//  Tokenizer
//
//  Created by Dániel Kerekes on 2025. 11. 13..
//

import SwiftUI

@main
struct TokenizerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(
                    minWidth: 1200,
                    maxWidth: 1200,
                    minHeight: 620,
                    maxHeight: 620,
                )
        }
        .defaultSize(width: 1200, height: 620)
        .windowResizability(.contentSize)
    }
}
