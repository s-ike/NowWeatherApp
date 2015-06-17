//
//  WeatherViewController.swift
//  WeatherAndAtmosphere
//
//  Created by 池田 俊太郎 on 2015/06/18.
//  Copyright (c) 2015年 池田 俊太郎. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var cityLabel: UILabel!
    var addressData: String = "Hoge"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cityLabel.text = addressData
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
