//
//  PlacesViewController.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 23/08/25.
//

import UIKit

struct PlaceHelp {
    let name: String
    let address: String
    let photo: String?
}

class PlacesViewController: UIViewController {
    
    @IBOutlet weak var indicatorContainer: UIView!
    
    private let placeInfo = PlaceHelp(name: "Erick's work", address: "De La Paz Avenue 1234", photo: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicatorContainer.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        
        indicatorContainer.layer.borderWidth = 2
        indicatorContainer.layer.borderColor = UIColor.white.withAlphaComponent(0.8).cgColor
        indicatorContainer.layer.cornerRadius = 10
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleOnTapGesture(_ sender: Any) {
        self.performSegue(withIdentifier: "showPlaceConfig", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! PlaceConfigModalViewController
        destinationViewController.place = placeInfo
    }
    
}
