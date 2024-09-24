//
//  ContentView.swift
//  WeatherAggregator
//
//  Created by apple  on 23/09/24.
//

import SwiftUI
import UIKit

struct ContentView: View {

    @StateObject var viewModel: WeatherViewModel
    @State private var searchText = ""
    
    var body: some View {
        NavigationView{
            VStack {
                List {
                    ForEach(viewModel.filteredApiData, id: \.location?.name) { weatherModel in
                        HStack {
                            VStack(alignment: .leading){
                                Text(weatherModel.location?.name ?? "")
                                Text(weatherModel.location?.country ?? "")
                                    .font(.custom("Helvetica", size: 12))
                            }
                            Spacer()
                            Text("\(weatherModel.current?.temp_c ?? 0.0, specifier: "%.1f") °C")
                        }
                    }
                }
                .navigationTitle("Weather Aggregator")
                .searchable(text: $searchText, prompt: "Search")  // Add the search bar
                .refreshable {
                    searchText = ""
                    viewModel.fetchFromAPI()
                }
                // Buttons at the bottom
                HStack {
                    Button(action: {
                        // Action to sort or filter by name
                        viewModel.nameSort()
                    }) {
                        Text("Sort by\nName")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        // Action to sort or filter by temperature
                        viewModel.tempratureSort()
                    }) {
                        Text("Sort by\nTemperature")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 10) // To give some space from the bottom of the screen
            }
        }
        
        .onAppear(perform: {
            viewModel.fetchRequest()
        })
        .onChange(of: searchText) {
            viewModel.filterDataWithText(text: searchText)
        }
    }
}


//#Preview {
//    ContentView()
//}
