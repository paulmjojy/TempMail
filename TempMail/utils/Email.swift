//
//  Email.swift
//  TempMail
//
//  Created by Paul Jojy on 6/3/20.
//  Copyright © 2020 Paul Jojy. All rights reserved.
//

//This is supposed to be an "Email" Object. The purpose of the email object will be to generate and store the email address, along with the emails attached to it. 
import SwiftUI


class Email : ObservableObject {
    @Published var email_addr:String
    @Published var emails = [InboxModel]()
    
    //  init method
    init() {
        self.email_addr = ""
        genEmailAddr()
    }
    
    //    generates an email address
    func genEmailAddr() -> Void {
        //        list of acceptable chars
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        //         returns a random permutation of letters; string of up to length 9 for email addr
        self.email_addr = String((0..<9).map{ _ in letters.randomElement()!})
    }
    
    //    performs HTTP Request to get emails from server
    func loadEmails(){
        //        make the HTTP GET request to return the JSON
        if email_addr != nil {
            //            create url request
            guard let url = URL(string: "https://www.1secmail.com/api/v1/?action=getMessages&login=test&domain=1secmail.com")
                else{
                    print("Invalid URL")
                    return
            }
            let request = URLRequest(url: url)
            //        send url request and process JSON Response using Decoder
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    if let decodedResponse = try? JSONDecoder().decode(Emails.self, from: data){
                        DispatchQueue.main.async {
                            self.emails = decodedResponse.inbox
                        }
                        return
                    }
                }
                print("Fetch failed: \(error?.localizedDescription ?? "Unknown Error")")
            }.resume()
        }
        else{
            
        }
    }
    //     getter for email addr
    func getEmailAddr() -> String {
        return "Current Address: \(email_addr)@1secmail.com"
    }
    
    //    getter for emails
    func getEmails()->[InboxModel]{
        loadEmails()
        return emails
    }
    
}
