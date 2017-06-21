//
//  ViewController.swift
//  FBAnnotationClusteringSwift
//
//  Created by Robert Chen on 4/2/15.
//  Copyright (c) 2015 Robert Chen. All rights reserved.
//

import UIKit
import MapKit
import FBAnnotationClusteringSwift

class FBViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    fileprivate let clusteringManager = FBClusteringManager()
    
    fileprivate let numberOfLocations = 1000
    fileprivate var randomLocations: [FBAnnotation] {
        var array:[FBAnnotation] = []
        for _ in 0...numberOfLocations - 1 {
            let a = FBAnnotation()
            a.coordinate = CLLocationCoordinate2D(latitude: drand48() * 40 - 20, longitude: drand48() * 80 - 40 )
            array.append(a)
        }
        return array
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        clusteringManager.add(annotations: randomLocations)
        clusteringManager.delegate = self;

        mapView.centerCoordinate = CLLocationCoordinate2DMake(0, 0)
    }
    
    @IBAction func touchReset(_ sender: Any) {
        clusteringManager.removeAll()
        clusteringManager.add(annotations: randomLocations)
        mapView.centerCoordinate = CLLocationCoordinate2DMake(0, 0)
    }
    
    @IBAction func touchRemove(_ sender: Any) {
        var points = [MKAnnotation]()
        let upper = clusteringManager.annotations.count < 100 ? clusteringManager.annotations.count : 100
        for _ in 0...100 {
            points.append(clusteringManager.annotations[Int.random(lower: 0, upper: upper)])
        }

        print("\(Date().logString()) touchRemove - call")
        clusteringManager.remove(annotations: points)
        print("\(Date().logString()) touchRemove - finish")
        
        mapView.centerCoordinate = CLLocationCoordinate2DMake(0, 0)
    }
    
    @IBAction func touchGetAll(_ sender: Any) {
        print("\(Date().logString()) touchGetAll - call")

        let points = clusteringManager.annotations
        
        print("\(Date().logString()) touchGetAll - finish")
        print("\(points.count)")
    }
}

extension FBViewController : FBClusteringManagerDelegate {
 
    func cellSizeFactor(forCoordinator coordinator:FBClusteringManager) -> CGFloat {
        return 1.0
    }
}


extension FBViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {

		DispatchQueue.global(qos: .userInitiated).async {
			let mapBoundsWidth = Double(self.mapView.bounds.size.width)
			let mapRectWidth = self.mapView.visibleMapRect.size.width
			let scale = mapBoundsWidth / mapRectWidth

			let annotationArray = self.clusteringManager.clusteredAnnotations(withinMapRect: self.mapView.visibleMapRect,
			                                                                  zoomScale:scale)

			DispatchQueue.main.async {
				self.clusteringManager.display(annotations: annotationArray, onMapView:self.mapView)
			}
		}

    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var reuseId = ""
        
        if annotation is FBAnnotationCluster {
            reuseId = "Cluster"
            var clusterView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
			if clusterView == nil {
				clusterView = FBAnnotationClusterView(annotation: annotation,
				                                      reuseIdentifier: reuseId,
				                                      configuration: FBAnnotationClusterViewConfiguration.default())
			} else {
				clusterView?.annotation = annotation
			}

            return clusterView
        } else {
            reuseId = "Pin"
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
			if pinView == nil {
				pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
				pinView?.pinTintColor = UIColor.green
			} else {
				pinView?.annotation = annotation
			}
            
            return pinView
        }
    }
    
}
