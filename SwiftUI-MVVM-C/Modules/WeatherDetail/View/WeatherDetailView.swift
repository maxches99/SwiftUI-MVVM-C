//
//  WeatherDetailView.swift
//  SwiftUI-MVVM-C
//
//  Created by Максим Чесников on 04.01.2022.
//

import SwiftUI

struct WeatherDetailView: View {
    
    @EnvironmentObject var viewModel: WeatherDetailViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Button("Root", action: viewModel.rootAction)
                Button("New screen", action: viewModel.selectItem)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(viewModel.title)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading, content: {
                    BackButton(
                        backAction: { viewModel.backAction() },
                        menuItemAction: { viewModel.navigateTo(coordinator: $0) },
                        coordinators: viewModel.getAllCoordinators()
                    )
                })
            })
        }
    }
}

struct WeatherDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDetailView()
    }
}
