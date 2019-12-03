//
//  ContentView.swift
//  BucketList
//
//  Created by Levit Kanner on 30/11/2019.
//  Copyright © 2019 Levit Kanner. All rights reserved.
//

import SwiftUI
import LocalAuthentication
import MapKit

struct ContentView: View {
    @State private var isUnLocked = false
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var locations = [MKPointAnnotation]()
    @State private var selectedPlace: MKPointAnnotation?
    @State private var showingPlaceDetails = false
    @State private var showingEditView = false
      
    
    var body: some View {
        VStack{
            if isUnLocked{
                AnyView(
                    ZStack{
                        MapView(centerCoordinate: self.$centerCoordinate, annotations: self.locations, selectedPlace: self.$selectedPlace, showingPlaceDetails: self.$showingPlaceDetails)
                            .edgesIgnoringSafeArea(.all)
                        
                        //Circle in the center of the map View
                        Circle()
                            .fill(Color.blue)
                            .opacity(0.3)
                            .frame(width: 32 , height: 32)
                        
                        //Adds button to the right corner of the map view
                        VStack{
                            Spacer()
                            HStack{
                                Spacer()
                                Button(action:{
                                    //Button action to come soon
                                    
                                    let newLocation = MKPointAnnotation()
                                    newLocation.title = "Provide place name"
                                    newLocation.coordinate = self.centerCoordinate
                                    self.locations.append(newLocation)
                                    
                                    self.selectedPlace = newLocation
                                    self.showingEditView = true
                                    
                                }){
                                    Image(systemName: "plus")
                                }
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .foregroundColor(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 0.7)
                                .padding([.trailing , .bottom])
                            }
                            
                        }
                        
                    }
                        
                        
                    .alert(isPresented: $showingPlaceDetails, content: { () -> Alert in
                        Alert(title: Text(selectedPlace?.title ?? "Unknown place"), message: Text(selectedPlace?.subtitle ?? "Missing place information"), primaryButton: .default(Text("Okay")), secondaryButton: .default(Text("edit")){
                            self.showingEditView = true
                            })
                    })
                        .sheet(isPresented: $showingEditView, content: {
                            if self.selectedPlace != nil {
                                EditingView(placeMark: self.selectedPlace!)
                            }
                        })
                )
                
                
            }else{
                AnyView(Text("App locked"))
            }
        }
        .onAppear {
            self.authenticate()
        }
    }
    
    func authenticate(){
        
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            
            let reason = "Unlock App"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (success, error) in
                
                DispatchQueue.main.async {
                    if success {
                        //authenticated successfully
                        self.isUnLocked = true
                    }else{
                        //There was a problem
                    }
                }
                
            }
        }else{
            //no biometrics
            print("This device doesn't support biometric authentication")
        }
    }
    
}

