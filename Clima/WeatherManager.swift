//
//  WeatherManager.swift
//  Clima
//
//  Created by Julio Cezar Teixeira on 16/03/26.
//  Copyright © 2026 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=0e7032eabf75119d922cf9af7160c085&units=metric"
    
    func fetchWeather(cityName: String) {
        //let urlString = "\(weatherURL)&q=\(cityName)"
        let urlString = weatherURL + "&q=" + cityName
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        
        //1- create a URL
        if let url = URL(string: urlString) {
            //2- create a URLsession
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    self.parseJSON(weatherData: safeData)
                }
            }            
            //4- start a task
            task.resume()
            
        }
    }
    
    func parseJSON(weatherData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            print(decodedData.weather[0].description)
        } catch {
            print(error)
        }
    }
}
