//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Denis Evdokimov on 6/19/24.
//

import SwiftUI

struct AddressView: View {
    @Bindable var order: Order // начиная с 17 ios
    
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.name)
                TextField("Street Address", text: $order.streetAddress)
                TextField("City", text: $order.city)
                TextField("Zip", text: $order.zip)
                
            }
            Section {
                NavigationLink("Check out") {
                    CheckoutView(order: order)
                }
            }
            .disabled(order.hasValidAddress == false)
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
    
    #Preview {
        AddressView(order: Order())
    }
