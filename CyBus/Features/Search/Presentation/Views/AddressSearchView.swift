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
            
            TextField(
                "Type your destination...",
                text: $store.query
            )
            .padding()
            .autocorrectionDisabled()
            .focused($isFocused)
            .onSubmit {
                store.send(.onSubmit)
            }
            .overlay {
                ClearButton(text: $store.query)
                    .padding(.trailing)
                    .padding(.top, 8)
            }
            .textInputAutocapitalization(.never)
            .cornerRadius(12)
            .border(.primary)
            
            if store.error != nil {
                Text("Something went wrong, please retry")
            } else if store.isLoading {
                Spacer()
                ProgressView()
                Spacer()
            } else {
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

