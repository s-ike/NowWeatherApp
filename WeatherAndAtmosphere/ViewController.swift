//
//  ViewController.swift
//  WeatherAndAtmosphere
//
//  Created by 池田 俊太郎 on 2015/06/17.
//  Copyright (c) 2015年 池田 俊太郎. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // 取得ラベル
    var getButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 取得ボタンのフレーム設定
        getButton.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        // 取得ボタンの背景色
        getButton.backgroundColor = UIColor.orangeColor()
        // 取得ボタンの角丸
        getButton.layer.masksToBounds = true
        getButton.layer.cornerRadius = 100.0
        // 取得ボタンのフォントと文字サイズ
        getButton.titleLabel?.font = UIFont.systemFontOfSize(CGFloat(30))
        // 取得ボタンのタイトルと色を設定：通常時
        getButton.setTitle("取得", forState:UIControlState.Normal)
        getButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        // 取得ボタンの色を設定：ボタンがハイライト
        getButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        // 取得ボタンの位置を指定
        getButton.layer.position = CGPoint(x: self.view.bounds.width/2, y: 200)
        // 取得ボタンのタグを設定
        getButton.tag = 1
        // 取得ボタンをViewに追加
        self.view.addSubview(getButton)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

