import UIKit

final class ViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var changeBackgroundButton: UIButton!

    @IBOutlet weak var generatePasswordButton: UIButton!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var passwordLabel: UILabel!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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

    var password: String? {
        didSet {
            passwordLabel.text = password
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
        password = PasswordManager.generateRandomPassword(length: Constants.passwordLength)

        activityIndicator.startAnimating()
        if let password {
            BruteForce.execute(passwordToUnlock: password) { bruteforcedPassword in
                DispatchQueue.main.sync {
                    self.passwordTextField.text = bruteforcedPassword
                    self.passwordTextField.isSecureTextEntry = false
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }


}

// MARK: - Constants

fileprivate enum Constants {
    static let passwordLength = 40
}
