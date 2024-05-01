//
//  IntroView.swift
//  MeCheck
//
//  Created by Robert Mutai on 24/04/2024.
//

import SwiftUI

struct IntroView: View {
    @ObservedObject var viewModel: IntroViewModel
    @State  var selectedTab : Int = 1
    var body: some View {
      
            VStack {
                HStack{
                    Spacer()
                    Text("Welcome!")
                        .font(.IBMMedium(size: 20))
                        .padding([.trailing],-50)
                    Spacer()
                    Text("Skip")
                        .font(.IBMRegular(size: 17))
                        .padding([.leading,.trailing],18)
                        .padding([.top,.bottom], 10)
                        .modifier(CustomCard())
                        .onTapGesture {
                            viewModel.goHome()
                        }
                   
                }
                TabView(selection: $selectedTab) {
                        ForEach(viewModel.introMessage, id : \.self)  { item in
                            VStack {
                                
                                Image(item.icon, bundle: .none)
                                   // .resizable()
                                   // .frame(width:200,height: 330)
                                Text(item.title)
                                    .font(.IBMMedium(size: 19))
                                    .padding(8)
                                Text(item.detail)
                                    .font(.IBMRegular(size: 17))
                                    .multilineTextAlignment(.center)
                                    .lineLimit(3, reservesSpace: true)
                                    
                            }
                            .padding([.bottom], 25)
                            .tag(item.id)
                        }
                        
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .onAppear {
                    UIPageControl.appearance().currentPageIndicatorTintColor = .purple
                    UIPageControl.appearance().pageIndicatorTintColor = UIColor.purple.withAlphaComponent(0.2)
                }
                HStack{
                    Button {
                        if selectedTab != 1 {
                            selectedTab = selectedTab - 1
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.headline.weight(.semibold))
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    Button {
                        if selectedTab < viewModel.introMessage.count {
                            selectedTab = selectedTab + 1
                        } else {
                            viewModel.goHome()
                        }
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.headline.weight(.semibold))
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                }
                
            }
            .padding()
            .navigationBarBackButtonHidden()
            
      
        
    }
}

#Preview {
    IntroView(viewModel: IntroViewModel(appNavigation: AppNavigation()))
}
