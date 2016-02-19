//
//  RestaurantTableViewController.swift
//  FoodPin
//
//  Created by Xiulan Shi on 1/23/16.
//  Copyright © 2016 Xiulan Shi. All rights reserved.
//

import UIKit
import CoreData

class RestaurantTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
    
    var fetchResultsController: NSFetchedResultsController!
    var searchController: UISearchController!
    
    var searchResults: [Restaurant] = []
    
    @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
        
    }
    
    var restaurants:[Restaurant] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Remove the title of the back button
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableViewAutomaticDimension

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //create NSFetchRequest object with the Restaurant entity
        let fetchRequest = NSFetchRequest(entityName: "Restaurant")
        
        // specify the sort order using NSSortDescriptor object, it descripted how the fetched objects are sorted
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            
            //creat fetch request, initialize a fetched result controller
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            
            // specify its delegate for monitoring data changes
            fetchResultsController.delegate = self
            
            do { // call performFetch to execute the fetch request
                try fetchResultsController.performFetch()
                //get the restaurant object by access the fetchedObjects property, the property returns an array of anyobject, so we have to cast it to [Restaurant]
                restaurants = fetchResultsController.fetchedObjects as! [Restaurant]
            } catch {
                print(error)
            }
        }
        
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.placeholder = "Search restaurants..."
        searchController.searchBar.tintColor = UIColor(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0)
        searchController.searchBar.barTintColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.6)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let hasViewedWalkthrough = defaults.boolForKey("hasViewedWalkthrough")
        
        if hasViewedWalkthrough {
            return
        }
        
        if let pageViewController = storyboard?.instantiateViewControllerWithIdentifier("WalkthroughController") as? WalkthroughPageViewController {
            
            presentViewController(pageViewController, animated: true, completion: nil)
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.active {
            return searchResults.count
        } else {
            return restaurants.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! RestaurantTableViewCell
        
        let restaurant = (searchController.active) ? searchResults[indexPath.row] : restaurants[indexPath.row]

        // Configure the cell...
        cell.nameLabel.text = restaurant.name
        cell.locationLabel.text = restaurant.location
        cell.typeLabel.text = restaurant.type
        cell.thumbnailImageView.image = UIImage(data: restaurant.image!)
        
        if let isVisited = restaurant.isVisited?.boolValue {
        cell.accessoryType = isVisited ? .Checkmark : .None
        }
        return cell
    }
    
//        // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            restaurants.removeAtIndex(indexPath.row)
        }
        
//        tableView.reloadData()
        //use a better way
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        
    }
    
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        // Social Sharing Button
        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Share", handler: { (action, indexPath) -> Void in
            
            let defaultText = "Just checking in at " + self.restaurants[indexPath.row].name
            if let imageToShare = UIImage(data: self.restaurants[indexPath.row].image!) {
                let activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
                self.presentViewController(activityController, animated: true, completion: nil)
            }
        })
        
        // Delete button
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete",handler: { (action, indexPath) -> Void in
            
            // Delete the row from the data source
            
            if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
                
                let restaurantToDelete = self.fetchResultsController.objectAtIndexPath(indexPath) as! Restaurant
                managedObjectContext.deleteObject(restaurantToDelete)
                
                do {
                    try managedObjectContext.save()
                } catch {
                    print(error)
                }
            }
        })
        
        // Set the button color
        shareAction.backgroundColor = UIColor(red: 28.0/255.0, green: 165.0/255.0, blue: 253.0/255.0, alpha: 1.0)
        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        return [deleteAction, shareAction]
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if searchController.active {
            return false
        } else {
            return true
        }
    }
       
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // used to check the segue identifier
        if segue.identifier == "ShowRestaurantDetail" {
            
            // first retrieve the selected row by accessing tableview.indexPathForSelectedRow. the indexPath should contain the selected cell.
            if let indexPath = tableView.indexPathForSelectedRow {
                
                // Get the new view controller using segue.destinationViewController. we have to downcasting using as! here
                let destinationController = segue.destinationViewController as! RestaurantDetailViewController
                
                // Pass the selected object to the new view controller.
                destinationController.restaurant = (searchController.active) ? searchResults[indexPath.row] : restaurants[indexPath.row]
            }
        
        }
    }
    
    // this method is called when the fetched results controller is about to start processing the content change
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    // when there is any content change inthe managed context, the second method is called.
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        // determin the type of operation and proceed with the corresponding operation
        switch type {
        case .Insert:
            if let _newIndexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([_newIndexPath], withRowAnimation: .Fade)
            }
        case .Update:
            if let _indexPath = indexPath {
                tableView.reloadRowsAtIndexPaths([_indexPath], withRowAnimation: .Fade)
            }
        default:
            tableView.reloadData()
        }
        // because the objects are changed, we sync them with the restaurant array at the end of the method
        restaurants = controller.fetchedObjects as! [Restaurant]
    }// after the controller completes the change, it call didChange. It will tell the table view that we've completed the update and it will animate the change correspondingly.
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func filterContentForSearchText(searchText: String) {
        searchResults = restaurants.filter({(restaurant: Restaurant) -> Bool in
            let nameMatch = restaurant.name.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            let locationMatch = restaurant.location.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return nameMatch != nil || locationMatch != nil
    
        })
    }
   
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContentForSearchText(searchText)
            tableView.reloadData()
        }
    }

}
