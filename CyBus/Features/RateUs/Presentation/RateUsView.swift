//
//  ReviewUsView.swift
//  CyBus
//
//  Created by Artem Sereda on 26. 7. 2025.
//
import SwiftUI
import ComposableArchitecture
import StoreKit

struct RateUsView: View {
    @Bindable var store: StoreOf<RateUsFeature>
    
    let maximumRating = 5
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    
    let offColor = Color.gray
    let onColor = Color.yellow
    
    func image(for number: Int) -> Image {
        if number > store.rate {
            offImage ?? onImage
        } else {
            onImage
        }
    }
    
    var body: some View {
        VStack {
            Text("Rate us")
                .font(.title)
                .padding(.bottom)
            HStack {
                ForEach(1..<maximumRating + 1, id: \.self) { rate in
                    Button {
                        store.send(.onRateChanged(rate))
                    } label: {
                        image(for: rate)
                            .font(.largeTitle)
                            .foregroundColor(
                                rate <= store.rate ? onColor : offColor
                            )
                    }
                }
            }
            .padding(.bottom)
            
            TextField("Your email (optional)", text: $store.email)
                .padding(.horizontal)
                .frame(minHeight: 20)
            TextField("Leave your feedback...", text: $store.message)
                .padding(.horizontal)
                .frame(minHeight: 100)
            
            HStack {
                SecondaryButton(label: String(localized: "Not now")) {
                    store.send(.onDismiss)
                }
                PrimaryButton(label: String(localized: "Submit")) {
                    store.send(.submitReview)
                }
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

#Preview {
    RateUsView(
        store: Store(initialState: RateUsFeature.State()) {
            RateUsFeature()
        }
    )
}
