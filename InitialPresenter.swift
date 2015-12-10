import Foundation

class InitialPresenter: InitialViewDelegate, InitialModelDelegate {
    
    private let model: InitialModel
    private let view: InitialView
    
    init(model: InitialModel, view: InitialView) {
        self.model = model
        self.view = view
        self.model.delegate = self
        self.view.delegate = self
    }
    
    //MARK: InitialViewDelegate
    
    func moreDataRequested() {
        model.addTestData()
    }
    
    func dataRequested() {
        model.deviceTextRequested()
    }
    
    //MARK: InitialModelDelegate
    
    func updateTextViewWith(text: String) {
        view.updateViewWith(text)
    }
    
}