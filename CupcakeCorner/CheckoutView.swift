//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Denis Evdokimov on 6/20/24.
//

import SwiftUI

struct CheckoutView: View {
    var order: Order
    
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    @State private var showingWrongAlert = false
    
    var body: some View {
        ScrollView {
            
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"),scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)
                
                Text("Your total is \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)
                
                Button("Place Order") {
                    order.saveToUserDef()
                    Task {
                        await placeOrder()
                    }
                }
                    .padding()
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize) // включает скролл только если не помещяется контент
        .alert("Thank you!", isPresented: $showingConfirmation) {
            Button("OK") { }
        } message: {
            Text(confirmationMessage)
        }
        .alert("Wrong Request", isPresented: $showingWrongAlert) {
            Button("OK") { }
        } message: {
            Text(confirmationMessage)
        }
    }
}

extension CheckoutView {
    
    func placeOrder() async {
        guard let encoded =  try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
               return
        }
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            showingConfirmation = true
        } catch {
           // print("Checkout failed: \(error.localizedDescription)")
            confirmationMessage = "your order was not executed due to \(error.localizedDescription) "
            showingWrongAlert = true
        }
    }
}

#Preview {
    CheckoutView(order: Order())
}
