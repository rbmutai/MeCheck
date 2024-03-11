//
//  MoodView.swift
//  MeCheck
//
//  Created by Robert Mutai on 26/02/2024.
//

import SwiftUI

struct MoodView: View {
    @ObservedObject var viewModel: MoodViewModel
    var body: some View {
        ScrollView {
         Spacer(minLength: 15)
            VStack {
                    Group {
                        Text("Quote of the Day")
                        Text(viewModel.detail)
                            .bold()
                        HStack {
                            Spacer()
                            Text(viewModel.author)
                        }
                    }
                    .padding([.leading,.trailing], 18)
                    .italic()
                    .foregroundStyle(.black)
                }
                .frame(width: 350, height: 180)
                .background {
                    Image(viewModel.background, bundle: .none)
                        .resizable()
                        .frame(width: 330, height: 180, alignment: .center)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .blur(radius: 2)
                        
                }
            Spacer(minLength: 20)
            HStack{
                Image("add_circle", bundle: .none)
                Text("How do you feel today?")
            }
            .padding()
            .background(.quinary,in: RoundedRectangle(cornerRadius: 10.0, style: .circular))
            .onTapGesture {
                
            }
            moodOptionsSection
        }
        .padding([.leading,.trailing],10)
        
            
    }
}
private extension MoodView {
    var moodOptionsSection: some View {
        VStack {
            
        }
    }
}

#Preview {
    MoodView(viewModel: MoodViewModel(quoteItem: .none, date: Date()))
}
