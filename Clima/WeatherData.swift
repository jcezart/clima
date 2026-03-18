//
//  WeatherData.swift
//  Clima
//
//  Created by Julio Cezar Teixeira on 17/03/26.
//  Copyright © 2026 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather] //weather é um array no retorno da API
}

struct Main: Codable {
    let temp: Double
    
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
