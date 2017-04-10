//
//  FBAnnotationCluster.swift
//  FBAnnotationClusteringSwift
//
//  Created by Robert Chen on 4/2/15.
//  Copyright (c) 2015 Robert Chen. All rights reserved.
//

import Foundation
import MapKit

open class FBAnnotationCluster: NSObject {
    
    open var coordinate = CLLocationCoordinate2D()
    open var title: String?
    open var subtitle: String?
    
    open var annotations: [MKAnnotation] = []
    open var clusterRect: MKMapRect {
        var rect = MKMapRectNull
        annotations.forEach {
            rect = MKMapRectUnion(rect, MKMapRect(origin: MKMapPointForCoordinate($0.coordinate),
                                                  size: MKMapSize(width: 0.0, height: 0.0)))
        }
        return rect
    }
}

extension FBAnnotationCluster : MKAnnotation { }
