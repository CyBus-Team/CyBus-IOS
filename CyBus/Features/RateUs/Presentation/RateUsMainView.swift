//
//  ReviewUsView.swift
//  CyBus
//
//  Created by Artem Sereda on 26. 7. 2025.
//
import SwiftUI
import ComposableArchitecture
import StoreKit

struct RateUsMainView: View {
    @Bindable var store: StoreOf<RateUsFeatures>
    @Environment(\.requestReview) private var requestReview
    
    var label = "Rate us"
   
    var maximumRating = 5
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    
    var offColor = Color.gray
    var onColor = Color.yellow
    
    func image(for number: Int) -> Image {
        if number > store.rate {
            offImage ?? onImage
        } else {
            onImage
        }
    }
    
    var body: some View {
        @State var rateText: String = store.text
        @State var rate: Int = store.rate

        HStack{
            if label.isEmpty == false {
                Text(label)
            }
            
            ForEach(1..<maximumRating + 1, id: \.self) { number in
                Button{
                    store.send(.onRateChanged(number))
                    rate = number
                } label: {
                    image(for: number)
                        .foregroundColor(number > rate ? offColor : onColor)
                }
            }
        }
 
  
        TextField("Rate us please...", text: $rateText).frame(minHeight: 100)
        HStack {


            SecondaryButton(label: String(localized: "Not now")) {
                store.send(.onDismiss)
            }
            PrimaryButton(label: String(localized: "Submit")) {
                requestReview()
                store.send(.onSubmit)
            }
        }
        
        .buttonStyle(.plain)
    }
    
    
}

#Preview {
    RateUsMainView(store: Store(initialState: RateUsFeatures.State()) {
        RateUsFeatures()
    })
}
