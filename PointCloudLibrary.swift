import UIKit


class PointCloudLibrary {
    // empty point cloud array.
    var pointClouds = [PointCloud]()
    
    func recognizeFromLibrary(_ inputGesture:PointCloud) -> MatchResult {
        var b = Double.infinity
        var u = -1
        for (index, pointCloud) in pointClouds.enumerated() {
            if let d = inputGesture.greedyMatch(pointCloud) {
                if(d < b) {
                    b = d
                    u = index
                }
            }
        }
        if(u == -1) {
            return MatchResult(name: "No match", score: 0.0)
        } else {
            let score = round(max((b - 2.0) / -2.0, 0.0) * 100)/100
            return MatchResult(name:pointClouds[u].name, score:score)
        }
    }
    
    func recognizeoptionsFromLibrary(_ inputGesture:PointCloud) -> Array<String> {
        
        var dictionary: [Double:Int] = [:]
        var scores: [Double] = []
        var answer: [String] = []
        var b = Double.infinity
        
        var u = -1
        var i = 0
        var j = 4
        var it = 0
        var now = 0
        
        let suggestionBarMax = 10
        var suggestionBarCount : Int
        if(suggestionBarMax > self.pointClouds.count){
            suggestionBarCount = self.pointClouds.count
        } else {
            suggestionBarCount = suggestionBarMax
        }
        
        for (index, pointCloud) in pointClouds.enumerated() {
            if let l = inputGesture.greedyMatch(pointCloud) {
                if (i < suggestionBarCount){
                    dictionary.updateValue(index, forKey: l)
                    scores.append(l)
                    i = i + 1
                }
            }
        }
        scores = scores.sorted{ $0 < $1 }
        
        for (index, pointCloud) in pointClouds.enumerated() {
            
            if let d = inputGesture.greedyMatch(pointCloud) {
                if (now >= suggestionBarCount){
                    while (j >= 0){
                        if (scores[j] > d){
                            dictionary.removeValue(forKey: scores[j])
                            scores[j] = d
                            dictionary.updateValue(index, forKey: scores[j])
                            break;
                        }
                        j = j - 1
                    }
                }
                j = suggestionBarCount - 1
                
                if(d < b) {
                    b = d
                    u = index
                }
                scores = scores.sorted{ $0 < $1 }
                now = now + 1
            }
        }
        
        if(u == -1){
            var er = 0
            while (er < suggestionBarCount){
                answer.append("💩")
                er = er + 1
            }
        }
        else {
            while (it < suggestionBarCount){
                answer.append(pointClouds[dictionary[scores[it]]!].name)
                it = it + 1
            }
        }
        return answer
    }
    
    static func getDemoLibrary() -> PointCloudLibrary {
        let defaults = UserDefaults.init(suiteName: "group.swipemoji.appgroup")
        var _library = PointCloudLibrary()
        if let gestures = defaults!.array(forKey: "gestures") as? [NSMutableDictionary] {
            for gesture in gestures {
                _library = addGesture(newGesture: gesture, currentLibrary: _library)
            }
        }
        _library.pointClouds.sort(by: {$0.count > $1.count})
        return _library
    }
    
    static func addGesture(newGesture : NSMutableDictionary, currentLibrary: PointCloudLibrary) -> PointCloudLibrary{
        var gestureCount : Int
        if(newGesture["count"] != nil){
            gestureCount = newGesture["count"] as! Int
        } else {
            gestureCount = 0
        }
        for (key, value) in newGesture {
            if(key as! String == "count"){
                gestureCount = value as! Int
            } else {
                var points = [] as [Point]
                for array in value as! [NSArray] {
                    let point = Point(x:array[0] as! Double, y:array[1] as! Double, id:array[2] as! Int)
                    points.append(point)
                }
                currentLibrary.pointClouds.append(PointCloud(key as! String, points, gestureCount ))
            }
        }
        return currentLibrary
    }
    
    static func submitGesture(input: String, inputPoints: [Point]){
        let defaults = UserDefaults.init(suiteName: "group.swipemoji.appgroup")
        if let dicArray = defaults!.array(forKey: "gestures") as? [NSMutableDictionary] {
            var dicArrayStore = dicArray
            dicArrayStore = dicArrayStore.filter({ (dic) -> Bool in
                dic.allKeys[0] as! String != input && dic.allKeys[1] as! String != input
            })
            //TODO: Make it so it does not reset
            dicArrayStore.append([input : pointsToArray(points: inputPoints), "count": 0])
            defaults!.set(dicArrayStore, forKey: "gestures")
            
        } else {
            var dicArray: [NSMutableDictionary] = []
            dicArray.append([input : pointsToArray(points: inputPoints), "count": 0])
            defaults!.set(dicArray, forKey: "gestures")
        }
    }
    
    static func pointsToArray(points:[Point]) -> [NSArray] {
        var pointArray = [] as [NSArray]
        
        for point in points {
            var array = [point.x, point.y, point.id] as NSArray
            pointArray.append(array)
        }
        return pointArray
    }
    
    static func updateGestureDefault(input: String){
        let defaults = UserDefaults.init(suiteName: "group.swipemoji.appgroup")
            if var dicArray = defaults!.array(forKey: "gestures") as? [NSMutableDictionary] {
                let index = dicArray.index(where: { $0[input] != nil })
                let updatingDict = dicArray[index!]
                var newValue = 0
                if let count = updatingDict["count"] as? Int {
                    print(count)
                    newValue = count + 1
                } else {
                    print("No count defined") //keeps from errors occurring to old model
                }
                dicArray.append([ input: updatingDict[input], "count": newValue])
                dicArray.remove(at: index!)
                defaults!.set(dicArray, forKey: "gestures")
            }
    }

}
