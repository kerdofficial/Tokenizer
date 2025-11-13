//
//  ContentView.swift
//  Tokenizer
//
//  Created by Dániel Kerekes on 2025. 11. 13..
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = TokenCounterViewModel()
    @Namespace private var glassNamespace

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection

                    encodingPickerSection

                    textInputSection

                    if !viewModel.inputText.isEmpty {
                        tokenInformationSection
                    }

                    if let errorMessage = viewModel.errorMessage {
                        errorSection(message: errorMessage)
                    }
                }
                .padding()
            }
            .navigationTitle("Tokenizer")
        }
    }

    // MARK: - Header Section

    private var headerSection: some View {
        GlassEffectContainer(spacing: 20) {
            VStack(spacing: 4) {
                Image(systemName: "doc.text.magnifyingglass")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .padding(.bottom, 8)
                    .foregroundStyle(.blue)
                    .symbolRenderingMode(.hierarchical)

                Text("Tokenizer")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)

                Text(
                    "A lightweight tokenizer that mirrors OpenAI's tokenization."
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .glassEffect(.regular, in: .rect(cornerRadius: 20))
            .glassEffectID("header", in: glassNamespace)
        }
    }

    // MARK: - Encoding Picker Section

    private var encodingPickerSection: some View {
        GlassEffectContainer(spacing: 20) {
            VStack(alignment: .leading, spacing: 12) {
                Label("Select Encoding", systemImage: "gearshape.2.fill")
                    .font(.headline)
                    .foregroundStyle(.primary)

                Picker("Encoding", selection: $viewModel.selectedEncoding) {
                    ForEach(TokenCounterViewModel.EncodingType.allCases) {
                        encoding in
                        Text(encoding.displayName)
                            .tag(encoding)
                    }
                }
                .pickerStyle(.menu)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .onChange(of: viewModel.selectedEncoding) {
                    oldValue,
                    newValue in
                    Task {
                        await viewModel.updateTokenCount()
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .glassEffect(.regular, in: .rect(cornerRadius: 16))
            .glassEffectID("picker", in: glassNamespace)
        }
    }

    // MARK: - Text Input Section

    private var textInputSection: some View {
        GlassEffectContainer(spacing: 20) {
            VStack(alignment: .leading, spacing: 12) {

                Label("Tokenizable Text", systemImage: "text.alignleft")
                    .font(.headline)
                    .foregroundStyle(.primary)

                TextEditor(text: $viewModel.inputText)
                    .font(.body)
                    .frame(minHeight: 150, maxHeight: 250)
                    .padding(8)
                    .background(Color.primary.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .onChange(of: viewModel.inputText) { oldValue, newValue in
                        Task {
                            try? await Task.sleep(for: .milliseconds(300))
                            await viewModel.updateTokenCount()
                        }
                    }

                if viewModel.inputText.isEmpty {
                    Text("Enter or paste text to see the token count")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 4)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 16))
            .glassEffectID("input", in: glassNamespace)
        }
    }

    // MARK: - Token Information Section

    private var tokenInformationSection: some View {
        GlassEffectContainer(spacing: 20) {
            VStack(spacing: 16) {
                VStack(spacing: 8) {
                    VStack(spacing: 8) {
                        Text("Tokens")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(.circular)
                        } else {
                            Text("\(viewModel.tokenCount)")
                                .font(
                                    .system(
                                        size: 56,
                                        weight: .bold,
                                        design: .rounded
                                    )
                                )

                                .contentTransition(.numericText())
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .glassEffect(
                        .regular.tint(.primary.opacity(0.1)).interactive(),
                        in: .rect(cornerRadius: 16)
                    )

                    Text(
                        "Token counts are approximate. Actual usage may differ by up to ±200 tokens, especially when your text includes special characters."
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)

                }

                Divider()
                    .padding(.horizontal)

                VStack(spacing: 12) {
                    Text("Detailed Statistics")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    StatisticRow(
                        icon: "textformat.abc",
                        label: "Characters",
                        value: "\(viewModel.inputText.count)"
                    )

                    StatisticRow(
                        icon: "text.word.spacing",
                        label: "Words",
                        value:
                            "\(viewModel.inputText.split(separator: " ").count)"
                    )

                    StatisticRow(
                        icon: "number.circle",
                        label: "Tokens",
                        value: "\(viewModel.tokenCount)"
                    )

                    if viewModel.tokenCount > 0 {
                        StatisticRow(
                            icon: "percent",
                            label: "Character/Token ratio",
                            value: String(
                                format: "%.2f",
                                Double(viewModel.inputText.count)
                                    / Double(viewModel.tokenCount)
                            )
                        )
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .glassEffect(
                    .regular.tint(.primary.opacity(0.05)).interactive(),
                    in: .rect(cornerRadius: 16)
                )
            }
            .padding()
            .frame(maxWidth: .infinity)
            .glassEffect(.regular, in: .rect(cornerRadius: 20))
            .glassEffectID("stats", in: glassNamespace)
        }
        .transition(.scale.combined(with: .opacity))
    }

    // MARK: - Error Section

    private func errorSection(message: String) -> some View {
        GlassEffectContainer(spacing: 20) {
            HStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.red)
                    .font(.title2)

                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .glassEffect(.regular.tint(.red), in: .rect(cornerRadius: 12))
            .glassEffectID("error", in: glassNamespace)
        }
        .transition(.scale.combined(with: .opacity))
    }
}

// MARK: - Statistic Row Component

struct StatisticRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack {
            Label(label, systemImage: icon)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ContentView()
}
