//
//  FileManager.swift
//  BucketList
//
//  Created by Levit Kanner on 30/11/2019.
//  Copyright © 2019 Levit Kanner. All rights reserved.
//

import Foundation

extension FileManager{
    func getDocumentDirectory<T:Codable> (fileName: String) -> T {
        
        let path = self.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        guard let data = try? Data(contentsOf: path) else {
            fatalError("An error occurred trying to get data from directory")
        }
        
        guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
            fatalError("An error occurred trying to decode data")
        }
        return decodedData
        
    }
}
