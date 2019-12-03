//
//  MKPointAnnotation-ObservableObject.swift
//  BucketList
//
//  Created by Levit Kanner on 03/12/2019.
//  Copyright © 2019 Levit Kanner. All rights reserved.
//

import MapKit
 
extension MKPointAnnotation: ObservableObject{
    public var wrappedTitle: String{
        get{
            self.title ?? "No Title"
        }
        set{
            self.title = newValue
        }
    }
    
    public var wrappedSubtitle: String{
        get{
            self.subtitle ?? "No information on this location"
        }
        set{
            self.subtitle = newValue
        }
    }
}
