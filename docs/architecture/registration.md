# Registration Process

## Requesting access to patient data (aka. QR Code Generation)

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

The encryption/decryption details are omitted in the diagram in the next section for brevity. The following diagram provides these details.

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

```mermaid
sequenceDiagram

    actor User
    participant FE as Web Page
    participant BE as Listener
    participant API as New Backend
    %% participant DB as New DB
    participant ODB as OpalDB
    participant OIE

    note right of User: Registering through web page

    User ->> FE: enter details (MRN & code)
    FE ->> BE: Look up registration request
    BE ->> API: Find registration

    User ->> FE: Choose account option (existing vs new)
    FE ->> BE: retrieve security questions list
    BE ->> API: get list of security questions

    alt existing account
        User ->> FE: provide security questions and answers, phone number
    else new account
        User ->> FE: provide email
        FE ->> BE: request verification code
        BE ->> API: add email to registration code instance
        API ->> API: generate verification code
        API ->> API: send email
        User ->> FE: provide verification code
        FE ->> BE: verify verification code
        BE ->> API: verify verification code
        User ->> FE: provide complete account details
    end

    User ->> FE: continue with registration
    FE ->> BE: get language list
    User ->> FE: choose language and give consent
    User ->> FE: continue with registration
    FE ->> BE: get terms of use agreement for hospital
    %% note over FE, BE: currently retrieved locally from same host<br>but needs to be added to hospital settings
    BE ->> API: get hospital's terms of use agreement
    User ->> FE: accept terms of use agreement

    User ->> FE: Finish registration
    FE ->> BE: Finish registration
    alt new user
        BE ->> BE: create Firebase account
    else
        BE ->> BE: get Firebase account
    end
    BE ->> API: get patient data
    BE ->> ODB: insert patient
    note right of BE: should return legacy patient ID
    BE ->> ODB: insert patient hospital identifier
    BE ->> API: insert and update data
    note right of API: change registration status code to Registered<br>insert security answers<br>change user to active and set current datetime as date_joined
    BE ->> OIE: retrieve lab history
    BE ->> OIE: update patient status in ORMS
    BE ->> BE: send confirmation email
    note right of BE: move to new backend?
    
    %% rect rgb(150, 150, 150)
    %% note right of API: existing PHP functionality
    %% opt not patient exists
    %%     API ->> ODB: insert patient
    %%     API ->> ODB: insert patient hospital identifier
    %%     API ->> ODB: insert user (for patient)
    %%     note over API, ODB: TBD: Can there only be one user<br>or does there need to be a user each (for security questions)
    %% end
    %% end

    %% API ->> OIE: retrieve lab history
    %% API ->> OIE: update patient status in ORMS
    %%     note right of API: TBD: change to direct call to ORMS?
    %% API ->> DB: set legacy_id in patient
    %% API ->> DB: set legacy_id in caregiverprofile
    %% API ->> API: send confirmation email
```
