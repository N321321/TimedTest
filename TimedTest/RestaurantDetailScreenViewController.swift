//
//  RestaurantDetailScreenViewController.swift
//  TimedTest
//

//  Copyright © 2019 Nikolaus400. All rights reserved.
//

import UIKit

class RestaurantDetailScreenViewController: UIViewController
{
    
    @IBOutlet var name: UILabel!
    @IBOutlet var body: UILabel!
    @IBOutlet var devlivery_link_button: UIButton!
    
    var restaurant:Restaurant?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         // Do any additional setup after loading the view.
        
        name.text = restaurant?.name ?? "Error no name"
      
        
        do{
             body.attributedText = try NSAttributedString(data: (restaurant?.body.data(using: String.Encoding.utf8))!, options: [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html,NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }catch
        {
            body.text =  restaurant?.body ?? "Error no name"
        }
        
        
      if( restaurant?.deliveryLink == "")
      {
        devlivery_link_button.isHidden = true;

        }
      
  
        
    }
    
    
    
   
    @IBAction func deliveryLinkPressed(_ sender: UIButton) {
        
 
        guard let  devLink = restaurant?.deliveryLink , let url = URL(string: devLink)
            else{
                return
        }
        
        UIApplication.shared.openURL(url);
        
    }
    
    
    
    @IBAction func closeView(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    
}
