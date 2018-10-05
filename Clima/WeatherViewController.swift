//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON


class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate{
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    /***Get your own App ID at https://openweathermap.org/appid ****/
    

    //TODO: Declare instance variables here
    
    let locationManager=CLLocationManager()
    let weatherDataModel=WeatherDataModel()
    

    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TODO:Set up the location manager here.
    
        locationManager.delegate=self
    locationManager.desiredAccuracy=kCLLocationAccuracyHundredMeters
        
    locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    
    func getWeatherData (url: String, param: [String:Any]){
        
        Alamofire.request(url, method: .get, parameters: param).responseJSON{
            response in
            if response.result.isSuccess{
                print ("Sucess!!!! Got weather data")
                let weatherJSON: JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
               
                
                
            }
            
            else{
                print("Error\(response.result.error)")
                self.cityLabel.text="Connection Issues"
                
                
            }
            
        }
        
        
    }

    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    
    
   func updateWeatherData(json: JSON){
        
        let tempResult=json["main"]["temp"].double
    
    weatherDataModel.temperature=Int((tempResult!) - 273.15)
    weatherDataModel.city=json["name"].stringValue
    weatherDataModel.condition=json["weather"][0].intValue
    weatherDataModel.weatherIconName=weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
    
    updateUI()
    
    
    
    }
    

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    
    func updateUI(){
        cityLabel.text=weatherDataModel.city
        temperatureLabel.text=String(weatherDataModel.temperature)
        weatherIcon.image=UIImage(named: weatherDataModel.weatherIconName)
        
    }
    
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    
    
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location=locations[locations.count-1]
        if location.horizontalAccuracy>0{
            
            locationManager.stopUpdatingLocation()
            locationManager.delegate=nil
            let latitude=location.coordinate.latitude
            let longitude=location.coordinate.longitude
            
            let params : [String:Any]=["lat" : Float(latitude),"lon" : Float(longitude),"appid" : APP_ID]
            
            getWeatherData(url: WEATHER_URL,param: params)
            
            
        }
        
        
    }
    
    
    
    //Write the didFailWithError method here:
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print (error)
        cityLabel.text="Location Unavailable"
    }
    
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    func userEnteredANewCityName(city:String){
        
        let params: [String:String]=["q":city, "appid":APP_ID]
        
        getWeatherData(url: WEATHER_URL, param: params)
        
    }

    

    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName"{
            
            let destinationVC=segue.destination as! ChangeCityViewController
            destinationVC.delegate=self
        }
    }
    //Write the PrepareForSegue Method here
    
    
    
    
    
}


