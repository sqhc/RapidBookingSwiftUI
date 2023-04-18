//
//  ContentView.swift
//  RapidBooking
//
//  Created by 沈清昊 on 4/17/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Item>

    var body: some View {
        NavigationView {
            VStack{
                Image(systemName: "dollarsign.circle")
                    .font(.title)
                Text("Check today's USD currency")
                    .font(.title)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity,  alignment: .leading)
                NavigationLink {
                    CurrenciesView()
                } label: {
                    Text("Search for currencies")
                        .frame(width: 200, height: 50, alignment: .center)
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(20)
                }

                Divider()
                
            }
            .navigationTitle("Rapid Booking")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
