//
//  CarouselViewLayout.swift
//  Character Collector
//
//  Created by Michael Briscoe on 12/9/16.
//  Copyright © 2016 Razeware, LLC. All rights reserved.
//

import UIKit

class CarouselViewLayout: MosaicViewLayout {
  var standardItemAlpha: CGFloat = 0.5
  var standardItemScale: CGFloat = 0.5
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var layoutAttributes = [UICollectionViewLayoutAttributes]()
    for attributes in cache {
      if attributes.frame.intersects(rect) {
        changeLayoutAttributes(attributes)
        layoutAttributes.append(attributes)
      }
    }
    return layoutAttributes
  }
  
  func changeLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes) {    
    let collectionCenter = collectionView!.frame.size.height/2
    let offset = collectionView!.contentOffset.y
    let normalizedCenter = attributes.center.y - offset
    
    let maxDistance = CGFloat(300.0)
    let distance = min(abs(collectionCenter - normalizedCenter), maxDistance)
    let ratio = (maxDistance - distance)/maxDistance
    
    let alpha = ratio * (1 - self.standardItemAlpha) + self.standardItemAlpha
    let scale = ratio * (1 - self.standardItemScale) + self.standardItemScale
    attributes.alpha = alpha
    attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
    attributes.zIndex = Int(alpha * 10)
  }
  
  override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }
  
  override open func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
    
    guard let collectionView = collectionView , !collectionView.isPagingEnabled,
      let layoutAttributes = self.layoutAttributesForElements(in: collectionView.bounds)
      else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset) }
    
    let center = collectionView.bounds.size.height / 2
    let proposedContentOffsetCenterOrigin = proposedContentOffset.y + center
    
    let closest = layoutAttributes.sorted { abs($0.center.y - proposedContentOffsetCenterOrigin) < abs($1.center.y - proposedContentOffsetCenterOrigin) }.first ?? UICollectionViewLayoutAttributes()
    
    let targetContentOffset = CGPoint(x: proposedContentOffset.x, y: floor(closest.center.y - center))
    
    
    return targetContentOffset
  }

  
}
