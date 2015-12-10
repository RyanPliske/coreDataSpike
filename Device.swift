import Foundation

struct Device {
    
    var deviceType: String
    let deviceNumber: Int
    
    init(deviceNumber: Int, deviceType: String) {
        self.deviceNumber = deviceNumber
        self.deviceType = deviceType
    }
    
}