//
//  SubscriptionsView.swift
//  MeCheck
//
//  Created by Robert Mutai on 01/05/2024.
//

import SwiftUI
import StoreKit
struct SubscriptionsView: View {
    @State var selectedProduct: Product?
    @EnvironmentObject private var entitlementManager: EntitlementManager
    @EnvironmentObject private var subscriptionsManager: SubscriptionsViewModel
       
    var body: some View {
        if entitlementManager.hasPro {
                hasSubscriptionView.navigationTitle("Subcriptions")
    } else {
        subscriptionOptionsView
            .padding(.horizontal, 15)
            .navigationTitle("Subcriptions")
            .onAppear {
                Task {
                    await subscriptionsManager.loadProducts()
                }
            }
    }
       
    }
    // MARK: - Views
    private var hasSubscriptionView: some View {
        ScrollView {
        VStack(spacing: 10) {
            Image(systemName: "crown.fill")
                .foregroundStyle(.yellow)
                .font(Font.system(size: 40))
            
            Text("You've Unlocked Premium Access")
                .font(.IBMSemiBold(size: 33))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
           
                ForEach(subscriptionsManager.purchasedProduct.sorted(by: { $0.purchaseDate > $1.purchaseDate})) { item in
                    VStack(alignment: .leading, spacing: 4) {
                        VStack {
                            HStack{
                                Text("Start Date")
                                    .font(.IBMRegular(size: 15))
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                Text( subscriptionsManager.dateFormatter.string(from: item.purchaseDate))
                                    .font(.IBMRegular(size: 14))
                                    .multilineTextAlignment(.leading)
                            }
                            Divider().padding([.bottom],5)
                        }
                        
                        if  let  expirationDate = item.expirationDate {
                            VStack{
                                HStack{
                                    Text("End Date")
                                        .font(.IBMRegular(size: 15))
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                    Text( subscriptionsManager.dateFormatter.string(from: expirationDate))
                                        .font(.IBMRegular(size: 14))
                                        .multilineTextAlignment(.leading)
                                }
                                Divider().padding([.bottom],5)
                            }
                        }
                        
                        HStack{
                            Text("Subscription Type")
                                .font(.IBMRegular(size: 15))
                                .multilineTextAlignment(.leading)
                            Spacer()
                            
                            if item.id == subscriptionsManager.annualProductID {
                                
                                Text("ANNUAL")
                                    .font(.IBMRegular(size: 14))
                                    .multilineTextAlignment(.leading)
                            } else if item.id == subscriptionsManager.monthlyProductID {
                                
                                Text("MONTHLY")
                                    .font(.IBMRegular(size: 14))
                                    .multilineTextAlignment(.leading)
                            } else if item.id == subscriptionsManager.lifetimeProductID {
                                Text("LIFETIME PURCHASE")
                                    .font(.IBMRegular(size: 14))
                                    .multilineTextAlignment(.leading)
                            }
                        }
                    }
                    .padding()
                    .modifier(CustomCard())
                    .padding()
                    
                }
            
            
        }
        
    }
}
    
    private var subscriptionOptionsView: some View {
        ScrollView{
            VStack {
                if !subscriptionsManager.products.isEmpty {
                    Spacer()
                    proAccessView
                    featuresView
                    VStack(spacing: 2) {
                        productsListView
                        purchaseSection
                    }
                } else {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(1.5)
                        .ignoresSafeArea(.all)
                }
            }
        }
    }
    
    private var proAccessView: some View {
        VStack(alignment: .center, spacing: 10) {
            Image(systemName: "crown")
                .foregroundStyle(.purple)
                .font(Font.system(size: 40))
            
            Text("Unlock Premium")
                .font(.IBMSemiBold(size: 33))
                .multilineTextAlignment(.center)
            
            Text("Premium access benefits:")
                .font(.IBMMedium(size: 16))
                .multilineTextAlignment(.center)
                .padding([.horizontal,.bottom], 10)
        }
    }
    
    private var featuresView: some View {
        VStack(alignment: .leading, spacing: 4){
            ForEach(subscriptionsManager.features, id: \.self) { feature in
                HStack {
                    Image(systemName: "checkmark.circle")
                        .font(.system(size: 22.5, weight: .medium))
                        .foregroundStyle(.purple)
                    
                    Text(feature)
                        .font(.IBMRegular(size: 16))
                        .multilineTextAlignment(.leading)
                }
            }
        }
        
     
    }
    
    private var productsListView: some View {
        VStack(spacing: 15) {
            ForEach(subscriptionsManager.products) { item in
              
                    if item.id == subscriptionsManager.annualProductID {
                        let result = subscriptionsManager.calculateMonthly(price: item.price)
                        
                        ZStack(alignment: .top) {
                                            
                            HStack(alignment: .top) {
                                
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("\(item.displayName)")
                                            .font(.IBMMedium(size: 15))
                                        
                                        Text("\(item.displayPrice)")
                                            .font(.IBMMedium(size: 15))
                                        
                                    }.onAppear(perform: {
                                        selectedProduct = item
                                    })
                                    
                                    Spacer()
                                    
                                    HStack {
                                        VStack {
                                            HStack {
                                                Text("\(item.priceFormatStyle.currencyCode) " + "\(result.newMonthPrice)")
                                                    .font(.IBMSemiBold(size: 15))
                                                    .foregroundStyle(.purple)
                                                Text("/month")
                                                    .font(.IBMSemiBold(size: 13))
                                                    .foregroundStyle(.purple)
                                                    .padding([.leading],-5)
                                            }
                                            HStack {
                                                Text("\(item.priceFormatStyle.currencyCode) " + "\(result.currentMonthPrice)")
                                                    .font(.IBMMedium(size: 15))
                                                    .strikethrough()
                                                Text("/month")
                                                    .font(.IBMSemiBold(size: 13))
                                                    .strikethrough()
                                                    .padding([.leading],-5)
                                            }
                                            
                                        }
                                        
                                    }
                                }
                                
                                Image(systemName: selectedProduct == item ? "checkmark.circle.fill" : "circle")
                                        .foregroundStyle(selectedProduct == item ? .purple : .gray)
                                        .padding()
                                        .onTapGesture {
                                            selectedProduct = item
                                        }
                                
                            }
                            .padding()
                            .modifier(CustomCard(strokeColor: selectedProduct == item ? .purple : .lightGrey))
                            
                            HStack {
                                Text("Save")
                                    .font(.IBMMedium(size: 14))
                                Text("\(result.saving)")
                                    .font(.IBMMedium(size: 14))
                            }
                            .lineLimit(2)
                            .minimumScaleFactor(0.7)
                            .padding([.leading,.trailing])
                            .padding([.top,.bottom],3)
                            .background(.purple)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15)))
                            .padding([.top],-11)
                            
                        }
                        
                        
                    } else {
                        
                    HStack{
                        VStack(alignment: .leading) {
                            Text("\(item.displayName)")
                                .font(.IBMMedium(size: 15))
                            
                            Text("\(item.description)")
                                        .font(.IBMRegular(size: 15))
                        }
                        
                        Spacer()
                        Text("\(item.displayPrice)")
                            .font(.IBMMedium(size: 15))
                            
                        Image(systemName: selectedProduct == item ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(selectedProduct == item ? .purple : .gray)
                                .padding()
                                .onTapGesture {
                                    selectedProduct = item
                                }
                        }
                        .padding(10)
                        .modifier(CustomCard(strokeColor: selectedProduct == item ? .purple : .lightGrey))
                        
                    }
                    
            }
            
        }
    }
    
    private var purchaseSection: some View {
        VStack {
            Button(action: {
                if let selectedProduct = selectedProduct {
                    Task {
                        await subscriptionsManager.buyProduct(selectedProduct)
                    }
                } else {
                    print("Please select a product before purchasing.")
                }
            }) {
                RoundedRectangle(cornerRadius: 12.5)
                    .overlay {
                        Text("Purchase")
                            .foregroundStyle(.white)
                            .font(.system(size: 16.5, weight: .semibold, design: .rounded))
                    }
            }
            .padding(.horizontal, 20)
            .frame(height: 46)
            .disabled(selectedProduct == nil)
            
            Button("Restore Purchases") {
                Task {
                    await subscriptionsManager.restorePurchases()
                }
            }
            .font(.system(size: 14.0, weight: .regular, design: .rounded))
            .frame(height: 15, alignment: .center)
        }.padding([.top,.bottom])
    }
}



#Preview {
    SubscriptionsView()
        .environmentObject(EntitlementManager())
        .environmentObject(SubscriptionsViewModel(entitlementManager: EntitlementManager()))
}
