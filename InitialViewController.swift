import UIKit
import CoreData

class InitialViewController: UIViewController {
    
    var initialPresenter: InitialPresenter!
    
    var initialView: InitialView {
        return self.view as! InitialView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialPresenter = InitialPresenter(model: InitialModel(), view: initialView)
    }
    
}

