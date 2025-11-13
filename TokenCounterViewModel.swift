//
//  TokenCounterViewModel.swift
//  Tokenizer
//
//  Created by Dániel Kerekes on 2025. 11. 13..
//

import SwiftUI
import Tiktoken

@MainActor
@Observable
class TokenCounterViewModel {
    var inputText: String = ""
    var selectedEncoding: EncodingType = .o200k_base
    var tokenCount: Int = 0
    var tokens: [Int] = []
    var isLoading: Bool = false
    var errorMessage: String?

    enum EncodingType: String, CaseIterable, Identifiable {
        case p50k_base = "code-davinci-002"
        case cl100k_base = "gpt-4"
        case o200k_base = "gpt-4o"

        var id: String { rawValue }

        var displayName: String {
            switch self {
            case .p50k_base:
                return "p50k_base (Old Codex)"
            case .cl100k_base:
                return "cl100k_base (Older models, up to GPT-4)"
            case .o200k_base:
                return "o200k_base (Newest models)"
            }
        }
        
        var encodingName: String {
            switch self {
            case .p50k_base:
                return "p50k_base"
            case .cl100k_base:
                return "cl100k_base"
            case .o200k_base:
                return "o200k_base"
            }
        }
    }

    func updateTokenCount() async {
        guard !inputText.isEmpty else {
            tokenCount = 0
            tokens = []
            errorMessage = nil
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            print("Requesting encoding for: \(selectedEncoding.rawValue) (encoding: \(selectedEncoding.encodingName))")
            
            guard
                let encoder = try await Tiktoken.shared.getEncoding(
                    selectedEncoding.rawValue
                )
            else {
                print("Encoder not found for: \(selectedEncoding.rawValue)")
                throw TokenizerError.encoderNotFound
            }

            print("Encoder loaded successfully")
            print("Encoding text with \(inputText.count) characters...")
            
            let encodedTokens = encoder.encode(value: inputText)
            
            print("Successfully encoded to \(encodedTokens.count) tokens")

            tokens = encodedTokens
            tokenCount = encodedTokens.count
            errorMessage = nil // Clear error on success
        } catch TokenizerError.encoderNotFound {
            print("Error: Encoder not found")
            errorMessage = "The encoding was not found. Check your network connection and try again."
            tokenCount = 0
            tokens = []
        } catch {
            print("Error during tokenization: \(error)")
            if (error as NSError).domain == NSURLErrorDomain {
                if (error as NSError).code == NSURLErrorNotConnectedToInternet {
                    errorMessage = "No internet connection. Internet connection is required for first use to download vocabulary files."
                } else if (error as NSError).code == NSURLErrorCannotFindHost {
                    errorMessage = "Server not found. Check your network connection or try again later."
                } else {
                    errorMessage = "A network error occurred: \((error as NSError).localizedDescription)"
                }
            } else {
                errorMessage = "An error occurred during tokenization: \(error.localizedDescription)"
            }
            tokenCount = 0
            tokens = []
        }

        isLoading = false
    }

    func pasteFromClipboard() {
        if let clipboardText = NSPasteboard.general.string(forType: .string) {
            inputText = clipboardText
            Task {
                await updateTokenCount()
            }
        }
    }

    enum TokenizerError: LocalizedError {
        case encoderNotFound

        var errorDescription: String? {
            switch self {
            case .encoderNotFound:
                return "The selected encoding is not available."
            }
        }
    }
}
