workspace {

    model {
        user1 = person "Clinician"
        user2 = person "Patient"
        user3 = person "Researcher"
        user4 = person "Administration"

        # External Systems
        oie = softwareSystem "Opal Integration Engine"



        softwareSystem = softwareSystem "Opal Admin" {
            webapp = container "opaladmin" {
                user1 -> this "Uses"
                user2 -> this "Uses"
                user3 -> this "Uses"
                user4 -> this "Uses"
                oie -> this "Uses"

                comp = component "Components" {
                    user1 -> this
                }

            }
            db = container "Database" {
                webapp -> this "Reads from and writes to"
            }

            orms = container "ORMS" {
                oie -> this "api"
                this -> oie "api"
            }

            applistner = container "App Listener" {
                this -> oie "api"
                this -> db "Reads from and writes to"
                orms -> this "api"
            }
            firebase = container "Firebase" {
                this -> applistner "api"
            }
        }
    }

    views {
        systemContext softwareSystem {
            include *
            #autolayout lr
        }

        container softwareSystem {
            include *
            #autolayout lr
        }

        component webapp {
            include *
        }

        theme default
    }

}
