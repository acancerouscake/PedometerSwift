//
//  ViewController.swift
//  PedometerProject
//
//  Created by Zewu Chen on 17/06/19.
//  Copyright © 2019 Zewu Chen. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet weak var lblPassos: UILabel!
    @IBOutlet weak var lblDistancia: UILabel!
    @IBOutlet weak var lblAviso: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    let pedometer = CMPedometer()
    
    func getData(){
        let date = Date()
        let dateAnt = Calendar.current.date(byAdding: .hour, value: -6, to: Date())
        
        if let dateAntes = dateAnt{
            pedometer.queryPedometerData(from: dateAntes, to: date) { (dados, erros) in
                guard let data = dados, erros == nil else { return }

                DispatchQueue.main.async {
                    self.lblPassos.text = data.numberOfSteps.stringValue
                    if let a = data.distance?.stringValue{
                        var texto = a.split(separator: ".")
                        self.lblDistancia.text =  String(Double(texto[0].description)! / 1000) + " km"
                        self.lblAviso.text = "VOCÊ PODIA TER CONTADO \(String(texto[0])) METROS NO PÓKEMON GO"
                    }
                }
                
            }
        }
        
        
    }

}

