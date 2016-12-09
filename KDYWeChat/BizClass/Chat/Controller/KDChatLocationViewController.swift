//
//  KDChatLocationViewController.swift
//  KDYWeChat
//
//  Created by mac on 16/11/1.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


/// 地理位置页面
class KDChatLocationViewController: UIViewController {
    
    var mapView: MKMapView!
    
    var annotation: MKPointAnnotation!
    
    var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 5
        
        return locationManager
    }()
    
    var locationCoordinate: CLLocationCoordinate2D!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "位置"
        self.view.backgroundColor = UIColor.white
        
        // 导航栏按钮
        seupBarButtonItems()
        
        self.mapView = MKMapView(frame: self.view.bounds)
        self.mapView.mapType = .standard
        self.mapView.isZoomEnabled = true
        self.mapView.showsUserLocation = true
        self.mapView.userTrackingMode = .follow
        self.view.addSubview(mapView)
        
        self.mapView.delegate = self
        self.locationManager.delegate = self
        
        if Float(UIDevice.current.systemVersion) >= 8.0 {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.locationManager.stopUpdatingLocation()
    }
    
    func seupBarButtonItems() {
        let leftBarItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(leftBarButtonAction))
        self.navigationItem.leftBarButtonItem = leftBarItem
        
        let rightBarItem = UIBarButtonItem(title: "确定", style: .plain, target: self, action: #selector(rightBarButtonAction))
        self.navigationItem.rightBarButtonItem = rightBarItem
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    // MARK: - Event Response 
    func leftBarButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func rightBarButtonAction() {
        // 当定位成功后，设置确定按钮可用
        
    }
}

// MARK: - MKMapViewDelegate
extension KDChatLocationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation.location!) { (array, error) in
            if (error == nil) {
                let placemark: CLPlacemark = (array?.first)!
                print("addressString = \(placemark.name)")
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didFailToLocateUserWithError error: Error) {
        
    }
}

// MARK: - CLLocationManagerDelegate
extension KDChatLocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        let location = locations.first
        print("纬度 = \(location?.coordinate.latitude)，经度 = \(location?.coordinate.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error = \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch (status) {
        case .notDetermined: print("用户未决定")
        case .denied:
            // 判断定位服务被拒绝
            if CLLocationManager.locationServicesEnabled() {
                if let url = URL(string: UIApplicationOpenSettingsURLString) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.openURL(url)
                    }
                }
                
            } else {
                print("没有开始定位功能")
            }
        default:
            break;
        }
    }
}

