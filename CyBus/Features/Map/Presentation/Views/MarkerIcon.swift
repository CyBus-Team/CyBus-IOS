//
//  MarkerIcon.swift
//  CyBus
//
//  Created by Artem on 13.11.2024.
//
import Foundation
import SwiftUI

struct MarkerIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0, y: 0.36666*height))
        path.addCurve(to: CGPoint(x: 0.00324*width, y: 0.32345*height), control1: CGPoint(x: 0.00109*width, y: 0.35101*height), control2: CGPoint(x: 0.00126*width, y: 0.33717*height))
        path.addCurve(to: CGPoint(x: 0.01209*width, y: 0.28465*height), control1: CGPoint(x: 0.00513*width, y: 0.31043*height), control2: CGPoint(x: 0.00797*width, y: 0.29739*height))
        path.addCurve(to: CGPoint(x: 0.02896*width, y: 0.24273*height), control1: CGPoint(x: 0.01667*width, y: 0.27049*height), control2: CGPoint(x: 0.02265*width, y: 0.25655*height))
        path.addCurve(to: CGPoint(x: 0.0923*width, y: 0.15291*height), control1: CGPoint(x: 0.04366*width, y: 0.21041*height), control2: CGPoint(x: 0.06547*width, y: 0.18074*height))
        path.addCurve(to: CGPoint(x: 0.20336*width, y: 0.07014*height), control1: CGPoint(x: 0.12317*width, y: 0.12088*height), control2: CGPoint(x: 0.16044*width, y: 0.09345*height))
        path.addCurve(to: CGPoint(x: 0.29813*width, y: 0.03036*height), control1: CGPoint(x: 0.23273*width, y: 0.0542*height), control2: CGPoint(x: 0.26401*width, y: 0.04038*height))
        path.addCurve(to: CGPoint(x: 0.35871*width, y: 0.01363*height), control1: CGPoint(x: 0.31815*width, y: 0.02446*height), control2: CGPoint(x: 0.33821*width, y: 0.01857*height))
        path.addCurve(to: CGPoint(x: 0.4002*width, y: 0.00665*height), control1: CGPoint(x: 0.37214*width, y: 0.0104*height), control2: CGPoint(x: 0.38626*width, y: 0.00863*height))
        path.addCurve(to: CGPoint(x: 0.44818*width, y: 0.00078*height), control1: CGPoint(x: 0.41612*width, y: 0.00441*height), control2: CGPoint(x: 0.43214*width, y: 0.00252*height))
        path.addCurve(to: CGPoint(x: 0.46688*width, y: -0.00002*height), control1: CGPoint(x: 0.45433*width, y: 0.00011*height), control2: CGPoint(x: 0.46066*width, y: -0.00004*height))
        path.addCurve(to: CGPoint(x: 0.55024*width, y: 0.00076*height), control1: CGPoint(x: 0.49468*width, y: 0.00009*height), control2: CGPoint(x: 0.52252*width, y: -0.0003*height))
        path.addCurve(to: CGPoint(x: 0.59762*width, y: 0.00635*height), control1: CGPoint(x: 0.56612*width, y: 0.00136*height), control2: CGPoint(x: 0.58187*width, y: 0.00425*height))
        path.addCurve(to: CGPoint(x: 0.62691*width, y: 0.01107*height), control1: CGPoint(x: 0.60746*width, y: 0.00766*height), control2: CGPoint(x: 0.61727*width, y: 0.00914*height))
        path.addCurve(to: CGPoint(x: 0.66998*width, y: 0.02058*height), control1: CGPoint(x: 0.64138*width, y: 0.01394*height), control2: CGPoint(x: 0.65609*width, y: 0.01654*height))
        path.addCurve(to: CGPoint(x: 0.73426*width, y: 0.0414*height), control1: CGPoint(x: 0.69176*width, y: 0.0269*height), control2: CGPoint(x: 0.71347*width, y: 0.03353*height))
        path.addCurve(to: CGPoint(x: 0.86994*width, y: 0.11821*height), control1: CGPoint(x: 0.78588*width, y: 0.06091*height), control2: CGPoint(x: 0.83069*width, y: 0.08696*height))
        path.addCurve(to: CGPoint(x: 0.93118*width, y: 0.17863*height), control1: CGPoint(x: 0.8933*width, y: 0.13682*height), control2: CGPoint(x: 0.91354*width, y: 0.15704*height))
        path.addCurve(to: CGPoint(x: 0.96779*width, y: 0.23479*height), control1: CGPoint(x: 0.94576*width, y: 0.19649*height), control2: CGPoint(x: 0.95834*width, y: 0.21514*height))
        path.addCurve(to: CGPoint(x: 0.98505*width, y: 0.27432*height), control1: CGPoint(x: 0.97407*width, y: 0.24783*height), control2: CGPoint(x: 0.98001*width, y: 0.261*height))
        path.addCurve(to: CGPoint(x: 0.99217*width, y: 0.30138*height), control1: CGPoint(x: 0.98836*width, y: 0.28315*height), control2: CGPoint(x: 0.98955*width, y: 0.29239*height))
        path.addCurve(to: CGPoint(x: 0.99997*width, y: 0.36998*height), control1: CGPoint(x: 0.99874*width, y: 0.324*height), control2: CGPoint(x: 0.99963*width, y: 0.347*height))
        path.addCurve(to: CGPoint(x: 0.99731*width, y: 0.40602*height), control1: CGPoint(x: 1.00014*width, y: 0.382*height), control2: CGPoint(x: 0.99905*width, y: 0.39407*height))
        path.addCurve(to: CGPoint(x: 0.98965*width, y: 0.4419*height), control1: CGPoint(x: 0.99556*width, y: 0.41804*height), control2: CGPoint(x: 0.99232*width, y: 0.42995*height))
        path.addCurve(to: CGPoint(x: 0.98316*width, y: 0.46954*height), control1: CGPoint(x: 0.98759*width, y: 0.45113*height), control2: CGPoint(x: 0.98582*width, y: 0.4604*height))
        path.addCurve(to: CGPoint(x: 0.97286*width, y: 0.49928*height), control1: CGPoint(x: 0.98022*width, y: 0.47953*height), control2: CGPoint(x: 0.97683*width, y: 0.48948*height))
        path.addCurve(to: CGPoint(x: 0.95645*width, y: 0.53593*height), control1: CGPoint(x: 0.96784*width, y: 0.5116*height), control2: CGPoint(x: 0.96244*width, y: 0.52384*height))
        path.addCurve(to: CGPoint(x: 0.93401*width, y: 0.57797*height), control1: CGPoint(x: 0.94945*width, y: 0.55007*height), control2: CGPoint(x: 0.94242*width, y: 0.56426*height))
        path.addCurve(to: CGPoint(x: 0.89357*width, y: 0.63975*height), control1: CGPoint(x: 0.92124*width, y: 0.5988*height), control2: CGPoint(x: 0.90796*width, y: 0.61948*height))
        path.addCurve(to: CGPoint(x: 0.85075*width, y: 0.69474*height), control1: CGPoint(x: 0.88029*width, y: 0.65845*height), control2: CGPoint(x: 0.86633*width, y: 0.67702*height))
        path.addCurve(to: CGPoint(x: 0.77078*width, y: 0.78161*height), control1: CGPoint(x: 0.82497*width, y: 0.72411*height), control2: CGPoint(x: 0.79826*width, y: 0.75305*height))
        path.addCurve(to: CGPoint(x: 0.67002*width, y: 0.87384*height), control1: CGPoint(x: 0.73979*width, y: 0.81382*height), control2: CGPoint(x: 0.70535*width, y: 0.84412*height))
        path.addCurve(to: CGPoint(x: 0.54498*width, y: 0.97068*height), control1: CGPoint(x: 0.63016*width, y: 0.90738*height), control2: CGPoint(x: 0.58855*width, y: 0.93971*height))
        path.addCurve(to: CGPoint(x: 0.50554*width, y: 0.99795*height), control1: CGPoint(x: 0.532*width, y: 0.97992*height), control2: CGPoint(x: 0.51852*width, y: 0.98876*height))
        path.addCurve(to: CGPoint(x: 0.49497*width, y: 0.99783*height), control1: CGPoint(x: 0.50156*width, y: 1.00076*height), control2: CGPoint(x: 0.4988*width, y: 1.0006*height))
        path.addCurve(to: CGPoint(x: 0.3875*width, y: 0.9198*height), control1: CGPoint(x: 0.45918*width, y: 0.9718*height), control2: CGPoint(x: 0.42271*width, y: 0.94626*height))
        path.addCurve(to: CGPoint(x: 0.2722*width, y: 0.82261*height), control1: CGPoint(x: 0.34655*width, y: 0.88904*height), control2: CGPoint(x: 0.30867*width, y: 0.85623*height))
        path.addCurve(to: CGPoint(x: 0.2097*width, y: 0.76165*height), control1: CGPoint(x: 0.25061*width, y: 0.80272*height), control2: CGPoint(x: 0.22972*width, y: 0.7824*height))
        path.addCurve(to: CGPoint(x: 0.16269*width, y: 0.70847*height), control1: CGPoint(x: 0.19308*width, y: 0.74441*height), control2: CGPoint(x: 0.17786*width, y: 0.72642*height))
        path.addCurve(to: CGPoint(x: 0.11457*width, y: 0.64908*height), control1: CGPoint(x: 0.14617*width, y: 0.68888*height), control2: CGPoint(x: 0.12971*width, y: 0.66924*height))
        path.addCurve(to: CGPoint(x: 0.07773*width, y: 0.59486*height), control1: CGPoint(x: 0.10129*width, y: 0.63142*height), control2: CGPoint(x: 0.08925*width, y: 0.6132*height))
        path.addCurve(to: CGPoint(x: 0.04873*width, y: 0.54391*height), control1: CGPoint(x: 0.06724*width, y: 0.57815*height), control2: CGPoint(x: 0.05779*width, y: 0.56107*height))
        path.addCurve(to: CGPoint(x: 0.0323*width, y: 0.50778*height), control1: CGPoint(x: 0.04248*width, y: 0.53209*height), control2: CGPoint(x: 0.03739*width, y: 0.51991*height))
        path.addCurve(to: CGPoint(x: 0.01803*width, y: 0.47077*height), control1: CGPoint(x: 0.02716*width, y: 0.49554*height), control2: CGPoint(x: 0.02229*width, y: 0.4832*height))
        path.addCurve(to: CGPoint(x: 0.01129*width, y: 0.44504*height), control1: CGPoint(x: 0.01512*width, y: 0.46232*height), control2: CGPoint(x: 0.01349*width, y: 0.45362*height))
        path.addCurve(to: CGPoint(x: 0.00627*width, y: 0.42527*height), control1: CGPoint(x: 0.00962*width, y: 0.43846*height), control2: CGPoint(x: 0.00792*width, y: 0.43186*height))
        path.addCurve(to: CGPoint(x: 0.0056*width, y: 0.4218*height), control1: CGPoint(x: 0.00598*width, y: 0.42413*height), control2: CGPoint(x: 0.00572*width, y: 0.42296*height))
        path.addCurve(to: CGPoint(x: 0.0016*width, y: 0.38239*height), control1: CGPoint(x: 0.00424*width, y: 0.40867*height), control2: CGPoint(x: 0.00293*width, y: 0.39552*height))
        path.addCurve(to: CGPoint(x: -0.00005*width, y: 0.36668*height), control1: CGPoint(x: 0.00099*width, y: 0.37653*height), control2: CGPoint(x: 0.00036*width, y: 0.37068*height))
        path.addLine(to: CGPoint(x: 0, y: 0.36666*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.09244*width, y: 0.36264*height))
        path.addCurve(to: CGPoint(x: 0.21889*width, y: 0.57305*height), control1: CGPoint(x: 0.09349*width, y: 0.44262*height), control2: CGPoint(x: 0.13509*width, y: 0.51483*height))
        path.addCurve(to: CGPoint(x: 0.49914*width, y: 0.65508*height), control1: CGPoint(x: 0.29689*width, y: 0.62725*height), control2: CGPoint(x: 0.39065*width, y: 0.65489*height))
        path.addCurve(to: CGPoint(x: 0.79288*width, y: 0.56488*height), control1: CGPoint(x: 0.61468*width, y: 0.65529*height), control2: CGPoint(x: 0.71289*width, y: 0.62467*height))
        path.addCurve(to: CGPoint(x: 0.9076*width, y: 0.35879*height), control1: CGPoint(x: 0.86907*width, y: 0.50792*height), control2: CGPoint(x: 0.90748*width, y: 0.43886*height))
        path.addCurve(to: CGPoint(x: 0.78411*width, y: 0.14522*height), control1: CGPoint(x: 0.90772*width, y: 0.27481*height), control2: CGPoint(x: 0.86604*width, y: 0.20346*height))
        path.addCurve(to: CGPoint(x: 0.50074*width, y: 0.06142*height), control1: CGPoint(x: 0.70574*width, y: 0.08952*height), control2: CGPoint(x: 0.61068*width, y: 0.06142*height))
        path.addCurve(to: CGPoint(x: 0.2052*width, y: 0.15348*height), control1: CGPoint(x: 0.3843*width, y: 0.06142*height), control2: CGPoint(x: 0.28541*width, y: 0.09259*height))
        path.addCurve(to: CGPoint(x: 0.09247*width, y: 0.36265*height), control1: CGPoint(x: 0.1303*width, y: 0.21034*height), control2: CGPoint(x: 0.09315*width, y: 0.27903*height))
        path.addLine(to: CGPoint(x: 0.09244*width, y: 0.36264*height))
        path.closeSubpath()
        return path
    }
}
