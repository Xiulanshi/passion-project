//
//  ReviewViewController.swift
//  FoodPin
//
//  Created by Xiulan Shi on 1/25/16.
//  Copyright © 2016 Xiulan Shi. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    
    @IBOutlet var backgroundImageView : UIImageView!
    @IBOutlet var ratingStackView: UIStackView!
    @IBOutlet var dislikeButton: UIButton!
    @IBOutlet var goodButton: UIButton!
    @IBOutlet var greatButton: UIButton!
    
    var rating: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // scale down stack view when first loaded
//        ratingStackView.transform = CGAffineTransformMakeScale(0.0, 0.0)
        
        // Slide-up animation-- move stack view off (bottom)
//        ratingStackView.transform = CGAffineTransformMakeTranslation(0, 500)
        
        // Combine two transforms
//        let scale = CGAffineTransformMakeScale(0.0, 0.0)
//        let translate = CGAffineTransformMakeTranslation(0, 500)
//        ratingStackView.transform = CGAffineTransformConcat(scale, translate)
        
        // animate each button
        let translate = CGAffineTransformMakeTranslation(0, 500)
        dislikeButton.transform = translate
        goodButton.transform = translate
        greatButton.transform = translate
        
        // To apply a blurring effect to the background image view, all you need to do is create a UIVisualEffectView object with the blurring effect, followed by adding the visual effect view to the background image view.
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
    }
    
    // want to load the animation after the view is loaded
    override func viewDidAppear(animated: Bool) {
        // create growing effect
//        UIView.animateWithDuration(0.7, delay: 0.0, options: [], animations: { self.ratingStackView.transform = CGAffineTransformIdentity }, completion: nil)
        
        // Spring animation
//        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options:[], animations: {
//            self.ratingStackView.transform = CGAffineTransformIdentity }, completion: nil)
        
        // Spring animation for each button
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            self.dislikeButton.transform = CGAffineTransformIdentity
            }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            self.goodButton.transform = CGAffineTransformIdentity
            }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 0.4, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            self.greatButton.transform = CGAffineTransformIdentity
            }, completion: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ratingSelected(sender: UIButton) {
        switch (sender.tag) {
        case 100: rating = "dislike"
        case 200: rating = "good"
        case 300: rating = "great"
        default: break
        }
        performSegueWithIdentifier("unwindToDetailView", sender: sender)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
