import Foundation
import CoreData

enum FetchStatus<T> {
    case Success(T)
    case Failure(String)
    
    func map<P>(f: T -> P) -> FetchStatus<P> {
        switch self {
        case .Success(let value):
            return .Success(f(value))
        case .Failure(let errString):
            return .Failure(errString)
        }
    }
}

enum SaveStatus {
    case Success(String)
    case Failure(String)
}

struct DevicePersistence {
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    private enum DeviceEntityAttributes: String {
        case DeviceNumber = "deviceNumber"
        case DeviceType = "deviceType"
    }
    
    private let context: NSManagedObjectContext
    private let deviceEntityName = "Device"

    
    func addTestData() -> SaveStatus {
        let deviceEntity = NSEntityDescription.entityForName(deviceEntityName, inManagedObjectContext: context)!

        guard let numberOfDevicesInDatabase = deviceCount else {
            return SaveStatus.Failure("Couldn't Save")
        }
        
        for i in 1...3 {
            let device = NSManagedObject(entity: deviceEntity, insertIntoManagedObjectContext: context)
            device.setValue(i + numberOfDevicesInDatabase, forKey: DeviceEntityAttributes.DeviceNumber.rawValue)
            device.setValue(i % 3 == 0 ? "Watch" : "iPhone", forKey: DeviceEntityAttributes.DeviceType.rawValue)
        }
        return save()
    }
    
    var devices: FetchStatus<[Device]> {
        do {
            let fetchRequest = NSFetchRequest(entityName: deviceEntityName)
            let descriptor = NSSortDescriptor(key: DeviceEntityAttributes.DeviceNumber.rawValue, ascending: true)
            fetchRequest.sortDescriptors = [descriptor]
            var devices = [Device]()
            let results = try context.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            for result in results {
                if let deviceType = result.valueForKey(DeviceEntityAttributes.DeviceType.rawValue) as? String,
                    deviceNumber = result.valueForKey(DeviceEntityAttributes.DeviceNumber.rawValue) as? Int {
                        devices.append(Device(deviceNumber: deviceNumber, deviceType: deviceType))
                }
            }
            return FetchStatus.Success(devices)
        } catch {
            return FetchStatus.Failure("There was a fetch error!")
        }
    }
    
    private var deviceCount: Int? {
        
        func countFor(devices: [Device]) -> Int {
            return devices.count
        }
        
        switch (devices.map(countFor)) {
        case .Success(let deviceCount):
            return deviceCount
        case .Failure(_):
            return nil
        }
    }
    
    private func save() -> SaveStatus {
        do {
            try context.save()
            return SaveStatus.Success("Save was successful.")
        } catch let error as NSError {
            return SaveStatus.Failure(error.localizedDescription)
        }
    }
    
}