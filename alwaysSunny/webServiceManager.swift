//
//  webServiceManager.swift
//  alwaysSunny
//
//  Created by Yohsuke Yamakawa on 12/9/15.
//  Copyright © 2015 DigitalCrafts. All rights reserved.
//

import Foundation

struct WebServiceManager {
    
    
    private func parseForecast(jsonDict : [String : AnyObject] ) -> Weather{
        var newWeather = Weather()
        if let tempDict = jsonDict["temp"] as? [ String: AnyObject ]{
            newWeather.highTemp = tempDict["max"] as? Float
            newWeather.lowTemp = tempDict["min"] as? Float
        }else{
            newWeather.highTemp = 110
            newWeather.lowTemp = 10
        }
        if let weatherDict = jsonDict["weather"] as? [[ String : AnyObject ]]{
            newWeather.desc = weatherDict[0]["main"] as? String
            newWeather.icon = weatherDict[0]["icon"] as? String
        }
        if let timeResult = (jsonDict["dt"] as? Double) {
            
            let jsonDateObj = NSDate(timeIntervalSince1970: timeResult)
            let hourInSeconds :Double = 60 * 60
            let dayInSeconds : Double = hourInSeconds * 24
            let numericDateFormatter : NSDateFormatter = NSDateFormatter()
            numericDateFormatter.dateFormat = "dd"
            let todayDate = NSDate()
            let tomorrowDate = NSDate(timeInterval: dayInSeconds, sinceDate: todayDate)
            if( numericDateFormatter.stringFromDate(todayDate) == numericDateFormatter.stringFromDate(jsonDateObj)){
                newWeather.day = "Today"
            }
            else if( numericDateFormatter.stringFromDate( jsonDateObj ) ==  numericDateFormatter.stringFromDate(tomorrowDate) ){
                newWeather.day = "Tomorrow"
            }
            else{
                let dateFormatter : NSDateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "EEEE"
                newWeather.day = dateFormatter.stringFromDate(jsonDateObj)
            }
        }
        return newWeather
        
    }
    
    private func parseWeather(jsonDict : [String : AnyObject] ) -> Weather {
        var newWeather = Weather()
        if let tempDict = jsonDict["main"] as? [ String: AnyObject ]{
            newWeather.highTemp = tempDict["temp"] as? Float
            newWeather.lowTemp = tempDict["temp_min"] as? Float
        }else{
            newWeather.highTemp = 110
            newWeather.lowTemp = 10
        }
        if let weatherDict = jsonDict["weather"] as? [[ String : AnyObject ]]{
            newWeather.desc = weatherDict[0]["main"] as? String
            newWeather.icon = weatherDict[0]["icon"] as? String
        }
        if let timeResult = (jsonDict["dt"] as? Double) {
            let dateObj = NSDate(timeIntervalSince1970: timeResult)
            let dateFormatter : NSDateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMM dd"
            newWeather.day = dateFormatter.stringFromDate(dateObj)
        }
        return newWeather
        
    }
    
    
    
    func fetchForecasts(callback : ([Weather]) -> Void){
        let url = NSURL(string: "http://api.openweathermap.org/data/2.5/forecast/daily?q=Atlanta&mode=json&units=imperial&cnt=7&APPID=1d04e62091eabb4695bb6e9993976418")
        let request = NSURLRequest(URL: url!)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){ data, response, err in
            guard let responseData = data else{
                print("Error: no data received from forecasts call")
                return
            }
            if err == nil {
                //Processing code goes here
                var WeatherList = [Weather]()
                do{
                    if let jsonResultsObj : AnyObject = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.AllowFragments) {
                        if let forecastList = jsonResultsObj["list"] as? [ [String : AnyObject] ]{
                            for jsonDict in forecastList {
                                let newWeather = self.parseForecast(jsonDict)
                                WeatherList.append(newWeather)
                            }
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                callback(WeatherList)
                            })
                            
                        }
                    }
                }
                catch{
                    //We got an error
                    callback([])
                }
            }
            else {
                //Got an erro, so print it out
                print("Got an error: \(err)")
            }
        }
        task.resume()
    }
    
    func fetchWeather(callback : (Weather?) -> Void){
        let url = NSURL(string: "http://api.openweathermap.org/data/2.5/weather?q=Atlanta&units=imperial&APPID=1d04e62091eabb4695bb6e9993976418")
        let request = NSURLRequest(URL: url!)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){ data, response, err in
            guard let responseData = data else{
                print("Error: no data received for daily weather")
                return
            }
            if err == nil {
                do{
                    if let jsonResultsDict : [String : AnyObject] = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.AllowFragments) as? [String : AnyObject] {
                        let newWeather = self.parseWeather(jsonResultsDict)
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            callback(newWeather)
                        })
                    }
                }
                catch{
                    callback(nil)
                }
            }
            else{
                print("Got an error: \(err)")
            }
        }
        task.resume()
    }
    
}