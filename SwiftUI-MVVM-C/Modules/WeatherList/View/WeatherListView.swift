//
//  IndividualListView.swift
//  SwiftUI-MVVM-Coordinator-Test
//
//  Created by Максим Чесников on 04.01.2022.
//

import SwiftUI

struct WeatherListView: View {
    @EnvironmentObject var viewModel: WeatherListViewModel
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .failed(let error):
                ErrorView(error: error, handler: viewModel.getForecasts)
            case .success(let articles):
                NavigationView {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible(minimum: 40, maximum: .infinity))]) {
                            ForEach(articles) { item in
                                ForecastCell(forecast: item)
                                    .onTapGesture {
                                        viewModel.selectItem(item: item)
                                    }
                            }
                        }
                        .navigationTitle(Text("Эта ебаная погода"))
                    }
                }
            default:
                ProgressiveView(state: viewModel.state)
            }
        }
    }
}

struct IndividualListView_Previews: PreviewProvider {
    static var models = [Forecast.dummyData]
    static var viewModel = WeatherListViewModel(service: WeatherServiceImpl())
    static var previews: some View {
        WeatherListView().environmentObject(viewModel)
    }
}
