//
//  AddressSearchView.swift
//  CyBus
//
//  Created by Vadim Popov on 30/12/2024.
//

import SwiftUI
import ComposableArchitecture

struct AddressSearchView : View {
    @Environment(\.theme) var theme
    @FocusState private var isFocused: Bool
    
    @Bindable var store: StoreOf<AddressSearchFeature>
    
    var body: some View {
        
        VStack(alignment: store.isLoading || store.error != nil ? .center : .leading, spacing: 0) {
            // MARK: Search Text field
            TextField("Type your destination...", text: $store.query)
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
        
        .task {
            isFocused = true
        }
    }
}

