//
//  LoginViewController.swift
//  Mzyoon
//
//  Created by QOL on 16/10/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import Foundation
import UIKit
import AlamofireDomain
import Reachability

class ServerAPI : NSObject
{
    var delegate: ServerAPIDelegate?
    
    var resultDict:NSDictionary = NSDictionary()
    

//    var baseURL:String = "http://192.168.0.26/TailorAPI"
   
      var baseURL:String = "http://appsapi.mzyoon.com"
 
    let deviceId = UIDevice.current.identifierForVendor
    
    func API_LoginUser(CountryCode : String, PhoneNo : String, Language : String, delegate:ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Login Page")
            
            let parameters = ["CountryCode" : CountryCode, "PhoneNo" : PhoneNo, "DeviceId" : "\(deviceId!)", "Language" : Language] as [String : Any]
            
            print("LOGIN PARAMETERS", parameters)
            
            let urlString:String = String(format: "%@/API/Login/GenerateOTP", arguments: [baseURL])
            
            request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {response in
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    
                    delegate.API_CALLBACK_Login!(loginResult: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 1, errorMessage: "Login Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    func API_ResendOTP(CountryCode : String, PhoneNo : String, Language : String, delegate:ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Login Page")
            
            let parameters = ["CountryCode" : CountryCode, "PhoneNo" : PhoneNo, "DeviceId" : "\(deviceId!)", "Language" : Language] as [String : Any]
            
            print("LOGIN PARAMETERS", parameters)
            
            let urlString:String = String(format: "%@/API/Login/ResendOTP", arguments: [baseURL])
            
            request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {response in
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    
                    delegate.API_CALLBACK_ResendOTP!(otpResult: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 2, errorMessage: "Resend OTP Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    func API_ValidateOTP(CountryCode : String, PhoneNo : String, otp : String, type : String, delegate:ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Validate OTP Page")
            
            let parameters = ["CountryCode" : CountryCode, "PhoneNo" : PhoneNo, "DeviceId" : "\(deviceId!)", "OTP" : otp, "Type" : type] as [String : Any]
            
            print("LOGIN PARAMETERS", parameters)
            
            let urlString:String = String(format: "%@/API/Login/ValidateOTP", arguments: [baseURL])
            
            request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {response in
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    
                    delegate.API_CALLBACK_ValidateOTP!(loginResult: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 3, errorMessage: "Validate OTP Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    func API_CountryCode(delegate : ServerAPIDelegate)
    {
        print("ABCDEFGHIJKLMNOPQRSTUVWXYZ", (Reachability()?.connection)!)

        if Reachability.Connection.self != .none
        {
            print("Server Reached - Country Code Page")
            
            let urlString:String = String(format: "%@/API/login/getallcountries", arguments: [baseURL])
            
            print("URL COUNRTY", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    
                    delegate.API_CALLBACK_CountryCode!(countryCodes: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 4, errorMessage: "Country Code Failed")
                }
                
                
            }
            
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    func API_AllLanguges(delegate : ServerAPIDelegate)
    {
        
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Country Code Page")
            
            let parameters = [:] as [String : Any]
            
            
            let urlString:String = String(format: "%@/API/Login/GetAllLanguages", arguments: [baseURL])
            
            print("URL COUNRTY", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    
                    delegate.API_CALLBACK_AllLanguages!(languages: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 5, errorMessage: "All Languages Failed")
                }
                
                
            }
            
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    func API_FlagImages(imageName : String, delegate : ServerAPIDelegate)
    {
        
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Flag Images Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/images/flags/\(imageName)", arguments: [baseURL])
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    
                    delegate.API_CALLBACK_FlagImages!(flagImages: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 7, errorMessage: "Flag Images Failed")
                }
            }
            
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    func API_Gender(delegate : ServerAPIDelegate)
    {
        
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Gender Page")
            
            let parameters = [:] as [String : Any]
            
            
            let urlString:String = String(format: "%@/API/Order/GetGenders", arguments: [baseURL])
            
            request(urlString, method: .get, parameters: nil, encoding: URLEncoding.default).responseJSON {response in
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    
                    delegate.API_CALLBACK_Gender!(gender: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 8, errorMessage: "Genders Failed")
                }
            }
            
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    func API_GenderImage(imageName : String, delegate : ServerAPIDelegate)
    {
        
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Gender Image Page")
            
            let parameters = [:] as [String : Any]
            
            
            let urlString:String = String(format: "%@/images/\(imageName)", arguments: [baseURL])
            
            /*request(urlString, method: .get, parameters: nil, encoding: URLEncoding.default).responseJSON {response in
             
             if response.result.value != nil
             {
             self.resultDict = response.result.value as! NSDictionary // method in apidelegate
             delegate.API_CALLBACK_GenderImage!(genderImage: self.resultDict)
             }
             else
             {
             delegate.API_CALLBACK_Error(errorNumber: 9, errorMessage: "Genders Image Failed")
             }
             }*/
            
            request(urlString).responseData { (response) in
                if response.data != nil {
                    print(response.result)
                    // Show the downloaded image:
                    if let data = response.data {
                        delegate.API_CALLBACK_GenderImage!(genderImage: data)
                    }
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    func API_DressType(genderId : Int, delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Dress Type Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetDressTypeByGender?genderId=\(genderId)", arguments: [baseURL])
            
            print("DRESS TYPE API", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    
                    delegate.API_CALLBACK_DressType!(dressType: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 10, errorMessage: "Dress Type Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    class Customization: NSObject {
        
        var Id: Int?
        
        init(Id: Int) {
            self.Id = Id
        }
        
        func getDictFormat() -> [String: Int]{
            return ["Id" : Id!]
        }
    }
    
    func MakeRequest(season : [Int], origin : [Int]) -> ([String : Any])
    {
        var array = [Customization]()
        
        for i in 0..<origin.count
        {
            array.append(Customization(Id: origin[i]))
        }
        
//        array.append(Customization(Id: 1))
//
//        array.append(Customization(Id: 2))
        
        var List = [[String: Int]]()
        
        for item in array {
            
            List.append(item.getDictFormat())
            
        }
    
        var array1 = [Customization]()
        
//        array1.append(Customization(Id: 0))
        
        for i in 0..<season.count
        {
            array1.append(Customization(Id: season[i]))
        }
        
        
        var List1 = [[String: Int]]()
        
        for item in array1 {
            
            List1.append(item.getDictFormat())
            
        }
        
        let parameters = [
            
            "SeasonId": List1,
            
            "PlaceofOrginId": List
            
            ] as [String : Any]
        
        
        print("PARAMETERS OF SUPER", parameters)
        
        return parameters
    }
    
    func API_Customization1(originId : [[String: Int]], seasonId : [[String: Int]], delegate : ServerAPIDelegate)
    {
        print("IN FIRST STEP", originId)
        print("IN SECOND STEP", seasonId)

        var season = String()
        var origin = String()
        
        var convertedSeason = String()
        var convertedOrigin = String()
        
        for i in 0..<originId.count
        {
            if i == 0
            {
                origin.append("\(originId[i])")
            }
            else
            {
                origin.append(",\(originId[i])")
            }
        }
        
        for i in 0..<seasonId.count
        {
            if i == 0
            {
                season.append("\(seasonId[i])")
            }
            else
            {
                season.append(",\(seasonId[i])")
            }
        }
        
        print("DICT NEW", origin)
        print("DICT NEW SEASON", season)

                
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Customization 1 Page")
            
            let parameters = ["PlaceofOrginId" : originId, "seasonId" : seasonId] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetCustomization1", arguments: [baseURL])
            
            print("URL STRING", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {response in
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    
                    print("SELF RESULT DICT", self.resultDict)
                    
                    delegate.API_CALLBACK_Customization1!(custom1: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 11, errorMessage: "Customization 1 Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    func API_Customization2(brandId : [[String: Int]], materialId : [[String: Int]], ColorId : [[String: Int]], delegate : ServerAPIDelegate)
    {
        var materials = String()
        var colors = String()
        
        for i in 0..<materialId.count
        {
            if i == 0
            {
                materials.append("\(materialId[i])")
            }
            else
            {
                materials.append(",\(materialId[i])")
            }
        }
        
        for i in 0..<ColorId.count
        {
            if i == 0
            {
                colors.append("\(ColorId[i])")
            }
            else
            {
                colors.append(",\(ColorId[i])")
            }
        }
        
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Customization 2 Page")
            
            let parameters = ["BrandId" : brandId, "MaterialTypeId" : materialId, "ColorId" : ColorId] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetCustomization2", arguments: [baseURL])
            
            print("URL STRING", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_Customization2!(custom2: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 12, errorMessage: "Customization 2 Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    func API_Profile(delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Customization 1 Page")
            
            let parameters = ["Tailorid" : "6", "ShopNameInEnglish" : "Test English", "ShopNameInArabic" : "Test Arabic",  "CountryId" : "1",  "CityId" : "1",  "Latitude" : "13.005412",  "Longitude" : "80.021254",  "AddressInEnglish" : "Address English",  "AddressinArabic" : "Address Arabic",  "ShopOwnerImageURL" : "albert.png",] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Shop/InsertUpdateShopProfile", arguments: [baseURL])
            
            print("URL STRING", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_Profile!(profile: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 13, errorMessage: "Customization 1 Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    func API_OrderType(delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - OrderType Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/DisplayOrderType", arguments: [baseURL])
            
            print("URL STRING FOR OrderType", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: URLEncoding.default).responseJSON {response in
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    
                    delegate.API_CALLBACK_OrderType!(orderType: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 14, errorMessage: "Order Type Failed")
                }
            }
            
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    func API_Measurement1(delegate : ServerAPIDelegate)
    {
        
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Measurement1 Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/DisplayMeasurement1", arguments: [baseURL])
            
            print("URL STRING FOR OrderType", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: URLEncoding.default).responseJSON {response in
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_Measurement1!(measure1: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 15, errorMessage: "Measurement1 Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    func API_Customization3(DressTypeId : String, delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Customization 3 Page")
            
            let parameters = ["DressTypeId" : "\(DressTypeId)"] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetCustomization3", arguments: [baseURL])
            
            print("Custom 3", urlString)
            print("CUSTOM 3 PARAMETERS", parameters)
            
            request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON {response in
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_Customization3!(custom3: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 16, errorMessage: "Customization 3 Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    func API_Customization3Attr(AttributeId : Int, delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Dress Type Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetAttributesByAttributeId?AttributeId=\(AttributeId)", arguments: [baseURL])
            
            print("ATTRIBUTES WITH IMAGE ID", urlString)
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    
                    delegate.API_CALLBACK_Customization3Attr!(custom3Attr: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 17, errorMessage: "Customization 3 Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    func API_IntroProfile(Id : String, Name : String, profilePic : String, delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Intro Profile Page")
            
            let parameters = ["Id" : Id, "Name" : Name, "ProfilePicture" : profilePic] as [String : Any]
            
            let urlString:String = String(format: "%@/Api/Shop/InsertBuyerName", arguments: [baseURL])
            
            print("URL STRING", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON {response in
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_IntroProfile!(introProf:self.resultDict )
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 18, errorMessage: "Intro Profile Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    func API_ExistingUserProfile(Id : String, delegate : ServerAPIDelegate)
    {
        print("ABCDEFGHIJKLMNOPQRSTUVWXYZ", Reachability()?.connection)
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Existing User Profile Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/Api/Order/GetExistingUserProfile?Id=\(Id)", arguments: [baseURL])
            
            print("URL STRING", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON {response in
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_ExistingUserProfile!(userProfile: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 19, errorMessage: "Existing User Profile Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    // Profile Update
    func API_ProfileUpdate(Id : String, Email : String, Dob : String, Gender : String, ModifiedBy : String, delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Intro Profile Page")
            
            let parameters = ["Id" : Id, "Email" : Email, "Dob" : Dob, "Gender" : Gender, "ModifiedBy" : ModifiedBy] as [String : Any]
            
            let urlString:String = String(format: "%@/Api/Shop/InsertBuyerDetails", arguments: [baseURL])
            
            print("URL STRING", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_ProfileUpdate!(profUpdate: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 20, errorMessage: "Profile Update Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    // Insert Buyer Address..
    func API_InsertAddress(BuyerId : String, FirstName : String, LastName : String, CountryId : Int, StateId : Int, Area : String, Floor : String, LandMark : String, LocationType : String, ShippingNotes : String, IsDefault : String, CountryCode : String, PhoneNo : String, Longitude : Float, Latitude : Float, delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Address Page")
            
            let parameters = ["BuyerId" : "\(BuyerId)", "FirstName" : "\(FirstName)", "LastName" : LastName, "CountryId" : CountryId, "StateId" : StateId, "AreaId" : Area, "Floor" : Floor, "LandMark" : LandMark, "LocationType" : LocationType, "ShippingNotes" : ShippingNotes, "IsDefault" : IsDefault, "CountryCode" : CountryCode, "PhoneNo" : PhoneNo, "Longitude" : Longitude, "Lattitude" : Latitude] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Shop/InsertBuyerAddress", arguments: [baseURL])
            
            print("URL STRING", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_InsertAddress!(insertAddr: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 21, errorMessage: "Save Address Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    // Update Buyer Address..
    func API_UpdateAddress(Id : Int ,BuyerId : String, FirstName : String, LastName : String, CountryId : Int, StateId : Int, Area : String, Floor : String, LandMark : String, LocationType : String, ShippingNotes : String, IsDefault : String, CountryCode : String, PhoneNo : String, Longitude : Float, Latitude : Float, delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Address Page")
            
            let parameters = ["Id" : Id, "BuyerId" : BuyerId, "FirstName" : FirstName, "LastName" : LastName, "CountryId" : CountryId, "StateId" : StateId, "AreaId" : Area, "Floor" : Floor, "LandMark" : LandMark, "LocationType" : LocationType, "ShippingNotes" : ShippingNotes, "IsDefault" : IsDefault, "CountryCode" : CountryCode, "PhoneNo" : PhoneNo, "Longitude" : Longitude, "Lattitude" : Latitude] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Shop/UpdateBuyerAddress", arguments: [baseURL])
            
            print("URL STRING", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    
                    print("UPDATE RESPONSE", self.resultDict)
                    delegate.API_CALLBACK_UpdateAddress!(updateAddr: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 22, errorMessage: "Address Update Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    //Delete Buyer Address..
    func API_DeleteAddress(AddressId : Int, userId : String, delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Address Page")
            
            let parameters = [:] as [String : Any]

            let urlString:String = String(format: "%@/API/Shop/DeleteBuyerAddress?BuyerId=\(userId)&Id=\(AddressId)", arguments: [baseURL])
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    
                    delegate.API_CALLBACK_DeleteAddress!(deleteAddr: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 23, errorMessage: "Address Delete Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    //GEt Buyer Address..
    func API_GetBuyerAddress(BuyerAddressId : String, delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Address Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Shop/GetBuyerAddressByBuyerId?BuyerId=\(BuyerAddressId)", arguments: [baseURL])
            
            print("URL STRING", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    
                    delegate.API_CALLBACK_GetBuyerAddress!(getBuyerAddr: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 24, errorMessage: "Get Buyer Address Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    func API_GetBuyerIndividualAddressByAddressId(addressId : String, delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Individual Address Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Shop/GetBuyerAddressById?Id=\(addressId)", arguments: [baseURL])
            
            print("URL STRING", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    
                    delegate.API_CALLBACK_GetBuyerIndividualAddressByAddressId!(getAddress: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 24, errorMessage: "Get Buyer Individual Address Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }


    //Dress Sub-type..
    func API_DressSubType(DressSubTypeId : Int, delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Dress SubType")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/DisplayDressSubType?Id=\(DressSubTypeId)", arguments: [baseURL])
            
            print("DRESS TYPE")
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                print("REQUEST", urlString)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    print("response", self.resultDict)
                    delegate.API_CALLBACK_DressSubType!(dressSubType: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 25, errorMessage: "Dress SubType Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    // Measurement-2 full body pics...
    func API_GetMeasurement2(Measurement1Value : Int, delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Measurement2 Value")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetMeasurement2?Id=\(Measurement1Value)", arguments: [baseURL])
            
            print("GetMeasurement1 URL STRING", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_GetMeasurement2!(GetMeasurement1val: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 26, errorMessage: "Get Measurement-1 Value Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    // Measurement-1 Manually list show of existing user..
    func API_ExistingUserMeasurement(DressTypeId : String, UserId : String, delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Existing User Measurement Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetExistingUserMeasurement?DressTypeId=\(DressTypeId)&UserId=\(UserId)", arguments: [baseURL])
            
            print("ExistingUserMeasurement URL STRING", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    
                    delegate.API_CALLBACK_ExistingUserMeasurement!(getExistUserMeasurement: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 27, errorMessage: "Profile User Type Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    // Measurement-2 Parts after selection..
    func API_GetMeasurementParts(MeasurementParts : Int, delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Measurement Parts Value")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetMeasurementParts?Id=\(MeasurementParts)", arguments: [baseURL])
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                print("REQUEST", urlString)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    // print("response", self.resultDict)
                    delegate.API_CALLBACK_GetMeasurementParts!(getParts: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 28, errorMessage: "Get Measurement parts Value Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    // Measurement-2 Parts Tab..
    func API_DisplayMeasurement(Measurement2Value : Int, delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Display Measurement Value")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/DisplayMeasurementBySubTypeId?Id=\(Measurement2Value)", arguments: [baseURL])
            
            print("Display Measurement URL STRING", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_DisplayMeasurement!(GetMeasurement2val: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 29, errorMessage: "Display Measurement Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    // Profile User Type..
    func API_IsProfileUserType(UserType : String , UserId : Int, delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Profile User Type")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Login/IsProfileCreated?UserType=\(UserType)&Id=\(UserId)", arguments: [baseURL])
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    
                    delegate.API_CALLBACK_ProfileUserType!(userType: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 30, errorMessage: "Profile User Type Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    // Mesurement-2 values Insert..
    func API_InsertUserMeasurementValues(UserId : Int, DressTypeId : Int, MeasurementValue : [[String: Any]], MeasurementBy : String, CreatedBy : String, Units : String, Name : String, delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Measurement Values Page")
            
            let parameters = ["UserId" : UserId, "DressTypeId" : DressTypeId, "MeasurementValue" : MeasurementValue, "MeasurementBy" : MeasurementBy, "CreatedBy" : CreatedBy, "Units" : Units, "Name" : Name] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/InsertUserMeasurementValues", arguments: [baseURL])
            
            print("URL STRING", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_InsertUserMeasurement!(insUsrMeasurementVal: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 31, errorMessage: "User Measurement Values Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    //Device Details..
    func API_InsertDeviceDetails(DeviceId : String, Os : String, Manufacturer : String, CountryCode : String, PhoneNumber : String, Model : String, AppVersion : String, Type : String, Fcm : String, delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            let parameters = ["DeviceId" : deviceId!, "Os" : Os, "Manufacturer" : Manufacturer, "CountryCode" : CountryCode, "PhoneNumber" : PhoneNumber, "Model" : Model, "AppVersion" : AppVersion, "Type" : Type, "Fcm" : Fcm] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Login/InsertUpdateDeviceDetails", arguments: [baseURL])
            
            print("API_InsertDeviceDetails", urlString)
            print("API_InsertDeviceDetails", parameters)
            
            request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON {response in
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_DeviceDetails!(deviceDet: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 32, errorMessage: "Insert Device Details Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    // Image Upload.. profile
    func API_ProfileImageUpload(buyerImages : UIImage, delegate : ServerAPIDelegate)
    {
        let date = Date().timeIntervalSince1970
        print("DATE", date)
        
        let dateInt = Int(date)
        
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Image Upload Page")
            
            let parameters = ["BuyerImages" : buyerImages] as [String : UIImage]
            
            let urlString:String = String(format: "%@/API/FileUpload/UploadFile", arguments: [baseURL])
            
            print("URL STRING FOR OrderType", urlString)
            
            let headers: HTTPHeaders = [
                /* "Authorization": "your_access_token",  in case you need authorization header */
                "Content-type": "multipart/form-data",
                "Accept":"*/*"
            ]
            
            upload(multipartFormData: {(multipartFormData:MultipartFormData) in
                for (key,value) in parameters
                {
                    print("VALUES", value)
                    multipartFormData.append(value.jpegData(compressionQuality: 0.5)!, withName: key, fileName: "Profile_\(dateInt).png", mimeType: "image/jpeg")
                };
                
            }, usingThreshold: UInt64.init(), to:  urlString, method: .post, headers: headers, encodingCompletion: { encodingResult in
                switch encodingResult
                {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        print("SUCCESS IMAGE", response)
                        
                        if response.result.value != nil{
                            self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                            delegate.API_CALLBACK_ProfileImageUpload!(ImageUpload: self.resultDict)
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    print("FAILURE IMAGE", encodingError)
                    delegate.API_CALLBACK_Error(errorNumber: 33, errorMessage: "Image Upload Page Failed")
                }
            })
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    // Tailor List View..
    func API_GetTailorList(DressSubType : String, OrderType : String, MeasuremenType : String, DeliveryType : String, AreaId : String, Customization : [[String: Int]], delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Tailor List Page")
            
            let parameters = ["DressSubType" : DressSubType, "OrderType" : OrderType, "MeasuremenType" : MeasuremenType, "DeliveryType" : DeliveryType, "AreaId" : AreaId, "Customization" : Customization] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetTailorlist", arguments: [baseURL])
            
            print("URL STRING FOR Tailor List", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON {response in
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_GetTailorList!(TailorList: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 34, errorMessage: "Tailor List Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    // Device error...
    func API_InsertErrorDevice(DeviceId : String, PageName : String, MethodName : String, Error : String, ApiVersion : String, Type : String, delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            let parameters = ["DeviceId" : DeviceId, "PageName" : PageName, "MethodName" : MethodName, "Error" : Error, "ApiVersion" : ApiVersion, "Type" : Type] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Login/InsertError", arguments: [baseURL])
            
            request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {response in
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_InsertErrorDevice!(deviceError: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 35, errorMessage: "Insert Error Device Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    
    // Order Summary... 19/12/2018..
    func API_InsertOrderSummary(dressType : Int, CustomerId : Int, AddressId : Int, PatternId : Int, Ordertype : Int, MeasurementId : Int, MaterialImage : [String], ReferenceImage : [String], OrderCustomization : [[String : Any]], TailorId : [[String: Any]], MeasurementBy : String, CreatedBy : Int, MeasurementName : String, UserMeasurement : [[String : Any]], DeliveryTypeId : Int, units : String, measurementType : Int, delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Order Summary Page")
            
            let parameters = ["dressType" : dressType, "CustomerId" : CustomerId, "AddressId" : AddressId, "PatternId" : PatternId, "Ordertype" : Ordertype, "MeasurementId" : MeasurementId, "MaterialImage" : MaterialImage, "ReferenceImage" : ReferenceImage, "OrderCustomization" : OrderCustomization, "TailorId" : TailorId, "MeasurementBy" : MeasurementBy, "CreatedBy" : CreatedBy, "MeasurementName" : MeasurementName, "UserMeasurementValues" : UserMeasurement, "DeliveryTypeId" : DeliveryTypeId, "Units" : units, "MeasurmentType" : measurementType] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/InsertOrder", arguments: [baseURL])
            
            print("URL STRING", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_InsertOrderSummary!(insertOrder: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 36, errorMessage: "Insert Order Summary Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    func API_GetStateListByCountry(countryId : String, delegate : ServerAPIDelegate)
    {
        
        if Reachability.Connection.self != .none
        {
            
            print("Server Reached - State List Page")
            
            let parameters = ["Id" : countryId] as [String : Any]
            
            let urlString:String = String(format: "%@/api/Shop/DisplayStatebyCountry", arguments: [baseURL])
            
            print("URL STRING", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON {response in
                
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_GetStateListByCountry!(stateList: self.resultDict)
                    print("response", self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 37, errorMessage: "State List Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    // Order Approval .. 21/12/2018..
    func API_OrderApprovalPrice(TailorResponseId : Int , delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached -  Value")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetTailorResponseList?TailorResponseId=\(TailorResponseId)", arguments: [baseURL])
            
            print("Order Approval Pricing: ", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    // print("response", self.resultDict)
                    delegate.API_CALLBACK_OrderApprovalPrice!(orderApprovalPrice: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 38, errorMessage: "Order Approval Pricing Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    func API_OrderApprovalDelivery(TailorResponseId : Int , delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached -  Value")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetTailorResponseList2?TailorResponseId=\(TailorResponseId)", arguments: [baseURL])
            
            print("Order Approval Delivery: ", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    // print("response", self.resultDict)
                    delegate.API_CALLBACK_OrderApprovalDelivery!(orderApprovalDelivery: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 39, errorMessage: "Order Approval Delivery Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    // 27-12-2018..
    
    func API_GetQuotationList(OrderId : Int , delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached -  Value")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetQuotationList?OrderId=\(OrderId)", arguments: [baseURL])
            
            print("Tailor Quotation List: ", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    // print("response", self.resultDict)
                    delegate.API_CALLBACK_GetQuotationList!(quotationList: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 40, errorMessage: "Get Quotation List Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    func API_GetOrderRequest(RequestId : Int , delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached -  Value")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetOrderRequest?Id=\(RequestId)", arguments: [baseURL])
            
            print("Order Request List: ", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                // print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    print("response", self.resultDict)
                    delegate.API_CALLBACK_GetOrderRequest!(requestList: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 41, errorMessage: "Get Order Request Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    //Book an Appointment Material..
    func API_InsertAppoinmentMaterial(OrderId : Int, AppointmentType : Int, AppointmentTime : String, From : String, To : String, CreatedBy : String, delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Book an Appointment Page")
            
            let parameters = ["OrderId" : OrderId, "AppointmentType" : AppointmentType, "AppointmentTime" : AppointmentTime, "From" : From, "To" : To, "CreatedBy" : CreatedBy] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/InsertAppointforMaterial", arguments: [baseURL])
            
            print("URL STRING", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_InsertAppointmentMaterial!(insertAppointmentMaterial: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 42, errorMessage: "Insert Appoinment Material Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    //Book an Appointment Measurement..
    func API_InsertAppoinmentMeasurement(OrderId : Int, AppointmentType : Int, AppointmentTime : String, From : String, To : String, CreatedBy : String, delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Book an Appointment Page")
            
            let parameters = ["OrderId" : OrderId, "AppointmentType" : AppointmentType, "AppointmentTime" : AppointmentTime, "From" : From, "To" : To, "CreatedBy" : CreatedBy] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/InsertAppointforMeasurement", arguments: [baseURL])
            
            print("URL STRING", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_InsertAppointmentMeasurement!(insertAppointmentMeasure: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 43, errorMessage: "Insert Appoinment Measurement Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    func API_SortAscending(delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Sort Ascending Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetAscendingDressType", arguments: [baseURL])
            
            print("URL STRING", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_SortAscending!(ascending: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 44, errorMessage: "Sort Ascending Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    func API_SortDescending(delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Sort Descending Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetDescendingDressType", arguments: [baseURL])
            
            print("URL STRING", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_SortDescending!(descending: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 45, errorMessage: "Sort Descending Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    
    // Order Approval - Qty update..
    func API_UpdateQtyOrderApproval(OrderId : Int, Qty : Int, delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Order Approval Page")
            
            let parameters = ["OrderId" : OrderId, "Qty" : Qty] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/UPdateQtyInOrderApproval", arguments: [baseURL])
            
            print("URL STRING", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_UpdateQtyOrderApproval!(updateQtyOA: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 46, errorMessage: "Order Approval Qty Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    // Book an Appointment Get Material..
    func API_GetAppointmentMaterial(OrderId : Int , delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Book an Appointemnt Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetCustomerInAppoinmentMeaterial?OrderId=\(OrderId)", arguments: [baseURL])
            
            print("Order Request List: ", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                // print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    // print("response", self.resultDict)
                    delegate.API_CALLBACK_GetAppointmentMaterial!(getAppointmentMaterial: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 47, errorMessage: "Get Appointment Material Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    // Book an Appointment Get Measurement..
    func API_GetAppointmentMeasurement(OrderId : Int , delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached -  Book an Appointemnt Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetCustomerInAppoinmentMeasurement?OrderId=\(OrderId)", arguments: [baseURL])
            
            print("Order Request List: ", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                // print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    // print("resultDict", self.resultDict)
                    delegate.API_CALLBACK_GetAppointmentMeasurement!(getAppointmentMeasure: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 48, errorMessage: "Get Appointment Measurement Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    // Book an Appointment IsApprove Material..
    func API_IsApproveAppointmentMaterial(AppointmentId : Int, IsApproved : Int, Reason:String, delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Book an Appointemnt Page")
            
            let parameters = ["AppointmentId" : AppointmentId, "IsApproved" : IsApproved, "Reason" : Reason] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/BuyerOrderApprovalMaterial", arguments: [baseURL])
            
            print("Appointment IsApprove: ", urlString)
            
            request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {response in
                // print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    print("response", self.resultDict)
                    delegate.API_CALLBACK_IsApproveAptMaterial!(IsApproveMaterial: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 49, errorMessage: "IsApprove Material Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    // Book an Appointment IsApprove Measurement..
    func API_IsApproveAppointmentMeasurement(AppointmentId : Int, IsApproved : Int, Reason:String, delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached -  Book an Appointemnt Page")
            
            let parameters = ["AppointmentId" : AppointmentId, "IsApproved" : IsApproved, "Reason" : Reason] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/BuyerOrderApprovalMeasurement", arguments: [baseURL])
            
            print("Appointment IsApprove: ", urlString)
            
            request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {response in
                // print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    print("response", self.resultDict)
                    delegate.API_CALLBACK_IsApproveAptMeasurement!(IsApproveMeasure: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 50, errorMessage: "IsApprove Measurement Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    
    // Payment Status....
    func API_updatePaymentStatus(PaymentStatus : Int, OrderId : Int, delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached -  Payment Page")
            
            let parameters = ["PaymentStatus" : PaymentStatus, "OrderId" : OrderId] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/UpatePaymentStatus", arguments: [baseURL])
            
            print("Update Payment Status: ", urlString)
            
            request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {response in
                // print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    print("response", self.resultDict)
                    delegate.API_CALLBACK_UpdatePaymentStatus!(updatePaymentStatus: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 51, errorMessage: "Payment Status Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    // Buyer Order Approval....
    func API_BuyerOrderApproval(OrderId : Int, ApprovedTailorId : Int, delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached -  Payment Page")
            
            let parameters = ["OrderId" : OrderId, "ApprovedTailorId" : ApprovedTailorId] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/BuyerOrderApproval", arguments: [baseURL])
            
            print("Buyer Order Approval: ", urlString)
            
            request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {response in
                // print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    print("response", self.resultDict)
                    delegate.API_CALLBACK_BuyerOrderApproval!(buyerOrderApproval: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 52, errorMessage: "Payment Status Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    // Get Appointments List..
    func API_GetAppointmentList(BuyerId : Int , delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Appointment List Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetAppoinmentList?BuyerId=\(BuyerId)", arguments: [baseURL])
            
            print("Order Request List: ", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                // print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    print("resultDict", self.resultDict)
                    delegate.API_CALLBACK_GetAppointmentList!(getAppointmentList: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 53, errorMessage: "Appointment List Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    // Total Appointment List.. Approve and reject List..
    func API_ApproveRejectAppointmentList(BuyerId : Int , delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Appointment List Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetTotelAppoinmentList?BuyerId=\(BuyerId)", arguments: [baseURL])
            
            print("Order Request List: ", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                // print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    print("resultDict", self.resultDict)
                    delegate.API_CALLBACK_ApproveRejectAppointmentList!(getTotalAppointmentList: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 54, errorMessage: "Appointment List Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    func API_ServiceRequest(delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Service Request Page")
            
            let urlString:String = String(format: "%@/API/Shop/GetServiceType", arguments: [baseURL])
            
            print("URL STRING FOR Service Request", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: URLEncoding.default).responseJSON {response in
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    
                    delegate.API_CALLBACK_ServiceRequest!(service: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 55, errorMessage: "Service Request Failed")
                }
            }
        }
        
    }
    
    // Get Ratings..
    func API_GetRatings(TailorId : Int , delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Reviews and Ratings Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetRating?TailorId=\(TailorId)", arguments: [baseURL])
            
            print("Get Ratings List: ", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                // print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    print("resultDict", self.resultDict)
                    delegate.API_CALLBACK_GetRatings!(getRatings: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 56, errorMessage: "Get Ratings Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    
    
    func API_DirectionRequest(origin : String, destination : String, delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Direction Page")
            
            let urlString:String = String(format: "%@https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving", arguments: [])
            
            print("URL STRING", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: URLEncoding.default).responseJSON {response in
                
                print("REQUEST", request)
                //                let json = JSON(data: response.data!)
                //                let routes = json["routes"].arrayValue
                
                print("ROUTES", response.data)
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_DirectionRequest!(direction: self.resultDict)
                    print("response", self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 57, errorMessage: "Direction Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    // Insert Ratings...
    func API_InsertRatings(OrderId : Int, CategoryId0 : Int, CategoryRating0 : Int, CategoryId1 : Int, CategoryRating1 : Int, CategoryId2 : Int, CategoryRating2 : Int, Review : String, TailorId : Int, delegate : ServerAPIDelegate)
   {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Reviews And Ratings Page")
            
            let parameters = ["OrderId" : OrderId, "Category[0][Id]" : CategoryId0, "Category[0][Rating]" : CategoryRating0, "Category[1][Id]" : CategoryId1, "Category[1][Rating]" : CategoryRating1, "Category[2][Id]" : CategoryId2, "Category[2][Rating]" : CategoryRating2, "Review" : Review, "TailorId" : TailorId] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/InsertRating", arguments: [baseURL])
            
            print("URL STRING", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_InsertRating!(insertRating: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 58, errorMessage: "Insert Ratings Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    //  List Of Orders(Pending)..
    func API_ListOfOrdersPending(BuyerId : String , delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - List Of Orders Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/ListOfOrderPending?BuyerId=\(BuyerId)", arguments: [baseURL])
            
            print("List of Orders(Pending): ", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                // print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    //print("resultDict", self.resultDict)
                    
                    delegate.API_CALLBACK_ListOfPendOrders!(PendingOrdersList: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 59, errorMessage: "List Of Orders Failed")
                    
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    
    //  ORder Details..
    func API_GetOrderDetails(OrderId : Int , delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - List Of Orders Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetOrderDetails?OrderId=\(OrderId)", arguments: [baseURL])
            
            print("Order Details: ", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                // print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    // print("resultDict", self.resultDict)
                    
                    delegate.API_CALLBACK_GetOrderDetails!(getOrderDetails: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 60, errorMessage: "Order Details Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    //  Tracking Details..
    func API_GetTrackingDetails(OrderId : Int , delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - List Of Orders Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetTrackingDetails?OrderId=\(OrderId)", arguments: [baseURL])
            
            print("Tracking Details: ", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                // print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    print("resultDict", self.resultDict)
                    
                    delegate.API_CALLBACK_GetTrackingDetails!(getTrackingDetails: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 61, errorMessage: "Tracking Details Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    func API_ReferenceImageUpload(referenceImages : [UIImage], delegate : ServerAPIDelegate)
    {
        let date = Date().timeIntervalSince1970
        print("DATE", date)
        
        let dateInt = Int(date)
        
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Reference Image Upload Page")
            
            let parameters = ["ReferenceImages" : referenceImages] as [String : [UIImage]]
            
            let urlString:String = String(format: "%@/API/FileUpload/UploadFile", arguments: [baseURL])
            
            print("URL STRING FOR OrderType", urlString)
            
            let headers: HTTPHeaders = [
                /* "Authorization": "your_access_token",  in case you need authorization header */
                "Content-type": "multipart/form-data",
                "Accept":"*/*"
            ]
            
            upload(multipartFormData: {(multipartFormData:MultipartFormData) in
                
                for (keys,values) in parameters
                {
                    print("VALUES IN REFERENCE API", values)
                    
                    for i in 0..<values.count
                    {
                        if let image = values[i] as? UIImage
                        {
                            print("IMAGE IN REFERENCE", image)
                            if image != nil
                            {
                                multipartFormData.append(image.jpegData(compressionQuality: 0.5)!, withName: keys, fileName: "Reference\(dateInt).png", mimeType: "image/jpeg")
                            }
                        }
                        
                    }
                };
                
            }, usingThreshold: UInt64.init(), to:  urlString, method: .post, headers: headers, encodingCompletion: { encodingResult in
                switch encodingResult
                {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        print("SUCCESS IMAGE", response)
                        
                        if response.result.value != nil{
                            self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                            delegate.API_CALLBACK_ReferenceImageUpload!(reference: self.resultDict)
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    print("FAILURE IMAGE", encodingError)
                    delegate.API_CALLBACK_Error(errorNumber: 62, errorMessage: "REFERENCE Image Upload Page Failed")
                }
            })
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    func API_MaterialImageUpload(materialImages : [UIImage], delegate : ServerAPIDelegate)
    {
        let date = Date().timeIntervalSince1970
        print("DATE", date)
        
        let dateInt = Int(date)
        
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Material Image Upload Page", materialImages.count)
            
            let parameters = ["MaterialImages" : materialImages] as [String : [UIImage]]
            
            let urlString:String = String(format: "%@/API/FileUpload/UploadFile", arguments: [baseURL])
            
            print("URL STRING FOR OrderType", urlString)
            
            let headers: HTTPHeaders = [
                /* "Authorization": "your_access_token",  in case you need authorization header */
                "Content-type": "multipart/form-data",
                "Accept":"*/*"
            ]
            
            upload(multipartFormData: {(multipartFormData:MultipartFormData) in
                
                for (keys,values) in parameters
                {
                    print("VALUES IN MATERIAL API", values)
                    
                    for i in 0..<values.count
                    {
                        if let image = values[i] as? UIImage
                        {
                            print("IMAGE IN MATERIAL", image)
                            if image != nil
                            {
                                multipartFormData.append(image.jpegData(compressionQuality: 0.5)!, withName: keys, fileName: "Material\(dateInt).png", mimeType: "image/jpeg")
                            }
                        }
                        
                    }
                };
                
            }, usingThreshold: UInt64.init(), to:  urlString, method: .post, headers: headers, encodingCompletion: { encodingResult in
                switch encodingResult
                {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        print("SUCCESS IMAGE", response)
                        
                        if response.result.value != nil{
                            self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                            delegate.API_CALLBACK_MaterialImageUpload!(material: self.resultDict)
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    print("FAILURE IMAGE", encodingError)
                    delegate.API_CALLBACK_Error(errorNumber: 63, errorMessage: "Material Image Upload Page Failed")
                }
            })
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
   
    
    
    
    // Insert Payment Status...
    func API_InsertPaymentStatus(OrderId : Int, Transactionid : String, Amount : String, Status : String, Code : String, message : String, cvv : String, avs : String, cardcode : String, cardlast4 : String, Trace : String, ca_Valid : String,delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Payment Transaction Page")
            
            let parameters = ["OrderId" : OrderId, "Transactionid" : Transactionid, "Amount" : Amount, "Status" : Status, "Code" : Code, "message" : message, "cvv" : cvv, "avs" : avs, "cardcode" : cardcode, "cardlast4" : cardlast4, "Trace" : Trace, "ca_Valid" : ca_Valid] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/InsertPaymentStatus", arguments: [baseURL])
            
            print("URL STRING", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_InsertPaymentStatus!(status: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 64, errorMessage: "Insert Payment Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    
    //19.02.2019
    func API_GetAreaByState(stateId : String, delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            
            print("Server Reached - Get Area By State Page")
            
            let parameters = ["Id" : stateId] as [String : Any]
            
            let urlString:String = String(format: "%@/api/Shop/GetAreaByState", arguments: [baseURL])
            
            print("URL STRING AREA", urlString)
            print("PARAMETERS AREA", parameters)
            
            request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {response in
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_GetAreaByState!(area: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber:65, errorMessage: "Get Area By State Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }

    
    //  Payment Store Details..  20/2/2019
    func API_GetPaymentStoreDetails(delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Payment Summary Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetPaymentStore", arguments: [baseURL])
            
            print("Payment Store Details: ", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                // print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    // print("resultDict", self.resultDict)
                    
                    delegate.API_CALLBACK_GetPaymentStore!(StoreDetails: self.resultDict)
                    
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 66, errorMessage: "Payment Store Details Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
  
  
    // Get AppointmentDate ForMaterail List
    func API_GetAppointmentDateForMaterail(OrderId : Int , delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Appointment List Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetAppointmentDateForMaterail?OrderId=\(OrderId)", arguments: [baseURL])
            
            print("Order Request List: ", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                // print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                   // print("resultDict", self.resultDict)
                    delegate.API_CALLBACK_GetAppointmentDateForMaterail!(MaterialDate: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 67, errorMessage: "Appointment List Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
 
    
    // Get AppointmentDate For Measurement List..
    func API_GetAppointmentDateForMeasurement(OrderId : Int , delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Appointment List Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetAppointmentDateForMeasurement?OrderId=\(OrderId)", arguments: [baseURL])
            
            print("Order Request List: ", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                // print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                   // print("resultDict", self.resultDict)
                    delegate.API_CALLBACK_GetAppointmentDateForMeasurement!(MeasurementDate: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 68, errorMessage: "Appointment List Failed")
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    //  List Of Orders(Delivered)..
    func API_ListOfOrdersDelivered(BuyerId : String , delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - List Of Orders Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/ListOfOrderDelivered?BuyerId=\(BuyerId)", arguments: [baseURL])
            
            print("List of Orders(Delivered): ", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                // print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    //print("resultDict", self.resultDict)
                    
                    delegate.API_CALLBACK_ListOfDeliverOrders!(DeliverOrdersList: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 69, errorMessage: "List Of Orders Failed")
                    
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    
    //  Get Payment Address..
    func API_GetPaymentAddress(BuyerId : String , delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Payment Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetPaymentAddress?BuyerId=\(BuyerId)", arguments: [baseURL])
            
            print("Get Payment Address: ", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                // print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    //print("resultDict", self.resultDict)
                    
                    delegate.API_CALLBACK_GetPaymentAddress!(getAddress:self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 60, errorMessage: "Payment Address Failed")
                    
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    //  Get Shop Details..
    func API_GetShopDetails(TailorId : Int , delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Shop Details Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetShopDetails?TailorId=\(TailorId)", arguments: [baseURL])
            
            print("Get Shop Details: ", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                // print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    //print("resultDict", self.resultDict)
                    
                    delegate.API_CALLBACK_GetShopDetails!(getShopDetails: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 61, errorMessage: "Shop Details Failed")
                    
                }
            }
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    //17.04.2019
    
    func API_ViewDetails(patternId : Int, delegate : ServerAPIDelegate)
    {
        
        if Reachability.Connection.self != .none
        {
            print("Server Reached - View Details Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/Api/Order/ViewMaterialDetails?Id=\(patternId)", arguments: [baseURL])
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    
                    delegate.API_CALLBACK_ViewDetails!(details: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 62, errorMessage: "View Details Failed")
                }
            }
            
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    //25.04.2019
    
    func API_MeasurementList(userId : Int, delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Measurement List Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/Api/order/MeasurementList?CustomerId=\(userId)", arguments: [baseURL])
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_MeasurementList!(list: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 63, errorMessage: "Measuremen tList Failed")
                }
            }
            
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
    
    // 03.05.2019
    func API_GetTailorListType(delegate : ServerAPIDelegate)
    {
        if Reachability.Connection.self != .none
        {
            print("Server Reached - Tailor List Type Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/Api/order/GetTailorListType", arguments: [baseURL])
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_GetTailorListType!(tailorType: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 65, errorMessage: "Tailor List Type Failed")
                }
            }
            
        }
        else
        {
            delegate.API_CALLBACK_Error(errorNumber: 0, errorMessage: "No Internet")
        }
    }
}
