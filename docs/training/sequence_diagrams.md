# Sequence Diagrams

Sequence diagrams are part of the Unified Modeling Language (UML)[^uml-spec], a standardized general-purpose graphical modeling language.

Sequence diagrams are one kind of interaction diagram which focus on the message interchange between different actors and software systems. They show the sequence of messages that are exchanged.

Sequence diagrams can be used to convey message exchanges at different levels of abstraction and to different stakeholders.

## Important Elements of Sequence Diagrams

<figure markdown>
  ![Import elements of a sequence diagram](images/sequence_diagram_elements.png)
  <figcaption>A sample sequence diagram with some import elements ([Source](https://mattsch.com/research/publications/#paper-7)</figcaption>
</figure>

A detailed overview of all the elements can be found in[^sequence-diagrams].

## Example

Below are two examples, one showing a high-level diagram and the second one showing a more detailed diagram that is closer to code. Basically, sequence diagrams can be used to show interactions at different abstraction levels.

### High-level

```plantuml
@startuml
Alice -> Bob: Authentication Request
Bob --> Alice: Authentication Response

Alice -> Bob: Another authentication Request
Alice <-- Bob: Authentication failed
@enduml
```

Taken from the official PlantUML documentation[^plantuml-sd].

### Low-level

```plantuml
@startuml
participant Caller

create SomeClass
Caller -> SomeClass: new

opt foo == null
    SomeClass -> SomeClass: foo:= bar()
end

SomeClass --> Caller: instance
@enduml
```

## Resources

[^uml-spec]: The OMG Unified Modeling Language (UML) Specification: https://www.omg.org/spec/UML/
[^sequence-diagrams]: Great overview of sequence diagrams and their elements: https://www.uml-diagrams.org/sequence-diagrams.html
[^plantuml-sd]: PlantUML Sequence Diagrams syntax and features: https://plantuml.com/sequence-diagram
