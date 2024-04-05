import Foundation

final class PointsListViewModel {
    private let list: [MapPoint]
    
    init(list: [MapPoint]) {
        self.list = list
    }
    
    func getListCount() -> Int {
        list.count
    }
    
    func getListItem(number: Int) -> MapPoint {
        list[number]
    }
    
    func getPointTitle(number: Int) -> String {
        list[number].isDiscovered ? list[number].title : "Undiscovered point"
    }
    
    func isDiscovered(number: Int) -> Bool {
        list[number].isDiscovered
    }
}
