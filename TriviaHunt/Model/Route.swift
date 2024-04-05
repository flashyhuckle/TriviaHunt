import MapKit

struct Route: Codable {
    let id: UUID
    let name: String
    var description: String
    let creator: String
    let dateCreated: Date
    let mapPoints: [MapPoint]
    
    init(
        id: UUID = UUID(),
        name: String,
        description: String,
        creator: String,
        dateCreated: Date = Date.now,
        mapPoints: [MapPoint]
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.creator = creator
        self.dateCreated = dateCreated
        self.mapPoints = mapPoints
    }
}

extension Route {
    var mapRegion: MKCoordinateRegion {
        let mapPointCount = mapPoints.count
        var latitudeSum = 0.0
        var longitudeSum = 0.0
        
        var latitudeMax = mapPoints.first?.coordinate.latitude ?? 0.0
        var latitudeMin = mapPoints.first?.coordinate.latitude ?? 0.0
        var longitudeMax = mapPoints.first?.coordinate.longitude ?? 0.0
        var longitudeMin = mapPoints.first?.coordinate.longitude ?? 0.0
        
        for mapPoint in mapPoints {
            let latitude = mapPoint.coordinate.latitude
            let longitude = mapPoint.coordinate.longitude
            latitudeSum += latitude
            longitudeSum += longitude
            
            latitudeMax = (latitude > latitudeMax) ? latitude : latitudeMax
            latitudeMin = (latitude < latitudeMin) ? latitude : latitudeMin
            longitudeMax = (longitude > longitudeMax) ? longitude : longitudeMax
            longitudeMin = (longitude < longitudeMin) ? longitude : longitudeMin
        }
        let latitudeAverage = (mapPointCount != 0) ? (latitudeSum / Double(mapPointCount)) : 0.0
        let longitudeAverage = (mapPointCount != 0) ? (longitudeSum / Double(mapPointCount)) : 0.0
        
        let latitudeSpan = latitudeMax - latitudeMin
        let longitudeSpan = longitudeMax - longitudeMin
        
        let spanDegrees = max(latitudeSpan, longitudeSpan) * 1.2
        
        let center = CLLocationCoordinate2D(latitude: latitudeAverage, longitude: longitudeAverage)
        let span = MKCoordinateSpan(latitudeDelta: spanDegrees, longitudeDelta: spanDegrees)
        let region = MKCoordinateRegion(center: center, span: span)
        return region
    }
}
