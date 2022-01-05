//
//  ForecastCell.swift
//  SwiftUI-MVVM-Coordinator-Test
//
//  Created by Максим Чесников on 04.01.2022.
//

import SwiftUI

struct ForecastCell: View {
    @Namespace var namespace
    
    @State var show = false
    let forecast: Forecast
    
    var body: some View {
        ZStack {
            if !show {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(forecast.name ?? "")
                            .matchedGeometryEffect(id: "title", in: namespace)
                            .foregroundColor(.black)
                            .font(.system(size: 18, weight: .semibold))
                       
                    }
                    .padding()
                    Spacer()
                    Text(convertTemp(temp: Double(forecast.temperature!), from: .fahrenheit, to: .celsius))
                        .matchedGeometryEffect(id: "temp", in: namespace)
                        .foregroundColor(.black)
                        .font(.system(size: 18, weight: .semibold))
                        .padding()
                }
            } else {
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(forecast.name ?? "")
                                .matchedGeometryEffect(id: "title", in: namespace)
                                .foregroundColor(.black)
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .padding()
                        Spacer()
                        Text(convertTemp(temp: Double(forecast.temperature!), from: .fahrenheit, to: .celsius))
                            .matchedGeometryEffect(id: "temp", in: namespace)
                            .foregroundColor(.black)
                            .font(.system(size: 18, weight: .semibold))
                    }
                    HStack {
                        Text(forecast.forecastDescription ?? "")
                            .matchedGeometryEffect(id: "text", in: namespace)
                            .foregroundColor(.gray)
                        .font(.footnote)
                        Spacer()
                    }
                    .padding()
                }
            }
        }
//        .onTapGesture {
//            withAnimation {
//                show.toggle()
//            }
//        }
    }
}

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastCell(forecast: Forecast.dummyData)
            .previewLayout(.sizeThatFits)
    }
}

