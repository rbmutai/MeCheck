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
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                    
                VStack(alignment: .leading, spacing: 1){
                    HStack {
                        Text("Go Premium")
                            .font(.IBMMedium(size: 15))
                        NavigationLink(value: Route.subscriptions) {
                            HStack {
                                Text("View options")
                                    .font(.IBMRegular(size: 14))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .frame(width: 5, height: 10)
                                    
                            }
                            .padding(8)
                            .modifier(CustomCard())
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                            .frame(maxWidth: .infinity)
                        }.buttonStyle(.plain)
                    }
                    
                    Text("Unlimited habits and gratitude journals, unlock all charts, remove ads!")
                        .font(.IBMRegular(size: 14))
                    
                }
                
            }
            
           
           
        }
        .padding(10)
        .modifier(CustomCard(cornerRadius: 10))
        
        
       
    }
}

#Preview {
    PremiumAdView()
}
