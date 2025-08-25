//
//  ReviewUsView.swift
//  CyBus
//
//  Created by Artem Sereda on 26. 7. 2025.
//
import SwiftUI
import ComposableArchitecture

struct RateUsMainView: View {
    @Bindable var store: StoreOf<RateUsFeatures>

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
                store.send(.onSubmit)
            }
        }
        
        .buttonStyle(.plain)
    }
    
    
}

#Preview {
    RateUsView(store: Store(initialState: RateUsFeatures.State()) {
        RateUsFeatures()
    })
}
