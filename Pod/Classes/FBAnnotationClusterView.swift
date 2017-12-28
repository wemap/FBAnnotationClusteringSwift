//
//  FBAnnotationClusterView.swift
//  FBAnnotationClusteringSwift
//
//  Created by Robert Chen on 4/2/15.
//  Copyright (c) 2015 Robert Chen. All rights reserved.
//

import Foundation
import MapKit

open class FBAnnotationClusterView : MKAnnotationView {
	public var configuration: FBAnnotationClusterViewConfiguration

    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.autoresizingMask = [.flexibleWidth]
        label.textAlignment = .center
        label.backgroundColor = .white
        label.textColor = UIColor.darkText
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.baselineAdjustment = .alignCenters
        label.clipsToBounds = true
        return label
    }()

	open override var annotation: MKAnnotation? {
		didSet {
			updateClusterSize()
		}
	}
    
    public convenience init(annotation: MKAnnotation?,
                            reuseIdentifier: String?,
                            configuration: FBAnnotationClusterViewConfiguration){
        self.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
		self.configuration = configuration
		self.setupView()
    }

	public override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
		self.configuration = FBAnnotationClusterViewConfiguration.default
		super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
		self.setupView()
	}

    required public init?(coder aDecoder: NSCoder) {
		self.configuration = FBAnnotationClusterViewConfiguration.default
        super.init(coder: aDecoder)
		self.setupView()
    }
    
    public func setupView() {
		backgroundColor = UIColor.clear
		addSubview(countLabel)
    }

	private func updateClusterSize() {
		if let cluster = annotation as? FBAnnotationCluster {

            let count = cluster.annotations.count
            let template = configuration.templateForCount(count: count)
            
            switch template.displayMode {
            case .image(let sideLength, _):
                backgroundColor = UIColor.clear
                frame = CGRect(origin: frame.origin, size: CGSize(width: sideLength, height: sideLength))
        
                layer.cornerRadius = 0.0
                layer.borderWidth = 0.0
                layer.borderColor = UIColor.clear.cgColor

                countLabel.minimumScaleFactor = 0
                countLabel.backgroundColor = .white
                countLabel.textColor = UIColor.darkText
                countLabel.clipsToBounds = true
                countLabel.autoresizingMask = [.flexibleWidth]

            case .solidColor(let sideLength, let color):
                backgroundColor = color
                frame = CGRect(origin: frame.origin, size: CGSize(width: sideLength, height: sideLength))
                
                layer.cornerRadius = sideLength / 2.0
                layer.borderWidth = template.borderWidth
                layer.borderColor = UIColor.white.cgColor
                
                countLabel.minimumScaleFactor = 2
                countLabel.backgroundColor = .clear
                countLabel.textColor = UIColor.white
                countLabel.clipsToBounds = false
                countLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            }
            
            countLabel.font = template.font
            countLabel.text = "\(count)"
            
            setNeedsLayout()
		}
	}

    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if layer.cornerRadius != 0 {
            countLabel.frame = bounds
        } else {
            countLabel.frame = CGRect(origin: CGPoint(x: bounds.width * 0.65,
                                                      y: 0.0),
                                      size: CGSize(width: bounds.width / 2.0,
                                                   height: 14.0))
            
            if countLabel.frame.width < countLabel.frame.height {
                countLabel.frame.size = CGSize(width: countLabel.frame.height,
                                               height: countLabel.frame.height)
            }
            countLabel.layer.cornerRadius = countLabel.frame.height / 2.0
        }
    }
}
