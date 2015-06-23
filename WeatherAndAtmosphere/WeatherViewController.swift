//
//  WeatherViewController.swift
//  WeatherAndAtmosphere
//
//  Created by 池田 俊太郎 on 2015/06/18.
//  Copyright (c) 2015年 池田 俊太郎. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class WeatherViewController: UIViewController,UIWebViewDelegate,CLLocationManagerDelegate {
    // 表示ラベル：地名
    @IBOutlet weak var cityLabel: UILabel!
    // 表示ビュー：天気アイコン
    @IBOutlet weak var iconImageView: UIImageView!
    // 表示ラベル：天気
    @IBOutlet weak var mainLabel: UILabel!
    // 表示ラベル：風速数値
    @IBOutlet weak var speedLabel: UILabel!
    // 表示ラベル：気温
    @IBOutlet weak var tempLabel: UILabel!
    // 表示ラベル：湿度
    @IBOutlet weak var humidityLabel: UILabel!
    // 表示ラベル：降水量
    @IBOutlet weak var rainLabel: UILabel!
    
    // 地名格納変数
    var addressData: String = "Hoge"
    // 現在地の位置情報の取得にはCLLocationManagerを使用
    var lm: CLLocationManager!
    // 取得した緯度を保持するインスタンス
    var latitude: CLLocationDegrees!
    // 取得した経度を保持するインスタンス
    var longitude: CLLocationDegrees!
    
    // weather用、配列と辞書
    var weatherDataArray = NSArray()
    var weatherDataDic = NSDictionary()
    // wind用、辞書
    var windDataDic = NSDictionary()
    // main用、辞書
    var mainDataDic = NSDictionary()
    // rain用、辞書
    var rainDataDic = NSDictionary()
    
    // インディケーター用変数
    var indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // タイトル
        self.title = "Now Weather"
        
        // インディケーターを画面中央に設定
        indicator.center = self.view.center
        // インディケーターのスタイル、色を設定
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        // インディケーターを設置
        self.view.addSubview(indicator)
        
        // フィールドの初期化
        lm = CLLocationManager()
        longitude = CLLocationDegrees()
        latitude = CLLocationDegrees()
        
        // CLLocationManagerをDelegateに指定
        lm.delegate = self
        
        // 位置情報取得の許可を求めるメッセージの表示．必須．
        lm.requestAlwaysAuthorization()
        // 位置情報の精度を指定．任意，
        // lm.desiredAccuracy = kCLLocationAccuracyBest
        // 位置情報取得間隔を指定．指定した値（メートル）移動したら位置情報を更新する．任意．
        // lm.distanceFilter = 1000
        
        // GPSの使用を開始する
        lm.startUpdatingLocation()
    }
    
    // ページの読み込み開始を通知
    func dataDidStartLoad(iconImageView: UIImageView){
        indicator.startAnimating()
    }
    // ページの読み込み終了を通知
    func dataDidFinishLoad(iconImageView: UIImageView){
        indicator.stopAnimating()
    }
    
    /* 位置情報取得成功時に実行される関数 */
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation){
        // 取得した緯度がnewLocation.coordinate.longitudeに格納されている
        latitude = newLocation.coordinate.latitude
        // 取得した経度がnewLocation.coordinate.longitudeに格納されている
        longitude = newLocation.coordinate.longitude
        // 取得した緯度・経度をLogに表示
        NSLog("latiitude: \(latitude) , longitude: \(longitude)")
        
        // get address
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            if error != nil {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                self.displayLocationInfo(pm)
                //stop updating location to save battery life
                self.lm.stopUpdatingLocation()
            } else {
                println("Problem with the data received from geocoder")
            }
        })
        
        // GPSの使用を停止する．停止しない限りGPSは実行され，指定間隔で更新され続ける．
        lm.stopUpdatingLocation()
        
        // 天気情報の取得先
        let requestUrl = "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=metric"
        // println("\(requestUrl)")
        // Webサーバに対してHTTp通信のリクエストを出してデータを取得
        Alamofire.request(.GET,requestUrl).responseJSON {(request, response, json, error) in
            // JSONデータをNSDictionary型に変換
            let jsonDic = json as! NSDictionary
            
            // パージ：weather
            self.weatherDataArray = jsonDic["weather"] as! NSArray
            self.weatherDataDic = self.weatherDataArray[0] as! NSDictionary
            // println("コメントdic：\(self.weatherDataDic)")
            
            var weatherDic:Dictionary = self.weatherDataDic as Dictionary
            
            for (key,value) in weatherDic {
                switch key {
                case "main":
                    println("case main：\(value)")
                    self.mainLabel.text = "\(value)"
                case "icon":
                    println("case icon：\(value)")
                    // 表示する天気画像を設定する
                    // var dataWeatherIcon: AnyObject? = self.weatherDataDic["icon"]
                    let iconUrl = NSURL(string: "http://openweathermap.org/img/w/\(value).png")
                    println("URL用：\(value),\(iconUrl)")
                    var err: NSError?
                    var imageData: NSData = NSData(contentsOfURL: iconUrl!, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)!
                    var iconImg = UIImage(data: imageData)
                    
                    let iv:UIImageView = UIImageView(image:iconImg)
                    iv.frame = CGRectMake(0, 0, 100, 100)
                    self.view.addSubview(iv)
                    // 画像の表示する座標を指定する.
                    iv.layer.position = CGPoint(x: self.view.bounds.width/2-90, y: 165.0)
                default:
                    println("その他")
                }
            }
            // パージ：main
            self.mainDataDic = jsonDic["main"] as! NSDictionary
            var mainDic:Dictionary = self.mainDataDic as Dictionary
            
            for (key,value) in mainDic {
                switch key {
                case "humidity":
                    println("case humidity：\(value)")
                    self.humidityLabel.text = "\(value)%"
                case "temp":
                    // var tempData:Int = Int(value as! NSNumber)
                    var tempData:Double = Double(value as! NSNumber)
                    var tempDataRound = Int(round(tempData))
                    self.tempLabel.text = "\((tempDataRound))℃"
                default:
                    println("")
                }
            }
            // パージ：wind
            self.windDataDic = jsonDic["wind"] as! NSDictionary
            var windDic:Dictionary = self.windDataDic as Dictionary
            
            for (key,value) in windDic {
                switch key {
                case "speed":
                    println("case speed：\(value)")
                    var speedData:Double = Double(value as! NSNumber)
                    var speedDataRound = round(speedData*10)/10.0
                    self.speedLabel.text = "\(speedDataRound)m/s"
                default:
                    println("case deg：\(value)")
                }
            }
            // パージ：rain
            if jsonDic["rain"] == nil {
                println("rain判定：nil")
            } else {
                self.rainDataDic = jsonDic["rain"] as! NSDictionary
                var rainDic:Dictionary = self.rainDataDic as Dictionary
                println("case rain：\(rainDic)")
                var rainData: AnyObject! = rainDic["3h"]
                self.rainLabel.text = "\(rainData)"
            }
        }
    }
    
    /* 位置情報取得失敗時に実行される関数 */
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        // Error表示．
        NSLog("Error")
        let alert = UIAlertView()
        alert.title = "位置情報取得失敗"
        alert.message = "位置情報を許可してください"
        alert.addButtonWithTitle("閉じる")
        alert.show()
    }
    
    // 位置情報表示
    func displayLocationInfo(placemark: CLPlacemark) {
        var address: String = ""
        address = placemark.locality != nil ? placemark.locality : ""
        address += ","
        // address += placemark.administrativeArea != nil ? placemark.administrativeArea : ""
        // address += ","
        address += placemark.country != nil ? placemark.country : ""
        addressData = address
        cityLabel.text = addressData
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
