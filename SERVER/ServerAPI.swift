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
    
//    var baseURL:String = "http://192.168.0.21/TailorAPI"
    var baseURL:String = "http://appsapi.mzyoon.com"
    
    let deviceId = UIDevice.current.identifierForVendor

    func API_LoginUser(CountryCode : String, PhoneNo : String, delegate:ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Login Page")
            
            let parameters = ["CountryCode" : CountryCode, "PhoneNo" : PhoneNo, "DeviceId" : "\(String(describing: deviceId!))"] as [String : Any]
            
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
            print("no internet")
        }
    }
    
    func API_ValidateOTP(CountryCode : String, PhoneNo : String, otp : String, type : String, delegate:ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
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
                    delegate.API_CALLBACK_Error(errorNumber: 1, errorMessage: "Validate OTP Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    func API_CountryCode(delegate : ServerAPIDelegate)
    {
        
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Country Code Page")
            
            let parameters = [:] as [String : Any]
            
            
            let urlString:String = String(format: "%@/API/login/getallcountries", arguments: [baseURL])
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    
                    delegate.API_CALLBACK_CountryCode!(countryCodes: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 2, errorMessage: "Country Code Failed")
                }
                
                
            }
            
        }
        else
        {
            print("no internet")
        }
    }
    
    func API_FlagImages(imageName : String, delegate : ServerAPIDelegate)
    {
        
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Flag Images Page")
            
            let parameters = [:] as [String : Any]
            
            
            let urlString:String = String(format: "%@/images/flags/\(imageName)", arguments: [baseURL])
            
            print("URL STRING", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    
                    delegate.API_CALLBACK_FlagImages!(flagImages: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 3, errorMessage: "Flag Images Failed")
                }
            }
            
        }
        else
        {
            print("no internet")
        }
    }
    
    func API_Gender(delegate : ServerAPIDelegate)
    {
        
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Gender Page")
            
            let parameters = [:] as [String : Any]
            
            
            let urlString:String = String(format: "%@/API/Order/GetGenders", arguments: [baseURL])
            
            print("URL STRING FOR GENDER", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: URLEncoding.default).responseJSON {response in
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    
                    delegate.API_CALLBACK_Gender!(gender: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 4, errorMessage: "Genders Failed")
                }
            }
            
        }
        else
        {
            print("no internet")
        }
    }
    
    func API_GenderImage(imageName : String, delegate : ServerAPIDelegate)
    {
        
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Gender Image Page")
            
            let parameters = [:] as [String : Any]
            
            
            let urlString:String = String(format: "%@/images/\(imageName)", arguments: [baseURL])
            
            print("URL STRING FOR GENDER", urlString)
            
            /*request(urlString, method: .get, parameters: nil, encoding: URLEncoding.default).responseJSON {response in
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_GenderImage!(genderImage: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 4, errorMessage: "Genders Image Failed")
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
            print("no internet")
        }
    }
    
    func API_DressType(genderId : Int, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Dress Type Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetDressTypeByGender?genderId=\(genderId)", arguments: [baseURL])
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    
                    delegate.API_CALLBACK_DressType!(dressType: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 5, errorMessage: "Dress Type Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    func API_Customization1(originId : [Int], seasonId : [Int], delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Customization 1 Page")
            
            let parameters = ["placeofOrginId[0][id]" : "\(originId)", "seasonId[0][id]" : "\(seasonId)"] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetCustomization1", arguments: [baseURL])
            
//            let urlString = "http://192.168.0.21/TailorAPI/API/Order/GetCustomization1"
            
            print("Customization 1URL STRING", urlString)
            print("Customization 1 PARAMETERS", parameters)
            
            request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON {response in
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    
                    delegate.API_CALLBACK_Customization1!(custom1: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 6, errorMessage: "Customization 1 Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    func API_Customization2(originId : [Int], seasonId : [Int], ColorId : [Int], delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Customization 2 Page")
            
            let parameters = ["BrandId[0][Id]" : "\(originId)", "MaterialTypeId[0][Id]" : "\(seasonId)", "ColorId[0][Id]" : ColorId] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetCustomization2", arguments: [baseURL])
            
            print("URL STRING", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_Customization2!(custom2: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 6, errorMessage: "Customization 2 Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    func API_Profile(delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
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
                    delegate.API_CALLBACK_Error(errorNumber: 6, errorMessage: "Customization 1 Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    func API_OrderType(delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
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
                    delegate.API_CALLBACK_Error(errorNumber: 10, errorMessage: "Order Type Failed")
                }
            }
            
        }
        else
        {
            print("no internet")
        }
    }
    
    func API_Measurement1(delegate : ServerAPIDelegate)
    {
        
        if (Reachability()?.isReachable)!
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
                    delegate.API_CALLBACK_Error(errorNumber: 13, errorMessage: "Measurement1 Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    func API_Customization3(DressTypeId : Int, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Customization 3 Page")
            
            let parameters = ["DressTypeId" : "\(DressTypeId)"] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetCustomization3", arguments: [baseURL])
            
            print("Custom 3", urlString)
                        
            request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON {response in
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_Customization3!(custom3: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 14, errorMessage: "Customization 3 Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    func API_Customization3Attr(AttributeId : Int, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
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
                    delegate.API_CALLBACK_Error(errorNumber: 14, errorMessage: "Customization 3 Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    func API_IntroProfile(Id : String, Name : String, profilePic : UIImage, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
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
                    delegate.API_CALLBACK_Error(errorNumber: 11, errorMessage: "Intro Profile Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    // Profile Update
    func API_ProfileUpdate(Id : Int,Email : String ,Dob : String ,Gender : String ,ModifiedBy : String ,delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
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
                    delegate.API_CALLBACK_Error(errorNumber: 12, errorMessage: "Profile Update Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    // Insert Buyer Address..
    func API_InsertAddress(BuyerId : String, FirstName : String, LastName : String, CountryId : Int, StateId : Int, Area : String, Floor : String, LandMark : String, LocationType : String, ShippingNotes : String, IsDefault : String, CountryCode : Int, PhoneNo : String, Longitude : Float, Latitude : Float, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Address Page")
            
            let parameters = ["BuyerId" : "\(BuyerId)", "FirstName" : "\(FirstName)", "LastName" : LastName, "CountryId" : CountryId, "StateId" : StateId, "Area" : Area, "Floor" : Floor, "LandMark" : LandMark, "LocationType" : LocationType, "ShippingNotes" : ShippingNotes, "IsDefault" : IsDefault, "CountryCode" : CountryCode, "PhoneNo" : PhoneNo, "Longitude" : Longitude, "Latitude" : Latitude] as [String : Any]
            
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
                    delegate.API_CALLBACK_Error(errorNumber: 6, errorMessage: "Save Address Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    // Update Buyer Address..
    func API_UpdateAddress(Id : Int ,BuyerId : Int, FirstName : String, LastName : String, CountryId : Int, StateId : Int, Area : String, Floor : String, LandMark : String, LocationType : String, ShippingNotes : String, IsDefault : String, CountryCode : Int, PhoneNo : String, Longitude : Float, Latitude : Float, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Address Page")
            
            let parameters = ["Id" : Id, "BuyerId" : BuyerId, "FirstName" : FirstName, "LastName" : LastName, "CountryId" : CountryId, "StateId" : StateId, "Area" : Area, "Floor" : Floor, "LandMark" : LandMark, "LocationType" : LocationType, "ShippingNotes" : ShippingNotes, "IsDefault" : IsDefault, "CountryCode" : CountryCode, "PhoneNo" : PhoneNo, "Longitude" : Longitude, "Latitude" : Latitude] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Shop/UpdateBuyerAddress", arguments: [baseURL])
            
            print("URL STRING", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_UpdateAddress!(updateAddr: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 6, errorMessage: "Address Update Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    //Delete Buyer Address..
    func API_DeleteAddress(AddressId : Int, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Address Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Shop/DeleteBuyerAddressByAddressId?Id=\(AddressId)", arguments: [baseURL])
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    
                    delegate.API_CALLBACK_DeleteAddress!(deleteAddr: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 5, errorMessage: "Address Delete Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    //GEt Buyer Address..
    func API_GetBuyerAddress(BuyerAddressId : Int, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Address Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Shop/GetBuyerAddressById?Id=\(BuyerAddressId)", arguments: [baseURL])
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    
                    delegate.API_CALLBACK_GetBuyerAddress!(getBuyerAddr: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 5, errorMessage: "Get Buyer Address Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    //Dress Sub-type..
    func API_DressSubType(DressSubTypeId : Int, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Dress SubType")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/DisplayDressSubType?Id=\(DressSubTypeId)", arguments: [baseURL])
            
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
                    delegate.API_CALLBACK_Error(errorNumber: 5, errorMessage: "Dress SubType Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    // Measurement-2 full body pics...
    func API_GetMeasurement1(Measurement1Value : Int, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Measurement2 Value")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetMeasurement2?Id=\(Measurement1Value)", arguments: [baseURL])
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    print("response", self.resultDict)
                    delegate.API_CALLBACK_GetMeasurement1Value!(GetMeasurement1val: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 5, errorMessage: "Get Measurement-1 Value Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
     // Measurement-1 Manually list show of existing user..
    func API_ExistingUserMeasurement(DressTypeId : String, UserId : String, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Profile User Type")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetExistingUserMeasurement?DressTypeId=\(DressTypeId)&UserId=\(UserId)", arguments: [baseURL])
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    print("response", self.resultDict)
                    
                    delegate.API_CALLBACK_ExistingUserMeasurement!(getExistUserMeasurement: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 5, errorMessage: "Profile User Type Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    // Measurement-2 Parts after selection..
    func API_GetMeasurementParts(MeasurementParts : Int, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Measurement Parts Value")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetMeasurementParts?Id=\(MeasurementParts)", arguments: [baseURL])
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                // print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    // print("response", self.resultDict)
                    delegate.API_CALLBACK_GetMeasurementParts!(getParts: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 5, errorMessage: "Get Measurement parts Value Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    // Measurement-2 Parts Tab..
    func API_GetMeasurement2(Measurement2Value : Int, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Measurement2 Value")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/DisplayMeasurementBySubTypeId?Id=\(Measurement2Value)", arguments: [baseURL])
            
            print("MEASUREMENT", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    print("response", self.resultDict)
                    delegate.API_CALLBACK_GetMeasurement2Value!(GetMeasurement2val: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 5, errorMessage: "Get Measurement-2 Value Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    // Profile User Type..
    func API_IsProfileUserType(UserType : String , UserId : Int, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Profile User Type")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Login/IsProfileCreated?UserType=\(UserType)&Id=\(UserId)", arguments: [baseURL])
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    print("response", self.resultDict)
                    
                    delegate.API_CALLBACK_ProfileUserType!(userType: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 5, errorMessage: "Profile User Type Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    // Mesurement-2 values Insert..
    func API_InsertUserMeasurementValues(UserId : Int, DressTypeId : Int, MeasurementValueId : [Int], MeasurementValue : [Int], MeasurementBy : String, CreatedBy : String, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Measurement Values Page")
            
            let parameters = ["UserId" : UserId, "DressTypeId" : DressTypeId, "MeasurementValue[0][MeasurementId]" : "\(MeasurementValueId)", "MeasurementValue[0][Value]" : "\(MeasurementValue)", "MeasurementBy" : MeasurementBy, "CreatedBy" : CreatedBy] as [String : Any]
            
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
                    delegate.API_CALLBACK_Error(errorNumber: 6, errorMessage: "User Measurement Values Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    //Device Details..
    func API_InsertDeviceDetails(DeviceId : String, Os : String, Manufacturer : String, CountryCode : String, PhoneNumber : String, Model : String, AppVersion : String, Type : String,delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - home Page")
            
            let parameters = ["DeviceId" : DeviceId, "Os" : Os, "Manufacturer" : Manufacturer, "CountryCode" : CountryCode, "PhoneNumber" : PhoneNumber, "Model" : Model, "AppVersion" : AppVersion, "Type" : Type] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Login/InsertUpdateDeviceDetails", arguments: [baseURL])
            
            print("URL STRING", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_DeviceDetails!(deviceDet: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 6, errorMessage: "Insert Device Details Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    // Image Upload.. profile
    func API_ProfileImageUpload(delegate : ServerAPIDelegate)
    {
        
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Image Upload Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/FileUpload/UploadFile", arguments: [baseURL])
            
            print("URL STRING FOR OrderType", urlString)
            
            let fileName = urlString
            
            upload(multipartFormData: {(multipartFormData:MultipartFormData) in
                for (key,value) in parameters
                {
                    multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                    multipartFormData.append(value as! Data, withName: "Profile", fileName: fileName,mimeType: "image/jpeg")
                };
                
            },usingThreshold: UInt64.init(),to: urlString,method: .post, encodingCompletion: { encodingResult in
                switch encodingResult
                {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
            })
            
            
        }
        else
        {
            print("no internet")
        }
    }
    
    // Tailor List View..
    func API_GetTailorList(delegate : ServerAPIDelegate)
    {
        
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Tailor List Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetTailorlist", arguments: [baseURL])
            
            print("URL STRING FOR Tailor List", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: URLEncoding.default).responseJSON {response in
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_GetTailorList!(TailorList: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 13, errorMessage: "Tailor List Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    // Device error...
    func API_InsertErrorDevice(DeviceId : String, PageName : String, MethodName : String, Error : String, ApiVersion : String, Type : String, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - home Page")
            
            let parameters = ["DeviceId" : DeviceId, "PageName" : PageName, "MethodName" : MethodName, "Error" : Error, "ApiVersion" : ApiVersion, "Type" : Type] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Login/InsertError", arguments: [baseURL])
            
            print("URL STRING", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_InsertErrorDevice!(deviceError: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 6, errorMessage: "Insert Error Device Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    
    // Order Summary...
    func API_InsertOrderSummary(dressType : Int, CustomerId : Int, AddressId : Int, PatternId : Int, Ordertype : Int, MeasurementId : Int, MaterialImage : [UIImage], ReferenceImage : [UIImage], OrderCustomizationAttributeId : [Int], OrderCustomizationAttributeImageId : [Int], TailorId : [Int], MeasurementBy : String, CreatedBy : Int, MeasurementName : String, UserMeasurementValuesId : [Int], UserMeasurementValues : String, DeliveryTypeId : Int, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Order Summary Page")
            
            let parameters = ["dressType" : dressType, "CustomerId" : CustomerId, "AddressId" : AddressId, "PatternId" : PatternId, "Ordertype" : Ordertype, "MeasurementId" : MeasurementId, "MaterialImage[0][Image]" : "\(MaterialImage)", "ReferenceImage[0][Image]" : "\(ReferenceImage)" , "OrderCustomization[0][CustomizationAttributeId]" : "\(OrderCustomizationAttributeId)", "OrderCustomization[0][AttributeImageId]" : "\(OrderCustomizationAttributeImageId)", "TailorId[0][Id]" : "\(TailorId)", "MeasurementBy" : MeasurementBy, "CreatedBy" : CreatedBy, "MeasurementName" : MeasurementName, "UserMeasurementValues[0][UserMeasurementId]" : "\(UserMeasurementValuesId)", "UserMeasurementValues[0][Value]" : "\(UserMeasurementValues)", "DeliveryTypeId" : DeliveryTypeId ] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/InsertOrder", arguments: [baseURL])
            
            print("URL STRING", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_InsertOrderSummary!(insertOrder: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 6, errorMessage: "Insert Order Summary Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    
    func API_GetStateListByCountry(countryId : String, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
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
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 6, errorMessage: "State List Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    
}
