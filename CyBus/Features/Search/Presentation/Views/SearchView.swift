//
//  SearchView.swift
//  CyBus
//
//  Created by Vadim Popov on 27/12/2024.
//

import SwiftUI

struct SearchView : View {
    @Environment(\.theme) var theme
    
    @State private var isSearchPresented = false
    
    @State private var placeholder: String = ""
    
    var body: some View {
        HStack {
            Button {
                self.isSearchPresented = true
            } label: {
                Text("Search here")
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(theme.colors.textFieldBackground)
                    .cornerRadius(12)
            }
            
            Spacer()
            
            Button {
                //TODO: favourites feature
            } label: {
                Image(systemName: "bookmark.fill")
                    .padding(12)
                    .background(theme.colors.textFieldBackground)
                    .cornerRadius(12)
            }
        }
        .padding([.horizontal, .bottom], 12)
        .padding(.top, 6)
        .background(.white)
        .foregroundColor(theme.colors.linkTitle)
        .cornerRadius(12)
        
        .sheet(isPresented: $isSearchPresented) {
            Text("Full search")
                .presentationDetents([.large])
        }
    }
}

#Preview {
    SearchView()
}
