//
//  AddressAutocompleteView.swift
//  CyBus
//
//  Created by Vadim Popov on 30/12/2024.
//

import SwiftUI

struct AddressAutocompleteView : View {
    @Environment(\.theme) var theme
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            TextField(
                "Type your destination...",
                text: $query
            )
            .padding()
            .autocorrectionDisabled()
            .focused($isFocused)
            .onSubmit {
                //
            }
            .overlay {
                ClearButton(text: $query)
                    .padding(.trailing)
                    .padding(.top, 8)
            }
            .onAppear {
                isFocused = true
            }
            .textInputAutocapitalization(.never)
            .cornerRadius(12)
            .border(.primary)
            
            List(self.results) { address in
                Text(address)
                    .listRowBackground(theme.colors.background)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
        .padding()
        .background(theme.colors.background)
        .edgesIgnoringSafeArea(.bottom)
    }
}

