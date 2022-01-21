import ProjectDescription
import Foundation

let nameAttribute: Template.Attribute = .required("name")
let targetAttribute: Template.Attribute = .required("target")


let template = Template(
    description: "TCA Template",
    attributes: [
        nameAttribute,
        targetAttribute,
        .optional("platform", default: "ios"),
    ],
    items: [
        .file(
            path: "Targets/\(targetAttribute)/Sources/Screens/\(nameAttribute)/\(nameAttribute)Core.swift",
            templatePath: "core.stencil"
        ),
        .file(
            path: "Targets/\(targetAttribute)/Sources/Screens/\(nameAttribute)/\(nameAttribute)Screen.swift",
            templatePath: "screen.stencil"
        ),
    ]
)






