//
//  dataManager.swift
//  alwaysSunny
//
//  Created by Yohsuke Yamakawa on 12/9/15.
//  Copyright © 2015 DigitalCrafts. All rights reserved.
//

import Foundation

import Foundation


struct dataManager {
    static let sharedManager = dataManager()
    
    
    func loadForecasts() -> [Weather]? {
        var forecasts = [Weather]()
        
        for var i = 0; i < 10; i++ {
            var w = Weather()
            w.day = "1430326800"
            w.highTemp = 53
            w.lowTemp = 41
            w.icon  = "10n"
            forecasts.append(w)
        }
        
        return forecasts
    }
    
}