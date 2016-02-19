//
//  RestaurantDetailViewController.swift
//  FoodPin
//
//  Created by Xiulan Shi on 1/24/16.
//  Copyright © 2016 Xiulan Shi. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var restaurantImageView: UIImageView!
    @IBOutlet var ratingButton: UIButton!

    
    var restaurant:Restaurant!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        restaurantImageView.image = UIImage(data: restaurant.image!)
        
        tableView.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.2)
        
        // remove the separators of empty rows by setting table footer view to blank.
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        // change the separtorcolor for content rows
        tableView.separatorColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue:
            240.0/255.0, alpha: 0.8)
        
        // set navigation bar title to restaurant name
        title = restaurant.name
        
        
        //the first line of code sets the estimated row height of the cell. That's the height of the existing prototype cell. The second line changes the rowHeight property to UITableViewAutomaticDimension , which is the default row height in iOS 9.
        // Enable self sizing cells
        tableView.estimatedRowHeight = 36.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Set the rating of the restaurant
        
        if let rating = restaurant.rating where rating != "" {
            ratingButton.setImage(UIImage(named: restaurant.rating!), forState: UIControlState.Normal)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! RestaurantDetailTableViewCell
        
        //Configure the cell...
        cell.backgroundColor = UIColor.clearColor() // This makes the cell color transparent, so the background color of table view can be seen.
        
        switch indexPath.row {
        case 0:
            cell.fieldLabel.text = "Name"
            cell.valueLabel.text = restaurant.name
        case 1:
            cell.fieldLabel.text = "Type"
            cell.valueLabel.text = restaurant.type
        case 2:
            cell.fieldLabel.text = "Location"
            cell.valueLabel.text = restaurant.location
        case 3:
            cell.fieldLabel.text = "Phone"
            cell.valueLabel.text = restaurant.phoneNumber
        case 4:
            cell.fieldLabel.text = "Been here"
            if let isVisited = restaurant.isVisited?.boolValue {
            cell.valueLabel.text = isVisited ? "Yes, I've been here before" : "No"
            }
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
            
        }
        
        return cell
    }
    
    @IBAction func close(segue:UIStoryboardSegue) {
        
        if let reviewViewController = segue.sourceViewController as? ReviewViewController {
            if let rating = reviewViewController.rating {
                restaurant.rating = rating  //this store the rating
                ratingButton.setImage(UIImage(named: rating), forState: UIControlState.Normal)
                
                if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
                    
                    do {
                        try managedObjectContext.save()
                    } catch {
                        print(error)
                    }
                }
            }
        }
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showMap" {
        // Get the new view controller using segue.destinationViewController.
            let destinationViewController = segue.destinationViewController as! MapViewController
        // Pass the selected object to the new view controller.
            destinationViewController.restaurant = restaurant
        }
    }
   

}
