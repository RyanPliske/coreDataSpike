import Foundation

protocol InitialModelDelegate: class {
    func updateTextViewWith(text: String)
}

class InitialModel {
    
    let devicePersistence = DevicePersistence(context: CoreDataStack().managedObjectContext)
    weak var delegate: InitialModelDelegate?
    
    private var isDisplayingToastMessage = false
    
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