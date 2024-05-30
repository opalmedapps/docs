# Registration Process

## Requesting access to patient data (aka. Opal Registration aka. QR Code Generation aka. Access Request)

This reflects the currently envisioned flow with the new OpalAdmin/Backend.

```mermaid
sequenceDiagram

    actor Clerk
    participant FE as OpalAdmin v2
    participant BE as Backend
    participant DB as New DB
    participant OIE

    Clerk ->> FE: search patient
    FE ->> OIE: search patient by MRN/RAMQ
    FE ->> Clerk: show search result
    Clerk ->> FE: provide relationship details

    alt new user
        Clerk ->> FE: provide name of user
        %% Clerk ->> FE: request code generation
    else existing user
        Clerk ->> FE: search for existing user
        FE ->> BE: look up user
        FE ->> Clerk: provide search result
        %% Clerk ->> FE: request access
    end

    Clerk ->> FE: request generate QR code/add access
    FE ->> BE: handle request
    opt patient does not exist yet
        BE ->> DB: insert minimal patient data
    end
    opt user does not exist yet
        BE ->> DB: insert minimal user data
    end
    BE ->> DB: insert relationship request details
    opt new user
        BE ->> BE: generate registration code
        BE ->> DB: insert registration code
    end
    BE ->> FE: result
    FE ->> Clerk: result
```

## Registration Web Page Encryption/Decryption

The encryption/decryption details are omitted in the diagram in the next section for brevity.
The following diagram provides these details.

```mermaid
sequenceDiagram

    participant FE as Web Page
    participant BE as Listener
    participant API as New Backend

    FE ->> FE: encrypt with PBKDF2(key=code, salt=RAMQ)
    FE ->> BE: send request via Firebase
    note right of FE: request contains SHA512(code)
    BE ->> API: get registration details for hashed code
    note right of API: patient health insurance number and list of MRNs
    loop until correct salt found
    BE ->> BE: decrypt request using code and current data
    note right of BE: remember correct salt
    end
    note right of BE: handle request
    BE ->> BE: encrypt response with PBKDF2(key=code, salt=correct_salt)
    BE -->> FE: send response via Firebase
```

## Using the registration web page

This reflects the currently envisioned flow with the new OpalAdmin/Backend via the listener's new API request functionality.

```plantuml source="docs/development/architecture/diagrams/registration.puml"
```
