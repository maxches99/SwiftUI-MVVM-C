//
//  BackButton.swift
//  SwiftUI-MVVM-Coordinator-Test
//
//  Created by Максим Чесников on 30.01.2022.
//

import SwiftUI

struct BackButton: View {
    
    var backAction: () -> Void
    var menuItemAction: (Coordinator) -> Void
    var coordinators: [Coordinator]
    
    var body: some View {
        Button(action: {
            backAction()
        }, label: {
            Text(coordinators[0].title)
        })
            .contextMenu {
                menuItems
            }
    }
    
    var menuItems: some View {
        Group {
            ForEach((coordinators.indices), id: \.self) { index in
                Button {
                    menuItemAction(coordinators[index])
                } label: {
                    Text(coordinators[index].title)
                }
            }
        }
    }
}
