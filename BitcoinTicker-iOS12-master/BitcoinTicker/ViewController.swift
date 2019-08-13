//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let simbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL = ""
    var finalSimbol = ""

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }

    
    //TODO: Place your 3 UIPickerView delegate methods here
    // numero de colunas que o pickerView terá
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // numero de linhas do pickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + currencyArray[row]
        finalSimbol = simbolArray[row]
        print(finalURL)
        getCurrencyData(url: finalURL, finalSimbol)
    }
    
    
    //MARK: - Networking
    /***************************************************************/
    
    func getCurrencyData(url: String,_ simbol: String ) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {

                    print("Sucess! Got the currency data")
                    let currencyJSON : JSON = JSON(response.result.value!)

                    self.updateCurrencyData(json: currencyJSON, simbol)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updateCurrencyData(json : JSON,_ simbol: String) {
        
        if let currencyResult = json["ask"].double {
            bitcoinPriceLabel.text = simbol+"\(currencyResult)"
        } else {
            bitcoinPriceLabel.text = "Price Unavailable"
        }
    }
    




}
