//
//  AddressSearchView.swift
//  CyBus
//
//  Created by Vadim Popov on 30/12/2024.
//

import ComposableArchitecture
import SwiftUI

struct AddressSearchView: View {
    @Environment(\.theme) var theme
    /// <#Description#>
    @FocusState private var isFocused: Bool

    @Bindable var store: StoreOf<AddressSearchFeature>

    var body: some View {

        VStack(
            alignment: store.isLoading || store.error != nil
                ? .center : .leading,
            spacing: 0
        ) {
            // MARK: Search Text field
            TextField("Type your destination...", text: $store.query)
                .debounced(
                    text: $store.query,
                    debouncedText: $store.debouncedQuery
                )
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(theme.colors.textFieldBackground)
                )
                .overlay(
                    HStack {
                        Spacer()
                        if !store.query.isEmpty {
                            Button {
                                store.send(.onReset)
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                            .padding(.trailing, 8)
                        }
                    }
                )
                .font(theme.typography.regular)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .focused($isFocused)
                .onSubmit {
                    store.send(.onSubmit)
                }
                .onChange(of: store.debouncedQuery) { _, newValue in
                    store.query = newValue
                    store.send(.onSubmit)
                }
            if store.error != nil {
                // MARK: Error
                // TODO: Implement something went wrong component
                Text("Something went wrong, please retry")
            } else if store.isLoading {
                // MARK: Loading
                Spacer()
                ProgressView()
                Spacer()
            } else {
                // MARK: Suggestions
                List(store.suggestions) { suggestion in
                    Text(suggestion.label)
                        .listRowBackground(theme.colors.background)
                        .onTapGesture {
                            store.send(.onSelect(suggestion))
                        }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        .padding()
        .background(theme.colors.background)
        .edgesIgnoringSafeArea(.bottom)

        .onAppear {
            store.send(.setup)
            isFocused = true
        }
    }
}

class DebounceViewModel: ObservableObject {
    @Published var userInput: String = ""
}

struct DebouncedModifier: ViewModifier {
    @State private var viewModel = DebounceViewModel()

    @Binding var text: String
    @Binding var debouncedText: String
    let debounceInterval: TimeInterval

    func body(content: Content) -> some View {
        content
            .onReceive(
                viewModel.$userInput.debounce(
                    for:
                        RunLoop.SchedulerTimeType.Stride(debounceInterval),
                    scheduler:
                        RunLoop.main
                )
            ) { value in
                debouncedText = value
            }
            .onChange(of: text) { _, newValue in
                viewModel.userInput = newValue
            }
    }
}

extension View {
    public func debounced(
        text:
            Binding<String>,
        debouncedText: Binding<String>,
        debounceInterval: TimeInterval = 1
    )
        -> some View
    {
        modifier(
            DebouncedModifier(
                text: text,
                debouncedText: debouncedText,
                debounceInterval: debounceInterval
            )
        )
    }

}
