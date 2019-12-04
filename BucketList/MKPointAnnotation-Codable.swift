//
//  MKPointAnnotation-Codable.swift
//  BucketList
//
//  Created by Levit Kanner on 04/12/2019.
//  Copyright © 2019 Levit Kanner. All rights reserved.
//

import Foundation
import MapKit

class  CodableMKPointAnnotation: MKPointAnnotation , Codable {
    enum codingKeys: CodingKey {
        case title ,subtitle , longitude , latitude
    }
    override init() {
        super.init()
    }
    
    public required init(from decoder: Decoder) throws{
        super.init()
        
        let container = try decoder.container(keyedBy: codingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        subtitle = try container.decode(String.self, forKey: .subtitle)
        
        let latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: codingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(subtitle, forKey: .subtitle)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
        
    }
}
