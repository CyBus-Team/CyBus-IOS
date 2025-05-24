//
//  AddressSearchView.swift
//  CyBus
//
//  Created by Vadim Popov on 30/12/2024.
//

import Combine
import ComposableArchitecture
import SwiftUI

struct AddressSearchView: View {
    @Environment(\.theme) var theme
    @FocusState private var isFocused: Bool

    @Bindable var store: StoreOf<AddressSearchFeature>
    var body: some View {
        VStack(
            alignment: { () -> HorizontalAlignment in
                if store.isLoading {
                    return .center
                } else if let _ = store.error {
                    return .center
                } else {
                    return .leading
                }
            }(),
            spacing: 0
        ) {
            // MARK: Search Text field
            @State var searchText: String = store.query
            let searchTextPublisher = PassthroughSubject<String, Never>()
            TextField("Type your destination...", text: $store.query)
                .onChange(of: searchText) { _, searchText in
                    searchTextPublisher.send(searchText)
                }
                .onReceive(
                    searchTextPublisher
                        .debounce(
                            for: .seconds(1),
                            scheduler: DispatchQueue.main
                        )
                ) { debouncedSearchText in
                    store.send(.onSubmit)
                }
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
            if let error = store.error {
                // MARK: Error
                // TODO: Implement something went wrong component
                Text("Something went wrong, please retry:" + error)
            } else if store.isLoading {
                // MARK: Loading
                Spacer()
                ProgressView()
                    .scaleEffect(1.5)
                Spacer()
            } else {
                // MARK: Suggestions
                List(store.suggestions) { suggestion in
                    Text(suggestion.label)
                        .onTapGesture {
                            store.send(.onSelect(suggestion))
                        }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        .padding()
        .edgesIgnoringSafeArea(.bottom)
        
        .task {
            isFocused = true
        }
    }
}

#Preview {
    AddressSearchView(
        store: .init(
            initialState: AddressSearchFeature.State(
                isLoading: true, query: "test"
            ),
            reducer: {
                AddressSearchFeature()
            }
        )
    )
}
