workspace {

    model {
        user = person "Caregiver" "A caregiver of a patient or the patient themselves (patient is their own caregiver)."

        enterprise "Opal" {
            opalApp = softwareSystem "Opal Mobile App" "Allows caregivers to access their own medical data or that of the patients they care for."
            opalSystem = softwareSystem "Opal Patient Information Exchange"
            clinicalStaff = person "Clinical Staff" "A clinician or clerk who manages patient data or provides access to patient data."
        }

        hospitalSystem = softwareSystem "Hospital System" "One or more hospital source systems that house various patient data, such as lab results, appointments, personal patient information etc."

        user -> opalApp "Uses"
        opalApp -> opalSystem "Communicates with\n[via Firebase]"
        clinicalStaff -> opalSystem "Uses"
        hospitalSystem -> opalSystem "Sends unsolicited and solicited patient data to"
        opalSystem -> hospitalSystem "Requests patient data from"
    }

    views {
        systemlandscape "SystemLandscape" "The system landscape for the Opal Solution" {
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
