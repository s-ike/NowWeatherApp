//
//  ViewController.swift
//  WeatherAndAtmosphere
//
//  Created by 池田 俊太郎 on 2015/06/17.
//  Copyright (c) 2015年 池田 俊太郎. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate {
    // 現在地の位置情報の取得にはCLLocationManagerを使用
    var lm: CLLocationManager!
    // 取得した緯度を保持するインスタンス
    var latitude: CLLocationDegrees!
    // 取得した経度を保持するインスタンス
    var longitude: CLLocationDegrees!
    // 地名
    var addressData: String = ""
    
    var x = "0"
    

    @IBAction func getButton(sender: AnyObject) {
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        x = "2"
        println("地名3：\(addressData)")
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
        
        // SegueのIDを引数にして画面遷移
        performSegueWithIdentifier("weather", sender: nil)
    }
    
    /* 位置情報取得失敗時に実行される関数 */
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        // この例ではLogにErrorと表示するだけ．
        NSLog("Error")
    }
    
    // 位置情報表示
    func displayLocationInfo(placemark: CLPlacemark) {
        var address: String = ""
        address = placemark.administrativeArea != nil ? placemark.administrativeArea : ""
        address += ","
        address += placemark.country != nil ? placemark.country : ""
        addressData = address
                println("地名：\(addressData)")
    }
    

    // 表示画面へ値を渡す
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let wVC = segue.destinationViewController as! WeatherViewController
        println("地名2：\(addressData)")
        wVC.addressData = addressData
    }
    
}

