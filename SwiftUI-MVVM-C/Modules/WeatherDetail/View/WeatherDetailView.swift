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
                Text(viewModel.forecast.name ?? "")
                    .navigationBarItems(leading: Button(action: {
                        viewModel.backAction()
                    }, label: {
                        Text("Back")
                }))
                Button("Root", action: viewModel.rootAction)
                Button("New screen", action: viewModel.selectItem)
            }
        }
        .onDisappear(perform: {
            viewModel.dismissScene()
        })
    }
}

struct WeatherDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDetailView()
    }
}
