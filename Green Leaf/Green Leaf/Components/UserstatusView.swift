//
//  UserstatusView.swift
//  Green Leaf
//
//  Created by Maisam Ahmadi on 17.09.24.
//

import SwiftUI

struct UserstatusView: View {
    let value: Int
    let title: String
    
    var body: some View {
        VStack {
            Text("\(value)")
                .font(.subheadline)
                .fontWeight(.semibold)
            Text(title)
                .font(.footnote)
        }
        .frame(width: 100)
    }
}

#Preview {
    UserstatusView(value: 3, title: "Posts")
}
