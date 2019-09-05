//
//  Model.swift
//  TimedTest
//

//  Copyright © 2019 Nikolaus400. All rights reserved.
//

import Foundation

class Model
{
    
    let urlAddress:String = "https://www.frankieandbennys.com/trg_restaurant_feed/JSON";
    
    let dataUrl = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("Timedtest");
    
    weak private var modelDelegate: ModelDelegate?;

    
    
    func setModelDelegateAndGetData(modelDelegate:ModelDelegate)
    {
        self.modelDelegate = modelDelegate;
        
        getRestaurantData();
    }
    
    public func getRestaurantData()
    {
       
        
        if let url = URL(string: urlAddress)
        {
            URLSession.shared.dataTask(with: url){ data, response, error in

                if let  unwrapped  = error{
                    
                    //There is some kind of error or the device if offline,  print the error
                    print("download error \(unwrapped.localizedDescription)")
                   
                    //Try to retreive previously cached data
                    self.retreiveSavedData();
                    

                }else
                {
                    //success, no error to do with download

                    if let content = data
                    {
                      
                      self.parseData(data: content);

                        //save data for offline use
                        do{
                            try content.write(to: self.dataUrl)

                        }
                        catch
                        {
                            print("error saving data :\(error)")
                        }




                    }

                }


                }.resume();
        }

     
        
    }
    
    
    func retreiveSavedData()
    {
        
        do{
            let savedData = try Data(contentsOf: dataUrl)

           parseData(data:savedData);
            
        }catch
        {
            print("error retreived saved data:\(error)")
        }
        
       
        
    }
    
    
    func parseData(data:Data)
    {
        var restaurants:[Restaurant]?;
        
        do{
             restaurants = [Restaurant]();
            
            let jsonArray:[Any] = try (JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [Any])!

            for i in 0..<jsonArray.count
            {
                
                let jsonObject:[String:Any] = jsonArray[i] as! [String:Any]
                
                //prevents crash if body and devlink keys are not present
                var body = "";
                var devlink = "";
                
                if jsonObject.keys.contains("body")
                {
                    body = jsonObject["body"] as! String;
                }
                
                if jsonObject.keys.contains("delivery_link")
                {
                    devlink = jsonObject["delivery_link"] as! String;
                }
                
                
                let name = jsonObject["name"] as! String;
                let latitude = Double(jsonObject["latitude"] as! String)!
                let longitude = Double(jsonObject["longitude"] as! String)! ;
                

                
                let newRestaurant = Restaurant(name: name, body: body, deliveryLink: devlink, latitude: latitude, longitude: longitude);
        
               
                restaurants?.append(newRestaurant);
    
                
                
            }
           
           self.modelDelegate?.dataReceived(data: restaurants)
            
            
        }catch let error as NSError
        {
            print(error)
        }
        
        
        
    }
    
    
}
