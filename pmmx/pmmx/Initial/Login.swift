//
//  Login.swift
//  pmmx
//
//  Created by ISPMMX on 11/9/17.
//  Copyright © 2017 com.pmi. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseMessaging

class Login: UIViewController, UITextViewDelegate {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    let URL_USER_REGISTER = "http://serverpmi.tr3sco.net/api/Account/ExternalLogin"
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: nil, action: #selector(self.doneClicked))
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        txtEmail.inputAccessoryView = toolBar
        txtPassword.inputAccessoryView = toolBar
        
        if self.defaults.string(forKey: "UserName") != nil
        {
            self.nextController()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func doneClicked()
    {
        view.endEditing(true)
    }
    
    //Hide keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //Presses return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }

    @IBAction func logginButton(_ sender: UIButton)
    {
        let token = Messaging.messaging().fcmToken
        //print("FCM token: \(token ?? "")")
        
        let parameters: Parameters=[
            "Email":txtEmail.text!,
            "Password":txtPassword.text!,
            "Llave": token ?? "",
            "RememberMe": true
        ]
        
        Alamofire.request(URL_USER_REGISTER, method: .post, parameters: parameters)
            .responseJSON
            {response in
                
                switch(response.result)
                {
                case .success(_):
                    if let result = response.result.value
                    {
                        
                        if(( (result as AnyObject).count ) != nil)
                        {
                            let jsonData = result as! NSDictionary
                            let mensaje = (jsonData.value(forKey: "Mensaje") as! String?)
                            
                            if (jsonData.value(forKey: "Respuesta") as AnyObject).count != nil
                            {
                                let respuestas = (jsonData.value(forKey: "Respuesta") as! NSDictionary?)
                                self.defaults.set((respuestas?.value(forKey: "UserName") as! String?)!, forKey: "UserName")
                                self.defaults.set((respuestas?.value(forKey: "Email") as! String?)!, forKey: "Email")
                                self.defaults.set((respuestas?.value(forKey: "Id") as! Int?)!, forKey: "Id")
                                self.defaults.set((respuestas?.value(forKey: "Password") as! String?)!, forKey: "Password")
                                self.defaults.set((respuestas?.value(forKey: "IdEntorno") as! Int?)!, forKey: "IdEntorno")
                                self.defaults.set((respuestas?.value(forKey: "IdPersona") as! Int?)!, forKey: "IdPersona")
                                
                                let IdEntorno: Int = self.defaults.integer(forKey: "IdEntorno" )
                                
                                switch IdEntorno
                                {
                                    case 1:
                                        print("Mecanico")
                                        if self.defaults.string(forKey: "UserName") != nil
                                        {
                                            self.nextController()
                                        }
                                        break
                                    case 2:
                                        print("Operador")
                                        break
                                    case 3:
                                        print("Leader")
                                        if self.defaults.string(forKey: "UserName") != nil
                                        {
                                            self.nextController()
                                        }
                                        break
                                    default:
                                        print("Default")
                                        if self.defaults.string(forKey: "UserName") != nil
                                        {
                                            self.nextController()
                                        }
                                        break
                                }
                            }
                            else
                            {
                                self.alertNotifications(msn: mensaje!)
                            }
                        }
                        else
                        {
                            self.alertNotifications(msn: "Email o password invalid!")
                        }
                        
                    }
                    break
                case .failure(_):
                    guard case let .failure(error) = response.result else { return }
                    print(error)
                    break
                }
        }
    }
    
    func logoutButton()
    {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! Login
        self.navigationController?.pushViewController(loginViewController, animated: true)
        self.dismiss(animated: false, completion: nil)
    }
    
    func nextController()
    {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealVC") as! SWRevealViewController
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDel.window?.rootViewController = next
    }
    
    func alertNotifications(msn: String)
    {
        let alert = UIAlertController(title: "Error", message: msn, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            switch action.style{
            case .default:
                self.txtEmail.text = ""
                self.txtPassword.text = ""
                self.view.endEditing(false)
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }}))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

