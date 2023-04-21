//
//  LocationsView.swift
//  RapidBooking
//
//  Created by 沈清昊 on 4/19/23.
//

import SwiftUI

struct LocationsView: View {
    
    @ObservedObject var vm : LocationsViewModel
    
    var body: some View {
        VStack{
            if vm.isLoading{
                ProgressView()
            }
            else{
                SearchPropertyPart()
                
                List{
                    ForEach(vm.locations, id: \.dest_id){ location in
                        LocationItem(location: location)
                    }
                }
                .listStyle(.plain)
                .navigationTitle(vm.location)
            }
        }
        .onAppear(perform: vm.fetchLocations)
        .alert(isPresented: $vm.hasError, error: vm.error) {
            Button {
                
            } label: {
                Text("Cancel")
            }

        }
        .environmentObject(vm)
    }
}

struct LocationsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsView(vm: LocationsViewModel(location: ""))
    }
}

struct SearchPropertyPart: View{
    
    @EnvironmentObject var vm: LocationsViewModel
    
    var body: some View{
        Text("Arrival Date:")
            .frame(maxWidth: .infinity, alignment: .leading)
        TextField("Arrival Date", text: $vm.arrivalDate)
        Text("Departure Date:")
            .frame(maxWidth: .infinity, alignment: .leading)
        TextField("Departure Date", text: $vm.departureDate)
        Text("Guest number:")
            .frame(maxWidth: .infinity, alignment: .leading)
        TextField("Guest qantity", text: $vm.guestQty)
        Text("Room number:")
            .frame(maxWidth: .infinity, alignment: .leading)
        TextField("Room Quantity", text: $vm.roomQty)
    }
}

struct LocationItem: View{
    let location: RapidLocation
    
    @EnvironmentObject var vm: LocationsViewModel
    
    var body: some View{
        VStack(alignment: .leading){
            Text(location.label!)
                .font(.largeTitle)
            Text("**Number of hotels** : \(location.hotels!)")
            AsyncImage(url: URL(string: location.image_url!))
            NavigationLink {
                PropertiesView(vm: PropertiesViewModel(arrivalDate: vm.arrivalDate, departureDate: vm.departureDate, guestQty: vm.guestQty, roomQty: vm.roomQty, dest_id: location.dest_id!, search_type: location.dest_type!))
            } label: {
                Text("Search properties")
                    .frame(width: 200, height: 50, alignment: .center)
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(20)
            }

        }
    }
}
