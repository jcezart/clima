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
            let id = decodedData.weather[0].id //o id é a condição do tempo na API
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            print(weather.conditionName)
            print(weather.temperatureString)
        } catch {
            print(error)
        }
    }
    

}
