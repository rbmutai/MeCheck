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
                            .resizable()
                            .frame(width: 18,height: 13)
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
                HStack {
                    Text("View options")
                        .font(.IBMRegular(size: 14))
                    Image(systemName: "chevron.right")
                        .resizable()
                        .frame(width: 5,height: 10)
                        
                }
                .padding([.leading,.trailing])
                .padding([.top,.bottom], 8)
                .modifier(CustomCard())
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15)))
                .frame(maxWidth: .infinity)
                    
            }.buttonStyle(.plain)
        }.frame(maxWidth: .infinity)
       
    }
}

#Preview {
    PremiumContentView()
}
