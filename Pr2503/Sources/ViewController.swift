import UIKit

final class ViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var changeBackgroundButton: UIButton!

    @IBOutlet weak var generatePasswordButton: UIButton!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var passwordLabel: UILabel!

    // MARK: - Data

    var isBlack: Bool = false {
        didSet {
            if isBlack {
                self.view.backgroundColor = .black
            } else {
                self.view.backgroundColor = .white
            }
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Actions

    @IBAction func onChangeBackgroundTapped(_ sender: UIButton) {
        isBlack.toggle()
    }

    @IBAction func onGeneratePasswordTapped(_ sender: UIButton) {

    }
}
