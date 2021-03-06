//
//  FBQuadTree.swift
//  FBAnnotationClusteringSwift
//
//  Created by Robert Chen on 4/2/15.
//  Copyright (c) 2015 Robert Chen. All rights reserved.
//

import Foundation
import MapKit

open class FBQuadTree {
    
    let rootNode = FBQuadTreeNode(boundingBox: FBBoundingBox(mapRect: MKMapRectWorld))

	// MARK: Internal functions
    
    func insert(annotation: MKAnnotation) -> Bool {
        return insert(annotation: annotation, toNode:rootNode)
    }

    func remove(annotation: MKAnnotation) -> Bool {
        return remove(annotation: annotation, fromNode:rootNode)
    }

    func enumerateAnnotations(inBox box: FBBoundingBox, callback: (MKAnnotation) -> Void) {
		enumerateAnnotations(inBox: box, withNode:rootNode, callback: callback)
    }
    
    func enumerateAnnotationsUsingBlock(_ callback: (MKAnnotation) -> Void) {
		enumerateAnnotations(inBox: FBBoundingBox(mapRect: MKMapRectWorld), withNode:rootNode, callback:callback)
    }

	// MARK: Private functions
    private func remove(annotation: MKAnnotation, fromNode node: FBQuadTreeNode) -> Bool {
        if node.remove(annotation: annotation) {
            return true
        }
        
        if let northEast = node.northEast {
            if remove(annotation: annotation, fromNode: northEast) {
            return true
            }
        }
        
        if let northWest = node.northWest {
            if remove(annotation: annotation, fromNode: northWest) {
                return true
            }
        }

        if let southEast = node.southEast {
            if remove(annotation: annotation, fromNode: southEast) {
                return true
            }
        }

        if let southWest = node.southWest {
            if remove(annotation: annotation, fromNode: southWest) {
                return true
            }
        }

        return false
    }

	private func insert(annotation: MKAnnotation, toNode node: FBQuadTreeNode) -> Bool {
		if !node.boundingBox.contains(coordinate: annotation.coordinate) {
			return false
		}

		if node.canAppendAnnotation() {
			return node.append(annotation: annotation)
		}

		let siblings = node.siblings() ?? node.createSiblings()

		if insert(annotation: annotation, toNode:siblings.northEast) {
			return true
		}

		if insert(annotation: annotation, toNode:siblings.northWest) {
			return true
		}

		if insert(annotation: annotation, toNode:siblings.southEast) {
			return true
		}

		if insert(annotation: annotation, toNode:siblings.southWest) {
			return true
		}

		return false
	}

    private func enumerateAnnotations(inBox box: FBBoundingBox, withNode node: FBQuadTreeNode, callback: (MKAnnotation) -> Void) {
        if !node.boundingBox.intersects(box2: box) {
            return
        }

        if box ==  FBBoundingBox(mapRect: MKMapRectWorld) {
            node.annotations.forEach { callback($0) }
        } else {
            node.annotations.forEach {
                if box.contains(coordinate: $0.coordinate) {
                    callback($0)
                }
            }
        }

        if node.isLeaf() {
            return
        }

		if let northEast = node.northEast {
			enumerateAnnotations(inBox: box, withNode: northEast, callback: callback)
		}

		if let northWest = node.northWest {
			enumerateAnnotations(inBox: box, withNode: northWest, callback: callback)
		}

		if let southEast = node.southEast {
			enumerateAnnotations(inBox: box, withNode: southEast, callback: callback)
		}

		if let southWest = node.southWest {
			enumerateAnnotations(inBox: box, withNode: southWest, callback: callback)
		}
    }
}
