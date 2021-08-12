//
//  CountryLocationCell.swift
//  Vexillum
//
//  Created by Richard Robinson on 2021-08-11.
//

import Foundation
import UIKit
import MapKit

class CountryLocationCell: UITableViewCell, BindableCell, ReusableView {
  private let mapView = MKMapView()
  private var country: Country!

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
    self.mapView.addGestureRecognizer(tapGesture)

    self.mapView.isZoomEnabled = false
    self.mapView.isScrollEnabled = false

    self.mapView.translatesAutoresizingMaskIntoConstraints = false

    self.contentView.addSubview(self.mapView)

    NSLayoutConstraint.activate([
      self.contentView.heightAnchor.constraint(equalToConstant: 200.0)
    ])

    self.mapView.pinEdges(to: self.contentView)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc private func onTap(_ gesture: UIGestureRecognizer) {
    let placemark = MKPlacemark(coordinate: self.coordinateRegion.center)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = self.country.name.common

    mapItem.openInMaps(launchOptions: [
        MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: self.coordinateRegion.center),
        MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: self.coordinateRegion.span)
    ])
  }

  private var coordinateRegion: MKCoordinateRegion {
    let spanValue = max(-50.0 + 5.0 * log(self.country.area), 5.0)
    let span = MKCoordinateSpan(latitudeDelta: spanValue, longitudeDelta: spanValue)

    return MKCoordinateRegion(center: self.country.coordinates, span: span)
  }

  func bind(to country: Country, for row: Int) {
    self.country = country
    self.mapView.region = self.coordinateRegion
  }
}
