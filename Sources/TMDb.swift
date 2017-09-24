//
//  TMDb.swift
//  TMDb
//
//  Created by Shane Whitehead on 22/9/17.
//  Copyright © 2017 TMDb. All rights reserved.
//

import Foundation

/*
v3 API Key: ...
API Read Access Token (v4): ...
example: https://api.themoviedb.org/3/movie/550?api_key=...
*/

let baseURL = "https://api.themoviedb.org/3"

public protocol Identifiable {
  var id: Int {get}
}

public class TMDb {
  public static var shared: TMDb = TMDb()
  
  public var apiKey: String?
  public var readAccessToken: String?
  
  fileprivate init() {
  }
}

/*
 Language + Country
 english + australia = en-AU
 */

public struct Language: CustomStringConvertible {
  public let name: String
  public let code: String
  private var country: Country?
  static private var registry: [String: Language] = [:]
  
  public init(name: String, code: String, country: Country? = nil, register: Bool = true) {
    self.name = name
    self.code = code
    self.country = country
    guard register else {
      return
    }
    Language.registry[code] = self
  }
  
  public func from(_ country: Country) -> Language {
    return Language(name: name, code: code, country: country, register: false)
  }
  
  public var description: String {
    guard let country = country else {
      return code
    }
    
    return "\(code)-\(country.rawValue.uppercased())"
  }
  
  public static func find(byCode: String) -> Language? {
    return Language.registry[byCode]
  }
  
}

func + (lhs: Language, rhs: Country) -> Language {
  return lhs.from(rhs)
}

func + (lhs: Country, rhs: Language) -> Language {
  return rhs.from(lhs)
}

public extension Language {

  public static let afar: Language = Language(name: "Afar", code: "aa")
  public static let abkhazian: Language = Language(name: "Abkhazian", code: "ab")
  public static let avestan: Language = Language(name: "Avestan", code: "ae")
  public static let afrikaans: Language = Language(name: "Afrikaans", code: "af")
  public static let akan: Language = Language(name: "Akan", code: "ak")
  public static let amharic: Language = Language(name: "Amharic", code: "am")
  public static let aragonese: Language = Language(name: "Aragonese", code: "an")
  public static let arabic: Language = Language(name: "Arabic", code: "ar")
  public static let assamese: Language = Language(name: "Assamese", code: "as")
  public static let avaric: Language = Language(name: "Avaric", code: "av")
  public static let aymara: Language = Language(name: "Aymara", code: "ay")
  public static let azerbaijani: Language = Language(name: "Azerbaijani", code: "az")
  public static let bashkir: Language = Language(name: "Bashkir", code: "ba")
  public static let belarusian: Language = Language(name: "Belarusian", code: "be")
  public static let bulgarian: Language = Language(name: "Bulgarian", code: "bg")
  public static let bihari: Language = Language(name: "Bihari", code: "bh")
  public static let bislama: Language = Language(name: "Bislama", code: "bi")
  public static let bambara: Language = Language(name: "Bambara", code: "bm")
  public static let bengali: Language = Language(name: "Bengali", code: "bn")
  public static let tibetan: Language = Language(name: "Tibetan", code: "bo")
  public static let breton: Language = Language(name: "Breton", code: "br")
  public static let bosnian: Language = Language(name: "Bosnian", code: "bs")
  public static let catalan: Language = Language(name: "Catalan", code: "ca")
  public static let chechen: Language = Language(name: "Chechen", code: "ce")
  public static let chamorro: Language = Language(name: "Chamorro", code: "ch")
  public static let corsican: Language = Language(name: "Corsican", code: "co")
  public static let cree: Language = Language(name: "Cree", code: "cr")
  public static let czech: Language = Language(name: "Czech", code: "cs")
  public static let churchSlavic: Language = Language(name: "Church Slavic", code: "cu")
  public static let chuvash: Language = Language(name: "Chuvash", code: "cv")
  public static let welsh: Language = Language(name: "Welsh", code: "cy")
  public static let danish: Language = Language(name: "Danish", code: "da")
  public static let german: Language = Language(name: "German", code: "de")
  public static let divehi: Language = Language(name: "Divehi", code: "dv")
  public static let dzongkha: Language = Language(name: "Dzongkha", code: "dz")
  public static let ewe: Language = Language(name: "Ewe", code: "ee")
  public static let greek: Language = Language(name: "Greek", code: "el")
  public static let english: Language = Language(name: "English", code: "en")
  public static let esperanto: Language = Language(name: "Esperanto", code: "eo")
  public static let spanish: Language = Language(name: "Spanish", code: "es")
  public static let estonian: Language = Language(name: "Estonian", code: "et")
  public static let basque: Language = Language(name: "Basque", code: "eu")
  public static let persian: Language = Language(name: "Persian", code: "fa")
  public static let fulah: Language = Language(name: "Fulah", code: "ff")
  public static let finnish: Language = Language(name: "Finnish", code: "fi")
  public static let fijian: Language = Language(name: "Fijian", code: "fj")
  public static let faroese: Language = Language(name: "Faroese", code: "fo")
  public static let french: Language = Language(name: "French", code: "fr")
  public static let westernFrisian: Language = Language(name: "Western Frisian", code: "fy")
  public static let irish: Language = Language(name: "Irish", code: "ga")
  public static let scottishGaelic: Language = Language(name: "Scottish Gaelic", code: "gd")
  public static let galician: Language = Language(name: "Galician", code: "gl")
  public static let guarani: Language = Language(name: "Guarani", code: "gn")
  public static let gujarati: Language = Language(name: "Gujarati", code: "gu")
  public static let manx: Language = Language(name: "Manx", code: "gv")
  public static let hausa: Language = Language(name: "Hausa", code: "ha")
  public static let hebrew: Language = Language(name: "Hebrew", code: "he")
  public static let hindi: Language = Language(name: "Hindi", code: "hi")
  public static let hiriMotu: Language = Language(name: "Hiri Motu", code: "ho")
  public static let croatian: Language = Language(name: "Croatian", code: "hr")
  public static let haitian: Language = Language(name: "Haitian", code: "ht")
  public static let hungarian: Language = Language(name: "Hungarian", code: "hu")
  public static let armenian: Language = Language(name: "Armenian", code: "hy")
  public static let herero: Language = Language(name: "Herero", code: "hz")
  public static let interlingua: Language = Language(name: "Interlingua (International Auxiliary Language Association)", code: "ia")
  public static let indonesian: Language = Language(name: "Indonesian", code: "id")
  public static let interlingue: Language = Language(name: "Interlingue", code: "ie")
  public static let igbo: Language = Language(name: "Igbo", code: "ig")
  public static let sichuanYi: Language = Language(name: "Sichuan Yi", code: "ii")
  public static let inupiaq: Language = Language(name: "Inupiaq", code: "ik")
  public static let ido: Language = Language(name: "Ido", code: "io")
  public static let icelandic: Language = Language(name: "Icelandic", code: "is")
  public static let italian: Language = Language(name: "Italian", code: "it")
  public static let inuktitut: Language = Language(name: "Inuktitut", code: "iu")
  public static let japanese: Language = Language(name: "Japanese", code: "ja")
  public static let javanese: Language = Language(name: "Javanese", code: "jv")
  public static let georgian: Language = Language(name: "Georgian", code: "ka")
  public static let kongo: Language = Language(name: "Kongo", code: "kg")
  public static let kikuyu: Language = Language(name: "Kikuyu", code: "ki")
  public static let kwanyama: Language = Language(name: "Kwanyama", code: "kj")
  public static let kazakh: Language = Language(name: "Kazakh", code: "kk")
  public static let kalaallisut: Language = Language(name: "Kalaallisut", code: "kl")
  public static let centralKhmer: Language = Language(name: "Central Khmer", code: "km")
  public static let kannada: Language = Language(name: "Kannada", code: "kn")
  public static let korean: Language = Language(name: "Korean", code: "ko")
  public static let kanuri: Language = Language(name: "Kanuri", code: "kr")
  public static let kashmiri: Language = Language(name: "Kashmiri", code: "ks")
  public static let kurdish: Language = Language(name: "Kurdish", code: "ku")
  public static let komi: Language = Language(name: "Komi", code: "kv")
  public static let cornish: Language = Language(name: "Cornish", code: "kw")
  public static let kirghiz: Language = Language(name: "Kirghiz", code: "ky")
  public static let latin: Language = Language(name: "Latin", code: "la")
  public static let luxembourgish: Language = Language(name: "Luxembourgish", code: "lb")
  public static let ganda: Language = Language(name: "Ganda", code: "lg")
  public static let limburgish: Language = Language(name: "Limburgish", code: "li")
  public static let lingala: Language = Language(name: "Lingala", code: "ln")
  public static let lao: Language = Language(name: "Lao", code: "lo")
  public static let lithuanian: Language = Language(name: "Lithuanian", code: "lt")
  public static let lubaKatanga: Language = Language(name: "Luba-Katanga", code: "lu")
  public static let latvian: Language = Language(name: "Latvian", code: "lv")
  public static let malagasy: Language = Language(name: "Malagasy", code: "mg")
  public static let marshallese: Language = Language(name: "Marshallese", code: "mh")
  public static let maori: Language = Language(name: "Maori", code: "mi")
  public static let macedonian: Language = Language(name: "Macedonian", code: "mk")
  public static let malayalam: Language = Language(name: "Malayalam", code: "ml")
  public static let mongolian: Language = Language(name: "Mongolian", code: "mn")
  public static let marathi: Language = Language(name: "Marathi", code: "mr")
  public static let malay: Language = Language(name: "Malay", code: "ms")
  public static let maltese: Language = Language(name: "Maltese", code: "mt")
  public static let burmese: Language = Language(name: "Burmese", code: "my")
  public static let nauru: Language = Language(name: "Nauru", code: "na")
  public static let norwegianBokmål: Language = Language(name: "Norwegian Bokmål", code: "nb")
  public static let northNdebele: Language = Language(name: "North Ndebele", code: "nd")
  public static let nepali: Language = Language(name: "Nepali", code: "ne")
  public static let ndonga: Language = Language(name: "Ndonga", code: "ng")
  public static let dutch: Language = Language(name: "Dutch", code: "nl")
  public static let norwegianNynorsk: Language = Language(name: "Norwegian Nynorsk", code: "nn")
  public static let norwegian: Language = Language(name: "Norwegian", code: "no")
  public static let southNdebele: Language = Language(name: "South Ndebele", code: "nr")
  public static let navajo: Language = Language(name: "Navajo", code: "nv")
  public static let chichewa: Language = Language(name: "Chichewa", code: "ny")
  public static let occitan: Language = Language(name: "Occitan", code: "oc")
  public static let ojibwa: Language = Language(name: "Ojibwa", code: "oj")
  public static let oromo: Language = Language(name: "Oromo", code: "om")
  public static let oriya: Language = Language(name: "Oriya", code: "or")
  public static let ossetian: Language = Language(name: "Ossetian", code: "os")
  public static let panjabi: Language = Language(name: "Panjabi", code: "pa")
  public static let pali: Language = Language(name: "Pali", code: "pi")
  public static let polish: Language = Language(name: "Polish", code: "pl")
  public static let pashto: Language = Language(name: "Pashto", code: "ps")
  public static let portuguese: Language = Language(name: "Portuguese", code: "pt")
  public static let quechua: Language = Language(name: "Quechua", code: "qu")
  public static let romansh: Language = Language(name: "Romansh", code: "rm")
  public static let rundi: Language = Language(name: "Rundi", code: "rn")
  public static let romanian: Language = Language(name: "Romanian", code: "ro")
  public static let russian: Language = Language(name: "Russian", code: "ru")
  public static let kinyarwanda: Language = Language(name: "Kinyarwanda", code: "rw")
  public static let sanskrit: Language = Language(name: "Sanskrit", code: "sa")
  public static let sardinian: Language = Language(name: "Sardinian", code: "sc")
  public static let sindhi: Language = Language(name: "Sindhi", code: "sd")
  public static let northernSami: Language = Language(name: "Northern Sami", code: "se")
  public static let sango: Language = Language(name: "Sango", code: "sg")
  public static let sinhala: Language = Language(name: "Sinhala", code: "si")
  public static let slovak: Language = Language(name: "Slovak", code: "sk")
  public static let slovenian: Language = Language(name: "Slovenian", code: "sl")
  public static let samoan: Language = Language(name: "Samoan", code: "sm")
  public static let shona: Language = Language(name: "Shona", code: "sn")
  public static let somali: Language = Language(name: "Somali", code: "so")
  public static let albanian: Language = Language(name: "Albanian", code: "sq")
  public static let serbian: Language = Language(name: "Serbian", code: "sr")
  public static let swati: Language = Language(name: "Swati", code: "ss")
  public static let sothoSouthern: Language = Language(name: "Sotho, Southern", code: "st")
  public static let sundanese: Language = Language(name: "Sundanese", code: "su")
  public static let swedish: Language = Language(name: "Swedish", code: "sv")
  public static let swahili: Language = Language(name: "Swahili", code: "sw")
  public static let tamil: Language = Language(name: "Tamil", code: "ta")
  public static let telugu: Language = Language(name: "Telugu", code: "te")
  public static let tajik: Language = Language(name: "Tajik", code: "tg")
  public static let thai: Language = Language(name: "Thai", code: "th")
  public static let tigrinya: Language = Language(name: "Tigrinya", code: "ti")
  public static let turkmen: Language = Language(name: "Turkmen", code: "tk")
  public static let tagalog: Language = Language(name: "Tagalog", code: "tl")
  public static let tswana: Language = Language(name: "Tswana", code: "tn")
  public static let tonga: Language = Language(name: "Tonga", code: "to")
  public static let turkish: Language = Language(name: "Turkish", code: "tr")
  public static let tsonga: Language = Language(name: "Tsonga", code: "ts")
  public static let tatar: Language = Language(name: "Tatar", code: "tt")
  public static let twi: Language = Language(name: "Twi", code: "tw")
  public static let tahitian: Language = Language(name: "Tahitian", code: "ty")
  public static let uighur: Language = Language(name: "Uighur", code: "ug")
  public static let ukrainian: Language = Language(name: "Ukrainian", code: "uk")
  public static let urdu: Language = Language(name: "Urdu", code: "ur")
  public static let uzbek: Language = Language(name: "Uzbek", code: "uz")
  public static let venda: Language = Language(name: "Venda", code: "ve")
  public static let vietnamese: Language = Language(name: "Vietnamese", code: "vi")
  public static let volapük: Language = Language(name: "Volapük", code: "vo")
  public static let walloon: Language = Language(name: "Walloon", code: "wa")
  public static let wolof: Language = Language(name: "Wolof", code: "wo")
  public static let xhosa: Language = Language(name: "Xhosa", code: "xh")
  public static let yiddish: Language = Language(name: "Yiddish", code: "yi")
  public static let yoruba: Language = Language(name: "Yoruba", code: "yo")
  public static let zhuang: Language = Language(name: "Zhuang", code: "za")
  public static let chinese: Language = Language(name: "Chinese", code: "zh")
  public static let zulu: Language = Language(name: "Zulu", code: "zu")

}

public enum Country: String { // ISO-639-1
  case belarus = "BY"
  case singapore = "SG"
  case tajikistan = "TJ"
  case barbados = "BB"
  case eritrea = "ER"
  case isleOfMan = "IM"
  case lesotho = "LS"
  case indonesia = "ID"
  case palau = "PW"
  case saintMartin = "MF"
  case sintMaarten = "SX"
  case myanmar = "MM"
  case mozambique = "MZ"
  case bosniaAndHerzegovina = "BA"
  case cameroon = "CM"
  case brazil = "BR"
  case eastTimor = "TL"
  case madagascar = "MG"
  case austria = "AT"
  case marshallIslands = "MH"
  case argentina = "AR"
  case nepal = "NP"
  case kiribati = "KI"
  case norway = "NO"
  case macao = "MO"
  case solomonIslands = "SB"
  case unitedStatesMinorOutlyingIslands = "UM"
  case seychelles = "SC"
  case caymanIslands = "KY"
  case uzbekistan = "UZ"
  case northKorea = "KP"
  case suriname = "SR"
  case mauritius = "MU"
  case mongolia = "MN"
  case libya = "LY"
  case antiguaAndBarbuda = "AG"
  case anguilla = "AI"
  case italy = "IT"
  case sierraLeone = "SL"
  case turkmenistan = "TM"
  case frenchGuiana = "GF"
  case guernsey = "GG"
  case senegal = "SN"
  case laos = "LA"
  case honduras = "HN"
  case andorra = "AD"
  case uganda = "UG"
  case slovakia = "SK"
  case ukraine = "UA"
  case slovenia = "SI"
  case bermuda = "BM"
  case switzerland = "CH"
  case alandIslands = "AX"
  case kosovo = "XK"
  case dominicanRepublic = "DO"
  case guineaBissau = "GW"
  case turksAndCaicosIslands = "TC"
  case serbia = "RS"
  case vanuatu = "VU"
  case latvia = "LV"
  case ireland = "IE"
  case republicOfTheCongo = "CG"
  case djibouti = "DJ"
  case guyana = "GY"
  case philippines = "PH"
  case niue = "NU"
  case spain = "ES"
  case gambia = "GM"
  case northernMarianaIslands = "MP"
  case benin = "BJ"
  case canada = "CA"
  case sudan = "SD"
  case colombia = "CO"
  case saintPierreAndMiquelon = "PM"
  case greece = "GR"
  case croatia = "HR"
  case centralAfricanRepublic = "CF"
  case morocco = "MA"
  case norfolkIsland = "NF"
  case dominica = "DM"
  case macedonia = "MK"
  case curacao = "CW"
  case portugal = "PT"
  case turkey = "TR"
  case elSalvador = "SV"
  case liechtenstein = "LI"
  case trinidadAndTobago = "TT"
  case brunei = "BN"
  case guatemala = "GT"
  case saoTomeAndPrincipe = "ST"
  case kazakhstan = "KZ"
  case peru = "PE"
  case kenya = "KE"
  case bonaire,SaintEustatiusAndSaba = "BQ"
  case bahamas = "BS"
  case chad = "TD"
  case afghanistan = "AF"
  case luxembourg = "LU"
  case aruba = "AW"
  case tanzania = "TZ"
  case palestinianTerritory = "PS"
  case southAfrica = "ZA"
  case nicaragua = "NI"
  case grenada = "GD"
  case belize = "BZ"
  case haiti = "HT"
  case usVirginIslands = "VI"
  case cocosIslands = "CC"
  case greenland = "GL"
  case togo = "TG"
  case gabon = "GA"
  case zambia = "ZM"
  case tokelau = "TK"
  case southKorea = "KR"
  case mali = "ML"
  case reunion = "RE"
  case nauru = "NR"
  case ghana = "GH"
  case iceland = "IS"
  case cuba = "CU"
  case americanSamoa = "AS"
  case tunisia = "TN"
  case india = "IN"
  case panama = "PA"
  case iraq = "IQ"
  case kuwait = "KW"
  case netherlands = "NL"
  case papuaNewGuinea = "PG"
  case malaysia = "MY"
  case svalbardAndJanMayen = "SJ"
  case venezuela = "VE"
  case egypt = "EG"
  case hongKong = "HK"
  case oman = "OM"
  case mayotte = "YT"
  case saintBarthelemy = "BL"
  case belgium = "BE"
  case taiwan = "TW"
  case algeria = "DZ"
  case frenchPolynesia = "PF"
  case gibraltar = "GI"
  case montenegro = "ME"
  case czechRepublic = "CZ"
  case martinique = "MQ"
  case vatican = "VA"
  case swaziland = "SZ"
  case bhutan = "BT"
  case romania = "RO"
  case malawi = "MW"
  case moldova = "MD"
  case germany = "DE"
  case azerbaijan = "AZ"
  case jersey = "JE"
  case jamaica = "JM"
  case jordan = "JO"
  case montserrat = "MS"
  case sanMarino = "SM"
  case sriLanka = "LK"
  case kyrgyzstan = "KG"
  case iran = "IR"
  case somalia = "SO"
  case angola = "AO"
  case christmasIsland = "CX"
  case heardIslandAndMcDonaldIslands = "HM"
  case finland = "FI"
  case westernSahara = "EH"
  case tonga = "TO"
  case saudiArabia = "SA"
  case mauritania = "MR"
  case lebanon = "LB"
  case maldives = "MV"
  case nigeria = "NG"
  case armenia = "AM"
  case australia = "AU"
  case denmark = "DK"
  case britishVirginIslands = "VG"
  case newCaledonia = "NC"
  case southSudan = "SS"
  case guam = "GU"
  case bouvetIsland = "BV"
  case burundi = "BI"
  case mexico = "MX"
  case japan = "JP"
  case uruguay = "UY"
  case cyprus = "CY"
  case liberia = "LR"
  case saintVincentAndTheGrenadines = "VC"
  case comoros = "KM"
  case unitedStates = "US"
  case china = "CN"
  case cambodia = "KH"
  case pitcairn = "PN"
  case lithuania = "LT"
  case thailand = "TH"
  case tuvalu = "TV"
  case yemen = "YE"
  case bolivia = "BO"
  case bangladesh = "BD"
  case newZealand = "NZ"
  case ethiopia = "ET"
  case bulgaria = "BG"
  case capeVerde = "CV"
  case britishIndianOceanTerritory = "IO"
  case niger = "NE"
  case estonia = "EE"
  case georgia = "GE"
  case saintLucia = "LC"
  case unitedKingdom = "GB"
  case bahrain = "BH"
  case guinea = "GN"
  case malta = "MT"
  case guadeloupe = "GP"
  case albania = "AL"
  case samoa = "WS"
  case ivoryCoast = "CI"
  case vietnam = "VN"
  case syria = "SY"
  case antarctica = "AQ"
  case costaRica = "CR"
  case israel = "IL"
  case rwanda = "RW"
  case fiji = "FJ"
  case russia = "RU"
  case monaco = "MC"
  case hungary = "HU"
  case namibia = "NA"
  case zimbabwe = "ZW"
  case paraguay = "PY"
  case chile = "CL"
  case poland = "PL"
  case puertoRico = "PR"
  case pakistan = "PK"
  case sweden = "SE"
  case botswana = "BW"
  case falklandIslands = "FK"
  case france = "FR"
  case saintKittsAndNevis = "KN"
  case unitedArabEmirates = "AE"
  case frenchSouthernTerritories = "TF"
  case qatar = "QA"
  case wallisAndFutuna = "WF"
  case burkinaFaso = "BF"
  case cookIslands = "CK"
  case saintHelena = "SH"
  case democraticRepublicOfTheCongo = "CD"
  case ecuador = "EC"
  case equatorialGuinea = "GQ"
  case southGeorgiaAndTheSouthSandwichIslands = "GS"
  case micronesia = "FM"
  case faroeIslands = "FO"
}

