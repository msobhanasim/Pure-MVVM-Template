//  MVVM Template
//
//  Created by Sobhan Asim on 17/07/2022.
//

import Foundation
struct UserInfo : Codable {
	var code : Int?
	var message : String?
	var success : UserData?
    var user_message : String?

	enum CodingKeys: String, CodingKey {

		case code = "code"
		case message = "message"
		case success = "success"
        case user_message  = "user_message"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		code = try values.decodeIfPresent(Int.self, forKey: .code)
		message = try values.decodeIfPresent(String.self, forKey: .message)
		success = try values.decodeIfPresent(UserData.self, forKey: .success)
        user_message = try values.decodeIfPresent(String.self, forKey: .user_message)
	}
    
    init(){}
    
    static func initFrom(json:[String:Any]) -> UserInfo{
        var obj = UserInfo()
        obj.code = json[CodingKeys.code.rawValue] as? Int
        obj.message = json[CodingKeys.message.rawValue] as? String
        
        if let user = json[CodingKeys.success.rawValue] as? [String:Any]{
            obj.success = UserData.initFrom(json: user)
        }
        
        obj.user_message = json[CodingKeys.user_message.rawValue] as? String
        
        return obj
    }
    
    
    func saveCurrentSession(forKey: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self) {
            UserDefaults.standard.set(encoded, forKey: forKey)
        }
    }
}
