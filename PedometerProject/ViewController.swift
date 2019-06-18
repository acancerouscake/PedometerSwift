//
//  ViewController.swift
//  PedometerProject
//
//  Created by Zewu Chen on 17/06/19.
//  Copyright © 2019 Zewu Chen. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var lblPassos: UILabel!
    @IBOutlet weak var lblDistancia: UILabel!
    @IBOutlet weak var lblAviso: UILabel!
    
    @IBOutlet weak var pickerViewTime: UIPickerView!
    @IBOutlet weak var pickerViewNumber: UIPickerView!
    
    var pickerDataTime: [String] = []
    var pickerDataNumber: [String] = []
    var tempo:[Calendar.Component] = [.hour, .day]
    var auxTempo:Calendar.Component = .hour
    var auxValue:Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        
        self.pickerViewTime.delegate = self
        self.pickerViewTime.dataSource = self
        
        self.pickerViewNumber.delegate = self
        self.pickerViewNumber.dataSource = self
        
        pickerDataTime = ["Hour", "Day"]
        pickerDataNumber = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerViewTime{
            return pickerDataTime.count
        }else if pickerView == pickerViewNumber{
            return pickerDataNumber.count
        }
        else{
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerViewTime{
            return pickerDataTime[row]
        }else if pickerView == pickerViewNumber{
            return pickerDataNumber[row]
        }
        else{
            return "Erro"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerViewTime{
            auxTempo = tempo[row]
            getData()
        }else if pickerView == pickerViewNumber{
            if let a = Int(pickerDataNumber[row]){
                auxValue = a * -1
                getData()
            }
        }
        else{
            print("Deu erro ao selecionar o valor do picker: \(pickerView)")
        }
    }
    
    let pedometer = CMPedometer()
    
    func getData(){
        let date = Date()
        let dateAnt = Calendar.current.date(byAdding: auxTempo, value: auxValue, to: Date())
        
        if let dateAntes = dateAnt{
            pedometer.queryPedometerData(from: dateAntes, to: date) { (dados, erros) in
                guard let data = dados, erros == nil else { return }

                DispatchQueue.main.async {
                    self.lblPassos.text = data.numberOfSteps.stringValue
                    if let a = data.distance?.stringValue{
                        var texto = a.split(separator: ".")
                        self.lblDistancia.text =  String(Int(texto[0].description)! / 1000) + " KM"
                        self.lblAviso.text = "VOCÊ PODIA TER CONTADO \(String(texto[0])) METROS NO PÓKEMON GO"
                    }
                }
                
            }
        }
        
        
    }

}

