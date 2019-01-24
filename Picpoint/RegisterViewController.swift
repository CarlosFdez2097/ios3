import UIKit
import Alamofire

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var nickNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    override func viewDidLoad() {super.viewDidLoad()}
    @IBAction func register(_ sender: Any){
        emptyFields()
        checkPassword()
        checkLengthPassword()
        emailValidation()
        requestRegister()
    }
    @IBAction func enterWithoutRegistration(_ sender: Any) {
        requestGuestLogin()
    }
    func requestGuestLogin()
    {
        request("http://192.168.6.162/api/public/index.php/api/guest",
            method: .post,
            encoding: URLEncoding.httpBody).responseJSON { (replyQuestGL) in
                print(replyQuestGL.response?.statusCode ?? 0)
                
                var ResponseGL = replyQuestGL.result.value as! [String:Any]

                if((replyQuestGL.response?.statusCode) != 200)
                {
                    let alert = UIAlertController(title: "\(ResponseGL["message"] ?? "default") ", message:
                        "Try it again", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "ok", style:
                        .cancel, handler: { (accion) in}))
                    self.present(alert, animated: true, completion: nil)
                }
                if replyQuestGL.result.isSuccess
                {
                    print(replyQuestGL.result.value!)
                    saveInDefaults(value: ResponseGL["token"] as! String, key: "token")
                    print(loadFromDefaults(key: "token"))
                    self.performSegue(withIdentifier: "registerOK", sender: nil)
                }
        }
    }
    func requestRegister()
    {
        request("http://192.168.6.162/api/public/index.php/api/register",
            method: .post,
            parameters: ["name":nameField.text!, "email":emailField.text!, "password":passwordField.text! , "nickName":nickNameField.text!],
            encoding: URLEncoding.httpBody).responseJSON { (replyQuestR) in
                print(replyQuestR.response?.statusCode ?? 0)
                
                var ResponseR = replyQuestR.result.value as! [String:Any]
                
                if replyQuestR.response?.statusCode == 200
                {
                    saveInDefaults(value: ResponseR["token"] as! String, key: "token")
                    print(loadFromDefaults(key: "token"))
                    self.performSegue(withIdentifier: "registerOK", sender: nil)
                }
                
                if((replyQuestR.response?.statusCode) != 200)
                {
                    let alert = UIAlertController(title: "\(ResponseR["message"] ?? "An error ocurred") ", message:
                        "Try it again", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "ok", style:
                        .cancel, handler: { (accion) in}))
                    self.present(alert, animated: true, completion: nil)
                }
        }
    }
    func registerLogic()
    {
        if registerBtn.isTouchInside && (!(nameField.text?.isEmpty)!) && (!(nickNameField.text?.isEmpty)!) && (!(emailField.text?.isEmpty)!)  && (!(passwordField.text?.isEmpty)!) && (!(confirmPasswordField.text?.isEmpty)!) && (passwordField.text) == (confirmPasswordField.text)
        {
            requestRegister()
        }
    }
    func checkPassword()
    {
        if passwordField.text != confirmPasswordField.text
        {
            let alert = UIAlertController(title: "Passwords don´t match", message:
                "Try it again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: { (accion) in}))
            present(alert, animated: true, completion: nil)
        }
    }
    func checkLengthPassword()
    {
        if (passwordField.text?.count)! < 8
        {
            let alert = UIAlertController(title: "Password must be at least 8 characters long", message:
                "Try it again", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "ok", style:
                .cancel, handler: { (accion) in}))
            present(alert, animated: true, completion: nil)
        }
    }
    func emptyFields()
    {
        if ((nameField.text?.isEmpty)! && (nickNameField.text?.isEmpty)! && (emailField.text?.isEmpty)! && (passwordField.text?.isEmpty)! && (confirmPasswordField.text?.isEmpty)!)
        {
            let alert = UIAlertController(title: "There can be no empty fields", message:
                "Try it again", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "ok", style:
                .cancel, handler: { (accion) in}))
            present(alert, animated: true, completion: nil)
        }
    }
    func emailValidation()
    {
        if (!(emailField.text?.contains("@"))!)
        {
            let alert = UIAlertController(title: "The mail must contain @ and .", message:
                "Try it again", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "ok", style:
                .cancel, handler: { (accion) in}))
            present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func textExit(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
}
