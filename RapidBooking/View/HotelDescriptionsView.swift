//
//  HotelDescriptionsView.swift
//  RapidBooking
//
//  Created by 沈清昊 on 4/21/23.
//

import SwiftUI

struct HotelDescriptionsView: View {
    
    @ObservedObject var vm: HotelDescriptionsViewModel
    
    var body: some View {
        ZStack{
            if let descriptions = vm.descriptions{
                List{
                    ForEach(descriptions, id: \.description){ description in
                        Text(description.description ?? "Unknown")
                    }
                }
                .listStyle(.plain)
                .navigationTitle(Text("Descriptions"))
            }
            else{
                ProgressView()
            }
        }
        .onAppear(perform: vm.fetchDescriptions)
        .alert(isPresented: $vm.hasError, error: vm.error) {
            Button {
                
            } label: {
                Text("Cancel")
            }
        }
    }
}

struct HotelDescriptionsView_Previews: PreviewProvider {
    static var previews: some View {
        HotelDescriptionsView(vm: HotelDescriptionsViewModel(hotel_id: 0, checkIn: "", checkOut: ""))
    }
}
