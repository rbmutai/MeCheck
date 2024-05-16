//
//  PremiumContentView.swift
//  MeCheck
//
//  Created by Robert Mutai on 16/05/2024.
//

import SwiftUI

struct PremiumContentView: View {
    var body: some View {
        VStack{
            HStack{
                Text("Available on").font(.IBMRegular(size: 15))
                NavigationLink(value: Route.subscriptions) {
                     HStack {
                        Image(systemName: "crown.fill")
                            .foregroundStyle(.white)
                        Text("Premium")
                             .font(.IBMMedium(size: 14))
                             
                        
                    }
                    .padding([.leading,.trailing])
                    .padding([.top,.bottom], 4)
                    .background(.purple)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15)))
                    .contentShape(Rectangle())
                    
                }
                
            }.padding(8)
            NavigationLink(value: Route.subscriptions) {
                Text("View Options")
                    .font(.IBMMedium(size: 15))
                    .foregroundStyle(.purple)
                    .padding([.leading,.trailing])
                    .padding([.top,.bottom], 8)
                    .modifier(CustomCard())
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15)))
                    
            }
        }.frame(maxWidth: .infinity)
       
    }
}

#Preview {
    PremiumContentView()
}
