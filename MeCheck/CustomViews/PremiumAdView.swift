//
//  PremiumAdView.swift
//  MeCheck
//
//  Created by Robert Mutai on 16/05/2024.
//

import SwiftUI

struct PremiumAdView: View {
    var body: some View {
        VStack(spacing: 1) {
            HStack {
                Image(uiImage: UIImage(named: "AppIcon60x60") ?? UIImage())
                    .resizable()
                    .frame(width: 50, height: 50, alignment: .center)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15)))
                    
                    
                VStack(alignment: .leading, spacing: 1){
                    HStack {
                        Text("Go Premium")
                            .font(.IBMMedium(size: 15))
                        Spacer().frame(width: 30)
                        NavigationLink(value: Route.subscriptions) {
                            Text("View options")
                                .font(.IBMMedium(size: 14))
                                .foregroundStyle(.purple)
                                .padding([.leading,.trailing])
                                .padding([.top,.bottom], 8)
                                .modifier(CustomCard())
                                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15)))
                        }
                    }
                    
                    Text("Unlimited habits and gratitude journals, unlock all charts, remove ads!")
                        .font(.IBMRegular(size: 14))
                    
                }
                
            }
            
           
           
        }
        .padding(10)
        .modifier(CustomCard())
        
        
       
    }
}

#Preview {
    PremiumAdView()
}
