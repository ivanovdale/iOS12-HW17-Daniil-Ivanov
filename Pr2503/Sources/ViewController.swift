import UIKit

final class ViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet private weak var changeBackgroundButton: UIButton!
    @IBOutlet private weak var generatePasswordButton: UIButton!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Data

    var bruteForce: BruteForce?

    var passwordManager: PasswordManager?

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
        view.configureTapGestureForEndEditing()
    }

    // MARK: - Actions

    @IBAction private func onChangeBackgroundTapped(_ sender: UIButton) {
        isBlack.toggle()
    }

    @IBAction private func onGeneratePasswordTapped(_ sender: UIButton) {
        if isCrackingPasswordInProgress {
            stopCracking()
        } else {
            crackPassword()
        }
    }

    @objc func textFieldDidChange(textField: UITextField) {
        password = textField.text
    }

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

    // MARK: - Update data

    private func crackPassword() {
        if let _ = password {
            view.endEditing(true)
            isCrackingPasswordInProgress = true
            startBruteForcing()
            startRandomPasswordGeneration()
        }
    }

    private func startBruteForcing() {
        guard let password else { return }
        bruteForce = BruteForce()
        bruteForce?.execute(
            passwordToUnlock: password,
            completionHandler: { bruteforcedPassword in
                DispatchQueue.main.async {
                    self.passwordLabel.text = "Cracked password \"\(bruteforcedPassword)\""
                    self.isCrackingPasswordInProgress = false
                    self.passwordTextField.isSecureTextEntry = false
                    self.bruteForce = nil
                }
                self.passwordManager?.stopRandomPasswordSelection()
            }
        )
    }

    private func startRandomPasswordGeneration() {
        guard let password else { return }
        passwordManager = PasswordManager()
        passwordManager?.startRandomPasswordSelection(
            passwordToUnlock: password,
            inProccessHandler: { possiblePassword in
                DispatchQueue.main.async {
                    self.passwordLabel.text = "Possible password \"\(possiblePassword)\""
                }
            }
        )
    }

    private func stopCracking() {
        bruteForce?.stop()
        passwordManager?.stopRandomPasswordSelection()
        passwordLabel.text = "Password \"\(password ?? "")\" has not been cracked"
        isCrackingPasswordInProgress = false
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
