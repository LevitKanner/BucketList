//
//  EditingView.swift
//  BucketList
//
//  Created by Levit Kanner on 03/12/2019.
//  Copyright © 2019 Levit Kanner. All rights reserved.
//

import SwiftUI
import MapKit

struct EditingView: View {
    enum LoadingState{
           case Loading , loaded , failed
       }
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var placeMark: MKPointAnnotation
    
    @State private var loadingState = LoadingState.Loading
    @State private var pages = [Page]()
    

    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    TextField("Place Name", text: $placeMark.wrappedTitle)
                    TextField("Description" , text: $placeMark.wrappedSubtitle)
                }
                
                Section(header: Text("Nearby...")) {
                    if self.loadingState == .Loading {
                        Text("Loading...")
                    }else if loadingState == .failed {
                        Text("Please try again later...")
                    }else{
                        List(self.pages , id: \.pageId){ page in
                            Text(page.title)
                                .font(.headline)
                            + Text(":") +
                            Text("Page description here..")
                                .italic()
                        }
                    }
                }
            }
            .navigationBarTitle("Edit Place")
            .navigationBarItems(leading: Button(action:{
                self.presentationMode.wrappedValue.dismiss()
            }){
                Text("Done")
            })
        }
        .onAppear(perform: self.loadNearbyPlaces)
   
    }
    
    func loadNearbyPlaces(){
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(placeMark.coordinate.latitude)%7C\(placeMark.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"

        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                
                // we got some data back!
                let decoder = JSONDecoder()

                if let items = try? decoder.decode(Result.self, from: data) {
                    print(items)
                    // success – convert the array values to our pages array
                    self.pages = Array(items.query.pages.values)
                    self.loadingState = .loaded
                    return
                }
            }

            // if we're still here it means the request failed somehow
            self.loadingState = .failed
        }.resume()
    }
}

struct EditingView_Previews: PreviewProvider {
    static var placeMark = MKPointAnnotation()
    static var previews: some View {
        EditingView(placeMark: placeMark)
    }
}
