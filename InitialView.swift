import UIKit

protocol InitialViewDelegate: class {
    func moreDataRequested()
    func dataRequested()
    func dataRequestedviaBackground()
}

class InitialView: UIView {
    
    weak var delegate: InitialViewDelegate?
    
    @IBOutlet private weak var textView: UITextView!
    
    func updateViewWith(text: String) {
        textView.text = text
    }
    
    @IBAction func addTestDataButtonPressed(sender: AnyObject) {
        delegate?.moreDataRequested()
    }
    
    @IBAction func refreshButtonPressed(sender: AnyObject) {
        delegate?.dataRequested()
    }
    
    @IBAction func backgroundRefreshButtonPressed(sender: AnyObject) {
        delegate?.dataRequestedviaBackground()
    }
    
    
    
}

