//
//  CurrenciesView.swift
//  RapidBooking
//
//  Created by 沈清昊 on 4/17/23.
//

import SwiftUI

struct CurrenciesView: View {
    
    @StateObject private var vm = CurrenciesViewModel()
    
    var body: some View {
        ZStack{
            if let rates = vm.currency?.exchange_rates{
                List{
                    ForEach(rates, id: \.currency){ rate in
                        CurrencyItem(rate: rate.exchange_rate_buy ?? "Unknown", currency: rate.currency ?? "Unknown")
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .navigationTitle("\(vm.currency?.base_currency_date ?? "Unknown")'s USD rate")
            }
            else{
                ProgressView()
            }
        }
        .onAppear(perform: vm.fetchCurrency)
        .alert(isPresented: $vm.hasError, error: vm.error) {
            Button {
                vm.fetchCurrency()
            } label: {
                Text("Cancel")
            }

        }
    }
}

struct CurrenciesView_Previews: PreviewProvider {
    static var previews: some View {
        CurrenciesView()
    }
}

struct CurrencyItem: View{
    
    let rate: String
    let currency: String
    
    var body: some View{
        VStack(alignment: .leading){
            Text("**Currency**: \(currency)")
            Divider()
            Text("**Rate**: \(rate)")
        }
        .frame(maxWidth: .infinity,
               alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        .padding(.horizontal, 4)
    }
}
