//
//  MapView.swift
//  Frippy_finall
//
//  Created by Mac Mini 6 on 18/5/2023.
//

import SwiftUI
import MapKit


struct MapView : UIViewRepresentable
{
  let manager = LocationManager()
let mapView = MKMapView()
    @StateObject var locationviewModel = LocationSearchModel()
 
    func makeUIView(context: Context) -> some UIView {
        mapView .delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.setRegion(manager.region, animated: true)
        return mapView
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if let selectedLocation = locationviewModel.selectedLocationCoordinate
        {
            context .coordinator.addAndSelectAnnotation(withCoordinate: selectedLocation)
            context .coordinator.configurePolyline(withDestinationCoordinate: selectedLocation)
            print("selected in mapview generator \(selectedLocation)")
        }
    }
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
}
extension MapView {
    class MapCoordinator:NSObject,MKMapViewDelegate
    {let searchmodel = LocationSearchModel()
        var userlocationCoordinate : CLLocationCoordinate2D?
        let parent:MapView
        init(parent: MapView) {
            self.parent = parent
            super.init()
        }
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.userlocationCoordinate = userLocation.coordinate
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            parent.mapView.setRegion(region, animated: true)
        }
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let line = MKPolylineRenderer(overlay: overlay)
            line.strokeColor = .systemBlue
            line.lineWidth = 6
            return line
        }
        func addAndSelectAnnotation(withCoordinate coordinate:CLLocationCoordinate2D)
        {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            
           parent.mapView.addAnnotation(annotation)
            //parent.mapView.selectAnnotation(annotation, animated: true)
            
            parent.mapView.showAnnotations(parent.mapView.annotations, animated: true)
        }
        func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
            if let title = annotation.title {
                let alertController = UIAlertController(title: title, message: "Do you want to go to this location?", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alertController.addAction(UIAlertAction(title: "Go Now!", style: .default, handler: { _ in
                  
                    
                //    self.searchmodel.userlocationTitle() HELPPPPPP
                    
                      
                }))
                if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                    if let rootViewController = window.rootViewController {
                        rootViewController.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }




        func configurePolyline(withDestinationCoordinate coordinate : CLLocationCoordinate2D)

        {
            guard let userlocation = self.userlocationCoordinate else {return }
            getDestinationRoute(from:userlocation , to: coordinate) { route in
                self.parent.mapView.addOverlay(route.polyline)
                //self.parent.
            }
        }
        func getDestinationRoute(from userLocation:CLLocationCoordinate2D,to destination:CLLocationCoordinate2D,completion:@escaping(MKRoute)->Void)
        {
            let userPlaceMark = MKPlacemark(coordinate: userLocation)
            let destPlaceMark = MKPlacemark(coordinate: destination)
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: userPlaceMark)
            request.destination = MKMapItem(placemark: destPlaceMark)
            request.transportType = .automobile
            request.requestsAlternateRoutes = true
            let directions = MKDirections(request: request)
            directions.calculate{
                response,error in
                if let error = error {
                    print("error in directions getdestinationRoute fnc \(error)")
                    return
                }
                guard let route = response?.routes.first else {
                    return
                }
                completion(route)
            }
        }
    }
}
