//
//  ViewController.swift
//  alwaysSunny
//
//  Created by Yohsuke Yamakawa on 11/30/15.
//  Copyright © 2015 DigitalCrafts. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    var forecasts : [Weather]?
    var todayWeather : Weather?
    
    @IBOutlet weak var dayDateLabel: UILabel!
    
    @IBOutlet weak var dayHighTempLabel: UILabel!
    
    @IBOutlet weak var dayLowTempLabel: UILabel!
    
    @IBOutlet weak var dayDescLabel: UILabel!
    
    @IBOutlet weak var dayIconImageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.dataSource = self
        let wsm = WebServiceManager()
        wsm.fetchForecasts{(newForecasts) -> Void in
            self.forecasts = [Weather]()
            for forecast in newForecasts{
                self.forecasts?.append(forecast)
            }
            self.tableView.reloadData()
        }
        wsm.fetchWeather({(newWeather) -> Void in
            self.todayWeather = newWeather
            self.dayDateLabel.text = "Today, \((self.todayWeather?.day)!)"
            self.dayDescLabel.text = self.todayWeather?.desc
            if let lowTemp = self.todayWeather?.lowTemp{
                self.dayLowTempLabel.text = "\(Int(lowTemp))º"
            }
            if let highTemp = self.todayWeather?.highTemp{
                self.dayHighTempLabel.text = "\(Int(highTemp))º"
            }
            self.dayIconImageView.image = UIImage(named: "\(self.todayWeather!.icon!)")
            
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.forecasts?.count{
            return count
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let forecast = self.forecasts![indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("forecastCellReuseID", forIndexPath: indexPath) as? forecastTableViewCell{
            cell.cellDayLabel.text = forecast.day
            cell.cellDescLabel.text = forecast.desc
            cell.cellHighTempLabel.text = "\(Int(forecast.highTemp!))º"
            cell.cellLowTempLabel.text = "\(Int(forecast.lowTemp!))º"
            cell.cellIconImageView.image = UIImage(named: "\(forecast.icon!)-icon")
            return cell
            
        }
        
        return UITableViewCell()
    }


}

