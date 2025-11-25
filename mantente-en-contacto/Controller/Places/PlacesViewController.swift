//
//  PlacesViewController.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 23/08/25.
//

import CoreLocation
import FirebaseAuth
import FirebaseFirestore
import MapKit
import UIKit

class PlacesViewController: UIViewController, CLLocationManagerDelegate,
    MKMapViewDelegate
{

    private let map = MKMapView()
    private let manager = CLLocationManager()
    private var hasCenteredOnce = false
    private var myCoordinates: CLLocationCoordinate2D!
    private var selectedCoordinates: CLLocationCoordinate2D!
    private var selectedPlaceName: String!
    private let searchController = UISearchController(
        searchResultsController: nil
    )

    private let selectionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Compartir este lugar", for: .normal)
        button.isHidden = true  // lo ocultamos
        button.backgroundColor = .myYellow
        return button
    }()

    // MARK: Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Lugares compartidos"

        // location manager
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters

        // mapa
        map.frame = view.bounds
        map.delegate = self
        map.showsUserLocation = true
        map.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(map)

        // serach
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar lugar"
        searchController.searchBar.delegate = self

        // apretar para seleccionar
        let longPress = UILongPressGestureRecognizer(
            target: self,
            action: #selector(handleLongPress(_:))
        )
        longPress.minimumPressDuration = 0.7
        map.addGestureRecognizer(longPress)

        setupSelectionButton()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let status = manager.authorizationStatus
        handleAuthorizationStatus(status)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // hacemos un refresh
        Task {
            await loadData()
        }
    }

    // MARK: Boton de Seleccion
    private func setupSelectionButton() {
        selectionButton.translatesAutoresizingMaskIntoConstraints = false
        selectionButton.setTitleColor(.black, for: .normal)
        selectionButton.titleLabel?.font = .systemFont(
            ofSize: 18,
            weight: .semibold
        )
        selectionButton.layer.cornerRadius = 12
        selectionButton.contentEdgeInsets = UIEdgeInsets(
            top: 12,
            left: 20,
            bottom: 12,
            right: 20
        )

        view.addSubview(selectionButton)
        selectionButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            selectionButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -16
            ),
            selectionButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            selectionButton.heightAnchor.constraint(equalToConstant: 44),
        ])

        selectionButton.addTarget(
            self,
            action: #selector(selectionButtonTapped),
            for: .touchUpInside
        )
    }

    // MARK: CLLocationManagerDelegate

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            print("Permiso de ubicación denegado")
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.first {
            if !hasCenteredOnce {
                centerMap(in: location)
                hasCenteredOnce = true
            }
            myCoordinates = location.coordinate
        }
    }

    // MARK: Helpers

    private func handleAuthorizationStatus(_ status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            print("Permiso de ubicación denegado")
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }

    private func centerMap(in location: CLLocation) {
        let region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
        map.setRegion(region, animated: true)
    }

    private func setSelectedPlace(
        at coordinate: CLLocationCoordinate2D,
        title: String?
    ) {
        // eliminamos los pines de seleccion
        let selectionPins = map.annotations.filter { $0 is SelectionAnnotation }
        map.removeAnnotations(selectionPins)

        let annotation = SelectionAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title ?? "Lugar seleccionado"
        map.addAnnotation(annotation)

        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
        map.setRegion(region, animated: true)

        selectionButton.isHidden = false
        selectedPlaceName = title ?? ""
        selectedCoordinates = coordinate
    }

    private func loadData() async {
        let db = Firestore.firestore()
        guard let userId = Auth.auth().currentUser?.uid else {
            showAlert(message: "You must be logged in to create a place.")
            return
        }

        do {
            // borramos los pines
            let placePins = map.annotations.compactMap { $0 as? MyPlacesAnnotation }
            map.removeAnnotations(placePins)
            
            let query = try await db.collection("places").whereField(
                "userId",
                isEqualTo: userId
            ).getDocuments()

            for document in query.documents {
                // creamos un place
                let place = try document.data(as: Place.self)
                print("loaded polace", place.name)

                let coordinate = CLLocationCoordinate2D(
                    latitude: place.latitude,
                    longitude: place.longitude
                )

                let annotation = MyPlacesAnnotation()
                annotation.coordinate = coordinate
                annotation.title = place.name
                map.addAnnotation(annotation)
            }

        } catch {
            showAlert(
                message:
                    "There was an error polling information about your places."
            )
        }
    }
    
    

    // MARK: Acciones

    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer)
    {
        if gesture.state == .began {
            let point = gesture.location(in: map)
            let coordinate = map.convert(point, toCoordinateFrom: map)

            setSelectedPlace(at: coordinate, title: "Lugar seleccionado")
        }
    }

    @objc private func selectionButtonTapped() {
        performSegue(withIdentifier: "addPlace", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addPlace" {
            if let dest = segue.destination as? AddPlaceViewController {
                dest.coordinates = self.selectedCoordinates
                dest.placeName = self.selectedPlaceName
            }
        }
    }

}

// MARK: Busqueda con Search Bar
extension PlacesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        // Buscamos en lugares alrededor de nosotros
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: myCoordinates.latitude,
                longitude: myCoordinates.longitude
            ),
            latitudinalMeters: 10000,
            longitudinalMeters: 10000
        )
        request.region = region

        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard
                let self = self,
                let response = response,
                let first = response.mapItems.first
            else { return }

            let coordinate = first.placemark.coordinate
            let name = first.name

            // Usamos la MISMA lógica que el long press:
            self.setSelectedPlace(at: coordinate, title: name)
        }

        searchBar.resignFirstResponder()
    }
}

// MARK: Personalizacion de los pines

extension PlacesViewController {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation)
        -> MKAnnotationView?
    {

        if annotation is MKUserLocation {
            return nil
        }

        let identifier = "MyPlacePin"
        var annotationView =
            mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView

        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(
                annotation: annotation,
                reuseIdentifier: identifier
            )
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }

        if let myAnnotation = annotation as? MyPlacesAnnotation {
            annotationView?.markerTintColor = myAnnotation.color
        }

        return annotationView
    }

}
