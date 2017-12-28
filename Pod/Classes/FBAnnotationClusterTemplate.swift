//
//  FBAnnotationClusterTemplate.swift
//  FBAnnotationClusteringSwift
//
//  Created by Antoine Lamy on 23/9/2016.
//  Copyright (c) 2016 Antoine Lamy. All rights reserved.
//

import Foundation

public enum FBAnnotationClusterDisplayMode {
	case solidColor(sideLength: CGFloat, color: UIColor)
	case image(sideLength: CGFloat, url: URL?)
}

public struct FBAnnotationClusterTemplate {
    public static let defaultColor = UIColor(red: 47.0/255.0,
                                             green: 125.0/255.0,
                                             blue: 255.0/255.0,
                                             alpha: 1.0)
    
    let range: Range<Int>?
    public var displayMode = FBAnnotationClusterDisplayMode.solidColor(sideLength: 50.0,
                                                                       color: FBAnnotationClusterTemplate.defaultColor)

	public var borderWidth: CGFloat = 0

	public var fontSize: CGFloat = 15
	public var fontName: String?

	public var font: UIFont? {
		if let fontName = fontName {
			return UIFont(name: fontName, size: fontSize)
		} else {
			return UIFont.boldSystemFont(ofSize: fontSize)
		}
	}

	public init(range: Range<Int>?, displayMode: FBAnnotationClusterDisplayMode) {
		self.range = range
		self.displayMode = displayMode
	}

    public init (range: Range<Int>?, sideLength: CGFloat, color: UIColor? = nil) {
        self.init(range: range, displayMode: .solidColor(sideLength: sideLength,
                                                         color: color ?? FBAnnotationClusterTemplate.defaultColor))
    }
}
