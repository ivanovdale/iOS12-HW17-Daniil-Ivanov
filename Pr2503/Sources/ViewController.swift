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
            setBackgroundColor()
        }
    }

    var password: String?

    var isCrackingPasswordInProgress = false {
        didSet {
            setButtonTitle()
            setButtonColor()
            setLabelText()
            setActivityIndicator()
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupOutlets()
        setupView()
    }

    // MARK: - Setup

    private func setupOutlets() {
        passwordTextField.delegate = self
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    private func setupView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(gesture)
    }

    // MARK: - Actions

    @IBAction func onChangeBackgroundTapped(_ sender: UIButton) {
        isBlack.toggle()
    }

    @IBAction func onGeneratePasswordTapped(_ sender: UIButton) {
        password = PasswordManager.generateRandomPassword(length: Constants.passwordLength)
    @objc
    private func viewTapped() {
        view.endEditing(true)
    }
    @objc func textFieldDidChange(textField: UITextField) {
        password = textField.text
    }

        activityIndicator.startAnimating()
        if let password {
            BruteForce.execute(passwordToUnlock: password) { bruteforcedPassword in
                DispatchQueue.main.sync {
                    self.passwordTextField.text = bruteforcedPassword
    // MARK: - Update UI

    private func setBackgroundColor() {
        if isBlack {
            view.backgroundColor = .black
        } else {
            view.backgroundColor = .white
        }
    }

    private func setButtonTitle() {
        let buttonTitle: String
        if isCrackingPasswordInProgress {
            buttonTitle = "Stop cracking"
        } else {
            buttonTitle = "Crack password"
        }
        generatePasswordButton.setTitle(buttonTitle, for: .normal)
    }

    private func setButtonColor() {
        let buttonColor: UIColor
        if isCrackingPasswordInProgress {
            buttonColor = .red
        } else {
            buttonColor = .systemBlue
        }
        generatePasswordButton.tintColor = buttonColor
    }

    private func setLabelText() {
        if isCrackingPasswordInProgress {
            passwordLabel.text = "Cracking started..."
        }
    }

    private func setActivityIndicator() {
        if isCrackingPasswordInProgress {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
                    self.passwordTextField.isSecureTextEntry = false
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }


}

// MARK: - Extensions

// MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn: String().printable)
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.isSecureTextEntry = true
    }
}
