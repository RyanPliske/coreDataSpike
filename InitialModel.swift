import Foundation

protocol InitialModelDelegate: class {
    func updateTextViewWith(text: String)
}

class InitialModel: DevicePersistenceDelegate {
    
    let devicePersistence: DevicePersistence
    weak var delegate: InitialModelDelegate?
    
    private var isDisplayingToastMessage = false
    
    init() {
        let coreDataStack = CoreDataStack()
        devicePersistence = DevicePersistence(context: coreDataStack.managedObjectContext, storeCoordinator: coreDataStack.persistentStoreCoordinator)
        devicePersistence.delegate = self
    }
    
    func deviceTextRequested() {
        delegate?.updateTextViewWith(deviceText)
    }
    
    func addTestData() {
        switch (devicePersistence.addTestData()) {
        case .Failure(let failureMessage):
            displayAlertWith(failureMessage)
        case .Success(let successMessage):
            displayAlertWith(successMessage)
            break
        }
    }
    
    func dataRequestedviaBackground() {
        devicePersistence.grabDevicesFromBackground()
    }
    
    // MARK: DevicePersistenceDelegate
    
    func devicesReturnedFromBackground(devices: [Device]) {
        dispatch_async(dispatch_get_main_queue()) { [unowned self]() -> Void in
            self.delegate?.updateTextViewWith(self.formatted(devices))
        }
    }
    
    func devicesFailedToReturn(failureMessage: String) {
        dispatch_async(dispatch_get_main_queue()) { [unowned self]() -> Void in
            self.delegate?.updateTextViewWith(failureMessage)
        }
    }
    
    private func displayAlertWith(text: String) {
        if isDisplayingToastMessage == false {
            let toastView = ToastView(message: text)
            isDisplayingToastMessage = true
            toastView.show({ [weak self]() -> () in
                self?.isDisplayingToastMessage = false
            })
        }
        
    }
    
    private var deviceText: String {
        switch (devicePersistence.devices.map(formatted)) {
        case .Success(let successMessage):
            return successMessage
        case .Failure(let failureMessage):
            displayAlertWith(failureMessage)
            return ""
        }
    }
    
    private func formatted(devices: [Device]) -> String {
        if devices.isEmpty {
            return "There are no devices saved locally."
        } else {
            let text = devices.reduce(String()) { $0 + "Device: \($1.deviceType) Device No: \($1.deviceNumber)\n" }
            return text
        }
    }
    
}