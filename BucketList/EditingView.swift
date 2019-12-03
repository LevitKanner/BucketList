//
//  EditingView.swift
//  BucketList
//
//  Created by Levit Kanner on 03/12/2019.
//  Copyright © 2019 Levit Kanner. All rights reserved.
//

import SwiftUI
import MapKit


enum LoadingState{
    case loading , loaded , failed
}


struct EditingView: View {

    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var placeMark: MKPointAnnotation
    
    @State private var loadingState = LoadingState.loading
    @State private var pages = [Page]()
    
    
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    TextField("Place Name", text: $placeMark.wrappedTitle)
                    TextField("Description" , text: $placeMark.wrappedSubtitle)
                }
                
                Section(header: Text("Nearby...")) {
                    if loadingState == .loaded {
                        List(self.pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                                + Text(": ") +
                                Text(page.description)
                                    .italic()
                                    .foregroundColor(.blue)
                                    .font(.system(size: 14))
                        }
                    } else if loadingState == .loading {
                        Text("Loading…")
                    } else {
                        Text("Please try again later.")
                    }
                }
                
            }
                .navigationBarTitle("Edit Place")
                .navigationBarItems(leading: Button(action:{
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    Text("Done")
                })
            .onAppear(perform: self.loadNearbyPlaces)
        }
        
        
    }
    
    func loadNearbyPlaces(){
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(placeMark.coordinate.latitude)%7C\(placeMark.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        
        
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                
                do{
                    let result = try JSONDecoder().decode(Result.self, from: data)
                    self.pages = Array(result.query.pages.values).sorted()
                    self.loadingState = .loaded
                    return
                }catch{
                    debugPrint(error)
                }
                
            }

            // if we're still here it means the request failed somehow
            self.loadingState = .failed
            
        }.resume()
    }
}
