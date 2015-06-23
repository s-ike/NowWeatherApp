//
//  ViewController.swift
//  WeatherAndAtmosphere
//
//  Created by S.Ikeda on 2015/06/17.
//  Copyright (c) 2015年 S.Ikeda. All rights reserved.
//

import UIKit
// import CoreLocation

class ViewController: UIViewController {

    @IBAction func getButton(sender: AnyObject) {
        // SegueのIDを引数にして画面遷移
        performSegueWithIdentifier("toWeather", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // タイトル
        self.title = "Get Now Weather"
    }
}

