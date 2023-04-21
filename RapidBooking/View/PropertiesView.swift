//
//  PropertiesView.swift
//  RapidBooking
//
//  Created by 沈清昊 on 4/20/23.
//

import SwiftUI

struct PropertiesView: View {
    @ObservedObject var vm: PropertiesViewModel
    
    var body: some View {
        ZStack{
            if let properties = vm.properties{
                List{
                    ForEach(properties.result, id: \.hotel_id){ property in
                        PropertyItem(property: property)
                    }
                }
                .listStyle(.plain)
            }
            else{
                ProgressView()
            }
        }
        .environmentObject(vm)
        .onAppear(perform: vm.fetchProperties)
        .alert(isPresented: $vm.hasError, error: vm.error) {
            Button {
                
            } label: {
                Text("Cancel")
            }

        }
    }
}

struct PropertiesView_Previews: PreviewProvider {
    static var previews: some View {
        PropertiesView(vm: PropertiesViewModel(arrivalDate: "", departureDate: "", guestQty: "", roomQty: "", dest_id: "", search_type: ""))
    }
}

struct PropertyItem: View{
    @EnvironmentObject var vm: PropertiesViewModel
    let property: RapidHotel
    
    var body: some View{
        VStack{
            Text(property.hotel_name!)
                .font(.title)
            Text("**Address** : \(property.city!), \(property.district!), \(property.address!), \(property.zip!)")
            HStack{
                Text("**CheckIn** : \(property.checkin.from!)")
                Spacer()
                Text("**CheckOut** : \(property.checkout.until!)")
            }
            Text("**Rate** : \(property.review_score!)")
            AsyncImage(url: URL(string: property.main_photo_url!))
        }
    }
}
