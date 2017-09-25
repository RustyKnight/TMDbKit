//
//  Types.swift
//  TMDb-iOS
//
//  Created by Shane Whitehead on 24/9/17.
//  Copyright © 2017 TMDb. All rights reserved.
//

import Foundation

extension String {
	var djb2hash: Int {
		let unicodeScalars = self.unicodeScalars.map { $0.value }
		return unicodeScalars.reduce(5381) {
			($0 << 5) &+ $0 &+ Int($1)
		}
	}
	
	var sdbmhash: Int {
		let unicodeScalars = self.unicodeScalars.map { $0.value }
		return unicodeScalars.reduce(0) {
			Int($1) &+ ($0 << 6) &+ ($0 << 16) - $0
		}
	}
}

/*
Language + Country
english + australia = en-AU
*/
public struct Language: CustomStringConvertible {
	public let name: String
	public let code: String
	internal var country: Country?
	private static var registry: Set<Language> = Set<Language>()

	public init(name: String, code: String, country: Country? = nil, register: Bool = true) {
		self.name = name
		self.code = code
		self.country = country
		guard register else {
			return
		}
		Language.registry.insert(self)
	}
	
	public func from(_ country: Country) -> Language {
		return Language(name: name, code: code, country: country, register: false)
	}
	
	public var description: String {
		guard let country = country else {
			return code
		}
		
		return "\(code)-\(country.code2.uppercased())"
	}
	
	public static func find(byCode: String) -> Language? {
		return Language.registry.first(where: {$0.code == byCode})
	}
	
}

extension Language: Hashable {
	public var hashValue: Int {
		let hash = combineHashes([name.hashValue, code.hashValue])
		return hash
	}
	
	public static func == (lhs: Language, rhs: Language) -> Bool {
		return lhs.name == rhs.name &&
						lhs.code == rhs.code &&
						lhs.country == rhs.country
	}
}

public func + (lhs: Language, rhs: Country) -> Language {
	return lhs.from(rhs)
}

public func + (lhs: Country, rhs: Language) -> Language {
	return rhs.from(lhs)
}

public extension Language { // iSO-639-1
	
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

public struct Country { // ISO-3166
	let name: String
	let code2: String
	let code3: String
	let countryCode: String
	
	private static var registry: Set<Country> = Set<Country>()
	
	public init(name: String, code2: String, code3: String, countryCode: String) {
		self.name = name
		self.code2 = code2
		self.code3 = code3
		self.countryCode = countryCode
		
		Country.registry.insert(self)
	}
	
	public static func find(byCode: String) -> Country? {
		return registry.first(where: {$0.code2 == byCode || $0.code3 == byCode})
	}
	
	public static func find(byCountryCode: String) -> Country? {
		return registry.first(where: {$0.countryCode == byCountryCode})
	}
}

extension Country: Hashable {
	public var hashValue: Int {
		let hash = combineHashes([name.hashValue, code2.hashValue, code3.hashValue, countryCode.hashValue])
		return hash
	}
	
	public static func == (lhs: Country, rhs: Country) -> Bool {
		return lhs.name == rhs.name &&
			lhs.code2 == rhs.code2 &&
			lhs.code3 == rhs.code3 &&
			lhs.countryCode == rhs.countryCode
	}
}


public extension Country {
	public static let afghanistan = Country(name: "Afghanistan", code2: "AF", code3: "AFG", countryCode: "004")
	public static let ålandIslands = Country(name: "Åland Islands", code2: "AX", code3: "ALA", countryCode: "248")
	public static let albania = Country(name: "Albania", code2: "AL", code3: "ALB", countryCode: "008")
	public static let algeria = Country(name: "Algeria", code2: "DZ", code3: "DZA", countryCode: "012")
	public static let americanSamoa = Country(name: "American Samoa", code2: "AS", code3: "ASM", countryCode: "016")
	public static let andorra = Country(name: "Andorra", code2: "AD", code3: "AND", countryCode: "020")
	public static let angola = Country(name: "Angola", code2: "AO", code3: "AGO", countryCode: "024")
	public static let anguilla = Country(name: "Anguilla", code2: "AI", code3: "AIA", countryCode: "660")
	public static let antarctica = Country(name: "Antarctica", code2: "AQ", code3: "ATA", countryCode: "010")
	public static let antiguaAndBarbuda = Country(name: "Antigua and Barbuda", code2: "AG", code3: "ATG", countryCode: "028")
	public static let argentina = Country(name: "Argentina", code2: "AR", code3: "ARG", countryCode: "032")
	public static let armenia = Country(name: "Armenia", code2: "AM", code3: "ARM", countryCode: "051")
	public static let aruba = Country(name: "Aruba", code2: "AW", code3: "ABW", countryCode: "533")
	public static let australia = Country(name: "Australia", code2: "AU", code3: "AUS", countryCode: "036")
	public static let austria = Country(name: "Austria", code2: "AT", code3: "AUT", countryCode: "040")
	public static let azerbaijan = Country(name: "Azerbaijan", code2: "AZ", code3: "AZE", countryCode: "031")
	public static let bahamas = Country(name: "Bahamas", code2: "BS", code3: "BHS", countryCode: "044")
	public static let bahrain = Country(name: "Bahrain", code2: "BH", code3: "BHR", countryCode: "048")
	public static let bangladesh = Country(name: "Bangladesh", code2: "BD", code3: "BGD", countryCode: "050")
	public static let barbados = Country(name: "Barbados", code2: "BB", code3: "BRB", countryCode: "052")
	public static let belarus = Country(name: "Belarus", code2: "BY", code3: "BLR", countryCode: "112")
	public static let belgium = Country(name: "Belgium", code2: "BE", code3: "BEL", countryCode: "056")
	public static let belize = Country(name: "Belize", code2: "BZ", code3: "BLZ", countryCode: "084")
	public static let benin = Country(name: "Benin", code2: "BJ", code3: "BEN", countryCode: "204")
	public static let bermuda = Country(name: "Bermuda", code2: "BM", code3: "BMU", countryCode: "060")
	public static let bhutan = Country(name: "Bhutan", code2: "BT", code3: "BTN", countryCode: "064")
	public static let plurinationalStateOfBolivia = Country(name: "Bolivia (Plurinational State of)", code2: "BO", code3: "BOL", countryCode: "068")
	public static let bonaireSintEustatiusAndSaba = Country(name: "Bonaire, Sint Eustatius and Saba", code2: "BQ", code3: "BES", countryCode: "535")
	public static let bosniaAndHerzegovina = Country(name: "Bosnia and Herzegovina", code2: "BA", code3: "BIH", countryCode: "070")
	public static let botswana = Country(name: "Botswana", code2: "BW", code3: "BWA", countryCode: "072")
	public static let bouvetIsland = Country(name: "Bouvet Island", code2: "BV", code3: "BVT", countryCode: "074")
	public static let brazil = Country(name: "Brazil", code2: "BR", code3: "BRA", countryCode: "076")
	public static let britishIndianOceanTerritory = Country(name: "British Indian Ocean Territory", code2: "IO", code3: "IOT", countryCode: "086")
	public static let bruneiDarussalam = Country(name: "Brunei Darussalam", code2: "BN", code3: "BRN", countryCode: "096")
	public static let bulgaria = Country(name: "Bulgaria", code2: "BG", code3: "BGR", countryCode: "100")
	public static let burkinaFaso = Country(name: "Burkina Faso", code2: "BF", code3: "BFA", countryCode: "854")
	public static let burundi = Country(name: "Burundi", code2: "BI", code3: "BDI", countryCode: "108")
	public static let cambodia = Country(name: "Cambodia", code2: "KH", code3: "KHM", countryCode: "116")
	public static let cameroon = Country(name: "Cameroon", code2: "CM", code3: "CMR", countryCode: "120")
	public static let canada = Country(name: "Canada", code2: "CA", code3: "CAN", countryCode: "124")
	public static let caboVerde = Country(name: "Cabo Verde", code2: "CV", code3: "CPV", countryCode: "132")
	public static let caymanIslands = Country(name: "Cayman Islands", code2: "KY", code3: "CYM", countryCode: "136")
	public static let centralAfricanRepublic = Country(name: "Central African Republic", code2: "CF", code3: "CAF", countryCode: "140")
	public static let chad = Country(name: "Chad", code2: "TD", code3: "TCD", countryCode: "148")
	public static let chile = Country(name: "Chile", code2: "CL", code3: "CHL", countryCode: "152")
	public static let china = Country(name: "China", code2: "CN", code3: "CHN", countryCode: "156")
	public static let christmasIsland = Country(name: "Christmas Island", code2: "CX", code3: "CXR", countryCode: "162")
	public static let cocosIslands = Country(name: "Cocos (Keeling) Islands", code2: "CC", code3: "CCK", countryCode: "166")
	public static let colombia = Country(name: "Colombia", code2: "CO", code3: "COL", countryCode: "170")
	public static let comoros = Country(name: "Comoros", code2: "KM", code3: "COM", countryCode: "174")
	public static let congo = Country(name: "Congo", code2: "CG", code3: "COG", countryCode: "178")
	public static let democraticRepublicOfTeCongo = Country(name: "Congo (Democratic Republic of the)", code2: "CD", code3: "COD", countryCode: "180")
	public static let cookIslands = Country(name: "Cook Islands", code2: "CK", code3: "COK", countryCode: "184")
	public static let costaRica = Country(name: "Costa Rica", code2: "CR", code3: "CRI", countryCode: "188")
	public static let coteDIvoire = Country(name: "Côte d'Ivoire", code2: "CI", code3: "CIV", countryCode: "384")
	public static let croatia = Country(name: "Croatia", code2: "HR", code3: "HRV", countryCode: "191")
	public static let cuba = Country(name: "Cuba", code2: "CU", code3: "CUB", countryCode: "192")
	public static let curaçao = Country(name: "Curaçao", code2: "CW", code3: "CUW", countryCode: "531")
	public static let cyprus = Country(name: "Cyprus", code2: "CY", code3: "CYP", countryCode: "196")
	public static let czechRepublic = Country(name: "Czech Republic", code2: "CZ", code3: "CZE", countryCode: "203")
	public static let denmark = Country(name: "Denmark", code2: "DK", code3: "DNK", countryCode: "208")
	public static let djibouti = Country(name: "Djibouti", code2: "DJ", code3: "DJI", countryCode: "262")
	public static let dominica = Country(name: "Dominica", code2: "DM", code3: "DMA", countryCode: "212")
	public static let dominicanRepublic = Country(name: "Dominican Republic", code2: "DO", code3: "DOM", countryCode: "214")
	public static let ecuador = Country(name: "Ecuador", code2: "EC", code3: "ECU", countryCode: "218")
	public static let egypt = Country(name: "Egypt", code2: "EG", code3: "EGY", countryCode: "818")
	public static let elSalvador = Country(name: "El Salvador", code2: "SV", code3: "SLV", countryCode: "222")
	public static let equatorialGuinea = Country(name: "Equatorial Guinea", code2: "GQ", code3: "GNQ", countryCode: "226")
	public static let eritrea = Country(name: "Eritrea", code2: "ER", code3: "ERI", countryCode: "232")
	public static let estonia = Country(name: "Estonia", code2: "EE", code3: "EST", countryCode: "233")
	public static let ethiopia = Country(name: "Ethiopia", code2: "ET", code3: "ETH", countryCode: "231")
	public static let falklandIslands = Country(name: "Falkland Islands (Malvinas)", code2: "FK", code3: "FLK", countryCode: "238")
	public static let faroeIslands = Country(name: "Faroe Islands", code2: "FO", code3: "FRO", countryCode: "234")
	public static let fiji = Country(name: "Fiji", code2: "FJ", code3: "FJI", countryCode: "242")
	public static let finland = Country(name: "Finland", code2: "FI", code3: "FIN", countryCode: "246")
	public static let france = Country(name: "France", code2: "FR", code3: "FRA", countryCode: "250")
	public static let frenchGuiana = Country(name: "French Guiana", code2: "GF", code3: "GUF", countryCode: "254")
	public static let frenchPolynesia = Country(name: "French Polynesia", code2: "PF", code3: "PYF", countryCode: "258")
	public static let frenchSouthernTerritories = Country(name: "French Southern Territories", code2: "TF", code3: "ATF", countryCode: "260")
	public static let gabon = Country(name: "Gabon", code2: "GA", code3: "GAB", countryCode: "266")
	public static let gambia = Country(name: "Gambia", code2: "GM", code3: "GMB", countryCode: "270")
	public static let georgia = Country(name: "Georgia", code2: "GE", code3: "GEO", countryCode: "268")
	public static let germany = Country(name: "Germany", code2: "DE", code3: "DEU", countryCode: "276")
	public static let ghana = Country(name: "Ghana", code2: "GH", code3: "GHA", countryCode: "288")
	public static let gibraltar = Country(name: "Gibraltar", code2: "GI", code3: "GIB", countryCode: "292")
	public static let greece = Country(name: "Greece", code2: "GR", code3: "GRC", countryCode: "300")
	public static let greenland = Country(name: "Greenland", code2: "GL", code3: "GRL", countryCode: "304")
	public static let grenada = Country(name: "Grenada", code2: "GD", code3: "GRD", countryCode: "308")
	public static let guadeloupe = Country(name: "Guadeloupe", code2: "GP", code3: "GLP", countryCode: "312")
	public static let guam = Country(name: "Guam", code2: "GU", code3: "GUM", countryCode: "316")
	public static let guatemala = Country(name: "Guatemala", code2: "GT", code3: "GTM", countryCode: "320")
	public static let guernsey = Country(name: "Guernsey", code2: "GG", code3: "GGY", countryCode: "831")
	public static let guinea = Country(name: "Guinea", code2: "GN", code3: "GIN", countryCode: "324")
	public static let guineaBissau = Country(name: "Guinea-Bissau", code2: "GW", code3: "GNB", countryCode: "624")
	public static let guyana = Country(name: "Guyana", code2: "GY", code3: "GUY", countryCode: "328")
	public static let haiti = Country(name: "Haiti", code2: "HT", code3: "HTI", countryCode: "332")
	public static let heardIslandAndMcDonaldIslands = Country(name: "Heard Island and McDonald Islands", code2: "HM", code3: "HMD", countryCode: "334")
	public static let holySee = Country(name: "Holy See", code2: "VA", code3: "VAT", countryCode: "336")
	public static let honduras = Country(name: "Honduras", code2: "HN", code3: "HND", countryCode: "340")
	public static let hongKong = Country(name: "Hong Kong", code2: "HK", code3: "HKG", countryCode: "344")
	public static let hungary = Country(name: "Hungary", code2: "HU", code3: "HUN", countryCode: "348")
	public static let iceland = Country(name: "Iceland", code2: "IS", code3: "ISL", countryCode: "352")
	public static let india = Country(name: "India", code2: "IN", code3: "IND", countryCode: "356")
	public static let indonesia = Country(name: "Indonesia", code2: "ID", code3: "IDN", countryCode: "360")
	public static let iran = Country(name: "Iran (Islamic Republic of)", code2: "IR", code3: "IRN", countryCode: "364")
	public static let iraq = Country(name: "Iraq", code2: "IQ", code3: "IRQ", countryCode: "368")
	public static let ireland = Country(name: "Ireland", code2: "IE", code3: "IRL", countryCode: "372")
	public static let isleOfMan = Country(name: "Isle of Man", code2: "IM", code3: "IMN", countryCode: "833")
	public static let israel = Country(name: "Israel", code2: "IL", code3: "ISR", countryCode: "376")
	public static let italy = Country(name: "Italy", code2: "IT", code3: "ITA", countryCode: "380")
	public static let jamaica = Country(name: "Jamaica", code2: "JM", code3: "JAM", countryCode: "388")
	public static let japan = Country(name: "Japan", code2: "JP", code3: "JPN", countryCode: "392")
	public static let jersey = Country(name: "Jersey", code2: "JE", code3: "JEY", countryCode: "832")
	public static let jordan = Country(name: "Jordan", code2: "JO", code3: "JOR", countryCode: "400")
	public static let kazakhstan = Country(name: "Kazakhstan", code2: "KZ", code3: "KAZ", countryCode: "398")
	public static let kenya = Country(name: "Kenya", code2: "KE", code3: "KEN", countryCode: "404")
	public static let kiribati = Country(name: "Kiribati", code2: "KI", code3: "KIR", countryCode: "296")
	public static let democraticPeoplesRepublicOfKorea = Country(name: "Korea (Democratic People's Republic of)", code2: "KP", code3: "PRK", countryCode: "408")
	public static let RepublicOfKorea = Country(name: "Korea (Republic of)", code2: "KR", code3: "KOR", countryCode: "410")
	public static let kuwait = Country(name: "Kuwait", code2: "KW", code3: "KWT", countryCode: "414")
	public static let kyrgyzstan = Country(name: "Kyrgyzstan", code2: "KG", code3: "KGZ", countryCode: "417")
	public static let laoPeoplesDemocraticRepublic = Country(name: "Lao People's Democratic Republic", code2: "LA", code3: "LAO", countryCode: "418")
	public static let latvia = Country(name: "Latvia", code2: "LV", code3: "LVA", countryCode: "428")
	public static let lebanon = Country(name: "Lebanon", code2: "LB", code3: "LBN", countryCode: "422")
	public static let lesotho = Country(name: "Lesotho", code2: "LS", code3: "LSO", countryCode: "426")
	public static let liberia = Country(name: "Liberia", code2: "LR", code3: "LBR", countryCode: "430")
	public static let libya = Country(name: "Libya", code2: "LY", code3: "LBY", countryCode: "434")
	public static let liechtenstein = Country(name: "Liechtenstein", code2: "LI", code3: "LIE", countryCode: "438")
	public static let lithuania = Country(name: "Lithuania", code2: "LT", code3: "LTU", countryCode: "440")
	public static let luxembourg = Country(name: "Luxembourg", code2: "LU", code3: "LUX", countryCode: "442")
	public static let macao = Country(name: "Macao", code2: "MO", code3: "MAC", countryCode: "446")
	public static let macedonia = Country(name: "Macedonia (the former Yugoslav Republic of)", code2: "MK", code3: "MKD", countryCode: "807")
	public static let madagascar = Country(name: "Madagascar", code2: "MG", code3: "MDG", countryCode: "450")
	public static let malawi = Country(name: "Malawi", code2: "MW", code3: "MWI", countryCode: "454")
	public static let malaysia = Country(name: "Malaysia", code2: "MY", code3: "MYS", countryCode: "458")
	public static let maldives = Country(name: "Maldives", code2: "MV", code3: "MDV", countryCode: "462")
	public static let mali = Country(name: "Mali", code2: "ML", code3: "MLI", countryCode: "466")
	public static let malta = Country(name: "Malta", code2: "MT", code3: "MLT", countryCode: "470")
	public static let marshallIslands = Country(name: "Marshall Islands", code2: "MH", code3: "MHL", countryCode: "584")
	public static let martinique = Country(name: "Martinique", code2: "MQ", code3: "MTQ", countryCode: "474")
	public static let mauritania = Country(name: "Mauritania", code2: "MR", code3: "MRT", countryCode: "478")
	public static let mauritius = Country(name: "Mauritius", code2: "MU", code3: "MUS", countryCode: "480")
	public static let mayotte = Country(name: "Mayotte", code2: "YT", code3: "MYT", countryCode: "175")
	public static let mexico = Country(name: "Mexico", code2: "MX", code3: "MEX", countryCode: "484")
	public static let micronesia = Country(name: "Micronesia (Federated States of)", code2: "FM", code3: "FSM", countryCode: "583")
	public static let moldova = Country(name: "Moldova (Republic of)", code2: "MD", code3: "MDA", countryCode: "498")
	public static let monaco = Country(name: "Monaco", code2: "MC", code3: "MCO", countryCode: "492")
	public static let mongolia = Country(name: "Mongolia", code2: "MN", code3: "MNG", countryCode: "496")
	public static let montenegro = Country(name: "Montenegro", code2: "ME", code3: "MNE", countryCode: "499")
	public static let montserrat = Country(name: "Montserrat", code2: "MS", code3: "MSR", countryCode: "500")
	public static let morocco = Country(name: "Morocco", code2: "MA", code3: "MAR", countryCode: "504")
	public static let mozambique = Country(name: "Mozambique", code2: "MZ", code3: "MOZ", countryCode: "508")
	public static let myanmar = Country(name: "Myanmar", code2: "MM", code3: "MMR", countryCode: "104")
	public static let namibia = Country(name: "Namibia", code2: "NA", code3: "NAM", countryCode: "516")
	public static let nauru = Country(name: "Nauru", code2: "NR", code3: "NRU", countryCode: "520")
	public static let nepal = Country(name: "Nepal", code2: "NP", code3: "NPL", countryCode: "524")
	public static let netherlands = Country(name: "Netherlands", code2: "NL", code3: "NLD", countryCode: "528")
	public static let newCaledonia = Country(name: "New Caledonia", code2: "NC", code3: "NCL", countryCode: "540")
	public static let newZealand = Country(name: "New Zealand", code2: "NZ", code3: "NZL", countryCode: "554")
	public static let nicaragua = Country(name: "Nicaragua", code2: "NI", code3: "NIC", countryCode: "558")
	public static let niger = Country(name: "Niger", code2: "NE", code3: "NER", countryCode: "562")
	public static let nigeria = Country(name: "Nigeria", code2: "NG", code3: "NGA", countryCode: "566")
	public static let niue = Country(name: "Niue", code2: "NU", code3: "NIU", countryCode: "570")
	public static let norfolkIsland = Country(name: "Norfolk Island", code2: "NF", code3: "NFK", countryCode: "574")
	public static let northernMarianaIslands = Country(name: "Northern Mariana Islands", code2: "MP", code3: "MNP", countryCode: "580")
	public static let norway = Country(name: "Norway", code2: "NO", code3: "NOR", countryCode: "578")
	public static let oman = Country(name: "Oman", code2: "OM", code3: "OMN", countryCode: "512")
	public static let pakistan = Country(name: "Pakistan", code2: "PK", code3: "PAK", countryCode: "586")
	public static let palau = Country(name: "Palau", code2: "PW", code3: "PLW", countryCode: "585")
	public static let palestine = Country(name: "Palestine, State of", code2: "PS", code3: "PSE", countryCode: "275")
	public static let panama = Country(name: "Panama", code2: "PA", code3: "PAN", countryCode: "591")
	public static let papuaNewGuinea = Country(name: "Papua New Guinea", code2: "PG", code3: "PNG", countryCode: "598")
	public static let paraguay = Country(name: "Paraguay", code2: "PY", code3: "PRY", countryCode: "600")
	public static let peru = Country(name: "Peru", code2: "PE", code3: "PER", countryCode: "604")
	public static let philippines = Country(name: "Philippines", code2: "PH", code3: "PHL", countryCode: "608")
	public static let pitcairn = Country(name: "Pitcairn", code2: "PN", code3: "PCN", countryCode: "612")
	public static let poland = Country(name: "Poland", code2: "PL", code3: "POL", countryCode: "616")
	public static let portugal = Country(name: "Portugal", code2: "PT", code3: "PRT", countryCode: "620")
	public static let puertoRico = Country(name: "Puerto Rico", code2: "PR", code3: "PRI", countryCode: "630")
	public static let qatar = Country(name: "Qatar", code2: "QA", code3: "QAT", countryCode: "634")
	public static let réunion = Country(name: "Réunion", code2: "RE", code3: "REU", countryCode: "638")
	public static let romania = Country(name: "Romania", code2: "RO", code3: "ROU", countryCode: "642")
	public static let russianFederation = Country(name: "Russian Federation", code2: "RU", code3: "RUS", countryCode: "643")
	public static let rwanda = Country(name: "Rwanda", code2: "RW", code3: "RWA", countryCode: "646")
	public static let saintBarthélemy = Country(name: "Saint Barthélemy", code2: "BL", code3: "BLM", countryCode: "652")
	public static let saintHelenaAscensionAndTristanDaCunha = Country(name: "Saint Helena, Ascension and Tristan da Cunha", code2: "SH", code3: "SHN", countryCode: "654")
	public static let saintKittsAndNevis = Country(name: "Saint Kitts and Nevis", code2: "KN", code3: "KNA", countryCode: "659")
	public static let saintLucia = Country(name: "Saint Lucia", code2: "LC", code3: "LCA", countryCode: "662")
	public static let saintMartin = Country(name: "Saint Martin (French part)", code2: "MF", code3: "MAF", countryCode: "663")
	public static let saintPierreAndMiquelon = Country(name: "Saint Pierre and Miquelon", code2: "PM", code3: "SPM", countryCode: "666")
	public static let saintVincentAndTheGrenadines = Country(name: "Saint Vincent and the Grenadines", code2: "VC", code3: "VCT", countryCode: "670")
	public static let samoa = Country(name: "Samoa", code2: "WS", code3: "WSM", countryCode: "882")
	public static let sanMarino = Country(name: "San Marino", code2: "SM", code3: "SMR", countryCode: "674")
	public static let saoTomeAndPrincipe = Country(name: "Sao Tome and Principe", code2: "ST", code3: "STP", countryCode: "678")
	public static let saudiArabia = Country(name: "Saudi Arabia", code2: "SA", code3: "SAU", countryCode: "682")
	public static let senegal = Country(name: "Senegal", code2: "SN", code3: "SEN", countryCode: "686")
	public static let serbia = Country(name: "Serbia", code2: "RS", code3: "SRB", countryCode: "688")
	public static let seychelles = Country(name: "Seychelles", code2: "SC", code3: "SYC", countryCode: "690")
	public static let sierraLeone = Country(name: "Sierra Leone", code2: "SL", code3: "SLE", countryCode: "694")
	public static let singapore = Country(name: "Singapore", code2: "SG", code3: "SGP", countryCode: "702")
	public static let sintMaarten = Country(name: "Sint Maarten (Dutch part)", code2: "SX", code3: "SXM", countryCode: "534")
	public static let slovakia = Country(name: "Slovakia", code2: "SK", code3: "SVK", countryCode: "703")
	public static let slovenia = Country(name: "Slovenia", code2: "SI", code3: "SVN", countryCode: "705")
	public static let solomonIslands = Country(name: "Solomon Islands", code2: "SB", code3: "SLB", countryCode: "090")
	public static let somalia = Country(name: "Somalia", code2: "SO", code3: "SOM", countryCode: "706")
	public static let southAfrica = Country(name: "South Africa", code2: "ZA", code3: "ZAF", countryCode: "710")
	public static let southGeorgiaAndTheSouthSandwichIslands = Country(name: "South Georgia and the South Sandwich Islands", code2: "GS", code3: "SGS", countryCode: "239")
	public static let southSudan = Country(name: "South Sudan", code2: "SS", code3: "SSD", countryCode: "728")
	public static let spain = Country(name: "Spain", code2: "ES", code3: "ESP", countryCode: "724")
	public static let sriLanka = Country(name: "Sri Lanka", code2: "LK", code3: "LKA", countryCode: "144")
	public static let sudan = Country(name: "Sudan", code2: "SD", code3: "SDN", countryCode: "729")
	public static let suriname = Country(name: "Suriname", code2: "SR", code3: "SUR", countryCode: "740")
	public static let svalbardAndJanMayen = Country(name: "Svalbard and Jan Mayen", code2: "SJ", code3: "SJM", countryCode: "744")
	public static let swaziland = Country(name: "Swaziland", code2: "SZ", code3: "SWZ", countryCode: "748")
	public static let sweden = Country(name: "Sweden", code2: "SE", code3: "SWE", countryCode: "752")
	public static let switzerland = Country(name: "Switzerland", code2: "CH", code3: "CHE", countryCode: "756")
	public static let syrianArabRepublic = Country(name: "Syrian Arab Republic", code2: "SY", code3: "SYR", countryCode: "760")
	public static let taiwan = Country(name: "Taiwan, Province of China", code2: "TW", code3: "TWN", countryCode: "158")
	public static let tajikistan = Country(name: "Tajikistan", code2: "TJ", code3: "TJK", countryCode: "762")
	public static let tanzania = Country(name: "Tanzania, United Republic of", code2: "TZ", code3: "TZA", countryCode: "834")
	public static let thailand = Country(name: "Thailand", code2: "TH", code3: "THA", countryCode: "764")
	public static let timorLeste = Country(name: "Timor-Leste", code2: "TL", code3: "TLS", countryCode: "626")
	public static let togo = Country(name: "Togo", code2: "TG", code3: "TGO", countryCode: "768")
	public static let tokelau = Country(name: "Tokelau", code2: "TK", code3: "TKL", countryCode: "772")
	public static let tonga = Country(name: "Tonga", code2: "TO", code3: "TON", countryCode: "776")
	public static let trinidadAndTobago = Country(name: "Trinidad and Tobago", code2: "TT", code3: "TTO", countryCode: "780")
	public static let tunisia = Country(name: "Tunisia", code2: "TN", code3: "TUN", countryCode: "788")
	public static let turkey = Country(name: "Turkey", code2: "TR", code3: "TUR", countryCode: "792")
	public static let turkmenistan = Country(name: "Turkmenistan", code2: "TM", code3: "TKM", countryCode: "795")
	public static let turksAndCaicosIslands = Country(name: "Turks and Caicos Islands", code2: "TC", code3: "TCA", countryCode: "796")
	public static let tuvalu = Country(name: "Tuvalu", code2: "TV", code3: "TUV", countryCode: "798")
	public static let uganda = Country(name: "Uganda", code2: "UG", code3: "UGA", countryCode: "800")
	public static let ukraine = Country(name: "Ukraine", code2: "UA", code3: "UKR", countryCode: "804")
	public static let unitedArabEmirates = Country(name: "United Arab Emirates", code2: "AE", code3: "ARE", countryCode: "784")
	public static let unitedKingdomOfGreatBritainAndNorthernIreland = Country(name: "United Kingdom of Great Britain and Northern Ireland", code2: "GB", code3: "GBR", countryCode: "826")
	public static let unitedStatesOfAmerica = Country(name: "United States of America", code2: "US", code3: "USA", countryCode: "840")
	public static let unitedStatesMinorOutlyingIslands = Country(name: "United States Minor Outlying Islands", code2: "UM", code3: "UMI", countryCode: "581")
	public static let uruguay = Country(name: "Uruguay", code2: "UY", code3: "URY", countryCode: "858")
	public static let uzbekistan = Country(name: "Uzbekistan", code2: "UZ", code3: "UZB", countryCode: "860")
	public static let vanuatu = Country(name: "Vanuatu", code2: "VU", code3: "VUT", countryCode: "548")
	public static let venezuela = Country(name: "Venezuela (Bolivarian Republic of)", code2: "VE", code3: "VEN", countryCode: "862")
	public static let vietNam = Country(name: "Viet Nam", code2: "VN", code3: "VNM", countryCode: "704")
	public static let virginIslandsBritish = Country(name: "Virgin Islands (British)", code2: "VG", code3: "VGB", countryCode: "092")
	public static let virginIslandsUS = Country(name: "Virgin Islands (U.S.)", code2: "VI", code3: "VIR", countryCode: "850")
	public static let wallisAndFutuna = Country(name: "Wallis and Futuna", code2: "WF", code3: "WLF", countryCode: "876")
	public static let westernSahara = Country(name: "Western Sahara", code2: "EH", code3: "ESH", countryCode: "732")
	public static let yemen = Country(name: "Yemen", code2: "YE", code3: "YEM", countryCode: "887")
	public static let zambia = Country(name: "Zambia", code2: "ZM", code3: "ZMB", countryCode: "894")
	public static let zimbabwe = Country(name: "Zimbabwe", code2: "ZW", code3: "ZWE", countryCode: "716")
}

//public enum Country: String { // ISO-3166-1
//	case belarus = "BY"
//	case singapore = "SG"
//	case tajikistan = "TJ"
//	case barbados = "BB"
//	case eritrea = "ER"
//	case isleOfMan = "IM"
//	case lesotho = "LS"
//	case indonesia = "ID"
//	case palau = "PW"
//	case saintMartin = "MF"
//	case sintMaarten = "SX"
//	case myanmar = "MM"
//	case mozambique = "MZ"
//	case bosniaAndHerzegovina = "BA"
//	case cameroon = "CM"
//	case brazil = "BR"
//	case eastTimor = "TL"
//	case madagascar = "MG"
//	case austria = "AT"
//	case marshallIslands = "MH"
//	case argentina = "AR"
//	case nepal = "NP"
//	case kiribati = "KI"
//	case norway = "NO"
//	case macao = "MO"
//	case solomonIslands = "SB"
//	case unitedStatesMinorOutlyingIslands = "UM"
//	case seychelles = "SC"
//	case caymanIslands = "KY"
//	case uzbekistan = "UZ"
//	case northKorea = "KP"
//	case suriname = "SR"
//	case mauritius = "MU"
//	case mongolia = "MN"
//	case libya = "LY"
//	case antiguaAndBarbuda = "AG"
//	case anguilla = "AI"
//	case italy = "IT"
//	case sierraLeone = "SL"
//	case turkmenistan = "TM"
//	case frenchGuiana = "GF"
//	case guernsey = "GG"
//	case senegal = "SN"
//	case laos = "LA"
//	case honduras = "HN"
//	case andorra = "AD"
//	case uganda = "UG"
//	case slovakia = "SK"
//	case ukraine = "UA"
//	case slovenia = "SI"
//	case bermuda = "BM"
//	case switzerland = "CH"
//	case alandIslands = "AX"
//	case kosovo = "XK"
//	case dominicanRepublic = "DO"
//	case guineaBissau = "GW"
//	case turksAndCaicosIslands = "TC"
//	case serbia = "RS"
//	case vanuatu = "VU"
//	case latvia = "LV"
//	case ireland = "IE"
//	case republicOfTheCongo = "CG"
//	case djibouti = "DJ"
//	case guyana = "GY"
//	case philippines = "PH"
//	case niue = "NU"
//	case spain = "ES"
//	case gambia = "GM"
//	case northernMarianaIslands = "MP"
//	case benin = "BJ"
//	case canada = "CA"
//	case sudan = "SD"
//	case colombia = "CO"
//	case saintPierreAndMiquelon = "PM"
//	case greece = "GR"
//	case croatia = "HR"
//	case centralAfricanRepublic = "CF"
//	case morocco = "MA"
//	case norfolkIsland = "NF"
//	case dominica = "DM"
//	case macedonia = "MK"
//	case curacao = "CW"
//	case portugal = "PT"
//	case turkey = "TR"
//	case elSalvador = "SV"
//	case liechtenstein = "LI"
//	case trinidadAndTobago = "TT"
//	case brunei = "BN"
//	case guatemala = "GT"
//	case saoTomeAndPrincipe = "ST"
//	case kazakhstan = "KZ"
//	case peru = "PE"
//	case kenya = "KE"
//	case bonaire,SaintEustatiusAndSaba = "BQ"
//	case bahamas = "BS"
//	case chad = "TD"
//	case afghanistan = "AF"
//	case luxembourg = "LU"
//	case aruba = "AW"
//	case tanzania = "TZ"
//	case palestinianTerritory = "PS"
//	case southAfrica = "ZA"
//	case nicaragua = "NI"
//	case grenada = "GD"
//	case belize = "BZ"
//	case haiti = "HT"
//	case usVirginIslands = "VI"
//	case cocosIslands = "CC"
//	case greenland = "GL"
//	case togo = "TG"
//	case gabon = "GA"
//	case zambia = "ZM"
//	case tokelau = "TK"
//	case southKorea = "KR"
//	case mali = "ML"
//	case reunion = "RE"
//	case nauru = "NR"
//	case ghana = "GH"
//	case iceland = "IS"
//	case cuba = "CU"
//	case americanSamoa = "AS"
//	case tunisia = "TN"
//	case india = "IN"
//	case panama = "PA"
//	case iraq = "IQ"
//	case kuwait = "KW"
//	case netherlands = "NL"
//	case papuaNewGuinea = "PG"
//	case malaysia = "MY"
//	case svalbardAndJanMayen = "SJ"
//	case venezuela = "VE"
//	case egypt = "EG"
//	case hongKong = "HK"
//	case oman = "OM"
//	case mayotte = "YT"
//	case saintBarthelemy = "BL"
//	case belgium = "BE"
//	case taiwan = "TW"
//	case algeria = "DZ"
//	case frenchPolynesia = "PF"
//	case gibraltar = "GI"
//	case montenegro = "ME"
//	case czechRepublic = "CZ"
//	case martinique = "MQ"
//	case vatican = "VA"
//	case swaziland = "SZ"
//	case bhutan = "BT"
//	case romania = "RO"
//	case malawi = "MW"
//	case moldova = "MD"
//	case germany = "DE"
//	case azerbaijan = "AZ"
//	case jersey = "JE"
//	case jamaica = "JM"
//	case jordan = "JO"
//	case montserrat = "MS"
//	case sanMarino = "SM"
//	case sriLanka = "LK"
//	case kyrgyzstan = "KG"
//	case iran = "IR"
//	case somalia = "SO"
//	case angola = "AO"
//	case christmasIsland = "CX"
//	case heardIslandAndMcDonaldIslands = "HM"
//	case finland = "FI"
//	case westernSahara = "EH"
//	case tonga = "TO"
//	case saudiArabia = "SA"
//	case mauritania = "MR"
//	case lebanon = "LB"
//	case maldives = "MV"
//	case nigeria = "NG"
//	case armenia = "AM"
//	case australia = "AU"
//	case denmark = "DK"
//	case britishVirginIslands = "VG"
//	case newCaledonia = "NC"
//	case southSudan = "SS"
//	case guam = "GU"
//	case bouvetIsland = "BV"
//	case burundi = "BI"
//	case mexico = "MX"
//	case japan = "JP"
//	case uruguay = "UY"
//	case cyprus = "CY"
//	case liberia = "LR"
//	case saintVincentAndTheGrenadines = "VC"
//	case comoros = "KM"
//	case unitedStates = "US"
//	case china = "CN"
//	case cambodia = "KH"
//	case pitcairn = "PN"
//	case lithuania = "LT"
//	case thailand = "TH"
//	case tuvalu = "TV"
//	case yemen = "YE"
//	case bolivia = "BO"
//	case bangladesh = "BD"
//	case newZealand = "NZ"
//	case ethiopia = "ET"
//	case bulgaria = "BG"
//	case capeVerde = "CV"
//	case britishIndianOceanTerritory = "IO"
//	case niger = "NE"
//	case estonia = "EE"
//	case georgia = "GE"
//	case saintLucia = "LC"
//	case unitedKingdom = "GB"
//	case bahrain = "BH"
//	case guinea = "GN"
//	case malta = "MT"
//	case guadeloupe = "GP"
//	case albania = "AL"
//	case samoa = "WS"
//	case ivoryCoast = "CI"
//	case vietnam = "VN"
//	case syria = "SY"
//	case antarctica = "AQ"
//	case costaRica = "CR"
//	case israel = "IL"
//	case rwanda = "RW"
//	case fiji = "FJ"
//	case russia = "RU"
//	case monaco = "MC"
//	case hungary = "HU"
//	case namibia = "NA"
//	case zimbabwe = "ZW"
//	case paraguay = "PY"
//	case chile = "CL"
//	case poland = "PL"
//	case puertoRico = "PR"
//	case pakistan = "PK"
//	case sweden = "SE"
//	case botswana = "BW"
//	case falklandIslands = "FK"
//	case france = "FR"
//	case saintKittsAndNevis = "KN"
//	case unitedArabEmirates = "AE"
//	case frenchSouthernTerritories = "TF"
//	case qatar = "QA"
//	case wallisAndFutuna = "WF"
//	case burkinaFaso = "BF"
//	case cookIslands = "CK"
//	case saintHelena = "SH"
//	case democraticRepublicOfTheCongo = "CD"
//	case ecuador = "EC"
//	case equatorialGuinea = "GQ"
//	case southGeorgiaAndTheSouthSandwichIslands = "GS"
//	case micronesia = "FM"
//	case faroeIslands = "FO"
//}

