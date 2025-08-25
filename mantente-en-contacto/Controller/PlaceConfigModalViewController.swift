//
//  PlaceConfigModalViewController.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 23/08/25.
//

import UIKit

class PlaceConfigModalViewController: UIViewController {
    
    @IBOutlet weak var placeTitle: UILabel!
    @IBOutlet weak var placeAddress: UILabel!
    
    var place: Place?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        
        placeTitle.text = place?.name
        placeAddress.text = place?.address
    }

}
