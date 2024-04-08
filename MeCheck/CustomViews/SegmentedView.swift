//
//  SegmentedView.swift
//  MeCheck
//
//  Created by Robert Mutai on 05/04/2024.
//

import SwiftUI

struct SegmentedView: View {

    let segments: [MenuItem]
    @Binding var  selected: Int
    @Namespace var name

    var body: some View {
        HStack(spacing: 0) {
            ForEach(segments, id: \.self) { segment in
                Button {
                    selected = segment.id
                } label: {
                    VStack {
                        HStack {
                            Image(segment.icon, bundle: .none)
                                .foregroundColor(selected == segment.id ? .blue : Color(uiColor: .systemGray))
                            Text(segment.title)
                                .font(.footnote)
                                .fontWeight(.medium)
                                .foregroundColor(selected == segment.id ? .blue : Color(uiColor: .systemGray))
                        }
                        
                        ZStack {
                            Capsule()
                                .fill(Color.clear)
                                .frame(height: 2)
                            if selected == segment.id {
                                Capsule()
                                    .fill(Color.blue)
                                    .frame(height: 2)
                                    .matchedGeometryEffect(id: "Tab", in: name)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SegmentedView(segments: [MenuItem(id: 1, title: "Hello", icon: "rule")], selected: .constant(1))
}
