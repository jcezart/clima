//
//  WeatherManager.swift
//  Clima
//
//  Created by Julio Cezar Teixeira on 16/03/26.
//  Copyright © 2026 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=0e7032eabf75119d922cf9af7160c085&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        //let urlString = "\(weatherURL)&q=\(cityName)"
        let urlString = weatherURL + "&q=" + cityName
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: Double, longitude: Double){
        //let urlString = weatherURL + "&lat=" + latitude + "&lon=" + longitude
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        
        //1- create a URL
        if let url = URL(string: urlString) {
            //2- create a URLsession
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                        
                    }
                }
            }            
            //4- start a task
            task.resume()
            
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id //o id é a condição do tempo na API
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather

        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    

}
