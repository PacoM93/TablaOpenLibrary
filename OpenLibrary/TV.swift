//
//  TV.swift
//  OpenLibrary
//
//  Created by Francisco Montes Fonseca on 24/01/18.
//  Copyright © 2018 COURSERA. All rights reserved.
//

import UIKit
import Foundation

class TV: UITableViewController, UITextFieldDelegate {

    private let reuseIdentifier = "Cell"
    var libros: Array<Array<String>> = Array<Array<String>>()
    var bandera : Bool = false
    var posicion : Int?
    
    @IBOutlet weak var historial: UILabel!
    @IBOutlet weak var ISBNtext: UITextField!
    @IBOutlet weak var Agregar: UIBarButtonItem!
    @IBOutlet weak var esperacarga: UILabel!
    
    @IBAction func reiniciar(_ sender: Any) {
        self.Agregar.isEnabled = false
        self.esperacarga.text = ""
    }
    
    @IBAction func ISBNBuscar(_ sender: Any) {
        bandera = true
        prueba()
        ISBNtext.resignFirstResponder()
    }
    
    
    
    func prueba(){
        let urlsIncompleto = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys="
        let ISBN = "ISBN:"+ISBNtext.text!
        let urlsCompleto = urlsIncompleto + ISBN
        let session = URLSession.shared
        let runLoop = CFRunLoopGetCurrent()
        var texto : NSString?
        let request = URL(string: urlsCompleto)
        //let request = URL(string: urlsCompleto)
        self.esperacarga.text="Espera"
        self.Agregar.isEnabled = false
        let task = session.dataTask(with: request!) { (data, response, error) in
            texto = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            CFRunLoopStop(runLoop)
        }
        task.resume()
        CFRunLoopRun()

        let respuesta = texto! as String
        if respuesta == "{}" {
            self.esperacarga.text = "Error"
            self.Agregar.isEnabled = false
        }else{
            self.esperacarga.text = "Listo"
            self.Agregar.isEnabled = true
        }
        
        print("done")
        esperacarga.resignFirstResponder()
        
    }

    
    
    /*@IBAction func AgregarLibro(_ sender: UIBarButtonItem) {
        
        
        
        
        
        
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Buscar") as! ViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }*/
    
    
    /*@IBAction func VistaPreliminar(_ sender: Any) {
    let newViewController = vista()
    self.navigationController?.pushViewController(newViewController, animated: true)
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ISBNtext.delegate = self
        self.Agregar.isEnabled = false
        self.esperacarga.text=""
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let sigVista=segue.destination as! ViewController
        print("Cambio de vista")
        if bandera{
            sigVista.ISBN = ISBNtext.text!
            obtenerUrl()
            self.historial.isEnabled = true
        }else{
            sigVista.ISBN = self.libros[posicion!][0]
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(libros)
        self.Agregar.isEnabled = false
        bandera = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.libros.count
    }

    
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = self.libros[indexPath.row][1]
        posicion = indexPath.row
    return cell!
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
 

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func obtenerUrl(){
        let urlsIncompleto = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys="
        let ISBN = "ISBN:"+ISBNtext.text!
        let urlsCompleto = urlsIncompleto + ISBN
        var respuestajsonTitulo = ""
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
                    print("\n\nERROR\n\n\nPor favor verifíca que el ISBN sea correcto.")
                }else{
                    let dict1 = json[ISBN] as! NSDictionary
                    
                    //Probar que exista título
                    if dict1["title"] != nil {
                        respuestajsonTitulo = dict1["title"] as! NSString as String
                    }else{
                        print("\nNo se encontro el Título del libro.")
                    }
                    
                    
                }
                
            } catch let error as NSError {
                print(error)
            }
        }).resume()
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6), execute: {
            if respuestajsonTitulo != ""{
                self.libros.append([self.ISBNtext.text!,respuestajsonTitulo])
                print("\nagregado a la tabla")
                self.tableView.reloadData()
            }else{
                print("Error al agregar")
            }
            
        })
        
}
}
