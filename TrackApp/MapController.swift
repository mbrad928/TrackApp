//
//  MapController.swift
//  TrackApp
//
//  Created by Max Bradley on 7/22/16.
//  Copyright © 2016 Max Bradley. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class MapController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    let rootRef = FIRDatabase.database().reference()
    var regions = [CLCircularRegion]()
    let locationMgr = CLLocationManager()
    var regionEntered = false
    var trackName = ""
    var newRegion:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(500, 500), radius: 500, identifier: "nil")
    
    /* Called when View loads */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupLocationInfo()
    }
    
    override func viewDidAppear(animated: Bool) {
        mapView.removeOverlays(mapView.overlays)
        let tabBarController = self.tabBarController as! TabBarController
        self.trackName = tabBarController.selectedTrack
        if(trackName != ""){
            setupRegions()
        }

    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* Called by viewDidLoad(). Sets location settings and starts getting location of user */
    func setupLocationInfo(){
        locationMgr.delegate = self
        locationMgr.desiredAccuracy = kCLLocationAccuracyBest
        locationMgr.requestWhenInUseAuthorization()
        locationMgr.startUpdatingLocation()
        setupMapInfo()
    }
    
    /* Called by setupLocationInfo(). Sets map settings */
    func setupMapInfo(){
        
        mapView.delegate = self
        mapView.mapType = MKMapType.Satellite
        self.mapView.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true);
        
        
    }
    
    
    /* Called by start(). Gets regions for current track from Firebase and overlays circles on map */
    func setupRegions(){
        let trackRef = rootRef.child("Tracks").child(trackName)
        trackRef.observeEventType(.Value, withBlock: { snapshot in
            var regs = [CLCircularRegion]()
            for region in snapshot.children{
                let desc = region.childSnapshotForPath("Description").value as! String
                let lat = region.childSnapshotForPath("Latitude").value as! Double
                let lon = region.childSnapshotForPath("Longitude").value as! Double
                let radius = region.childSnapshotForPath("Radius").value as! Double
                let coord = CLLocationCoordinate2DMake(lat, lon)
                let newRegion = CLCircularRegion(center: coord, radius: radius, identifier: desc)
                regs.append(newRegion)
                let circle = MKCircle(centerCoordinate: coord, radius: radius)
                self.mapView.addOverlay(circle)
            }
            self.regions = regs
            }, withCancelBlock: { error in
                print(error.description)
        })
    }
    
    /* Called to when an overlay is added to map */
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.strokeColor = UIColor.redColor()
        circleRenderer.lineWidth = 1.0
        return circleRenderer
    }
    
    /* Called each time user location is updated. Checks to see if user has entered the next region */
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        if(!regions.isEmpty) {
            
            if (newRegion.center.latitude == 500){ /*find next region */
                for region in regions {
                    if region.containsCoordinate(newLocation.coordinate) {
                        newRegion = region
                        break
                    }
                }
            }
            if(regionEntered == false && newRegion.center.latitude != 500 && newRegion.containsCoordinate(newLocation.coordinate)){
                regionEntered = true
                NSLog("region entered")
                let alertController = UIAlertController(title: "Entered Region", message:
                    newRegion.identifier, preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            } else if(regionEntered == true && newRegion.center.latitude != 500 && !newRegion.containsCoordinate(newLocation.coordinate)){
                regionEntered = false
                NSLog("region exited")
                /* reset region to placeholder */
                newRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(500, 500), radius: 500, identifier: "nil")
                
            }
        }
    }
    
    /* Segue function for TrackSelection modal view */
    @IBAction func cancelToMapController(segue:UIStoryboardSegue) {
    }
    /* Segue function for TrackSelection modal view */
    @IBAction func continueToMapController(segue:UIStoryboardSegue) {
        if let trackSelectionController = segue.sourceViewController as? TrackSelectionController {
            trackName = trackSelectionController.selectedTrack
        }
    }
    
    
}
