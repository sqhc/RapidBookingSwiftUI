//
//  HotelReviewsView.swift
//  RapidBooking
//
//  Created by 沈清昊 on 4/21/23.
//

import SwiftUI

struct HotelReviewsView: View {
    
    @ObservedObject var vm: HotelReviewsViewModel
    
    var body: some View {
        ZStack{
            if let reviews = vm.reviews?.vpm_featured_reviews{
                List{
                    ForEach(reviews, id: \.id){ review in
                        ReviewItem(review: review)
                    }
                }
                .listStyle(.plain)
                .navigationTitle(Text(vm.reviews?.featured_reviews_title ?? ""))
            }
            else{
                ProgressView()
            }
        }
        .onAppear(perform: vm.fetchReviews)
        alert(isPresented: $vm.hasError, error: vm.error) {
            Button {
                
            } label: {
                Text("Cancel")
            }
        }
    }
}

struct HotelReviewsView_Previews: PreviewProvider {
    static var previews: some View {
        HotelReviewsView(vm: HotelReviewsViewModel(hotel_id: 0))
    }
}

struct ReviewItem: View{
    var review: HotelReview
    
    var body: some View{
        VStack {
            Text(review.title ?? "")
                .font(.title)
            Text("**Author** : \(review.author?.name ?? "")")
            Text("**Scroe** : \(review.average_score_out_of_10 ?? 0.0)")
            Text("**Purpose** : \(review.travel_purpose ?? "")")
            Text("**Advantage** : \(review.pros ?? "")")
            Text("**Disadvantage** : \(review.cons ?? "")")
        }
        
    }
}
