//
//  LocationServiceImpl.swift
//  WoosmapGeofencingCore

import Foundation
import CoreLocation
public class LocationServiceImpl: LocationServiceCoreImpl  {
    
    public weak var airshipEventsDelegate: AirshipEventsDelegate?
    
    
    public override func refreshSystemGeofencePOI(addCustomGeofence: Bool = false, locationId: String) {
        var nbrSLots = getNumberOfAvailableSlotsGeofence()
        print("=>>>>>> refreshSystemGeofencePOI nbr Slots \(String(describing: nbrSLots))")
        if(addCustomGeofence) {
            nbrSLots -= 1
        }
        print("=>>>>>> refreshSystemGeofencePOI addCustomGeofence nbr Slots \(String(describing: nbrSLots))")
        let lastPOIs = POIs.getLastPOIsFromLocationID(locationId: locationId)
        let toBeMonitoredPOI = lastPOIs.sorted(by: { CLLocation(latitude: $0.latitude, longitude: $0.longitude).distance(from: currentLocation!) < CLLocation(latitude: $1.latitude, longitude: $1.longitude).distance(from: currentLocation!) })
        
        guard let monitoredRegions = locationManager?.monitoredRegions else { return }
        var limit = nbrSLots
        if (limit > toBeMonitoredPOI.count){
            limit = toBeMonitoredPOI.count
            if(limit == 0){
                return
            }
        }
            
        for region in monitoredRegions {
            var exist = false
            for index in 0...limit-1 {
                let identifier = "<id>" + (toBeMonitoredPOI[index].idstore ?? "") + "<id>"
                if (region.identifier.contains(identifier)) {
                    exist = true
                }
            }
            if(!exist && getRegionType(identifier: region.identifier) == RegionType.poi) {
                print("=>>>>>> delete geofence ")
                print("=>>>>>>  " + region.identifier)
                self.locationManager?.stopMonitoring(for: region)
            }
        }
        for index in 0...limit-1 {
            let identifier = "<id>" + (toBeMonitoredPOI[index].idstore ?? "") + "<id>"
            var exist = false
            for region in monitoredRegions {
                if (region.identifier.contains(identifier)) {
                    exist = true
                }
            }
            if(!exist) {
                let name = RegionType.poi.rawValue + identifier
                checkIfUserIsInRegion(region:  CLCircularRegion(center: CLLocationCoordinate2D(latitude: toBeMonitoredPOI[index].latitude, longitude: toBeMonitoredPOI[index].longitude), radius: CLLocationDistance(toBeMonitoredPOI[index].radius), identifier: name ))
                self.locationManager?.startMonitoring(for: CLCircularRegion(center: CLLocationCoordinate2D(latitude: toBeMonitoredPOI[index].latitude, longitude: toBeMonitoredPOI[index].longitude), radius: CLLocationDistance(toBeMonitoredPOI[index].radius), identifier: name))
                print("=>>>>>> add geofence ")
                print("=>>>>>>  " + name)
            }
        }
        
        lastRefreshRegionPOILocationId = Locations.getAll().last?.locationId ?? ""
        
        print("=>>>>>> refreshSystemGeofencePOI nbr monitoring \(String(describing: locationManager?.monitoredRegions.count))")
        guard let monitoredRegions = locationManager?.monitoredRegions else { return }
        var nbrPOI = 0
        for region in monitoredRegions {
            if(getRegionType(identifier: region.identifier) == RegionType.poi) {
                nbrPOI += 1
            }
        }
        print("=>>>>>> refreshSystemGeofencePOI nbr monitoring POI \(String(describing: nbrPOI))")
    }
    
    internal override func getNumberOfAvailableSlotsGeofence() -> Int {
        var nbrSlots = 0
        guard let monitoredRegions = locationManager?.monitoredRegions else { return nbrSlots}
        var nbrCustomGeofence = 0
        for region in monitoredRegions {
            if (getRegionType(identifier: region.identifier) == RegionType.custom) {
                nbrCustomGeofence += 1
            }
        }
        nbrSlots = 20 - 13 - nbrCustomGeofence
        return nbrSlots
    }
    
    internal override func getDistanceFurthestMonitoredPOI() -> Double {
        var distance = 0.0
        guard let monitoredRegions = locationManager?.monitoredRegions else { return distance}
        let identifier = RegionType.poi.rawValue
        guard let lastRefreshLocation = Locations.getLocationFromId(id: lastRefreshRegionPOILocationId) else { return distance}
        for region in monitoredRegions {
            if (region.identifier.contains(identifier)) {
                let idstore = region.identifier.components(separatedBy: "<id>")[1]
                guard let poi = POIs.getPOIbyIdStore(idstore: idstore) else {
                    return distance
                }
                let beforeLastDistance = CLLocation(latitude: lastRefreshLocation.latitude, longitude: lastRefreshLocation.longitude).distance(from: CLLocation(latitude: poi.latitude, longitude: poi.longitude))
                if( (beforeLastDistance - poi.radius) > distance ) {
                    distance = beforeLastDistance - poi.radius
                }
            }
        }
        return distance
    }
    
    //TODO: revisit this
    public override func searchAPIRequest(location: Location) {
#if DEBUG
        let logAPI = LogSearchAPI()
        logAPI.date = Date()
        logAPI.latitude = location.latitude
        logAPI.longitude = location.longitude
        logAPI.woosmapAPIKey = WoosmapAPIKey
        logAPI.searchAPIRequestEnable = searchAPIRequestEnable
        NSLog("=>>>>>> searchAPIRequest WoosmapKey = %@", WoosmapAPIKey)
        logAPI.lastSearchLocationLatitude = lastSearchLocation.latitude
        logAPI.lastSearchLocationLongitude = lastSearchLocation.longitude
#endif
        
        if(WoosmapAPIKey.isEmpty) {
            return
        }
        
        let POIClassified = POIs.getAll().sorted(by: { $0.distance > $1.distance })
        let lastPOI = POIClassified.first
#if DEBUG
        NSLog("=>>>>>> lastPOI distance = %@", String(lastPOI?.distance ?? 0))
        logAPI.lastPOI_distance = String(lastPOI?.distance ?? 0)
        logAPI.searchAPILastRequestTimeStampValue = searchAPILastRequestTimeStamp
#endif
        if lastPOI != nil && !location.locationId!.isEmpty && lastSearchLocation.locationId != "" {
            if(searchAPILastRequestTimeStamp > lastPOI!.date!.timeIntervalSince1970) {
                if ((searchAPILastRequestTimeStamp - lastPOI!.date!.timeIntervalSince1970) > Double(searchAPIRefreshDelayDay*3600*24)) {
                    sendSearchAPIRequest(location: location)
#if DEBUG
                    logAPI.sendSearchAPIRequest = true
#endif
                    return
                }
            }
            
            let timeEllapsed = abs(currentLocation!.timestamp.seconds(from: lastPOI!.date!))
        
            if (timeEllapsed < searchAPIRefreshDelayDay*3600*24) {
                let distanceLimit = lastPOI!.distance - lastPOI!.radius
                let distanceTraveled =  CLLocation(latitude: lastSearchLocation.latitude, longitude: lastSearchLocation.longitude).distance(from: currentLocation!)
#if DEBUG
                NSLog("=>>>>>> distanceLimit = %@", String(distanceLimit))
                NSLog("=>>>>>> distanceTraveled = %@", String(distanceTraveled))
                logAPI.distanceLimit = String(distanceLimit)
                logAPI.distanceTraveled = String(distanceTraveled)
#endif
                
                if (distanceTraveled > distanceLimit) && (distanceTraveled > searchAPIDistanceFilter) && (timeEllapsed > searchAPITimeFilter) {
                    POIs.deleteAll()
                    sendSearchAPIRequest(location: location)
#if DEBUG
                    logAPI.sendSearchAPIRequest = true
#endif
                } else {
                    let distanceToFurthestMonitoredPOI = getDistanceFurthestMonitoredPOI()
#if DEBUG
                    NSLog("=>>>>>> distanceToFurthestMonitoredPOI = %@", String(distanceToFurthestMonitoredPOI))
                    logAPI.distanceToFurthestMonitoredPOI = String(distanceToFurthestMonitoredPOI)
#endif
                    guard let locationRefresh = Locations.getLocationFromId(id: lastRefreshRegionPOILocationId) else {return}
                    let distanceTraveledLastRefreshPOIRegion = CLLocation(latitude: locationRefresh.latitude, longitude: locationRefresh.longitude).distance(from: currentLocation!)
#if DEBUG
                    NSLog("=>>>>>> distanceTraveledLastRefreshPOIRegion = %@", String(distanceTraveledLastRefreshPOIRegion))
                    logAPI.distanceTraveledLastRefreshPOIRegion = String(distanceTraveledLastRefreshPOIRegion)
#endif
                    if distanceTraveledLastRefreshPOIRegion > distanceToFurthestMonitoredPOI {
                        refreshSystemGeofencePOI(locationId: lastSearchLocation.locationId)
                    }
                }
            } else {
                POIs.deleteAll()
                sendSearchAPIRequest(location: location)
#if DEBUG
                logAPI.sendSearchAPIRequest = true
#endif
            }
        } else {
            POIs.deleteAll()
            sendSearchAPIRequest(location: location)
#if DEBUG
            logAPI.sendSearchAPIRequest = true
#endif
        }
#if DEBUG
        LogSearchAPIs.add(log: logAPI)
#endif
    }
    
    internal override func createRegionPOI(center: CLLocationCoordinate2D, name: String, radius: Double) {
        let identifier = RegionType.poi.rawValue + name
        guard let monitoredRegions = locationManager?.monitoredRegions else { return }
        var exist = false
        for region in monitoredRegions {
            if (region.identifier.contains(identifier)) {
               exist = true
            }
        }
        if !exist {
            self.locationManager?.startMonitoring(for: CLCircularRegion(center: center, radius: CLLocationDistance(radius), identifier: identifier))
            checkIfUserIsInRegion(region:  CLCircularRegion(center: center, radius: CLLocationDistance(radius), identifier: identifier ))
        }
    }
    
    internal override func removeOldPOIRegions(newPOIS: [POI]) {
        guard let monitoredRegions = locationManager?.monitoredRegions else { return }
        for region in monitoredRegions {
            var exist = false
            for poi in newPOIS {
                let identifier = "<id>" + (poi.idstore ?? "") + "<id>"
                if (region.identifier.contains(identifier)) {
                    exist = true
                }
            }
            if(!exist) {
                if region.identifier.contains(RegionType.poi.rawValue) {
                    self.locationManager?.stopMonitoring(for: region)
                }
            }
        }
    }
    
    public override func checkIfUserIsInRegion(region: CLCircularRegion) {
        guard let location = currentLocation else { return }
        if(region.contains(location.coordinate)) {
            let regionEnter = Regions.add(POIregion: region, didEnter: true, fromPositionDetection: true)
            sendASRegionEvents(region: regionEnter)
            self.regionDelegate?.didEnterPOIRegion(POIregion: regionEnter)
        }
    }
    
    override func addRegionLogTransition(region: CLRegion, didEnter: Bool, fromPositionDetection: Bool) {
        if let regionLog = Regions.getRegionFromId(id: region.identifier) {
            if (regionLog.date.timeIntervalSinceNow > -5) {
                return
            }
            if (regionLog.didEnter != didEnter) {
                let newRegionLog = Regions.add(POIregion: region, didEnter: didEnter, fromPositionDetection:fromPositionDetection)
                if newRegionLog.identifier != "" {
                    sendASRegionEvents(region: newRegionLog)
                    if (didEnter) {
                        self.regionDelegate?.didEnterPOIRegion(POIregion: newRegionLog)
                    } else {
                        self.regionDelegate?.didExitPOIRegion(POIregion: newRegionLog)
                    }
                }
            }
        } else if (didEnter) {
            let newRegionLog = Regions.add(POIregion: region, didEnter: didEnter, fromPositionDetection:fromPositionDetection)
            if newRegionLog.identifier != "" {
                sendASRegionEvents(region: newRegionLog)
                if (didEnter) {
                    self.regionDelegate?.didEnterPOIRegion(POIregion: newRegionLog)
                } else {
                    self.regionDelegate?.didExitPOIRegion(POIregion: newRegionLog)
                }
            }
        }
    }
    
    private func didEventRegionIsochrone(regionIsochrone: RegionIsochrone) {
        let newRegionLog = Regions.add(regionIso: regionIsochrone)
        sendASRegionEvents(region: newRegionLog)
        if newRegionLog.identifier != "" {
            if (newRegionLog.didEnter) {
                self.regionDelegate?.didEnterPOIRegion(POIregion: newRegionLog)
            } else {
                self.regionDelegate?.didExitPOIRegion(POIregion: newRegionLog)
            }
        }
    }
    
    public override func addRegion(identifier: String, center: CLLocationCoordinate2D, radius: Int, type: String) -> (isCreate: Bool, identifier: String){
        
        if(type == "isochrone"){
            let regionIsCreated = addRegionIsochrone(identifier: identifier, center: center, radius: radius)
            return (regionIsCreated, identifier)
        } else if(type == "circle"){
            let (regionIsCreated, identifier) = super.addRegion(identifier: identifier, center: center, radius: radius, type: type)
            return (regionIsCreated, identifier)
        }
        return (false, "the type is incorrect")
    }
    
    private func addRegionIsochrone(identifier: String, center: CLLocationCoordinate2D, radius: Int) -> Bool {
        if (RegionIsochrones.getRegionFromId(id: identifier) != nil) {
            print("Identifier already exist")
            return false
        }
        let regionIso = RegionIsochrone()
        regionIso.identifier = identifier
        regionIso.date = Date()
        regionIso.latitude = center.latitude
        regionIso.longitude = center.longitude
        regionIso.radius = radius
        regionIso.type = "isochrone"
        RegionIsochrones.add(regionIsochrone: regionIso)
        return true
    }
    
    override func updateLocation(locations: [CLLocation]) {
        guard let delegate = self.locationServiceDelegate else {
            return
        }

        let location = locations.last!

        if self.currentLocation != nil {

            let theLastLocation = self.currentLocation!

            let timeEllapsed = abs(locations.last!.timestamp.seconds(from: theLastLocation.timestamp))

            if theLastLocation.distance(from: location) < currentLocationDistanceFilter && timeEllapsed < currentLocationTimeFilter {
                return
            }

            if timeEllapsed < 2 && locations.last!.horizontalAccuracy >= theLastLocation.horizontalAccuracy {
                return
            }
        }
        // Save in database
        let locationSaved = Locations.add(locations: locations)

        if locationSaved.locationId == nil {
            return
        }

        // Retrieve location
        delegate.tracingLocation(location: locationSaved)

        self.currentLocation = location

        if searchAPIRequestEnable {
            searchAPIRequest(location: locationSaved)
        }
        
        checkIfPositionIsInsideGeofencingRegions(location: location)
        
        detectRegionIsochrone(location: location, locationId: locationSaved.locationId!)

    }
    
    func detectRegionIsochrone(location: CLLocation, locationId: String = "") {
        let regionsIsochrones = RegionIsochrones.getAll()
        var regionsBeUpdated = false
        for regionIso in regionsIsochrones {
            if regionIso.locationId == nil {
                regionsBeUpdated = true
            }
            let distance = location.distance(from: CLLocation(latitude: regionIso.latitude,
                                                              longitude: regionIso.longitude))
            if (distance < Double(distanceMaxAirDistanceFilter)) {
                let spendtime = -regionIso.date!.timeIntervalSinceNow
                let timeLimit = (regionIso.duration - regionIso.radius)/2
                if (spendtime > Double(timeLimit)) {
                    if(spendtime > Double(distanceTimeFilter)) {
                        regionsBeUpdated = true
                    }
                }
                else{
                    if (!optimizeDistanceRequest){
                        var distanceFromTheLastRefresh = Double(0)
                        if let regionIsoLocationId = regionIso.locationId
                        {
                            if let locationFromTheLastRefresh = Locations.getLocationFromId(id: regionIsoLocationId)
                                {
                                    distanceFromTheLastRefresh = location.distance(from: CLLocation(
                                        latitude:  locationFromTheLastRefresh.latitude,
                                        longitude: locationFromTheLastRefresh.longitude))
                                }
                        }
                        if (spendtime > 60){ //1 minute
                            let averageSpeed:Double = distanceFromTheLastRefresh/spendtime
                            let averageSpeedLimit:Double = regionIso.expectedAverageSpeed * 2
                            if(averageSpeed > averageSpeedLimit){
                                regionsBeUpdated = true
                            }
                        }
                    }
                }
            }
            if(regionsBeUpdated) {
                break
            }
        }
        
        if(regionsBeUpdated) {
            calculateDistanceWithRegion(location: location, locationId: locationId)
        }
        
    }
    
    public override func updateRegionWithDistance(distanceAr: [Distance]) {
        var regionIsoTodelete:[String] = []
        for regionIso in RegionIsochrones.getAll() {
            for distance in distanceAr {
                if(distance.destinationLatitude == regionIso.latitude && distance.destinationLongitude == regionIso.longitude) {
                    if(distance.status != "OK"){
                        print("Respone status = " + (distance.status ?? "NOK") + " Region Isochrone " + regionIso.identifier! + " is delete")
                        regionIsoTodelete.append(regionIso.identifier!)
                    }else {
                        var didEnter = regionIso.didEnter
                        let lastStatedidEnter = regionIso.didEnter
                        if(distance.duration <= regionIso.radius) {
                            if(regionIso.didEnter == false) {
                                didEnter = true
                                
                            }
                        } else {
                            if(regionIso.didEnter == true) {
                                didEnter = false
                            }
                        }
                        let regionUpdated = RegionIsochrones.updateRegion(id: regionIso.identifier!, didEnter: didEnter, distanceInfo: distance)
                        if(regionUpdated.didEnter != lastStatedidEnter) {
                            didEventRegionIsochrone(regionIsochrone: regionUpdated)
                        }
                    }
                }
            }
        }
        
        for regionIsoIdentifer in regionIsoTodelete {
            RegionIsochrones.removeRegionIsochrone(id: regionIsoIdentifer)
        }
       
    }
    
    private func removeRegionIsochrone(identifier: String) {
        RegionIsochrones.removeRegionIsochrone(id: identifier)
    }
    
    func calculateDistanceWithRegion(location: CLLocation, locationId: String = "") {
        var dest:[(Double, Double)] = [(Double, Double)]()
        for regionIso in  RegionIsochrones.getAll() {
            dest.append((regionIso.latitude, regionIso.longitude))
        }
        calculateDistance(locationOrigin: location, coordinatesDest: dest, locationId: locationId, regionIsochroneToUpdate: true)
    }
    
    override func sendASZOIClassifiedEvents(region: Region) {
        var propertyDictionary = Dictionary <String, Any>()
        propertyDictionary["ContactKey"] = SFMCCredentials["contactKey"] ?? ""
        propertyDictionary["id"] = region.identifier
        propertyDictionary["lat"] = region.latitude
        propertyDictionary["lng"] = region.longitude
        propertyDictionary["radius"] = region.radius
        
        if let ASdelegate = self.airshipEventsDelegate {
            propertyDictionary["date"] = region.date.stringFromDate()
            if(region.didEnter) {
                propertyDictionary["event"] = "woos_zoi_classified_entered_event"
                ASdelegate.ZOIclassifiedEnter(regionEvent: propertyDictionary, eventName: "woos_zoi_classified_entered_event")
            } else {
                propertyDictionary["event"] = "woos_zoi_classified_exited_event"
                ASdelegate.ZOIclassifiedExit(regionEvent: propertyDictionary, eventName: "woos_zoi_classified_exited_event")
            }
        }
        
        if let MCdelegate = self.marketingCloudEventsDelegate {
            propertyDictionary["date"] = region.date.stringFromISO8601Date()
            if(region.didEnter) {
                propertyDictionary["event"] = "woos_zoi_classified_entered_event"
                MCdelegate.ZOIclassifiedEnter(regionEvent: propertyDictionary, eventName: "woos_zoi_classified_entered_event")
            } else {
                propertyDictionary["event"] = "woos_zoi_classified_exited_event"
                MCdelegate.ZOIclassifiedExit(regionEvent: propertyDictionary, eventName: "woos_zoi_classified_exited_event")
            }
        }
        
        if((SFMCCredentials["zoiClassifiedEnteredEventDefinitionKey"] != "") && (SFMCCredentials["zoiClassifiedEnteredEventDefinitionKey"] != nil) && region.didEnter) {
            propertyDictionary["date"] = region.date.stringFromISO8601Date()
            propertyDictionary["event"] = "woos_zoi_classified_entered_event"
            SFMCAPIclient.pushDataToMC(poiData: propertyDictionary,eventDefinitionKey: SFMCCredentials["zoiClassifiedEnteredEventDefinitionKey"]!)
        }
        
        if((SFMCCredentials["zoiClassifiedExitedEventDefinitionKey"] != "") && (SFMCCredentials["zoiClassifiedExitedEventDefinitionKey"] != nil) && !region.didEnter) {
            propertyDictionary["date"] = region.date.stringFromISO8601Date()
            propertyDictionary["event"] = "woos_zoi_classified_exited_event"
            SFMCAPIclient.pushDataToMC(poiData: propertyDictionary,eventDefinitionKey: SFMCCredentials["zoiClassifiedExitedEventDefinitionKey"]!)
        }
    }
    
    // For test only
//    func detectLocationInZOIClassified(location: CLLocation, enter: Bool) {
//        let classifiedZOIs = ZOIs.getWorkHomeZOI()
//        for classifiedZOI in classifiedZOIs {
//            let sMercator = SphericalMercator()
//            let latitude = sMercator.y2lat(aY: classifiedZOI.lngMean)
//            let longitude = sMercator.x2lon(aX: classifiedZOI.latMean)
//            print(latitude)
//            print(longitude)
//            print(classifiedZOI.period!)
//            print("distance = ")
//
//            let distance = location.distance(from: CLLocation(latitude: latitude, longitude: longitude))
//            print(distance)
//            if(distance < radiusDetectionClassifiedZOI) {
//                let classifiedRegion = Region()
//                classifiedRegion.date = Date()
//                if(enter) {
//                    classifiedRegion.didEnter = true
//                } else {
//                    classifiedRegion.didEnter = false
//                }
//                classifiedRegion.radius = radiusDetectionClassifiedZOI
//                classifiedRegion.latitude = latitude
//                classifiedRegion.longitude = longitude
//                classifiedRegion.identifier = classifiedZOI.period
//                Regions.add(classifiedRegion: classifiedRegion)
//                self.regionDelegate?.homeZOIEnter(classifiedRegion: classifiedRegion)
//            }
//        }
//
//    }
    
    override func sendASVisitEvents(visit: Visit) {
        
        var propertyDictionary = Dictionary <String, Any>()
        propertyDictionary["ContactKey"] = SFMCCredentials["contactKey"] ?? ""
        propertyDictionary["event"] = "woos_visit_event"
        propertyDictionary["date"] = visit.date?.stringFromDate()
        propertyDictionary["arrivalDate"] = visit.arrivalDate?.stringFromDate()
        propertyDictionary["departureDate"] = visit.departureDate?.stringFromDate()
        propertyDictionary["id"] = visit.visitId
        propertyDictionary["lat"] = visit.latitude
        propertyDictionary["lng"] = visit.longitude
        
        if let ASdelegate = self.airshipEventsDelegate {
            propertyDictionary["date"] = visit.date?.stringFromDate()
            ASdelegate.visitEvent(visitEvent: propertyDictionary, eventName: "woos_visit_event")
        }
        
        if let MCdelegate = self.marketingCloudEventsDelegate {
            propertyDictionary["date"] = visit.date?.stringFromISO8601Date()
            MCdelegate.visitEvent(visitEvent: propertyDictionary, eventName: "woos_visit_event")
        }
        
        if((SFMCCredentials["visitEventDefinitionKey"] != "") && (SFMCCredentials["visitEventDefinitionKey"] != nil)) {
            propertyDictionary["date"] = visit.date?.stringFromISO8601Date()
            SFMCAPIclient.pushDataToMC(poiData: propertyDictionary,eventDefinitionKey: SFMCCredentials["visitEventDefinitionKey"]!)
        }
    }
    
    override func sendASPOIEvents(poi: POI) {
        var propertyDictionary = Dictionary <String, Any>()
        propertyDictionary["ContactKey"] = SFMCCredentials["contactKey"] ?? ""
        propertyDictionary["event"] = "woos_poi_event"
        propertyDictionary["name"] = poi.name
        propertyDictionary["lat"] = poi.latitude
        propertyDictionary["lng"] = poi.longitude
        propertyDictionary["city"] = poi.city
        propertyDictionary["distance"] = poi.distance
        propertyDictionary["tags"] = poi.tags
        propertyDictionary["types"] = poi.types
        propertyDictionary["radius"] = poi.radius
        
        setDataFromPOI(poi: poi, propertyDictionary: &propertyDictionary)

        if let ASdelegate = self.airshipEventsDelegate {
            propertyDictionary["date"] = poi.date?.stringFromDate()
            ASdelegate.poiEvent(POIEvent: propertyDictionary, eventName: "woos_poi_event")
        }
        
        if let MCdelegate = self.marketingCloudEventsDelegate {
            propertyDictionary["date"] = poi.date?.stringFromISO8601Date()
            MCdelegate.poiEvent(POIEvent: propertyDictionary, eventName: "woos_poi_event")
        }
        
        if((SFMCCredentials["poiEventDefinitionKey"] != "") && (SFMCCredentials["poiEventDefinitionKey"] != nil)) {
            propertyDictionary["date"] = poi.date?.stringFromISO8601Date()
            SFMCAPIclient.pushDataToMC(poiData: propertyDictionary,eventDefinitionKey: SFMCCredentials["poiEventDefinitionKey"]!)
        }
    }
    
    override func sendASRegionEvents(region: Region) {
        var propertyDictionary = Dictionary <String, Any>()
        propertyDictionary["ContactKey"] = SFMCCredentials["contactKey"] ?? ""
        propertyDictionary["lat"] = region.latitude
        propertyDictionary["lng"] = region.longitude
        propertyDictionary["radius"] = region.radius
        
        if(region.origin == "POI") {
            guard let poi = POIs.getPOIbyIdStore(idstore: region.identifier) else {
                return
            }
            setDataFromPOI(poi: poi, propertyDictionary: &propertyDictionary)
        } else {
            propertyDictionary["id"] = region.identifier
        }
        
        if let ASdelegate = self.airshipEventsDelegate {
            propertyDictionary["date"] = region.date.stringFromDate()
            if(region.didEnter) {
                propertyDictionary["event"] = "woos_geofence_entered_event"
                ASdelegate.regionEnterEvent(regionEvent: propertyDictionary, eventName: "woos_geofence_entered_event")
            } else {
                propertyDictionary["event"] = "woos_geofence_exited_event"
                ASdelegate.regionExitEvent(regionEvent: propertyDictionary, eventName: "woos_geofence_exited_event")
            }
        }
        
        if let MCdelegate = self.marketingCloudEventsDelegate {
            propertyDictionary["date"] = region.date.stringFromISO8601Date()
            if(region.didEnter) {
                propertyDictionary["event"] = "woos_geofence_entered_event"
                MCdelegate.regionEnterEvent(regionEvent: propertyDictionary, eventName: "woos_geofence_entered_event")
            } else {
                propertyDictionary["event"] = "woos_geofence_exited_event"
                MCdelegate.regionExitEvent(regionEvent: propertyDictionary, eventName: "woos_geofence_exited_event")
            }
        }
        
        if((SFMCCredentials["regionEnteredEventDefinitionKey"] != "") && (SFMCCredentials["regionEnteredEventDefinitionKey"] != nil) && region.didEnter) {
            propertyDictionary["date"] = region.date.stringFromISO8601Date()
            propertyDictionary["event"] = "woos_geofence_entered_event"
            SFMCAPIclient.pushDataToMC(poiData: propertyDictionary,eventDefinitionKey: SFMCCredentials["regionEnteredEventDefinitionKey"]!)
        }
        
        if((SFMCCredentials["regionExitedEventDefinitionKey"] != "") && (SFMCCredentials["regionExitedEventDefinitionKey"] != nil) && !region.didEnter) {
            propertyDictionary["date"] = region.date.stringFromISO8601Date()
            propertyDictionary["event"] = "woos_geofence_exited_event"
            SFMCAPIclient.pushDataToMC(poiData: propertyDictionary,eventDefinitionKey: SFMCCredentials["regionExitedEventDefinitionKey"]!)
        }
    }
}
