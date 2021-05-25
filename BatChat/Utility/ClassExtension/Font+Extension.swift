//
//  Font+Extension.swift
//  kanqiusports
//
//  Created by Apple on 2019/12/17.
//  Copyright © 2019 kanqiusports. All rights reserved.
//

import UIKit

extension UIFont {
    open class func robotoBoldItalic(_ fontSize: CGFloat) -> UIFont {
        getFont("Roboto-BoldItalic", ofSize: fontSize)
    }

    open class func robotoMedium(_ fontSize: CGFloat) -> UIFont {
        getFont("Roboto-Medium", ofSize: fontSize)
    }

    open class func helveticaNeue(_ fontSize: CGFloat) -> UIFont {
        getFont("HelveticaNeue", ofSize: fontSize)
    }

    open class func helveticaNeueMedium(_ fontSize: CGFloat) -> UIFont {
        getFont("HelveticaNeue-Medium", ofSize: fontSize)
    }

    open class func helveticaNeueBold(_ fontSize: CGFloat) -> UIFont {
        getFont("HelveticaNeue-Bold", ofSize: fontSize)
    }

    open class func regularSystem(_ fontSize: CGFloat) -> UIFont {
        getSystemFont(ofSize: fontSize, weight: .regular)
    }

    open class func boldFont(_ fontSize: CGFloat) -> UIFont {
        getSystemFont(ofSize: fontSize, weight: .bold)
    }

    open class func mediumFont(_ fontSize: CGFloat) -> UIFont {
        getSystemFont(ofSize: fontSize, weight: .medium)
    }

    open class func semiboldFont(_ fontSize: CGFloat) -> UIFont {
        getSystemFont(ofSize: fontSize, weight: .semibold)
    }

    open class func thinSystem(_ fontSize: CGFloat) -> UIFont {
        getSystemFont(ofSize: fontSize, weight: .thin)
    }

    class func pingfang(_ fontSize: CGFloat) -> UIFont {
        getFont("PingFangSC-Regular", ofSize: fontSize)
    }

    open class func pingfangMedium(_ fontSize: CGFloat) -> UIFont {
        getFont("PingFangSC-Medium", ofSize: fontSize)
    }

    open class func pingfangThin(_ fontSize: CGFloat) -> UIFont {
        getFont("PingFangSC-Thin", ofSize: fontSize)
    }
}

extension UIFont {
    private static func defaultFont(_ fontSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: fontSize)
    }

    private static func getFont(_ name: String, ofSize fontSize: CGFloat) -> UIFont {
        let font = UIFont(name: name, size: fontSize)
        assert(font != nil, "字体不匹配")
        return font ?? defaultFont(fontSize)
    }

    private static func getSystemFont(ofSize fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        return UIFont.systemFont(ofSize: fontSize, weight: weight)
    }

    public func isEqual(fontName name: String) -> Bool {
        showFontName()
        assert(fontName == name, "字体不匹配")
        return fontName == name
    }

    public func showFontName() {
        print("fontName: " + fontName)
    }

    public static func showSystemFont() {
        var index = 1
        for name in UIFont.familyNames {
            let names = fontNames(forFamilyName: name)
            names.forEach { fontName in
                print("\(index): " + fontName)
            }
            index += 1
        }
    }
}

// 1: Copperplate-Light
// 1: Copperplate
// 1: Copperplate-Bold
// 3: AppleSDGothicNeo-Thin
// 3: AppleSDGothicNeo-Light
// 3: AppleSDGothicNeo-Regular
// 3: AppleSDGothicNeo-Bold
// 3: AppleSDGothicNeo-SemiBold
// 3: AppleSDGothicNeo-UltraLight
// 3: AppleSDGothicNeo-Medium
// 4: Thonburi
// 4: Thonburi-Light
// 4: Thonburi-Bold
// 5: GillSans-Italic
// 5: GillSans-SemiBold
// 5: GillSans-UltraBold
// 5: GillSans-Light
// 5: GillSans-Bold
// 5: GillSans
// 5: GillSans-SemiBoldItalic
// 5: GillSans-BoldItalic
// 5: GillSans-LightItalic
// 6: MarkerFelt-Thin
// 6: MarkerFelt-Wide
// 7: HiraMaruProN-W4
// 8: CourierNewPS-ItalicMT
// 8: CourierNewPSMT
// 8: CourierNewPS-BoldItalicMT
// 8: CourierNewPS-BoldMT
// 9: KohinoorTelugu-Regular
// 9: KohinoorTelugu-Medium
// 9: KohinoorTelugu-Light
// 11: AvenirNextCondensed-Heavy
// 11: AvenirNextCondensed-MediumItalic
// 11: AvenirNextCondensed-Regular
// 11: AvenirNextCondensed-UltraLightItalic
// 11: AvenirNextCondensed-Medium
// 11: AvenirNextCondensed-HeavyItalic
// 11: AvenirNextCondensed-DemiBoldItalic
// 11: AvenirNextCondensed-Bold
// 11: AvenirNextCondensed-DemiBold
// 11: AvenirNextCondensed-BoldItalic
// 11: AvenirNextCondensed-Italic
// 11: AvenirNextCondensed-UltraLight
// 12: TamilSangamMN
// 12: TamilSangamMN-Bold
// 13: HelveticaNeue-UltraLightItalic
// 13: HelveticaNeue-Medium
// 13: HelveticaNeue-MediumItalic
// 13: HelveticaNeue-UltraLight
// 13: HelveticaNeue-Italic
// 13: HelveticaNeue-Light
// 13: HelveticaNeue-ThinItalic
// 13: HelveticaNeue-LightItalic
// 13: HelveticaNeue-Bold
// 13: HelveticaNeue-Thin
// 13: HelveticaNeue-CondensedBlack
// 13: HelveticaNeue
// 13: HelveticaNeue-CondensedBold
// 13: HelveticaNeue-BoldItalic
// 14: GurmukhiMN-Bold
// 14: GurmukhiMN
// 15: Georgia-BoldItalic
// 15: Georgia-Italic
// 15: Georgia
// 15: Georgia-Bold
// 16: TimesNewRomanPS-ItalicMT
// 16: TimesNewRomanPS-BoldItalicMT
// 16: TimesNewRomanPS-BoldMT
// 16: TimesNewRomanPSMT
// 17: SinhalaSangamMN-Bold
// 17: SinhalaSangamMN
// 18: ArialRoundedMTBold
// 19: Kailasa-Bold
// 19: Kailasa
// 20: KohinoorDevanagari-Regular
// 20: KohinoorDevanagari-Light
// 20: KohinoorDevanagari-Semibold
// 21: KohinoorBangla-Regular
// 21: KohinoorBangla-Semibold
// 21: KohinoorBangla-Light
//
// 22: ChalkboardSE-Bold
// 22: ChalkboardSE-Light
// 22: ChalkboardSE-Regular
// 23: AppleColorEmoji
// 24: PingFangTC-Regular
// 24: PingFangTC-Thin
// 24: PingFangTC-Medium
// 24: PingFangTC-Semibold
// 24: PingFangTC-Light
// 24: PingFangTC-Ultralight
// 25: GujaratiSangamMN
// 25: GujaratiSangamMN-Bold
// 26: GeezaPro-Bold
// 26: GeezaPro
// 27: DamascusBold
// 27: DamascusLight
// 27: Damascus
// 27: DamascusMedium
// 27: DamascusSemiBold
// 28: Noteworthy-Bold
// 28: Noteworthy-Light
// 29: Avenir-Oblique
// 29: Avenir-HeavyOblique
// 29: Avenir-Heavy
// 29: Avenir-BlackOblique
// 29: Avenir-BookOblique
// 29: Avenir-Roman
// 29: Avenir-Medium
// 29: Avenir-Black
// 29: Avenir-Light
// 29: Avenir-MediumOblique
// 29: Avenir-Book
// 29: Avenir-LightOblique
// 30: DiwanMishafi
// 31: AcademyEngravedLetPlain
// 32: Futura-CondensedExtraBold
// 32: Futura-Medium
// 32: Futura-Bold
// 32: Futura-CondensedMedium
// 32: Futura-MediumItalic
// 33: PartyLetPlain
// 34: KannadaSangamMN-Bold
// 34: KannadaSangamMN
// 35: ArialHebrew-Bold
// 35: ArialHebrew-Light
// 35: ArialHebrew
// 36: Farah
// 37: Arial-BoldMT
// 37: Arial-BoldItalicMT
// 37: Arial-ItalicMT
// 37: ArialMT
// 38: Chalkduster
// 39: Kefa-Regular
// 40: HoeflerText-Italic
// 40: HoeflerText-Black
// 40: HoeflerText-Regular
// 40: HoeflerText-BlackItalic
// 41: Optima-ExtraBlack
// 41: Optima-BoldItalic
// 41: Optima-Italic
// 41: Optima-Regular
// 41: Optima-Bold
// 42: Palatino-Italic
// 42: Palatino-Roman
// 42: Palatino-BoldItalic
// 42: Palatino-Bold
// 43: MalayalamSangamMN-Bold
// 43: MalayalamSangamMN
// 44: AlNile
// 44: AlNile-Bold
// 45: LaoSangamMN
// 46: BradleyHandITCTT-Bold
// 47: HiraMinProN-W3
// 47: HiraMinProN-W6
// 48: PingFangHK-Medium
// 48: PingFangHK-Thin
// 48: PingFangHK-Regular
// 48: PingFangHK-Ultralight
// 48: PingFangHK-Semibold
// 48: PingFangHK-Light
// 49: Helvetica-Oblique
// 49: Helvetica-BoldOblique
// 49: Helvetica
// 49: Helvetica-Light
// 49: Helvetica-Bold
// 49: Helvetica-LightOblique
// 50: Courier-BoldOblique
// 50: Courier-Oblique
// 50: Courier
// 50: Courier-Bold
// 51: Cochin-Italic
// 51: Cochin-Bold
// 51: Cochin
// 51: Cochin-BoldItalic
// 52: TrebuchetMS-Bold
// 52: TrebuchetMS-Italic
//
// 52: Trebuchet-BoldItalic
// 52: TrebuchetMS
// 53: DevanagariSangamMN
// 53: DevanagariSangamMN-Bold
// 54: OriyaSangamMN
// 54: OriyaSangamMN-Bold
// 55: Rockwell-Italic
// 55: Rockwell-Regular
// 55: Rockwell-Bold
// 55: Rockwell-BoldItalic
// 56: SnellRoundhand
// 56: SnellRoundhand-Bold
// 56: SnellRoundhand-Black
// 57: ZapfDingbatsITC
// 58: BodoniSvtyTwoITCTT-Bold
// 58: BodoniSvtyTwoITCTT-BookIta
// 58: BodoniSvtyTwoITCTT-Book
// 59: Verdana-Italic
// 59: Verdana
// 59: Verdana-Bold
// 59: Verdana-BoldItalic
// 60: AmericanTypewriter-CondensedBold
// 60: AmericanTypewriter-Condensed
// 60: AmericanTypewriter-CondensedLight
// 60: AmericanTypewriter
// 60: AmericanTypewriter-Bold
// 60: AmericanTypewriter-Semibold
// 60: AmericanTypewriter-Light
// 61: AvenirNext-Medium
// 61: AvenirNext-DemiBoldItalic
// 61: AvenirNext-DemiBold
// 61: AvenirNext-HeavyItalic
// 61: AvenirNext-Regular
// 61: AvenirNext-Italic
// 61: AvenirNext-MediumItalic
// 61: AvenirNext-UltraLightItalic
// 61: AvenirNext-BoldItalic
// 61: AvenirNext-Heavy
// 61: AvenirNext-Bold
// 61: AvenirNext-UltraLight
// 62: Baskerville-SemiBoldItalic
// 62: Baskerville-SemiBold
// 62: Baskerville-BoldItalic
// 62: Baskerville
// 62: Baskerville-Bold
// 62: Baskerville-Italic
// 63: KhmerSangamMN
// 64: Didot-Bold
// 64: Didot
// 64: Didot-Italic
// 65: SavoyeLetPlain
// 66: BodoniOrnamentsITCTT
// 67: Symbol
// 68: Charter-BlackItalic
// 68: Charter-Bold
// 68: Charter-Roman
// 68: Charter-Black
// 68: Charter-BoldItalic
// 68: Charter-Italic
// 69: Menlo-BoldItalic
// 69: Menlo-Bold
// 69: Menlo-Italic
// 69: Menlo-Regular
// 70: NotoNastaliqUrdu
// 71: BodoniSvtyTwoSCITCTT-Book
// 72: DINAlternate-Bold
// 73: Papyrus-Condensed
// 73: Papyrus
// 74: HiraginoSans-W3
// 74: HiraginoSans-W6
// 75: PingFangSC-Medium
// 75: PingFangSC-Semibold
// 75: PingFangSC-Light
// 75: PingFangSC-Ultralight
// 75: PingFangSC-Regular
// 75: PingFangSC-Thin
// 76: MyanmarSangamMN
// 76: MyanmarSangamMN-Bold
// 77: NotoSansChakma-Regular
// 78: Zapfino
// 80: BodoniSvtyTwoOSITCTT-BookIt
// 80: BodoniSvtyTwoOSITCTT-Book
// 80: BodoniSvtyTwoOSITCTT-Bold
// 81: EuphemiaUCAS
// 81: EuphemiaUCAS-Italic
// 81: EuphemiaUCAS-Bold
// 83: DINCondensed-Bold
