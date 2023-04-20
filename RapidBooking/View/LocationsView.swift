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
        ZStack{
            if vm.isLoading{
                ProgressView()
            }
            else{
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
    }
}

struct LocationsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsView(vm: LocationsViewModel(location: ""))
    }
}

struct LocationItem: View{
    let location: RapidLocation
    
    var body: some View{
        VStack(alignment: .leading){
            Text(location.label!)
                .font(.largeTitle)
            Text("**Number of hotels** : \(location.hotels!)")
            AsyncImage(url: URL(string: location.image_url!))
        }
    }
}
