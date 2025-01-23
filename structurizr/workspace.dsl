workspace {

    model {
        user = person "Caregiver" "A caregiver of a patient or the patient themselves (patient is their own caregiver)."
        opalApp = softwareSystem "Opal Mobile App" "Allows caregivers to access their own medical data or that of the patients they care for."
        opalSystem = softwareSystem "Opal Patient Information Exchange"

        user -> opalApp "Uses"
        opalApp -> opalSystem "Uses"
    }

    views {
        systemContext opalApp "Diagram1" {
            include *
            autoLayout
        }

        theme default

        // styles {
        //     element "Software System" {
        //         background #1168bd
        //         color #ffffff
        //     }
        //     element "Person" {
        //         shape person
        //         background #08427b
        //         color #ffffff
        //     }
        // }
    }

}
