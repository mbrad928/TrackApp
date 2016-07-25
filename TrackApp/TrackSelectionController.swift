//
//  TrackSelectionController.swift
//  TrackApp
//
//  Created by Max Bradley on 7/22/16.
//  Copyright © 2016 Max Bradley. All rights reserved.
//

import UIKit
import Firebase

class TrackSelectionController: UITableViewController {
    
    
    var trackList = [String]()
    let rootRef = FIRDatabase.database().reference()
    var selectedTrack = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateTable()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackList.count
    }
    
    /* Gets tracks from trackList after populateTableView has updated it */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TrackCell", forIndexPath: indexPath)
        cell.textLabel?.text = trackList[indexPath.item]
        return cell
    }
    
    /* Called when a user taps on a row in the table */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let track = trackList[indexPath.row]
        selectedTrack = track
        
        let tabController = self.tabBarController as! TabBarController
        tabController.selectedTrack = selectedTrack
        
        self.tabBarController?.selectedIndex = 1
    }
    
    
    /* Called by viewDidLoad(). Accesses databse for list of tracks and reloads table view */
    func populateTable(){
        rootRef.child("Tracks").observeEventType(.Value, withBlock: { snapshot in
            var tracks = [String]()
            for track in snapshot.children{
                tracks.append(track.key!)
            }
            self.trackList = tracks
            self.tableView.reloadData()
            }, withCancelBlock: { error in
                print(error.description)
        })
    }
    
    /* Called when user presses Go. Sends track selection to MapController */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "TrackSelectedSegue" {
            if let destinationVC = segue.destinationViewController as? MapController {
                destinationVC.trackName = selectedTrack
            }
        }
   
    }
    
}
