//
//  ViewController.swift
//  OpenLibrary
//
//  Created by Francisco Montes Fonseca on 12/01/18.
//  Copyright © 2018 COURSERA. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    var ISBN = ""
    @IBOutlet weak var uiImageView: UIImageView!
    //@IBOutlet weak var Valor: UITextField!
    @IBOutlet weak var Mensaje: UITextView!
   /* @IBAction func Limpiar(_ sender: Any) {
        Mensaje.text = ""
        Valor.text = ""
        uiImageView.image = nil
    }*/
    
    @IBOutlet weak var ISBNtexto: UILabel!
    
    
   /* @IBAction func regresar(_ sender: Any) {
        self.view.removeFromSuperview()
    }*/
    
    
    
    /*@IBAction func BuscarISBN(_ sender: UITextField) {
        uiImageView.image = nil
        obtenerUrl()
    }*/
    
    /*@IBAction func backgroundTap(_ sender: UIControl) {
        Valor.resignFirstResponder()
    }*/
    
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    
    
    
    
    
    
    
    func obtenerUrl(){
        let urlsIncompleto = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys="
        //let ISBN = "ISBN:"+Valor.text!
        let urlsCompleto = urlsIncompleto + ISBN
        var respuestajsonTitulo = ""
        var respuestajsonAutor = ""
        var respuestaJson = ""
        var URL_IMAGE = URL(string: "")
        var image: UIImage?
        //let urlsCompleto = urlsIncompleto + "978-84-376-0494-7"
        print(urlsCompleto)
        let request = URL(string: urlsCompleto)
       
        
        /*
         
        let data = NSData.init(contentsOf: request!) as Data
        let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        let session = URLSession.shared
        let runLoop = CFRunLoopGetCurrent()
        var texto : NSString?
        var titulo: NSDictionary?
        
        
        if request == nil{
            request = URL(string: urlsIncompleto)
        }
      let task = session.dataTask(with: request!) { (data, response, error) in
          texto = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
           CFRunLoopStop(runLoop)
        }
        task.resume()
        CFRunLoopRun()
       
         */
        
        URLSession.shared.dataTask(with: request!, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! NSDictionary
                
                
                //Probar que hay elementos en el diccionario
                let prueba = NSDictionary()
                if json == prueba {
                    respuestaJson = "\n\nERROR\n\n\nPor favor verifíca que el ISBN sea correcto."
                }else{
                    let dict1 = json[self.ISBN] as! NSDictionary
                    
                    //Probar que exista título
                    if dict1["title"] != nil {
                        respuestajsonTitulo = dict1["title"] as! NSString as String
                    }else{
                        respuestaJson = "\nNo se encontro el Título del libro."
                    }
                    
                    //Probar que existen autores
                    if dict1["authors"] != nil {
                        let authorsArray = dict1["authors"] as! NSArray
                        for i in 0..<authorsArray.count{
                            let authordict = authorsArray[i] as! NSDictionary
                            if authordict["name"] != nil{
                                let author = authordict["name"] as! NSString as String
                                respuestajsonAutor = respuestajsonAutor + "\n" + author
                            }
                            
                        }
                    }else{
                        respuestaJson = "\nNo se encontro el Author."
                    }
                    
                    //Probara si hay portada
                    if dict1["cover"] != nil {
                        let coverdict = dict1["cover"] as! NSDictionary
                        if coverdict["large"] != nil{
                            let cover = coverdict["large"] as! NSString as String
                            URL_IMAGE = URL(string: cover)
                        }
                        
                    }
                    
                    
                    
                    respuestaJson = "\nTítulo del libro: \(respuestajsonTitulo)\n\nAutor(es):\(respuestajsonAutor)"
                    
                }
                
            } catch let error as NSError {
                print(error)
            }
        }).resume()
        
        ISBNtexto.text = "ISBN: "+" "+ISBN
        
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            
            if URL_IMAGE != URL(string: ""){
                //Obtener la imagen del libro
                let session = URLSession(configuration: .default)
                //creating a dataTask
                let getImageFromUrl = session.dataTask(with: URL_IMAGE!) { (data, response, error) in
                    //if there is any error
                    if let e = error {
                        //displaying the message
                        print("Error Occurred: \(e)")
                        
                    } else {
                        //in case of now error, checking wheather the response is nil or not
                        if (response as? HTTPURLResponse) != nil {
                            
                            //checking if the response contains an image
                            if let imageData = data {
                                
                                //getting the image
                                image = UIImage(data: imageData)
                                
                            } else {
                                print("Image file is currupted")
                            }
                        } else {
                            print("No response from server")
                        }
                    }
                }
                getImageFromUrl.resume()
                
            }else{
                print("\nNo se pudo cargar la imagen.")
            }
            
            print("\ndone")
        })
        
        //starting the download task
        
        
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
            
            if respuestaJson != ""{

                if image != nil {
                    //displaying the image
                    self.uiImageView.image = image!
                }
                
                print(respuestaJson)
                self.Mensaje.text = respuestaJson
            }else{
                self.Mensaje.text = "Se supero el límite de tiempo de espera, vuelve a intentarlo."
            }
            
            print("\ndone")
        })
        
        
        
        
        
        
        
        /*let respuesta = texto! as String
        if respuesta == "{}" {
            self.Mensaje.text = "ERROR\n\n\nPorfavor verifíca que el ISBN sea correcto."
        }else{
            self.Mensaje.text = respuestaJson
            //self.Mensaje.text = titulo!
        }
        */
        
        //Valor.resignFirstResponder()
    
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        obtenerUrl()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

