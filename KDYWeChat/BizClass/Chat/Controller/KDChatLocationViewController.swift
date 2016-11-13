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
        self.view.backgroundColor = UIColor.whiteColor()
        
        // 导航栏按钮
        seupBarButtonItems()
        
        self.mapView = MKMapView(frame: self.view.bounds)
        self.mapView.mapType = .Standard
        self.mapView.zoomEnabled = true
        self.mapView.showsUserLocation = true
        self.mapView.userTrackingMode = .Follow
        self.view.addSubview(mapView)
        
        self.mapView.delegate = self
        self.locationManager.delegate = self
        
        if Float(UIDevice.currentDevice().systemVersion) >= 8.0 {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.locationManager.stopUpdatingLocation()
    }
    
    func seupBarButtonItems() {
        let leftBarItem = UIBarButtonItem(title: "取消", style: .Plain, target: self, action: #selector(leftBarButtonAction))
        self.navigationItem.leftBarButtonItem = leftBarItem
        
        let rightBarItem = UIBarButtonItem(title: "确定", style: .Plain, target: self, action: #selector(rightBarButtonAction))
        self.navigationItem.rightBarButtonItem = rightBarItem
        self.navigationItem.rightBarButtonItem?.enabled = false
    }
    
    // MARK: - Event Response 
    func leftBarButtonAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func rightBarButtonAction() {
        // 当定位成功后，设置确定按钮可用
        
    }
}

// MARK: - MKMapViewDelegate
extension KDChatLocationViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation.location!) { (array, error) in
            if (error == nil) {
                let placemark: CLPlacemark = (array?.first)!
                print("addressString = \(placemark.name)")
            }
        }
    }
    
    func mapView(mapView: MKMapView, didFailToLocateUserWithError error: NSError) {
        
    }
}

// MARK: - CLLocationManagerDelegate
extension KDChatLocationViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        let location = locations.first
        print("纬度 = \(location?.coordinate.latitude)，经度 = \(location?.coordinate.longitude)")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error = \(error.localizedDescription)")
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch (status) {
        case .NotDetermined: print("用户未决定")
        case .Denied:
            // 判断定位服务被拒绝
            if CLLocationManager.locationServicesEnabled() {
                if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
                    if UIApplication.sharedApplication().canOpenURL(url) {
                        UIApplication.sharedApplication().openURL(url)
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

