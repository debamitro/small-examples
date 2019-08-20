#!/usr/bin/swift

//
// I was trying to learn how to write Swift scripts
// that did useful work. This one is inspired by https://github.com/fulldecent/corelocationcli
// I have kept it to the bare minimum so that
// I can understand this some day
//

import CoreLocation

class Delegate: NSObject, CLLocationManagerDelegate
{
    let locationManager = CLLocationManager()

    func start ()
    {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self

/*
        // Prints out the last known location
        if let lastLocation = locationManager.location
        {
            print ("Last known location {")
            printLocation (lastLocation)
        }
 */
        // Prints out location everytime it changes
        // This is very power intensive
        locationManager.startUpdatingLocation()

        // Prints out location once
        //locationManager.requestLocation()
    }

    func printPlaceMark (_ placemark: CLPlacemark)
    {
        if let placeName = placemark.name
        {
            print ("   - name: \(placeName)")
        }
        if let placeCountry = placemark.country
        {
            print ("   - country: \(placeCountry)")
        }
        if let placeLocality = placemark.locality
        {
            print ("   - locality: \(placeLocality)")
        }
        if let placeTimeZone = placemark.timeZone
        {
            print ("   - timezone: \(placeTimeZone.identifier)")
        }
        if let placeRegion = placemark.region
        {
            print ("   - placeRegion: \(placeRegion.identifier)")
        }
        if let placeAreas = placemark.areasOfInterest
        {
            for placeArea in placeAreas
            {
                print ("   - interesting area: \(placeArea)")
            }
        }
    }

    func printLocation (_ location: CLLocation)
    {
        print (" * \(location.coordinate.latitude),\(location.coordinate.longitude) altitude \(location.altitude)")

        let geocoder = CLGeocoder ()
        geocoder.reverseGeocodeLocation(location,
                                        completionHandler: { (placemarks, error) in
           if error == nil
           {
               if let placemark = placemarks?[0]
               {
                   self.printPlaceMark (placemark)
                   print ("}")
               }
           }
        })
    }

    func locationManager (_ manager: CLLocationManager,
                          didUpdateLocations locations: [CLLocation])
    {
        print ("Updated locations: {")
        for location in locations
        {
            printLocation (location)
        }
    }

    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error)
    {
        print ("Got some error \(error)")
    }

}

func doEverything ()
{
    guard CLLocationManager.locationServicesEnabled () else
    {
        print ("location services disabled!")
        return
    }

    guard CLLocationManager.significantLocationChangeMonitoringAvailable () else
    {
        print ("location services disabled!")
        return
    }

    let delegate = Delegate ()

    delegate.start()

    RunLoop.main.run()
}

doEverything ()
